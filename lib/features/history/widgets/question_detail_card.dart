import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/quiz_record.dart';
import '../../../../shared/models/question.dart';
import '../../../../shared/widgets/question_image.dart';
import '../../../../shared/widgets/math_text.dart';
import 'option_tile.dart';

class QuestionDetailCard extends StatelessWidget {
  final QuizAnswer answer;
  final Question? question;

  const QuestionDetailCard({super.key, required this.answer, this.question});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsTheme>() ?? AppColorsTheme.light;
    final textTheme = Theme.of(context).textTheme;
    
    final isCorrect = answer.isCorrect;
    final statusColor = isCorrect ? colors.correct : colors.incorrect;
    final statusBgColor = isCorrect ? colors.correctBg : colors.incorrectBg;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: CircleAvatar(
          backgroundColor: statusBgColor,
          child: Icon(
            isCorrect ? Icons.check : Icons.close,
            color: statusColor,
          ),
        ),
        title: question != null
            ? MathText(
                question!.text,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                '問題ID: ${answer.questionId}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
        subtitle: Row(
          children: [
            Text(
              isCorrect ? '正解' : '不正解',
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              answer.selectedOption >= 0
                  ? 'あなたの回答: ${answer.selectedOption + 1}'
                  : '未回答',
              style: TextStyle(fontSize: 12, color: textTheme.bodySmall?.color),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: question != null
            ? _buildExpandedContent(context, question!)
            : [_buildNotFound()],
      ),
    );
  }

  List<Widget> _buildExpandedContent(BuildContext context, Question q) {
    final textTheme = Theme.of(context).textTheme;

    return [
      const _SectionLabel('問題全文:'),
      const SizedBox(height: 6),
      MathText(
        q.text,
        style: textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      if (q.imageUrl != null)
        QuestionImage(imageUrl: q.imageUrl!),
      const SizedBox(height: 20),
      const _SectionLabel('選択肢:'),
      const SizedBox(height: 10),
      for (final (index, optionText) in q.options.indexed)
        OptionTile(
          index: index,
          text: optionText,
          selectedOption: answer.selectedOption,
          correctOptionIndex: q.correctOptionIndex,
        ),
      const SizedBox(height: 20),
      const _SectionLabel('【 解説 】'),
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.accent.withValues(alpha: 1.0), // 元が0.1だったので要調整だが、accentBgを使うのが適切か
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.accent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MathText(
              q.explanation,
              style: textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            if (q.explanationImageUrl != null)
              QuestionImage(imageUrl: q.explanationImageUrl!),
          ],
        ),
      ),
    ];
  }

  Widget _buildNotFound() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(Icons.search_off, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text('この問題は削除されたか、データが見つかりません',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: context.colors.primary,
        fontSize: 13,
      ),
    );
  }
}
