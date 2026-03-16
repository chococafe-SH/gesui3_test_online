import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/user_repository.dart';

part 'user_repository_provider.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository();
}

@riverpod
Future<List<String>> categories(CategoriesRef ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.fetchCategories();
}
