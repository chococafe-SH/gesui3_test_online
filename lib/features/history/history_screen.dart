import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'history_provider.dart';
import '../../shared/theme/app_colors.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(quizHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学習履歴'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: historyState.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Text('履歴がまだありません。\nクイズに挑戦してみましょう！',
                  textAlign: TextAlign.center),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final record = history[index];
              final playedAt = record['playedAt'] as Timestamp?;
              final dateStr = playedAt != null
                  ? DateFormat('yyyy/MM/dd HH:mm').format(playedAt.toDate())
                  : '不明';
              final correct = record['correctCount'] as int? ?? 0;
              final total = record['totalQuestions'] as int? ?? 0;
              final score = (correct / total * 100).toStringAsFixed(0);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    record['category'] ?? '未分類',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('実施日: $dateStr'),
                      Text('正解数: $correct / $total'),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryGreen.withAlpha(26), // 0.1 * 255
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$score%',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('読み込みエラー: $err')),
      ),
    );
  }
}
