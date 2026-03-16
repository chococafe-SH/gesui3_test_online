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
          'createdAt': FieldValue.serverTimestamp(),
          'stats': {
            'totalAnswered': 0,
            'correctCount': 0,
            'lastActive': FieldValue.serverTimestamp(),
          },
        }).timeout(const Duration(seconds: 10));
      } else {
        await userDoc.update({
          'stats.lastActive': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 10));
      }
    } catch (e) {
      print('Failed to initialize user: $e');
      rethrow;
    }
  }

  // クイズ記録の保存
  Future<void> saveQuizResult(
    String uid,
    String category,
    List<Map<String, dynamic>> questionRecords,
    int correctCount,
  ) async {
    // 楽観的に完了させるため、同期を待たずに処理を開始
    final batch = _firestore.batch();
    
    // 1. 履歴の追加
    final historyRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('history')
        .doc();
    
    batch.set(historyRef, {
      'playedAt': FieldValue.serverTimestamp(),
      'category': category,
      'correctCount': correctCount,
      'totalQuestions': questionRecords.length,
      'questions': questionRecords,
    });

    // 2. ユーザー統計の更新
    final userRef = _firestore.collection('users').doc(uid);
    batch.update(userRef, {
      'stats.totalAnswered': FieldValue.increment(questionRecords.length),
      'stats.correctCount': FieldValue.increment(correctCount),
      'stats.lastActive': FieldValue.serverTimestamp(),
    });

    // オフライン対応のため、commit() 自体は即座に（あるいはバックグラウンドで）動作させる
    // await しないことで呼び出し元（UI）に即座に制御を戻す選択肢もあるが、
    // ここでは Firestore の内部キューに任せるため await する（Offline Persistence が有効なら即座に完了する）
    await batch.commit();
  }

  // オンライン・オフライン両対応の問題取得
  Future<List<Question>> fetchQuestions(String category) async {
    print('Fetching questions for category: "$category" (Cache first)');
    try {
      // 1. キャッシュ/サーバー混在で取得
      var snapshot = await _firestore
          .collection('questions')
          .where('category', isEqualTo: category)
          .get()
          .timeout(const Duration(seconds: 15), onTimeout: () {
            print('Fetch timeout for "$category", attempting cache source.');
            return _firestore
                .collection('questions')
                .where('category', isEqualTo: category)
                .get(const GetOptions(source: Source.cache));
          });

      // 2. もし結果が 0件 だった場合、サーバーから強制的に最新データを取得し直す（同期漏れ対策）
      if (snapshot.docs.isEmpty) {
        print('0 items found in cache/primary for "$category". Forcing server fetch.');
        snapshot = await _firestore
            .collection('questions')
            .where('category', isEqualTo: category)
            .get(const GetOptions(source: Source.server))
            .timeout(const Duration(seconds: 15));
      }

      print('Firestore fetch success: ${snapshot.docs.length} docs found. (isFromCache: ${snapshot.metadata.isFromCache})');
      
      final questions = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Question.fromMap(data);
      }).toList();

      return questions;
    } catch (e) {
      print('Error fetching questions for "$category": $e');
      rethrow;
    }
  }
  // カテゴリ一覧の取得
  Future<List<String>> fetchCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('order')
          .get()
          .timeout(const Duration(seconds: 10), onTimeout: () {
            return _firestore.collection('categories').get(const GetOptions(source: Source.cache));
          });
      
      if (snapshot.docs.isEmpty) {
        // デフォルトのカテゴリを返す（初期データがない場合）
        return ['下水道法', '下水処理', '検定概要'];
      }
      
      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return ['下水道法', '下水処理', '検定概要'];
    }
  }
}
