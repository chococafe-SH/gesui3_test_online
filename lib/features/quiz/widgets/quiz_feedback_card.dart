import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/question_image.dart';
import '../../../../shared/widgets/math_text.dart';

class QuizFeedbackCard extends StatelessWidget {
  final bool isCorrect;
  final String explanation;
  final String? explanationImageUrl;

  const QuizFeedbackCard({
    super.key,
    required this.isCorrect,
    required this.explanation,
    this.explanationImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? context.colors.correct.withValues(alpha: 0.1)
            : context.colors.accentYellow.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? context.colors.correct.withValues(alpha: 0.3)
              : context.colors.accentYellow.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.info_outline,
                color: isCorrect
                    ? context.colors.correct
                    : context.colors.accentYellow,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? '正解！' : '不正解',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCorrect
                      ? context.colors.correct
                      : context.colors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          MathText(
            explanation,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          if (explanationImageUrl != null)
            QuestionImage(imageUrl: explanationImageUrl!),
        ],
      ),
    );

  }
}
