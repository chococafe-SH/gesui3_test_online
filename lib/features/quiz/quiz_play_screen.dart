import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import 'quiz_provider.dart';

class QuizPlayScreen extends ConsumerWidget {
  const QuizPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider);
    
    if (quizState.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('問題がありません')),
      );
    }

    if (quizState.isCompleted) {
      return _buildResultScreen(context, ref, quizState);
    }

    return _buildQuestionScreen(context, ref, quizState);
  }

  Widget _buildQuestionScreen(BuildContext context, WidgetRef ref, quizState) {
    final question = quizState.currentQuestion;
    final isShowingFeedback = quizState.showingFeedback;

    return Scaffold(
      appBar: AppBar(
        title: Text('問題 ${quizState.currentIndex + 1} / ${quizState.questions.length}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // プログレスバー
            LinearProgressIndicator(
              value: (quizState.currentIndex + 1) / quizState.questions.length,
              backgroundColor: AppColors.disabled,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
            const SizedBox(height: 24),

            // 問題文
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  question.text,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 選択肢
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(question.options.length, (index) {
                      final isSelected = quizState.answers[quizState.currentIndex] == index;
                      final isCorrectOption = index == question.correctOptionIndex;

                      // フィードバック表示時の色分け
                      Color borderColor = AppColors.border;
                      Color? bgColor;
                      FontWeight fontWeight = FontWeight.normal;
                      Color textColor = AppColors.textPrimary;

                      if (isShowingFeedback) {
                        if (isCorrectOption) {
                          borderColor = AppColors.secondaryGreen;
                          bgColor = AppColors.secondaryGreen.withAlpha(25);
                          fontWeight = FontWeight.bold;
                          textColor = AppColors.secondaryGreen;
                        } else if (isSelected && !isCorrectOption) {
                          borderColor = AppColors.errorRed;
                          bgColor = AppColors.errorRed.withAlpha(25);
                          fontWeight = FontWeight.bold;
                          textColor = AppColors.errorRed;
                        }
                      } else if (isSelected) {
                        borderColor = AppColors.primaryBlue;
                        bgColor = AppColors.primaryBlue.withAlpha(13);
                        fontWeight = FontWeight.bold;
                        textColor = AppColors.primaryBlue;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: OutlinedButton(
                          onPressed: isShowingFeedback
                              ? null
                              : () => ref.read(quizNotifierProvider.notifier).selectOption(index),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                            side: BorderSide(
                              color: borderColor,
                              width: (isSelected || (isShowingFeedback && isCorrectOption)) ? 2 : 1,
                            ),
                            backgroundColor: bgColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            disabledForegroundColor: textColor,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${index + 1}. ${question.options[index]}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: fontWeight,
                                    ),
                                  ),
                                ),
                                if (isShowingFeedback && isCorrectOption)
                                  const Icon(Icons.check_circle, color: AppColors.secondaryGreen, size: 22),
                                if (isShowingFeedback && isSelected && !isCorrectOption)
                                  const Icon(Icons.cancel, color: AppColors.errorRed, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // 解説表示
                    if (isShowingFeedback) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: quizState.isCurrentCorrect
                              ? AppColors.secondaryGreen.withAlpha(15)
                              : AppColors.accentYellow.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: quizState.isCurrentCorrect
                                ? AppColors.secondaryGreen.withAlpha(60)
                                : AppColors.accentYellow.withAlpha(80),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  quizState.isCurrentCorrect ? Icons.check_circle : Icons.info_outline,
                                  color: quizState.isCurrentCorrect ? AppColors.secondaryGreen : AppColors.accentYellow,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  quizState.isCurrentCorrect ? '正解！' : '不正解',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: quizState.isCurrentCorrect ? AppColors.secondaryGreen : AppColors.errorRed,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              question.explanation,
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ボタン
            if (isShowingFeedback)
              ElevatedButton(
                onPressed: () => ref.read(quizNotifierProvider.notifier).confirmAnswer(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  quizState.currentIndex == quizState.questions.length - 1 ? '結果を見る' : '次の問題へ',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, WidgetRef ref, quizState) {
    // 正答数を計算
    int correctCount = 0;
    for (int i = 0; i < quizState.questions.length; i++) {
      if (quizState.answers[i] == quizState.questions[i].correctOptionIndex) {
        correctCount++;
      }
    }
    final total = quizState.questions.length;
    final score = total > 0 ? (correctCount / total * 100).toStringAsFixed(0) : '0';

    return Scaffold(
      appBar: AppBar(title: const Text('結果')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('クイズ完了！', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              // スコア表示
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Text(
                      '$score%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Text(
                      '$correctCount / $total 問正解',
                      style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // 保存エラーの通知
              if (quizState.saveError != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accentYellow),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: AppColors.accentYellow),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          '結果の保存に失敗しましたが、\nオンライン復帰時に自動で同期されます。',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(quizNotifierProvider.notifier).reset();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.home),
                label: const Text('ホームに戻る'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => ref.read(quizNotifierProvider.notifier).reset(),
                icon: const Icon(Icons.replay),
                label: const Text('もう一度解く'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

