import 'package:flutter/foundation.dart';

@immutable
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String? category;
  final String? year;
  final String? status; // "free" or "premium"

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.category,
    this.year,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'category': category,
      'year': year,
      'status': status,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    // 安全に数値型(int)に変換するヘルパー
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Question(
      id: map['id']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      options: (map['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctOptionIndex: toInt(map['correctOptionIndex']),
      explanation: map['explanation']?.toString() ?? '',
      category: map['category']?.toString(),
      year: map['year']?.toString(),
      status: map['status']?.toString(),
    );
  }
}

@immutable
class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final Map<int, int> answers; // questionIndex -> selectedOptionIndex
  final bool isCompleted;
  final bool showingFeedback; // 正解/不正解＋解説の表示中かどうか
  final String? saveError; // 結果保存エラーメッセージ

  const QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.answers = const {},
    this.isCompleted = false,
    this.showingFeedback = false,
    this.saveError,
  });

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    Map<int, int>? answers,
    bool? isCompleted,
    bool? showingFeedback,
    String? saveError,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
      showingFeedback: showingFeedback ?? this.showingFeedback,
      saveError: saveError ?? this.saveError,
    );
  }

  Question get currentQuestion => questions[currentIndex];

  /// 現在の問題が回答済みかどうか
  bool get isCurrentAnswered => answers.containsKey(currentIndex);

  /// 現在の問題の正解判定
  bool get isCurrentCorrect {
    if (!isCurrentAnswered) return false;
    return answers[currentIndex] == currentQuestion.correctOptionIndex;
  }
}
