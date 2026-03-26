import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/user_stats.dart';

class _ChartConfig {
  static const maxCategories = 8;
  static const maxLabelLength = 6;
  static const chartHeight = 280.0;
  static const tickCount = 4;
}

class RadarChartSection extends StatelessWidget {
  final Map<String, CategoryStat> categoryStats;

  const RadarChartSection({super.key, required this.categoryStats});

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

    // カテゴリをソート後、最大数に絞る
    final entries = categoryStats.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final displayEntries = entries.length > _ChartConfig.maxCategories 
        ? entries.sublist(0, _ChartConfig.maxCategories) 
        : entries;
    final count = displayEntries.length;

    // fl_chart の fillColor などを .withOpacity に修正
    final radarDataSets = [
      RadarDataSet(
        fillColor: context.colors.primary.withValues(alpha: 0.25),
        borderColor: context.colors.primary,
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
                Icon(Icons.radar, color: context.colors.primary),
                const SizedBox(width: 8),
                const Text(
                  '分野別 得手不得手',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: _ChartConfig.chartHeight,
              child: RadarChart(
                RadarChartData(
                  dataSets: radarDataSets,
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.grey, width: 1),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  tickCount: _ChartConfig.tickCount,
                  ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                  tickBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  getTitle: (index, angle) {
                    if (index >= count) return RadarChartTitle(text: '');
                    final cat = displayEntries[index].key;
                    final label = cat.length > _ChartConfig.maxLabelLength 
                        ? '${cat.substring(0, _ChartConfig.maxLabelLength)}…' 
                        : cat;
                    return RadarChartTitle(
                      text: label,
                      angle: 0, 
                    );
                  },
                  titleTextStyle: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  titlePositionPercentageOffset: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 分野別の凡例テーブル（forコントロールフローを使用）
            for (final e in displayEntries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: _rateColor(context, e.value.rate), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e.key, style: const TextStyle(fontSize: 13)),
                    ),
                    Text(
                      '${(e.value.rate * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold, color: _rateColor(context, e.value.rate)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${e.value.correct}/${e.value.total})',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _rateColor(BuildContext context, double rate) {
    if (rate >= 0.8) return context.colors.correct;
    if (rate >= 0.5) return Colors.orange;
    return context.colors.error;
  }
}
