import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/repositories/user_repository_provider.dart';

part 'question_sync_provider.g.dart';

@riverpod
class QuestionSync extends _$QuestionSync {
  @override
  FutureOr<void> build() async {
    // アプリ起動時にバックグラウンドで全カテゴリの同期（プリフェッチ）を開始
    _backgroundSync();
  }

  Future<void> _backgroundSync() async {
    try {
      // UserRepository.fetchQuestions が使用する全件取得クエリと同じものを実行し、
      // サーバーソースを指定することで Firestore のローカルキャッシュを強制更新する。
      await FirebaseFirestore.instance
          .collection('questions')
          .limit(500)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 20));
      
      print('Manual/Background sync: 500 questions prefetched from server.');
    } catch (e) {
      print('Sync failed: $e');
      rethrow; // triggerManualSync で捕捉できるように再スロー
    }
  }

  Future<void> triggerManualSync() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _backgroundSync());
  }
}
