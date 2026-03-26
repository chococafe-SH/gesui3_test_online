import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mypage_provider.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/models/user_stats.dart';
import 'widgets/profile_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/radar_chart_section.dart';

class MypageScreen extends ConsumerWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(mypageStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) => _buildBody(context, stats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildError(ref),
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserStats stats) {
    final correctRateStr = (stats.correctRate * 100).toStringAsFixed(1);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileCard(stats: stats),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: '総合解答数',
                value: '${stats.totalAnswered} 問',
                icon: Icons.quiz,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: '総合正解率',
                value: '$correctRateStr %',
                icon: Icons.analytics,
                color: context.colors.correct,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        RadarChartSection(categoryStats: stats.categoryStats),
      ],
    );
  }

  Widget _buildError(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('データの取得に失敗しました'),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => ref.invalidate(mypageStatsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('再試行'),
          ),
        ],
      ),
    );
  }
}
