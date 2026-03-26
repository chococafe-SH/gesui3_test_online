import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/user_stats.dart';

class ProfileCard extends StatelessWidget {
  final UserStats stats;

  const ProfileCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: context.colors.primary,
              child: const Icon(Icons.person, size: 40, color: Colors.white),
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
                Text('${stats.levelProgress} / ${stats.xpRequiredForNextLevel} XP'),
              ],
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'レベル${stats.level}の経験値 ${stats.levelProgress} / ${stats.xpRequiredForNextLevel}',
              child: LinearProgressIndicator(
                value: stats.levelProgressRate,
                backgroundColor: context.colors.disabled.withValues(alpha: 0.3),
                color: context.colors.primary,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
