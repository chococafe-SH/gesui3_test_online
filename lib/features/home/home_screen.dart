import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../quiz/quiz_provider.dart';
import '../quiz/quiz_play_screen.dart';
import '../../core/utils/seeder.dart';
import '../../core/repositories/user_repository_provider.dart';
import '../../core/providers/premium_provider.dart';
import '../mypage/mypage_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildHeaderBackground(context),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildUserInfo(context, ref),
                  const SizedBox(height: 32),
                  _buildProgressCard(context, ref),
                  const SizedBox(height: 40),
                  _buildMenuSection(context, ref),
                  const SizedBox(height: 40),
                  _buildDevTools(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.4;
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryDarkBlue,
          ],
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(52),
          bottomRight: Radius.circular(52),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(mypageStatsProvider);
    final streak = statsAsync.valueOrNull?.currentStreak ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '下水道3種',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '集中攻略 1.0.1',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white24,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=kenta'),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '田中 健太',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withAlpha(25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                  Text(' $streak 日', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(mypageStatsProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(160), 
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withAlpha(100), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: statsAsync.when(
            data: (stats) {
              final correctRate = stats.totalAnswered > 0 
                  ? (stats.correctCount / stats.totalAnswered * 100)
                  : 0.0;
              final xpProgress = stats.xp > 0 ? (stats.xp % 100) / 100.0 : 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '総合学習状況',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: CircularProgressIndicator(
                              value: stats.totalAnswered > 0 ? correctRate / 100 : 0.0,
                              strokeWidth: 12,
                              strokeCap: StrokeCap.round,
                              backgroundColor: AppColors.primaryBlue.withAlpha(30),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryGreen),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '${correctRate.toStringAsFixed(0)}%',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              Text('全${stats.totalAnswered}問', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 28),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('レベル: ${stats.level}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 10),
                            Text('経験値: ${stats.xp} XP', style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              child: LinearProgressIndicator(
                                value: xpProgress,
                                minHeight: 10,
                                backgroundColor: AppColors.primaryBlue.withAlpha(20),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryGreen),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Center(child: Text('読み込みエラー')),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(mypageStatsProvider);
    final userStats = statsAsync.valueOrNull;
    final weakQuestions = userStats?.weakQuestions ?? [];
    final weakCount = weakQuestions.length;

    return Column(
      children: [
        _buildGradientMenuCard(
          context: context,
          title: 'クイズを始める',
          subtitle: 'ランダム出題\n最大20問 / 推奨：15分',
          icon: Icons.play_circle_filled_rounded,
          colors: [const Color(0xFF81C784), AppColors.secondaryGreen],
          onTap: () async {
            await _handleQuizStart(context, ref);
          },
        ),
        const SizedBox(height: 20),
        _buildGradientMenuCard(
          context: context,
          title: '間違えた問題を復習',
          subtitle: 'ランダム出題\n最大20問 / 未習得 $weakCount問',
          icon: Icons.history_edu_rounded,
          colors: [const Color(0xFFFFD54F), const Color(0xFFFBBC05)],
          onTap: () async {
            await _handleWeakQuizStart(context, ref, weakQuestions);
          },
        ),
        const SizedBox(height: 20),
        _buildGradientMenuCard(
          context: context,
          title: '模擬試験',
          subtitle: '本番形式：全60問\n過去問ベース・実力診断',
          icon: Icons.assignment_turned_in_rounded,
          colors: [AppColors.primaryBlue.withAlpha(200), AppColors.primaryBlue],
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildGradientMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withAlpha(100),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(60),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleQuizStart(BuildContext context, WidgetRef ref) async {
    final selectedCategory = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const _CategorySelectionDialog(),
      transitionBuilder: (context, anim1, _, child) {
        return FadeTransition(opacity: anim1, child: ScaleTransition(scale: anim1, child: child));
      },
    );

    if (selectedCategory == null) return;

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
    );

    try {
      ref.invalidate(onlineQuestionsProvider(selectedCategory));
      final questions = await ref.read(onlineQuestionsProvider(selectedCategory).future)
          .timeout(const Duration(seconds: 25));
      
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        if (questions.isEmpty) {
          _showDiagnosticResult(context, ref, selectedCategory);
          return;
        }

        // 取得した全問題をランダムにシャッフルし、最大20問に絞る
        final randomQuestions = questions.toList()..shuffle();
        final targetQuestions = randomQuestions.take(20).toList();

        ref.read(quizNotifierProvider.notifier).startQuiz(targetQuestions);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('「$selectedCategory」から${targetQuestions.length}問を選択しました（全${questions.length}問）')),
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const QuizPlayScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _showDiagnosticResult(BuildContext context, WidgetRef ref, String category) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final repository = ref.read(userRepositoryProvider);
    final info = await repository.fetchDiagnosticInfo();
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('設定の確認・診断'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('検索カテゴリ: "$category"'),
              const Divider(),
              Text('プロジェクトID: ${info['projectId']}'),
              Text('サーバー側の問題数: ${info['totalQuestionsServer']}'),
              Text('カテゴリ例: ${info['existingCategories']}'),
              if (info['error'] != null) Text('エラー: ${info['error']}', style: const TextStyle(color: Colors.red)),
              const Divider(),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));
                  await ref.read(userRepositoryProvider).clearCache();
                  ref.invalidate(categoriesProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('キャッシュをクリアしました。アプリを再起動してください。')));
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('キャッシュクリア & 再同期'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              const SizedBox(height: 8),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  final json = await ref.read(userRepositoryProvider).fetchRawJsonData();
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('JSON データ出力'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: SelectableText(json, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる')),
                      ],
                    ),
                  );
                },
                child: const Text('データをJSONでエクスポート'),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context); // 診断ダイアログを閉じる
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );
                  
                  final result = await seedQuestions();
                  
                  if (!context.mounted) return;
                  Navigator.pop(context); // ローディングを閉じる
                  
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('データ投入結果'),
                      content: Text(result),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ref.invalidate(categoriesProvider); // カテゴリ一覧を更新
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.cloud_upload),
                label: const Text('サンプルデータを投入（シード）'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる')),
        ],
      ),
    );
  }

  Widget _buildDevTools(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ver 1.0.0',
          style: TextStyle(color: AppColors.disabled, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => _showDiagnosticResult(context, ref, '自動読込みテスト'),
          icon: const Icon(Icons.info_outline, size: 16, color: AppColors.disabled),
        ),
      ],
    );
  }
  Future<void> _handleWeakQuizStart(BuildContext context, WidgetRef ref, List<String> weakIds) async {
    if (weakIds.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('間違えた問題はありません！')),
        );
      }
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final isPremium = ref.read(premiumNotifierProvider);
      final questions = await ref.read(weakQuestionsProvider(weakIds, isPremium).future);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // loadingを閉じる
        if (questions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('復習対象の問題を取得できませんでした。')),
          );
          return;
        }

        final randomQuestions = questions.toList()..shuffle();
        final targetQuestions = randomQuestions.take(20).toList();

        ref.read(quizNotifierProvider.notifier).startQuiz(targetQuestions);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuizPlayScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
  }

}

class _CategorySelectionDialog extends ConsumerWidget {
  const _CategorySelectionDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(240),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.category_rounded, color: AppColors.primaryBlue, size: 48),
              const SizedBox(height: 16),
              const Text('学習カテゴリを選択', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryDarkBlue)),
              const SizedBox(height: 8),
              const Text('試験科目を選んで学習を開始します', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              categoriesState.when(
                data: (categories) => ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withAlpha(15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(category, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDarkBlue)),
                          trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.primaryBlue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          onTap: () => Navigator.of(context).pop(category),
                        ),
                      );
                    },
                  ),
                ),
                loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                error: (e, s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('エラー: $e', style: const TextStyle(color: Colors.redAccent)),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
          ),
        ),
      ),
    );
  }
}
