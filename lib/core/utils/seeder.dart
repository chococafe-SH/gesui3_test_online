import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

Future<String> seedQuestions() async {
  final firestore = FirebaseFirestore.instance;
  final questions = [
    {
      'text': '下水道法において、公共下水道の設置及び管理は原則として誰が行うものとされていますか？',
      'options': ['国', '地方公共団体（市町村等）', '民間事業者', '都道府県知事'],
      'correctOptionIndex': 1,
      'explanation': '下水道法第3条により、市町村が公衆衛生の向上等のために設置管理します。',
      'category': '下水道法',
    },
    {
      'text': '下水道法における「終末処理場」の定義として、正しいものはどれですか？',
      'options': [
        '下水を一時的に溜める施設',
        '下水を処理して公共用水域に放流する施設',
        '汚泥のみを焼却する施設',
        '雨水のみを排除する施設'
      ],
      'correctOptionIndex': 1,
      'explanation': '下水を処理し、下水道の出口において公共用水域に放流するために設けられる施設を指します。',
      'category': '下水道法',
    },
    {
      'text': '公共下水道の使用を開始しようとする者が、あらかじめ公共下水道管理者に届け出なければならない事項はどれですか？',
      'options': ['使用者の氏名', '下水の水質', '使用の開始、休止又は廃止', '放流先の水域'],
      'correctOptionIndex': 2,
      'explanation': '下水道法第16条により、使用の開始、休止又は廃止を届け出る必要があります。',
      'category': '下水道法',
    },
    {
      'text': 'BOD（生物化学的酸素要求量）の測定において、一般的に採用されている培養期間は何日間ですか？',
      'options': ['1日間', '3日間', '5日間', '20日間'],
      'correctOptionIndex': 2,
      'explanation': 'BOD5として知られる通り、20℃で5日間培養した時の酸素消費量を測定します。',
      'category': '下水道法',
    },
    {
      'text': '活性汚泥の沈降性を表す指標で、1gの活性汚泥浮遊物質が占める容積（ml）を何と呼びますか？',
      'options': ['SV30', 'SVI', 'MLVSS', 'SRT'],
      'correctOptionIndex': 1,
      'explanation': 'SVI（Sludge Volume Index：汚泥容量指標）です。通常100〜150程度が良好とされます。',
      'category': '下水道法',
    },
    {
       'text': '下水道法に基づき、事業場からの下水の排除を制限することができる物質はどれですか？',
       'options': ['純水', '蒸留水', '特定施設から排出される汚水（有害物質等）', '雨水'],
       'correctOptionIndex': 2,
       'explanation': '有害物質や下水道施設を損傷するおそれのある物質を含む下水は、除害施設の設置などにより制限されます。',
       'category': '下水道法',
    },
    {
       'text': '「汚水」の定義として適切なものはどれですか？',
       'options': ['雨水のみ', '生活又は事業に付随して排泄される液体状の不潔な物', '工場の冷却水のみ', '地下水'],
       'correctOptionIndex': 1,
       'explanation': '下水道法では、伝染病の病原体を含むおそれのある尿等、生活や事業による不潔な物を指します。',
       'category': '下水道法',
    },
  ];

  try {
    developer.log('=== Seeder 開始 ===', name: 'Seeder');

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
        return '診断結果: 書き込みは成功しましたが、サーバーから読み取れません。\nFirestore のセキュリティルールで READ が拒否されている可能性があります。\nルールを「allow read, write: if true;」に設定してください。';
      }
    } catch (serverReadError) {
      developer.log('ステップ2 エラー: サーバー読取り失敗: $serverReadError', name: 'Seeder');
      return '診断結果: サーバーからの読取りに失敗しました。\nエラー: $serverReadError\n\n考えられる原因:\n1. ネットワーク接続の問題\n2. Firestoreセキュリティルールの設定不備\n3. Authenticationの未設定';
    }

    // ステップ3: テストデータを削除
    await testRef.delete().timeout(const Duration(seconds: 10));
    developer.log('ステップ3: テストデータ削除完了', name: 'Seeder');

    // ステップ4: 本番データの投入（個別に書き込み）
    developer.log('ステップ4: 本番データ ${questions.length}件 を個別投入', name: 'Seeder');
    int successCount = 0;
    for (final q in questions) {
      final ref = firestore.collection('questions').doc();
      await ref.set(q).timeout(const Duration(seconds: 10));
      successCount++;
      developer.log('  投入完了: $successCount/${questions.length}', name: 'Seeder');
    }

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
