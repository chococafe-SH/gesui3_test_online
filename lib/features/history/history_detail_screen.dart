import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../quiz/quiz_provider.dart';
import '../../shared/models/quiz_models.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> record;

  const HistoryDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsData = record['questions'] as List<dynamic>? ?? [];
    final category = record['category'] as String? ?? '全て';
    
    // 全問題データを取得（カテゴリが分かっていればそのカテゴリ、分からなければ全て）
    final allQuestionsAsync = ref.watch(onlineQuestionsProvider(category));

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ結果詳細'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: allQuestionsAsync.when(
        data: (allQuestions) {
          // IDで引き当てやすくするためにMap化
          final questionMap = {for (var q in allQuestions) q.id: q};

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questionsData.length,
            itemBuilder: (context, index) {
              final qData = questionsData[index] as Map<String, dynamic>;
              final questionId = qData['questionId'] as String? ?? '';
              final selectedOption = qData['selectedOption'] as int? ?? -1;
              final isCorrect = qData['isCorrect'] as bool? ?? false;
              
              final question = questionMap[questionId];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  leading: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? AppColors.secondaryGreen : AppColors.errorRed,
                  ),
                  title: Text(
                    '第 ${index + 1} 問',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    question?.text ?? '問題データが見つかりません',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  childrenPadding: const EdgeInsets.all(16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (question != null) ...[
                      const Text(
                        '問題:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 4),
                      Text(question.text),
                      const SizedBox(height: 16),
                      const Text(
                        '選択肢:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(question.options.length, (i) {
                        final isSelected = i == selectedOption;
                        final isCorrectOption = i == question.correctOptionIndex;
                        
                        Color bgColor = Colors.transparent;
                        Color textColor = AppColors.textPrimary;
                        IconData? icon;

                        if (isSelected && isCorrectOption) {
                          bgColor = AppColors.secondaryGreen.withAlpha(30);
                          icon = Icons.check_circle_outline;
                        } else if (isSelected) {
                          bgColor = AppColors.errorRed.withAlpha(30);
                          icon = Icons.highlight_off;
                        } else if (isCorrectOption) {
                          bgColor = Colors.grey.withAlpha(20);
                          icon = Icons.check_circle_outline;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected || isCorrectOption 
                                ? Border.all(color: isCorrectOption ? AppColors.secondaryGreen : AppColors.errorRed)
                                : Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Text('${i + 1}. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(child: Text(question.options[i])),
                              if (icon != null) Icon(icon, size: 20, color: isCorrectOption ? AppColors.secondaryGreen : AppColors.errorRed),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      const Text(
                        '解説:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(question.explanation ?? '解説はありません。'),
                      ),
                    ] else ...[
                      const Text('問題の詳細データを取得できませんでした。'),
                    ],
                  ],
                ),
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
                const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                const SizedBox(height: 16),
                Text('データの読み込みに失敗しました: $err'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(onlineQuestionsProvider(category)),
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
