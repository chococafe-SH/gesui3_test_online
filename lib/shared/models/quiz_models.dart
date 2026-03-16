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

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.category,
    this.year,
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
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
      explanation: map['explanation'] ?? '',
      category: map['category'],
      year: map['year'],
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
