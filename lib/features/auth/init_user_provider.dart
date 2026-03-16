import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/repositories/user_repository_provider.dart';
import 'auth_provider.dart';

part 'init_user_provider.g.dart';

/// サインイン完了後にユーザードキュメントを初期化するプロバイダー。
/// オフライン時はタイムアウトでスキップし、アプリは継続利用可能。
@riverpod
Future<void> initUser(InitUserRef ref) async {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return;

  final repository = ref.read(userRepositoryProvider);
  try {
    await repository.initializeUser(user.uid, user.isAnonymous);
  } catch (e) {
    // オフラインや初期化失敗時でもアプリは続行可能
    // Firestoreのオフラインキューに積まれるので、次回オンライン時に反映される
    print('User initialization skipped (offline or error): $e');
  }
}
