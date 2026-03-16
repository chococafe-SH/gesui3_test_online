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
    final repository = ref.read(userRepositoryProvider);
    
    try {
      // カテゴリ一覧を動的に取得
      final categories = await repository.fetchCategories();

      for (final category in categories) {
        try {
          // サーバーから強制的にフェッチしてキャッシュを更新する
          await FirebaseFirestore.instance
              .collection('questions')
              .where('category', isEqualTo: category)
              .get(const GetOptions(source: Source.server))
              .timeout(const Duration(seconds: 10));
          print('Background sync completed for: $category');
        } catch (e) {
          print('Background sync failed for $category: $e');
        }
      }
    } catch (e) {
      print('Failed to fetch categories for sync: $e');
    }
  }

  Future<void> triggerManualSync() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _backgroundSync());
  }
}
