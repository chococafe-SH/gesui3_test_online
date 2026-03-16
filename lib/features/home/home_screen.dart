import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../quiz/quiz_provider.dart';
import '../quiz/quiz_play_screen.dart';
import '../../core/utils/seeder.dart';
import '../../core/repositories/user_repository_provider.dart';

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
                  _buildUserInfo(context),
                  const SizedBox(height: 32),
                  _buildProgressCard(context),
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

  Widget _buildUserInfo(BuildContext context) {
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
              '集中攻略',
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
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(25)),
                  ),
                  child: const Icon(Icons.notifications_none, color: Colors.white),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '週間の学習状況',
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
                          value: 0.78,
                          strokeWidth: 12,
                          strokeCap: StrokeCap.round,
                          backgroundColor: AppColors.primaryBlue.withAlpha(30),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryGreen),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '78%',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const Text('全150問', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('今週の正解率：78%', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        const Text('進捗状況：85 / 150 問', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: LinearProgressIndicator(
                            value: 0.56,
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
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildGradientMenuCard(
          context: context,
          title: 'クイズを始める',
          subtitle: '第1章：下水道法概論\n20問 / 推奨：15分',
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
          subtitle: '未習得の誤答：45問\n強化・克服トレーニング',
          icon: Icons.history_edu_rounded,
          colors: [const Color(0xFFFFD54F), Color(0xFFFBBC05)],
          onTap: () {},
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
    final selectedCategory = await showDialog<String>(
      context: context,
      builder: (context) => const _CategorySelectionDialog(),
    );

    if (selectedCategory == null) return;

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      ref.invalidate(onlineQuestionsProvider(selectedCategory));
      final questions = await ref.read(onlineQuestionsProvider(selectedCategory).future)
          .timeout(const Duration(seconds: 15));
      
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        if (questions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('このカテゴリには問題が登録されていません。')),
          );
          return;
        }
        ref.read(quizNotifierProvider.notifier).startQuiz(questions);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const QuizPlayScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('問題の取得に失敗: $e'), duration: const Duration(seconds: 8)),
        );
      }
    }
  }

  Widget _buildDevTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('開発者ツール', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
            const Text('ver 1.0.0+9', style: TextStyle(color: AppColors.disabled, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () async {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firebaseに接続中...')));
            
            showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
            try {
              final result = await seedQuestions();
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result),
                  duration: const Duration(seconds: 8),
                ));
              }
            } catch (e) {
               if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('予期せぬエラー: $e')));
              }
            }
          },
          icon: const Icon(Icons.storage),
          label: const Text('Firestoreにテスト問題を投入'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.disabled.withAlpha(50),
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _CategorySelectionDialog extends ConsumerWidget {
  const _CategorySelectionDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);

    return AlertDialog(
      title: const Text('学習カテゴリを選択', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: double.maxFinite,
        child: categoriesState.when(
          data: (categories) => ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => Navigator.of(context).pop(category),
              );
            },
          ),
          loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
          error: (e, s) => Text('カテゴリの取得に失敗しました: $e'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }
}
