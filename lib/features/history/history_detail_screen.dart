import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../quiz/quiz_provider.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> record;

  const HistoryDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsData = record['questions'] as List<dynamic>? ?? [];
    
    // IDで問題を引き当てるため、カテゴリに関わらず全問題データを取得
    final allQuestionsAsync = ref.watch(onlineQuestionsProvider('全て'));

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
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: isCorrect ? AppColors.secondaryGreen.withAlpha(40) : AppColors.errorRed.withAlpha(40),
                    child: Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: isCorrect ? AppColors.secondaryGreen : AppColors.errorRed,
                    ),
                  ),
                  title: Text(
                    question?.text ?? '問題ID: $questionId',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        isCorrect ? '正解' : '不正解',
                        style: TextStyle(
                          color: isCorrect ? AppColors.secondaryGreen : AppColors.errorRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'あなたの回答: ${selectedOption + 1}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  childrenPadding: const EdgeInsets.all(16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (question != null) ...[
                      const Text(
                        '問題全文:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(question.text, style: const TextStyle(fontSize: 15, height: 1.5)),
                      const SizedBox(height: 20),
                      const Text(
                        '選択肢:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(question.options.length, (i) {
                        final isMySelected = i == selectedOption;
                        final isCorrectOption = i == question.correctOptionIndex;
                        
                        Color bgColor = Colors.transparent;
                        Color textColor = AppColors.textPrimary;
                        Color borderColor = Colors.grey.shade300;
                        Widget? suffix;

                        if (isMySelected && isCorrectOption) {
                          bgColor = AppColors.secondaryGreen.withAlpha(20);
                          textColor = AppColors.secondaryGreen;
                          borderColor = AppColors.secondaryGreen;
                          suffix = const Icon(Icons.check_circle, color: AppColors.secondaryGreen, size: 20);
                        } else if (isMySelected) {
                          bgColor = AppColors.errorRed.withAlpha(15);
                          textColor = AppColors.errorRed;
                          borderColor = AppColors.errorRed;
                          suffix = const Icon(Icons.cancel, color: AppColors.errorRed, size: 20);
                        } else if (isCorrectOption) {
                          bgColor = AppColors.secondaryGreen.withAlpha(10);
                          borderColor = AppColors.secondaryGreen.withAlpha(100);
                          suffix = const Icon(Icons.check_circle_outline, color: AppColors.secondaryGreen, size: 20);
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: (isMySelected || isCorrectOption) ? 1.5 : 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isMySelected ? textColor : Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: isMySelected ? Colors.white : AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.options[i],
                                  style: TextStyle(
                                    color: isMySelected || isCorrectOption ? textColor : AppColors.textPrimary,
                                    fontWeight: isMySelected || isCorrectOption ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (suffix != null) suffix,
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      const Text(
                        '【 解説 】',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.accentYellow.withAlpha(60)),
                        ),
                        child: Text(
                          question.explanation,
                          style: const TextStyle(fontSize: 14, height: 1.6),
                        ),
                      ),
                    ] else
                      const Center(
                        child:  Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              Icon(Icons.search_off, color: Colors.grey, size: 40),
                              SizedBox(height: 8),
                              Text('問題の詳細データをロード中、または削除されています', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
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
                Text('データの読み込みに失敗しました\nカテゴリ: 全て', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(onlineQuestionsProvider('全て')),
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
