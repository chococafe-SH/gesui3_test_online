import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/models/question.dart';

part 'quiz_state.freezed.dart';

/// クイズ進行状態モデル
@freezed
class QuizState with _$QuizState {
  const QuizState._();

  const factory QuizState({
    /// 出題される問題リスト
    required List<Question> questions,

    /// 現在の問題インデックス (0から開始)
    @Default(0) int currentIndex,

    /// 回答マップ: key = 問題のインデックス, value = 選択した選択肢のインデックス
    @Default({}) Map<int, int> answers,

    /// クイズが終了（結果画面表示中）かどうか
    @Default(false) bool isCompleted,

    /// 現在の問題の解説を表示中かどうか
    @Default(false) bool showingFeedback,

    /// データを保存中かどうか
    @Default(false) bool isSaving,

    /// 結果保存時のエラーメッセージ
    String? saveError,
  }) = _QuizState;

  /// 現在の問題
  Question get currentQuestion => questions[currentIndex];

  /// 現在の問題が回答済みかどうか
  bool get isCurrentAnswered => answers.containsKey(currentIndex);

  /// 現在の問題の正解判定
  bool get isCurrentCorrect {
    if (!isCurrentAnswered) return false;
    return answers[currentIndex] == currentQuestion.correctOptionIndex;
  }

  /// 全問回答済みか
  bool get isAllAnswered => answers.length == questions.length;

  /// 正解数
  int get correctCount => answers.entries
      .where((e) => e.value == questions[e.key].correctOptionIndex)
      .length;

  /// 正答率 (0.0 ～ 1.0)
  double get correctRate =>
      answers.isNotEmpty ? correctCount / answers.length : 0.0;

  /// 回答の進捗率 (0.0 ～ 1.0)
  double get progress =>
      questions.isNotEmpty ? (currentIndex + 1) / questions.length : 0.0;

  /// 最後の問題かどうか
  bool get isLastQuestion => currentIndex == questions.length - 1;
}
