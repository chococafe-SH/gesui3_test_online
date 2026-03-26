import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../models/quiz_state.dart';
import '../quiz_provider.dart';

class QuizResultView extends ConsumerWidget {
  final QuizState quizState;

  const QuizResultView({
    super.key,
    required this.quizState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correctCount = quizState.correctCount;
    final total = quizState.questions.length;
    final score = (quizState.correctRate * 100).toStringAsFixed(0);

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
                  color: context.colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Text(
                      '$score%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                    Text(
                      '$correctCount / $total 問正解',
                      style: TextStyle(fontSize: 16, color: context.colors.textSecondary),
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
                    color: context.colors.accentYellow.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.colors.accentYellow),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: context.colors.accentYellow),
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
                  backgroundColor: context.colors.primary,
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
