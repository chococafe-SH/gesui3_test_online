import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../quiz/question_sync_provider.dart';
import '../../core/services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
          _buildSectionHeader('表示設定'),
          SwitchListTile(
            title: const Text('ダークモード'),
            subtitle: const Text('アプリのテーマを暗くします'),
            value: settings.isDarkMode,
            onChanged: (val) {
              ref.read(settingsNotifierProvider.notifier).toggleDarkMode(val);
            },
            activeColor: AppColors.primaryBlue,
          ),
          // 文字サイズ設定は削除されました
          const Divider(),
          _buildSectionHeader('通知設定'),
          SwitchListTile(
            title: const Text('学習リマインダー'),
            subtitle: const Text('毎日の学習継続をサポートします'),
            value: settings.enableNotifications,
            onChanged: (val) => ref.read(settingsNotifierProvider.notifier).toggleNotifications(val),
            activeColor: AppColors.primaryBlue,
          ),
          if (settings.enableNotifications) ...[
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
                   const Text('通知する曜日', style: TextStyle(fontSize: 12, color: Colors.grey)),
                   const SizedBox(height: 8),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: List.generate(7, (index) {
                       final day = index + 1;
                       final labels = ['月', '火', '水', '木', '金', '土', '日'];
                       final isSelected = settings.notificationDays.contains(day);
                       return InkWell(
                         onTap: () => ref.read(settingsNotifierProvider.notifier).toggleNotificationDay(day),
                         child: Container(
                           width: 36,
                           height: 36,
                           decoration: BoxDecoration(
                             color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                             shape: BoxShape.circle,
                             border: Border.all(color: AppColors.primaryBlue),
                           ),
                           child: Center(
                             child: Text(
                               labels[index],
                               style: TextStyle(
                                 color: isSelected ? Colors.white : AppColors.primaryBlue,
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
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
                await NotificationService().showImmediateNotification(
                  id: 999,
                  title: 'テスト通知',
                  body: '通知機能は正しく動作しています！',
                );
              },
            ),
          ],
          const Divider(),
          _buildSectionHeader('データ管理'),
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
                      backgroundColor: Colors.red,
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
               showDialog(context: context, builder: (context) => AlertDialog(
                 title: const Text('アカウント連携'),
                 content: const Text('この機能は準備中です。将来のアップデートで利用可能になります。'),
                 actions: [
                   TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                 ],
               ));
            },
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            subtitle: const Text('アプリのプライバシーポリシーを確認します'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
               showDialog(context: context, builder: (context) => AlertDialog(
                 title: const Text('プライバシーポリシー'),
                 content: const Text('このアプリはFirebaseを使用して学習履歴等を保存しています。\n\n詳細なプライバシーポリシーページは準備中です。'),
                 actions: [
                   TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                 ],
               ));
            },
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text('Version 1.0.1', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}
