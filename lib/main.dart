import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_theme.dart';
import 'features/home/main_screen.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/init_user_provider.dart';
import 'features/quiz/question_sync_provider.dart';
import 'features/settings/settings_provider.dart';
import 'core/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // 通知サービスの初期化
  await NotificationService().init();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);

    return MaterialApp(
      title: '下水道3種 集中攻略',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) {
          if (user == null) {
            // サインインしていない場合は匿名サインインを実行
            ref.read(authNotifierProvider.notifier).signInAnonymously();
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // ユーザードキュメントの初期化（オフライン時はスキップ）
          ref.watch(initUserProvider);
          // バックグラウンド同期を起動
          ref.watch(questionSyncProvider);
          return const MainScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => _ErrorScreen(
          error: err,
          onRetry: () {
            ref.invalidate(authNotifierProvider);
            ref.read(authNotifierProvider.notifier).signInAnonymously();
          },
        ),
      ),
    );
  }
}

/// エラー時にリトライ可能な画面
class _ErrorScreen extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorScreen({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                'ネットワークに接続できません',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'インターネット接続を確認して、もう一度お試しください。',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('再試行'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
