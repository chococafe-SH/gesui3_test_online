import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/level_system.dart';

part 'user_stats.freezed.dart';

/// 分野ごとの正解数・解答数を保持するモデル
@freezed
class CategoryStat with _$CategoryStat {
  const CategoryStat._();

  @Assert('total >= 0', 'total must be non-negative')
  @Assert('correct >= 0', 'correct must be non-negative')
  @Assert('correct <= total', 'correct cannot exceed total')
  const factory CategoryStat({
    @Default(0) int total,
    @Default(0) int correct,
  }) = _CategoryStat;

  double get rate => total > 0 ? correct / total : 0.0;

  factory CategoryStat.fromMap(Map<String, dynamic> map) {
    return CategoryStat(
      total: map['total'] as int? ?? 0,
      correct: map['correct'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {'total': total, 'correct': correct};
}

/// ユーザー統計データモデル
@freezed
class UserStats with _$UserStats {
  const UserStats._();

  const factory UserStats({
    @Default(0) int totalAnswered,
    @Default(0) int correctCount,
    @Default(0) int xp,
    @Default(1) int level,
    @Default(0) int currentStreak,
    DateTime? lastQuizDate,
    DateTime? lastActive,
    @Default([]) List<String> weakQuestions,
    @Default({}) Map<String, CategoryStat> categoryStats,
  }) = _UserStats;

  /// 正答率
  double get correctRate =>
      totalAnswered > 0 ? correctCount / totalAnswered : 0.0;

  /// 現在のレベル内での進捗XP
  int get levelProgress => xp - LevelSystem.totalXpForLevel(level);

  /// 現在のレベルをクリアするのに必要な合計XP (そのレベルのステップサイズ)
  int get xpRequiredForNextLevel => LevelSystem.xpForNextLevel(level);

  /// 次のレベルまでに必要な残りXP
  int get xpRemainingToNextLevel => xpRequiredForNextLevel - levelProgress;

  /// レベルの進捗率 (0.0 ～ 1.0)
  double get levelProgressRate =>
      xpRequiredForNextLevel > 0 ? levelProgress / xpRequiredForNextLevel : 0.0;

  /// 今日クイズを解いたか
  bool get hasPlayedToday {
    if (lastQuizDate == null) return false;
    final now = DateTime.now();
    return lastQuizDate!.year == now.year &&
        lastQuizDate!.month == now.month &&
        lastQuizDate!.day == now.day;
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    final rawCategoryStats = map['categoryStats'];
    final categoryStats = <String, CategoryStat>{};
    if (rawCategoryStats is Map<String, dynamic>) {
      rawCategoryStats.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          categoryStats[key] = CategoryStat.fromMap(value);
        }
      });
    }

    return UserStats(
      totalAnswered: map['totalAnswered'] as int? ?? 0,
      correctCount: map['correctCount'] as int? ?? 0,
      xp: map['xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      currentStreak: map['currentStreak'] as int? ?? 0,
      lastQuizDate: _parseDateTime(map['lastQuizDate']),
      lastActive: _parseDateTime(map['lastActive']),
      weakQuestions: (map['weakQuestions'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      categoryStats: categoryStats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAnswered': totalAnswered,
      'correctCount': correctCount,
      'xp': xp,
      'level': level,
      'currentStreak': currentStreak,
      'lastQuizDate': _toTimestamp(lastQuizDate),
      'lastActive': _toTimestamp(lastActive),
      'weakQuestions': weakQuestions,
      'categoryStats': {
        for (final e in categoryStats.entries) e.key: e.value.toMap()
      },
    };
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value);
  return null;
}

dynamic _toTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}
