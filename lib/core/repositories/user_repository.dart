import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/models/quiz_models.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ユーザーの初期化または取得
  Future<void> initializeUser(String uid, bool isAnonymous) async {
    final userDoc = _firestore.collection('users').doc(uid);
    try {
      final snapshot = await userDoc.get().timeout(const Duration(seconds: 10));

      if (!snapshot.exists) {
        await userDoc.set({
          'id': uid,
          'isAnonymous': isAnonymous,
          'stats': {
            'totalAnswered': 0,
            'correctCount': 0,
            'xp': 0,
            'level': 1,
            'currentStreak': 0,
            'lastActive': FieldValue.serverTimestamp(),
            'weakQuestions': [],
          },
        }).timeout(const Duration(seconds: 10));
      } else {
        await userDoc.update({
          'stats.lastActive': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 10));
      }
    } catch (e) {
      debugPrint('Failed to initialize user: $e');
      rethrow;
    }
  }

  // クイズ記録の保存
  Future<void> saveQuizResult(
    String uid,
    String category,
    List<Map<String, dynamic>> questionRecords,
    int totalQuestions,
    int correctCount,
  ) async {
    final userRef = _firestore.collection('users').doc(uid);
    final logRef = userRef.collection('debug_logs').doc();

    try {
      // ユーザー情報の取得（最新状態をサーバーから強制取得）
      final userSnapshot = await userRef.get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 10));
      
      if (!userSnapshot.exists) {
        debugPrint('saveQuizResult: User document not found. UID: $uid. Initializing...');
        await initializeUser(uid, true).timeout(const Duration(seconds: 10));
        // 再度ドキュメントを取得せずに、初期値を使って続行するか、エラーを投げる
        // ここでは安全のため、初期化後に続行する最小限のデータを準備する
      }

      final data = userSnapshot.data() ?? {};
      final statsMap = data['stats'] as Map<String, dynamic>? ?? {};

      int currentXp = statsMap['xp'] as int? ?? 0;
      int currentLevel = statsMap['level'] as int? ?? 1;
      int currentStreak = statsMap['currentStreak'] as int? ?? 0;
      Timestamp? lastQuizTs = statsMap['lastQuizDate'] as Timestamp?;
      
      // おおまかなXP計算（正解1問 = 10XP）
      currentXp += correctCount * 10;
      
      // レベルアップ判定
      while (currentXp >= currentLevel * 100) { // 複数レベルアップに対応
        currentXp -= currentLevel * 100;
        currentLevel++;
      }

      // ストリーク計算
      final now = DateTime.now();
      if (lastQuizTs != null) {
        final lastDate = lastQuizTs.toDate();
        final today = DateTime(now.year, now.month, now.day);
        final last = DateTime(lastDate.year, lastDate.month, lastDate.day);
        final difference = today.difference(last).inDays;

        if (difference == 1) {
          currentStreak++;
        } else if (difference > 1) {
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }

      // 苦手問題（weakQuestions）の更新ロジック
      final List<String> currentWeakQuestions = List<String>.from(statsMap['weakQuestions'] ?? []);
      final Set<String> weakQuestionsSet = currentWeakQuestions.toSet();

      for (final record in questionRecords) {
        final id = record['questionId'] as String?;
        final isCorrect = record['isCorrect'] as bool? ?? false;
        if (id != null) {
          if (isCorrect) {
            weakQuestionsSet.remove(id);
          } else {
            weakQuestionsSet.add(id);
          }
        }
      }
      final weakQuestions = weakQuestionsSet.toList();

      // 分野別統計の集計
      final Map<String, int> catTotal = {};
      final Map<String, int> catCorrect = {};
      for (final record in questionRecords) {
        final cat = record['category'] as String? ?? category;
        final isCorrect = record['isCorrect'] as bool? ?? false;
        catTotal[cat] = (catTotal[cat] ?? 0) + 1;
        if (isCorrect) catCorrect[cat] = (catCorrect[cat] ?? 0) + 1;
      }

      final batch = _firestore.batch();

      // 1. 履歴の追加
      final historyRef = userRef.collection('history').doc();
      batch.set(historyRef, {
        'playedAt': FieldValue.serverTimestamp(),
        'category': category,
        'correctCount': correctCount,
        'totalQuestions': totalQuestions, // ここを引数の値に変更
        'questions': questionRecords,
      });

      // 2. 統計の更新（分野別を含む）
      final updateData = <String, dynamic>{
        'stats.totalAnswered': FieldValue.increment(totalQuestions),
        'stats.correctCount': FieldValue.increment(correctCount),
        'stats.xp': currentXp,
        'stats.level': currentLevel,
        'stats.currentStreak': currentStreak,
        'stats.lastQuizDate': FieldValue.serverTimestamp(),
        'stats.lastActive': FieldValue.serverTimestamp(),
        'stats.weakQuestions': weakQuestions,
      };
      // 分野別統計を ドット記法でマージ
      catTotal.forEach((cat, total) {
        updateData['stats.categoryStats.$cat.total'] = FieldValue.increment(total);
      });
      catCorrect.forEach((cat, correct) {
        updateData['stats.categoryStats.$cat.correct'] = FieldValue.increment(correct);
      });
      batch.update(userRef, updateData);


      // 3. デバッグログの保存（Firestore上に残す）
      batch.set(logRef, {
        'timestamp': FieldValue.serverTimestamp(),
        'event': 'quiz_finished',
        'category': category,
        'recordsCount': questionRecords.length,
        'totalQuestionsSession': totalQuestions,
        'correctCount': correctCount,
        'weakQuestionsAfter': weakQuestions.length,
        'uid': uid,
      });

      await batch.commit().timeout(const Duration(seconds: 15));
      debugPrint('saveQuizResult: Success for UID: $uid');
    } catch (e) {
      debugPrint('saveQuizResult: Error saving result: $e');
      // ログだけでも残す試み
      try {
        await logRef.set({
          'timestamp': FieldValue.serverTimestamp(),
          'event': 'error',
          'error': e.toString(),
          'uid': uid,
        });
      } catch (_) {}
      rethrow;
    }
  }

  // JSONアセットからの読み込み（フォールバック用）
  Future<List<Question>> loadQuestionsFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/questions.json');
      debugPrint('loadQuestionsFromAssets: Loaded string length: ${jsonString.length}');
      final List<dynamic> jsonData = json.decode(jsonString);
      debugPrint('loadQuestionsFromAssets: Decoded items: ${jsonData.length}');
      return jsonData.map((data) => Question.fromMap(data as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Asset loading error (path: assets/questions.json): $e');
      return [];
    }
  }

  // 正規化ヘルパー（全角・半角・スペース・大文字小文字を無視）
  String _normalize(String? s) {
    if (s == null) return '';
    return s.trim()
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll('　', '') // 全角スペース明示的除去
      .toLowerCase();
  }

  // オンライン・オフライン両対応の問題取得
  Future<List<Question>> fetchQuestions(String category, {bool isPremium = false}) async {
    final normalizedTarget = _normalize(category);
    debugPrint('--- fetchQuestions start: "$category" (Normalized: "$normalizedTarget", Premium: $isPremium) ---');
    
    List<Question> result = [];
    
    // 1. 最初は Firestore を試す
    try {
      final snapshot = await _firestore
          .collection('questions')
          .limit(500)
          .get()
          .timeout(const Duration(seconds: 15));

      final List<Question> fromFirestore = [];
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;
          fromFirestore.add(Question.fromMap(data));
        } catch (e) {
          debugPrint('Parse error for ${doc.id}: $e');
        }
      }

      // フィルタリング（カテゴリ + 有料設定）
      result = fromFirestore.where((q) {
        final qCat = _normalize(q.category);
        final categoryMatch = qCat == normalizedTarget || normalizedTarget == '全て' || normalizedTarget.isEmpty;
        
        // 有料フラグがある場合は、無料(free)に加えて有料(premium)も許可
        // 未課金の場合は「status が free」または「status フィールドがない」もののみ許可
        final status = q.status?.toLowerCase() ?? 'free';
        final accessMatch = isPremium || status == 'free';
        
        return categoryMatch && accessMatch;
      }).toList();

      if (result.isNotEmpty) {
        debugPrint('Firestore から ${result.length} 件取得しました。');
      }
    } catch (e) {
      debugPrint('Firestore 取得エラー: $e');
    }

    // 2. Firestore が空、または指定条件が 0 件だった場合、アセットを試す
    if (result.isEmpty) {
      debugPrint('Firestore が空のため、アセットからの読み込みを試行します...');
      final fromAssets = await loadQuestionsFromAssets();
      result = fromAssets.where((q) {
        final qCat = _normalize(q.category);
        final categoryMatch = qCat == normalizedTarget || normalizedTarget == '全て' || normalizedTarget.isEmpty;
        
        final status = q.status?.toLowerCase() ?? 'free';
        final accessMatch = isPremium || status == 'free';

        return categoryMatch && accessMatch;
      }).toList();
      debugPrint('アセットから ${result.length} 件取得しました。');
    }

    // 3. それでも空の場合、ハードコードされたサンプルを返す
    if (result.isEmpty) {
      debugPrint('アセットも空のため、ハードコードされたサンプルを使用します。');
      final sampleQuestions = _getHardcodedSamples();
      result = sampleQuestions.where((q) {
        final qCat = _normalize(q.category);
        return qCat == normalizedTarget || normalizedTarget == '全て' || normalizedTarget.isEmpty;
      }).toList();
      
      if (result.isEmpty && sampleQuestions.isNotEmpty) {
        result = sampleQuestions;
      }
    }

    return result;
  }

  // ハードコードされたサンプルデータ（seeder.dartのデータの一部を移植、またはリファクタリングして共有）
  List<Question> _getHardcodedSamples() {
    return [
      const Question(
        id: 's1',
        text: '下水道法において、公共下水道の設置及び管理は原則として誰が行うものとされていますか？',
        options: ['国', '地方公共団体（市町村等）', '民間事業者', '都道府県知事'],
        correctOptionIndex: 1,
        explanation: '下水道法第3条により、市町村が公衆衛生の向上等のために設置管理します。',
        category: '下水道法',
      ),
      const Question(
        id: 's2',
        text: 'BOD（生物化学的酸素要求量）の測定において、一般的に採用されている培養期間は何日間ですか？',
        options: ['1日間', '3日間', '5日間', '20日間'],
        correctOptionIndex: 2,
        explanation: 'BOD5として知られる通り、20℃で5日間培養した時の酸素消費量を測定します。',
        category: '下水処理',
      ),
      const Question(
        id: 's3',
        text: '下水道第3種技術検定の対象となるのは、主にどのような業務か？',
        options: ['下水道の設計', '下水道の工事監督', '下水道の維持管理', '下水道の計画立案'],
        correctOptionIndex: 2,
        explanation: '第3種技術検定は、主に下水道施設の維持管理（運転管理・点検整備など）に関する技術を問うものです。',
        category: '検定概要',
      ),
    ];
  }

  // デバッグ用: 全データを JSON 文字列として取得
  Future<String> fetchRawJsonData() async {
    try {
      final snapshot = await _firestore.collection('questions').get();
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      return json.encode(list);
    } catch (e) {
      return 'Error fetching raw data: $e';
    }
  }

  /// 診断用の情報を取得（サーバー優先）
  Future<Map<String, dynamic>> fetchDiagnosticInfo() async {
    try {
      final snapshot = await _firestore.collection('questions')
          .get(const GetOptions(source: Source.server)) // サーバーから強制取得
          .timeout(const Duration(seconds: 10));
      
      final categories = snapshot.docs
          .map((doc) => doc.data()['category'] as String? ?? '未分類')
          .toSet()
          .toList();

      return {
        'projectId': _firestore.app.options.projectId,
        'totalQuestionsServer': snapshot.size, // サーバー上の総数
        'existingCategories': categories.take(5).join(', '),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Firestoreのローカルキャッシュをクリアして再起動する
  Future<void> clearCache() async {
    try {
      await _firestore.terminate().timeout(const Duration(seconds: 3));
      await _firestore.clearPersistence().timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint('Failed to clear cache: $e');
    }
  }

  // カテゴリ一覧の取得
  Future<List<String>> fetchCategories() async {
    try {
      // 1. まず専用の categories コレクションを試す
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('order')
          .get()
          .timeout(const Duration(seconds: 10));
      
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
      }

      // 2. categories がない場合、questions コレクションから直接抽出する（より確実）
      final qSnapshot = await _firestore.collection('questions')
          .limit(1000)
          .get(const GetOptions(source: Source.server));
      
      final dynamicCategories = qSnapshot.docs
          .map((doc) => doc.data()['category']?.toString() ?? '')
          .where((cat) => cat.isNotEmpty)
          .toSet()
          .toList();

      if (dynamicCategories.isNotEmpty) {
        dynamicCategories.sort();
        return dynamicCategories;
      }
      
      // 3. 全て失敗した場合のフォールバック
      return ['下水道法', '下水処理', '検定概要'];
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return ['下水道法', '下水処理', '検定概要'];
    }
  }

}
      
      final dynamicCategories = qSnapshot.docs
          .map((doc) => doc.data()['category']?.toString() ?? '')
          .where((cat) => cat.isNotEmpty)
          .toSet()
          .toList();

      if (dynamicCategories.isNotEmpty) {
        dynamicCategories.sort();
        return dynamicCategories;
      }
      return ['下水道法', '下水処理', '検定概要'];
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return ['下水道法', '下水処理', '検定概要'];
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserPremiumStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
