import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../quiz/question_sync_provider.dart';
import '../../core/services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _testNotificationId = 999;
  static const _dayChipSize = 36.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final isSyncing = ref.watch(questionSyncProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDisplaySection(context, ref, settings),
          const Divider(),
          _buildNotificationSection(context, ref, settings),
          const Divider(),
          _buildDataSection(context, ref, isSyncing),
          const SizedBox(height: 32),
          _buildVersionInfo(context),
        ],
      ),
    );
  }

  Widget _buildDisplaySection(BuildContext context, WidgetRef ref, AppSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, '表示設定'),
        SwitchListTile(
          title: const Text('ダークモード'),
          subtitle: const Text('アプリのテーマを暗くします'),
          value: settings.isDarkMode,
          onChanged: (val) {
            ref.read(settingsNotifierProvider.notifier).toggleDarkMode(val);
          },
          activeThumbColor: context.colors.primary,
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context, WidgetRef ref, AppSettings settings) {
    if (!settings.enableNotifications) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, '通知設定'),
          SwitchListTile(
            title: const Text('学習リマインダー'),
            subtitle: const Text('毎日の学習継続をサポートします'),
            value: settings.enableNotifications,
            onChanged: (val) => ref.read(settingsNotifierProvider.notifier).toggleNotifications(val),
            activeThumbColor: context.colors.primary,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, '通知設定'),
        SwitchListTile(
          title: const Text('学習リマインダー'),
          subtitle: const Text('毎日の学習継続をサポートします'),
          value: settings.enableNotifications,
          onChanged: (val) => ref.read(settingsNotifierProvider.notifier).toggleNotifications(val),
          activeThumbColor: context.colors.primary,
        ),
        ListTile(
          title: const Text('通知時間'),
          subtitle: Text('${settings.notificationHour.toString().padLeft(2, '0')}:${settings.notificationMinute.toString().padLeft(2, '0')}'),
          trailing: const Icon(Icons.access_time),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: settings.notificationHour, minute: settings.notificationMinute),
            );
            if (time != null) {
              ref.read(settingsNotifierProvider.notifier).updateNotificationTime(time.hour, time.minute);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('通知する曜日', style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final day = index + 1;
                  final labels = ['月', '火', '水', '木', '金', '土', '日'];
                  final isSelected = settings.notificationDays.contains(day);
                  return InkWell(
                    onTap: () => ref.read(settingsNotifierProvider.notifier).toggleNotificationDay(day),
                    borderRadius: BorderRadius.circular(18),
                    child: Semantics(
                      label: '${labels[index]}曜日 ${isSelected ? "選択中" : "未選択"}',
                      child: Container(
                        width: _dayChipSize,
                        height: _dayChipSize,
                        decoration: BoxDecoration(
                          color: isSelected ? context.colors.primary : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.colors.primary),
                        ),
                        child: Center(
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : context.colors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text('通知のテスト'),
          subtitle: const Text('今すぐテスト通知を送ります'),
          trailing: const Icon(Icons.send),
          onTap: () async {
            final notificationService = ref.read(notificationServiceProvider);
            await notificationService.showImmediateNotification(
              id: _testNotificationId,
              title: 'テスト通知',
              body: '通知機能は正しく動作しています！',
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('テスト通知を送信しました')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context, WidgetRef ref, bool isSyncing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'データ管理'),
        ListTile(
          title: const Text('問題データの手動同期'),
          subtitle: const Text('最新の問題データをサーバーから取得します'),
          trailing: isSyncing 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.sync),
          onTap: () async {
            if (isSyncing) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('問題の同期を開始しました...'))
            );
            try {
              await ref.read(questionSyncProvider.notifier).triggerManualSync();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('同期が完了しました'))
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('同期に失敗しました: $e'),
                    backgroundColor: context.colors.error,
                  )
                );
              }
            }
          },
        ),
        ListTile(
          title: const Text('アカウント連携'),
          subtitle: const Text('データを引き継ぐためにアカウントを作成または連携します'),
          trailing: const Icon(Icons.link),
          onTap: () {
            _showInfoDialog(
              context,
              'アカウント連携',
              'この機能は準備中です。将来のアップデートで利用可能になります。',
            );
          },
        ),
        ListTile(
          title: const Text('プライバシーポリシー'),
          subtitle: const Text('アプリのプライバシーポリシーを確認します'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            _showInfoDialog(
              context,
              'プライバシーポリシー',
              'このアプリはFirebaseを使用して学習履歴等を保存しています。\n\n詳細なプライバシーポリシーページは準備中です。',
            );
          },
        ),
      ],
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Center(
      child: Text('Version 1.0.0', style: TextStyle(color: context.colors.textSecondary)),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: context.colors.primary,
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
