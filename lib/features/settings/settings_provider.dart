import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/services/notification_service.dart';

part 'settings_provider.freezed.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(false) bool isDarkMode,
    @Default(true) bool enableNotifications,
    @Default(19) int notificationHour,
    @Default(0) int notificationMinute,
    @Default([1, 2, 3, 4, 5, 6, 7]) List<int> notificationDays, // 1=Mon, ..., 7=Sun
  }) = _AppSettings;
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    _loadFromPrefs();
    // Notifier.listenSelf (Riverpod 2.10+) への移行
    listenSelf((previous, next) {
      if (previous == null) {
        updateScheduledNotifications();
      }
    });
    return const AppSettings();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final enableNotifications = prefs.getBool('enableNotifications') ?? true;
    final notificationHour = prefs.getInt('notificationHour') ?? 19;
    final notificationMinute = prefs.getInt('notificationMinute') ?? 0;
    final daysStringList = prefs.getStringList('notificationDays');
    
    List<int> days = const [1, 2, 3, 4, 5, 6, 7];
    if (daysStringList != null) {
      days = daysStringList.map((e) => int.parse(e)).toList();
    }

    state = AppSettings(
      isDarkMode: isDarkMode,
      enableNotifications: enableNotifications,
      notificationHour: notificationHour,
      notificationMinute: notificationMinute,
      notificationDays: days,
    );
    updateScheduledNotifications();
  }

  Future<void> _saveToPrefs(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', settings.isDarkMode);
    await prefs.setBool('enableNotifications', settings.enableNotifications);
    await prefs.setInt('notificationHour', settings.notificationHour);
    await prefs.setInt('notificationMinute', settings.notificationMinute);
    await prefs.setStringList(
      'notificationDays',
      settings.notificationDays.map((d) => d.toString()).toList(),
    );
  }

  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
    _saveToPrefs(state);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(enableNotifications: value);
    _saveToPrefs(state);
    updateScheduledNotifications();
  }

  void updateNotificationTime(int hour, int minute) {
    state = state.copyWith(notificationHour: hour, notificationMinute: minute);
    _saveToPrefs(state);
    updateScheduledNotifications();
  }

  void toggleNotificationDay(int day) {
    final current = List<int>.from(state.notificationDays);
    if (current.contains(day)) {
      if (current.length <= 1) return; // 最低1つは必要
      current.remove(day);
    } else {
      current.add(day);
      current.sort();
    }
    state = state.copyWith(notificationDays: current);
    _saveToPrefs(state);
    updateScheduledNotifications();
  }

  void updateScheduledNotifications() {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      if (!state.enableNotifications || state.notificationDays.isEmpty) {
        notificationService.cancelAll();
      } else {
        notificationService.scheduleDailyNotification(
          id: 100,
          title: '学習の時間です！',
          body: '今日の問題を1問だけ解いて、ストリークを維持しましょう！',
          hour: state.notificationHour,
          minute: state.notificationMinute,
          days: state.notificationDays,
        );
      }
    } catch (e) {
      debugPrint('通知スケジュール更新に失敗: $e');
    }
  }
}

final settingsNotifierProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});
