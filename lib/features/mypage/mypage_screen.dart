import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mypage_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/models/user_stats.dart';

class MypageScreen extends ConsumerWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(mypageStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) {
          final nextLevelXp = UserStats.getXpForNextLevel(stats.level);
          final progress = nextLevelXp > 0 ? stats.xp / nextLevelXp : 0.0;
          final correctRate = stats.totalAnswered > 0
              ? (stats.correctCount / stats.totalAnswered * 100).toStringAsFixed(1)
              : '0.0';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── プロフィールカード ──
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primaryBlue,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '学習者',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange),
                          Text(
                            ' ${stats.currentStreak} 日連続',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('レベル ${stats.level}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${stats.xp} / $nextLevelXp XP'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[200],
                        color: AppColors.primaryBlue,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── 統計カード ──
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: '総合解答数',
                      value: '${stats.totalAnswered} 問',
                      icon: Icons.quiz,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: '総合正解率',
                      value: '$correctRate %',
                      icon: Icons.analytics,
                      color: AppColors.secondaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── 分野別レーダーチャート ──
              _RadarChartSection(categoryStats: stats.categoryStats),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('データ取得エラー: $err')),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// レーダーチャートセクション
// ────────────────────────────────────────────────
class _RadarChartSection extends StatelessWidget {
  final Map<String, CategoryStat> categoryStats;

  const _RadarChartSection({required this.categoryStats});

  @override
  Widget build(BuildContext context) {
    // データがない場合は案内を表示
    if (categoryStats.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Column(
            children: [
              Icon(Icons.radar, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                '分野別チャート',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'クイズを解くと分野別の得手不得手が\nレーダーチャートで表示されます',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    // カテゴリを最大8件に絞る（RadarChartは頂点数が多すぎると読みにくい）
    final entries = categoryStats.entries.toList();
    final displayEntries = entries.length > 8 ? entries.sublist(0, 8) : entries;
    final count = displayEntries.length;

    // RadarChart用のデータセット（正解率 0.0〜1.0 を値として使用）
    final radarDataSets = [
      RadarDataSet(
        fillColor: AppColors.primaryBlue.withValues(alpha: 0.25),
        borderColor: AppColors.primaryBlue,
        borderWidth: 2,
        entryRadius: 4,
        dataEntries: displayEntries
            .map((e) => RadarEntry(value: e.value.rate * 100))
            .toList(),
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.radar, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  '分野別 得手不得手',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 280,
              child: RadarChart(
                RadarChartData(
                  dataSets: radarDataSets,
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.grey, width: 1),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  tickCount: 4,
                  ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                  tickBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  getTitle: (index, angle) {
                    if (index >= count) return RadarChartTitle(text: '');
                    final cat = displayEntries[index].key;
                    // 長いカテゴリ名を短縮表示
                    final label = cat.length > 6 ? '${cat.substring(0, 6)}…' : cat;
                    return RadarChartTitle(
                      text: label,
                      angle: 0, // 常に水平で読みやすく
                    );
                  },
                  titleTextStyle: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  titlePositionPercentageOffset: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 分野別の凡例テーブル
            ...displayEntries.map((e) {
              final rate = (e.value.rate * 100).toStringAsFixed(0);
              final color = _rateColor(e.value.rate);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e.key, style: const TextStyle(fontSize: 13)),
                    ),
                    Text(
                      '$rate%',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold, color: color),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${e.value.correct}/${e.value.total})',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _rateColor(double rate) {
    if (rate >= 0.8) return AppColors.secondaryGreen;
    if (rate >= 0.5) return Colors.orange;
    return AppColors.errorRed;
  }
}

// ────────────────────────────────────────────────
// 統計カード
// ────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
