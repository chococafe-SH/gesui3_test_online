import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  const UserStats({
    this.totalAnswered = 0,
    this.correctCount = 0,
    this.xp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.lastQuizDate,
    this.lastActive,
    this.weakQuestions = const [],
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalAnswered: map['totalAnswered'] as int? ?? 0,
      correctCount: map['correctCount'] as int? ?? 0,
      xp: map['xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      currentStreak: map['currentStreak'] as int? ?? 0,
      lastQuizDate: (map['lastQuizDate'] as Timestamp?)?.toDate(),
      lastActive: (map['lastActive'] as Timestamp?)?.toDate(),
      weakQuestions: List<String>.from(map['weakQuestions'] ?? []),
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
    };
  }

  /// 必要レベル到達のためのXPを計算する（簡易的に 1レベル = 100XP）
  static int getXpForNextLevel(int currentLevel) {
    return currentLevel * 100;
  }
}
