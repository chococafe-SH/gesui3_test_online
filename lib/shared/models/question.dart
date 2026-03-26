import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_helpers.dart';

part 'question.freezed.dart';

/// 問題の公開ステータス
enum QuestionStatus {
  free,
  premium;

  static QuestionStatus fromString(String? value) {
    return QuestionStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => QuestionStatus.free,
    );
  }
}

/// クイズの問題データモデル
@freezed
class Question with _$Question {
  const Question._();

  @Assert("id != ''", 'id must not be empty')
  @Assert("text != ''", 'text must not be empty')
  @Assert('options.length >= 2', 'options must have at least 2 items')
  @Assert(
    'correctOptionIndex >= 0 && correctOptionIndex < options.length',
    'correctOptionIndex out of range',
  )
  const factory Question({
    required String id,
    required String text,
    required List<String> options,
    required int correctOptionIndex,
    required String explanation,
    String? category,
    String? year,
    String? imageUrl,
    String? explanationImageUrl,
    @Default(QuestionStatus.free) QuestionStatus status,
  }) = _Question;

  factory Question.fromMap(Map<String, dynamic> map, [String? docId]) {
    return Question(
      id: docId ?? map['id']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      options: (map['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctOptionIndex: parseIntSafe(map['correctOptionIndex']),
      explanation: map['explanation']?.toString() ?? '',
      category: map['category']?.toString(),
      year: map['year']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      explanationImageUrl: map['explanationImageUrl']?.toString(),
      status: QuestionStatus.fromString(map['status']?.toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'category': category,
      'year': year,
      'imageUrl': imageUrl,
      'explanationImageUrl': explanationImageUrl,
      'status': status.name,
    };
  }
}
