import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_provider.dart';
import '../../shared/models/quiz_record.dart';

part 'history_provider.g.dart';

@riverpod
Stream<List<QuizRecord>> quizHistory(QuizHistoryRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        debugPrint('quizHistory: user is null -> return empty List');
        return Stream.value([]);
      }

      debugPrint('quizHistory: fetching snapshots for user: ${user.uid}');
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .orderBy('playedAt', descending: true)
          .limit(100)
          .snapshots()
          .map((snapshot) {
            debugPrint('quizHistory: snapshot received, count: ${snapshot.docs.length}');
            final records = <QuizRecord>[];
            for (final doc in snapshot.docs) {
              try {
                records.add(QuizRecord.fromMap(doc.data(), doc.id));
              } catch (e, stack) {
                debugPrint('⚠️ QuizRecord parse error (${doc.id}): $e\n$stack');
              }
            }
            return records;
          })
          .handleError((error, stackTrace) {
            debugPrint('quizHistory: Stream error: $error\n$stackTrace');
            throw error;
          });
    },
    loading: () {
      debugPrint('quizHistory: authState is loading -> return empty stream');
      return Stream.value([]);
    },
    error: (e, s) {
      debugPrint('quizHistory: authState error -> $e');
      return Stream.error(e, s);
    },
  );
}
