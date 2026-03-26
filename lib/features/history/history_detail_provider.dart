import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/models/question.dart';
import '../mypage/mypage_provider.dart';

extension ListChunk<T> on List<T> {
  List<List<T>> chunked(int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < length; i += chunkSize) {
      chunks.add(sublist(i, i + chunkSize > length ? length : i + chunkSize));
    }
    return chunks;
  }
}

final questionsForRecordProvider = FutureProvider.family<Map<String, Question>, List<String>>((ref, ids) async {
  if (ids.isEmpty) return {};
  
  final firestore = ref.watch(firestoreProvider);
  final results = <String, Question>{};
  
  // FirestoreのwhereInは最大10件
  for (final batch in ids.chunked(10)) {
    final snapshot = await firestore
        .collection('questions')
        .where(FieldPath.documentId, whereIn: batch)
        .get();
    for (final doc in snapshot.docs) {
      results[doc.id] = Question.fromMap(doc.data(), doc.id);
    }
  }
  return results;
});
