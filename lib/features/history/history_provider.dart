import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_provider.dart';
import '../../shared/models/quiz_record.dart';

part 'history_provider.g.dart';

@riverpod
Stream<List<QuizRecord>> quizHistory(QuizHistoryRef ref) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('history')
      .orderBy('playedAt', descending: true)
      .limit(100)
      .snapshots()
      .map((snapshot) {
    final records = <QuizRecord>[];
    for (final doc in snapshot.docs) {
      try {
        records.add(QuizRecord.fromMap(doc.data(), doc.id));
      } catch (e) {
        // 特定のドキュメントのパースエラーを許容し、他を表示する
        print('⚠️ QuizRecord parse error (${doc.id}): $e');
      }
    }
    return records;
  });
}
