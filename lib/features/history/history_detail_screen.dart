import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/quiz_record.dart';
import 'widgets/question_detail_card.dart';
import 'history_detail_provider.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final QuizRecord record;

  const HistoryDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionIdsString = record.questions.map((q) => q.questionId).join(',');

    // 必要な問題だけを取得
    final questionsAsync = ref.watch(questionsForRecordProvider(questionIdsString));

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ結果詳細'),
        elevation: 0,
      ),
      body: questionsAsync.when(
        data: (questionMap) {
          if (record.questions.isEmpty) {
            return const Center(child: Text('この履歴には詳細な回答データがありません。（古い履歴の可能性があります）'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: record.questions.length,
            itemBuilder: (context, index) {
              final answer = record.questions[index];
              final question = questionMap[answer.questionId];

              return QuestionDetailCard(
                answer: answer,
                question: question,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('データの読み込みに失敗しました\n$err', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(questionsForRecordProvider(questionIdsString)),
                  child: const Text('再試行'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
