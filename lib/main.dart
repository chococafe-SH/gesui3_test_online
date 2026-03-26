import 'dart:io';
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
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // スマホのホームボタン等のシステムUIを隠す（没入モード）
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  try {
    // Firebase初期化（必須）
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase初期化失敗: $e');
    runApp(const _InitErrorApp());
    return;
  }

  // 広告と通知の初期化は並列で実行（失敗してもアプリは起動させる）
  await Future.wait([
    MobileAds.instance.initialize().catchError((e) {
      debugPrint('AdMob initialization error: $e');
      return InitializationStatus({});
    }),
    NotificationService().init().catchError((e) {
      debugPrint('通知サービス初期化失敗: $e');
    }),
  ]);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// 匿名サインインを自動実行するためのプロバイダー
final autoSignInProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authNotifierProvider).valueOrNull;
  if (user == null) {
    await ref.read(authNotifierProvider.notifier).signInAnonymously();
  }
});

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
            // build内での副作用を避け、プロバイダー経由でサインインを実行
            ref.watch(autoSignInProvider);
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // 意図: ユーザードキュメントの初期化をトリガー（正常な場合のみ）
          ref.watch(initUserProvider);
          // 意図: バックグラウンド同期処理をアクティブに保つ
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
            ref.invalidate(autoSignInProvider);
          },
        ),
      ),
    );
  }
}

/// Firebase初期化そのものに失敗した場合の最小構成アプリ
class _InitErrorApp extends StatelessWidget {
  const _InitErrorApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('アプリの初期化に失敗しました',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('インターネット接続を確認し、アプリを再起動してください。',
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 認証エラー時などに表示する画面
class _ErrorScreen extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorScreen({required this.error, required this.onRetry});

  String _getErrorMessage(Object error) {
    if (error is FirebaseException) {
      return 'サーバーとの通信に失敗しました';
    }
    if (error is SocketException) {
      return 'ネットワーク環境を確認してください';
    }
    return '予期せぬエラーが発生しました';
  }

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
              Text(
                _getErrorMessage(error),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'もう一度お試しください。解決しない場合は時間を置いてからお試しください。',
                style: TextStyle(color: Colors.grey),
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
