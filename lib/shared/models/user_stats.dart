import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// 分野ごとの正解数・解答数を保持するモデル
@immutable
class CategoryStat {
  final int total;
  final int correct;

  const CategoryStat({this.total = 0, this.correct = 0});

  double get rate => total > 0 ? correct / total : 0.0;

  factory CategoryStat.fromMap(Map<String, dynamic> map) {
    return CategoryStat(
      total: map['total'] as int? ?? 0,
      correct: map['correct'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {'total': total, 'correct': correct};
}

@immutable
class UserStats {
  final int totalAnswered;
  final int correctCount;
  final int xp;
  final int level;
  final int currentStreak;
  final DateTime? lastQuizDate;
  final DateTime? lastActive;
  final List<String> weakQuestions;
  final Map<String, CategoryStat> categoryStats;

  const UserStats({
    this.totalAnswered = 0,
    this.correctCount = 0,
    this.xp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.lastQuizDate,
    this.lastActive,
    this.weakQuestions = const [],
    this.categoryStats = const {},
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    final rawCategoryStats = map['categoryStats'] as Map<String, dynamic>?;
    final categoryStats = <String, CategoryStat>{};
    rawCategoryStats?.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        categoryStats[key] = CategoryStat.fromMap(value);
      }
    });

    return UserStats(
      totalAnswered: map['totalAnswered'] as int? ?? 0,
      correctCount: map['correctCount'] as int? ?? 0,
      xp: map['xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      currentStreak: map['currentStreak'] as int? ?? 0,
      lastQuizDate: (map['lastQuizDate'] as Timestamp?)?.toDate(),
      lastActive: (map['lastActive'] as Timestamp?)?.toDate(),
      weakQuestions: List<String>.from(map['weakQuestions'] ?? []),
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
      'lastQuizDate': lastQuizDate != null ? Timestamp.fromDate(lastQuizDate!) : null,
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : FieldValue.serverTimestamp(),
      'weakQuestions': weakQuestions,
      'categoryStats': {
        for (final e in categoryStats.entries) e.key: e.value.toMap()
      },
    };
  }

  /// 必要レベル到達のためのXPを計算する（簡易的に 1レベル = 100XP）
  static int getXpForNextLevel(int currentLevel) {
    return currentLevel * 100;
  }
}
