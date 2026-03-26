import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/quiz_record.dart';
import '../../../shared/theme/app_colors.dart';
import '../history_detail_screen.dart';

class HistoryListItem extends StatelessWidget {
  final QuizRecord record;

  const HistoryListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy/MM/dd HH:mm').format(record.answeredAt);
    final score = (record.correctRate * 100).toStringAsFixed(0);
    final scoreValue = record.correctRate;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryDetailScreen(record: record),
            ),
          );
        },
        title: Row(
          children: [
            Flexible(
              child: Text(
                record.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (record.category == '模擬試験') ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '模試',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('実施日: $dateStr'),
            Text('正解数: ${record.correctCount} / ${record.totalQuestions}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getScoreColor(context, scoreValue).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _getScoreColor(context, scoreValue).withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            '$score%',
            style: TextStyle(
              color: _getScoreColor(context, scoreValue),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(BuildContext context, double rate) {
    if (rate >= 0.8) return context.colors.correct;
    if (rate >= 0.6) return context.colors.primary;
    if (rate >= 0.4) return context.colors.accentYellow;
    return context.colors.error;
  }
}
