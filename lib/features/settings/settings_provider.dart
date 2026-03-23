import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/notification_service.dart';

class AppSettings {
  final bool isDarkMode;
  final bool enableNotifications;
  final int notificationHour;
  final int notificationMinute;
  final List<int> notificationDays; // 1=Mon, ..., 7=Sun

  const AppSettings({
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.notificationHour = 19,
    this.notificationMinute = 0,
    this.notificationDays = const [1, 2, 3, 4, 5, 6, 7],
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? enableNotifications,
    int? notificationHour,
    int? notificationMinute,
    List<int>? notificationDays,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      notificationDays: notificationDays ?? this.notificationDays,
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    // 実際のアプリでは SharedPreferences 等から初期値を読み込む
    final initialSettings = const AppSettings();
    // 起動時にスケジュールを最新にする
    Future.microtask(() => updateScheduledNotifications());
    return initialSettings;
  }

  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(enableNotifications: value);
    updateScheduledNotifications();
  }

  void updateNotificationTime(int hour, int minute) {
    state = state.copyWith(notificationHour: hour, notificationMinute: minute);
    updateScheduledNotifications();
  }

  void toggleNotificationDay(int day) {
    final current = List<int>.from(state.notificationDays);
    if (current.contains(day)) {
      current.remove(day);
    } else {
      current.add(day);
    }
    state = state.copyWith(notificationDays: current);
    updateScheduledNotifications();
  }

  void updateScheduledNotifications() {
    if (!state.enableNotifications || state.notificationDays.isEmpty) {
      NotificationService().cancelAll();
    } else {
      NotificationService().scheduleDailyNotification(
        id: 100,
        title: '学習の時間です！',
        body: '今日の問題を1問だけ解いて、ストリークを維持しましょう！',
        hour: state.notificationHour,
        minute: state.notificationMinute,
        days: state.notificationDays,
      );
    }
  }
}

final settingsNotifierProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});
