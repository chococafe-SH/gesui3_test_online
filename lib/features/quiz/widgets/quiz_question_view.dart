import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/question_image.dart';
import '../models/quiz_state.dart';
import '../quiz_provider.dart';
import '../../../../shared/widgets/math_text.dart';
import '../../history/widgets/option_tile.dart';
import 'quiz_feedback_card.dart';
import 'quiz_exit_dialog.dart';

class QuizQuestionView extends ConsumerWidget {
  final QuizState quizState;

  const QuizQuestionView({
    super.key,
    required this.quizState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = quizState.currentQuestion;
    final isShowingFeedback = quizState.showingFeedback;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await showQuizExitDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('問題 ${quizState.currentIndex + 1} / ${quizState.questions.length}'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldPop = await showQuizExitDialog(context);
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // プログレスバー
                  LinearProgressIndicator(
                    value: quizState.progress,
                    backgroundColor: context.colors.disabled,
                    valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                  ),
                  const SizedBox(height: 24),

                  // 問題文
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MathText(
                            question.text,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (question.imageUrl != null)
                             QuestionImage(imageUrl: question.imageUrl!),
                        ],
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
                            return OptionTile(
                              index: index,
                              text: question.options[index],
                              selectedOption: quizState.answers[quizState.currentIndex],
                              correctOptionIndex: question.correctOptionIndex,
                              showingFeedback: isShowingFeedback,
                              onTap: isShowingFeedback
                                  ? null
                                  : () => ref.read(quizNotifierProvider.notifier).selectOption(index),
                            );
                          }),

                          // フィードバック表示
                          if (isShowingFeedback) ...[
                            const SizedBox(height: 8),
                            QuizFeedbackCard(
                              isCorrect: quizState.isCurrentCorrect,
                              explanation: question.explanation,
                              explanationImageUrl: question.explanationImageUrl,
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
                        backgroundColor: context.colors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        quizState.isLastQuestion ? '結果を見る' : '次の問題へ',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
