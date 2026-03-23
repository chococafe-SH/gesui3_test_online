import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:developer' as developer;

Future<String> seedQuestions() async {
  final firestore = FirebaseFirestore.instance;
  
  try {
    developer.log('=== Seeder 開始 (JSON アセット読み込み方式) ===', name: 'Seeder');

    // ステップ0: JSON アセットから全問題を読み込む
    final String jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final List<Map<String, dynamic>> questions = jsonData.cast<Map<String, dynamic>>();
    
    developer.log('アセットから ${questions.length} 件の問題を読み込みました。', name: 'Seeder');

    if (questions.isEmpty) {
      return 'エラー: アセットファイルが空か、正しく読み込めませんでした。';
    }

    // ステップ1: まず1件だけサーバーに直接書き込んでテスト
    developer.log('ステップ1: サーバー接続テスト（1件書き込み）', name: 'Seeder');
    final testRef = firestore.collection('questions').doc('test_connection');
    await testRef.set({
      'text': '接続テスト',
      'category': 'テスト',
      'timestamp': FieldValue.serverTimestamp(),
    }).timeout(const Duration(seconds: 15));
    developer.log('ステップ1 完了: 書き込み成功', name: 'Seeder');

    // ステップ2: サーバーから強制読み取りで検証
    developer.log('ステップ2: サーバーからの強制読取り検証', name: 'Seeder');
    try {
      final verifyDoc = await testRef.get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
      if (verifyDoc.exists) {
        developer.log('ステップ2 完了: サーバー上にデータを確認！', name: 'Seeder');
      } else {
        developer.log('ステップ2 警告: サーバーにデータが見つからない', name: 'Seeder');
        return '診断結果: 書き込みは成功しましたが、サーバーから読み取れません。\nFirestore のセキュリティルールを確認してください。';
      }
    } catch (serverReadError) {
      developer.log('ステップ2 エラー: サーバー読取り失敗: $serverReadError', name: 'Seeder');
      return '診断結果: サーバーからの読取りに失敗しました。\nエラー: $serverReadError';
    }

    // ステップ3: テストデータを削除
    await testRef.delete().timeout(const Duration(seconds: 10));
    developer.log('ステップ3: テストデータ削除完了', name: 'Seeder');

    // ステップ3.5: 既存データの全件クリア（サーバー上の実データを全削除）
    developer.log('ステップ3.5: 既存の問題データをすべて削除します（サーバー優先）', name: 'Seeder');
    QuerySnapshot existingDocs;
    try {
      existingDocs = await firestore.collection('questions')
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      developer.log('既存データ取得失敗: $e', name: 'Seeder');
      return '既存データの取得に失敗しました: $e';
    }
    
    developer.log('現在サーバー上に ${existingDocs.size} 件の問題があります。削除を開始します...', name: 'Seeder');

    WriteBatch batch = firestore.batch();
    int deleteCount = 0;
    for (final doc in existingDocs.docs) {
      batch.delete(doc.reference);
      deleteCount++;
      if (deleteCount % 400 == 0) {
        await batch.commit();
        batch = firestore.batch();
      }
    }
    await batch.commit(); // 残りの削除をコミット
    developer.log('既存データ $deleteCount 件の削除完了', name: 'Seeder');

    // ステップ4: 本番データの投入（一意なID指定）
    developer.log('ステップ4: 本番データ ${questions.length}件 を投入', name: 'Seeder');
    int successCount = 0;
    batch = firestore.batch();
    for (final q in questions) {
      final docId = q['id'] as String?;
      final ref = docId != null && docId.isNotEmpty 
          ? firestore.collection('questions').doc(docId) 
          : firestore.collection('questions').doc();
      batch.set(ref, q);
      successCount++;
    }
    await batch.commit();
    developer.log('  投入完了: $successCount 件', name: 'Seeder');

    // ステップ5: サーバーから強制読み取りで最終検証
    developer.log('ステップ5: サーバーから最終検証', name: 'Seeder');
    final serverDocs = await firestore.collection('questions')
        .get(const GetOptions(source: Source.server))
        .timeout(const Duration(seconds: 15));

    final serverCount = serverDocs.size;
    final fromCache = serverDocs.metadata.isFromCache;
    developer.log('最終結果: サーバー上 $serverCount件 (fromCache=$fromCache)', name: 'Seeder');

    if (fromCache) {
      return '警告: サーバーへの接続ができません（オフライン状態）。\nローカルには${successCount}件保存しましたが、サーバーには未反映です。\nネットワーク接続を確認してください。';
    }

    return '完了！サーバーに${serverCount}件の問題を確認しました。\n（今回${successCount}件を投入）\nFirebase Consoleで questions コレクションを確認してください。';
  } catch (e, stack) {
    developer.log('Seeder エラー: $e', name: 'Seeder', error: e, stackTrace: stack);
    return '失敗: $e';
  }
}
