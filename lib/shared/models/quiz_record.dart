import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_record.freezed.dart';

/// クイズの回答データ
@freezed
class QuizAnswer with _$QuizAnswer {
  const QuizAnswer._();

  const factory QuizAnswer({
    required String questionId,
    required int selectedOption,
    required bool isCorrect,
  }) = _QuizAnswer;

  factory QuizAnswer.fromMap(Map<String, dynamic> map) {
    return QuizAnswer(
      questionId: map['questionId'] as String? ?? '',
      selectedOption: map['selectedOption'] as int? ?? -1,
      isCorrect: map['isCorrect'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'questionId': questionId,
        'selectedOption': selectedOption,
        'isCorrect': isCorrect,
      };
}

/// クイズの履歴レコード
@freezed
class QuizRecord with _$QuizRecord {
  const QuizRecord._();

  const factory QuizRecord({
    required String id,
    required String category,
    required List<QuizAnswer> questions,
    required int score,
    required DateTime answeredAt,
  }) = _QuizRecord;

  int get totalQuestions => questions.length;
  int get correctCount => questions.where((q) => q.isCorrect).length;
  double get correctRate =>
      totalQuestions > 0 ? correctCount / totalQuestions : 0.0;

  factory QuizRecord.fromMap(Map<String, dynamic> map, [String? docId]) {
    // 日時: serverTimestamp は初回 null の可能性あり
    final rawDate = map['answeredAt'] ?? map['playedAt'];

    // 回答リスト: 保存時のキー名 'questions' に対応
    final rawAnswers = map['questions'] ?? map['answers'];

    // 正解数: 保存時は 'correctCount' で保存している
    final rawScore = map['correctCount'] ?? map['score'];

    return QuizRecord(
      id: docId ?? map['id'] as String? ?? '',
      category: map['category'] as String? ?? '未分類',
      score: rawScore is int
          ? rawScore
          : int.tryParse('$rawScore') ?? 0,
      answeredAt: rawDate is Timestamp
          ? rawDate.toDate()
          : DateTime.now(), // serverTimestamp が未解決の場合のフォールバック
      // whereType で安全にキャスト（不正な要素はスキップ）
      questions: (rawAnswers as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(QuizAnswer.fromMap)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() => {
        'category': category,
        'correctCount': score,                      // 保存側と統一
        'totalQuestions': totalQuestions,             // フィールド追加
        'playedAt': Timestamp.fromDate(answeredAt),  // 保存側と統一
        'questions': questions.map((q) => q.toMap()).toList(),
      };
}
