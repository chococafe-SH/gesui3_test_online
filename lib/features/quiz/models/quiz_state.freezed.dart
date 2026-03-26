// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizState {
  /// 出題される問題リスト
  List<Question> get questions => throw _privateConstructorUsedError;

  /// 現在の問題インデックス (0から開始)
  int get currentIndex => throw _privateConstructorUsedError;

  /// 回答マップ: key = 問題のインデックス, value = 選択した選択肢のインデックス
  Map<int, int> get answers => throw _privateConstructorUsedError;

  /// クイズが終了（結果画面表示中）かどうか
  bool get isCompleted => throw _privateConstructorUsedError;

  /// 現在の問題の解説を表示中かどうか
  bool get showingFeedback => throw _privateConstructorUsedError;

  /// データを保存中かどうか
  bool get isSaving => throw _privateConstructorUsedError;

  /// 結果保存時のエラーメッセージ
  String? get saveError => throw _privateConstructorUsedError;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStateCopyWith<QuizState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStateCopyWith<$Res> {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) then) =
      _$QuizStateCopyWithImpl<$Res, QuizState>;
  @useResult
  $Res call({
    List<Question> questions,
    int currentIndex,
    Map<int, int> answers,
    bool isCompleted,
    bool showingFeedback,
    bool isSaving,
    String? saveError,
  });
}

/// @nodoc
class _$QuizStateCopyWithImpl<$Res, $Val extends QuizState>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentIndex = null,
    Object? answers = null,
    Object? isCompleted = null,
    Object? showingFeedback = null,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(
      _value.copyWith(
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<Question>,
            currentIndex: null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            showingFeedback: null == showingFeedback
                ? _value.showingFeedback
                : showingFeedback // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            saveError: freezed == saveError
                ? _value.saveError
                : saveError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizStateImplCopyWith<$Res>
    implements $QuizStateCopyWith<$Res> {
  factory _$$QuizStateImplCopyWith(
    _$QuizStateImpl value,
    $Res Function(_$QuizStateImpl) then,
  ) = __$$QuizStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Question> questions,
    int currentIndex,
    Map<int, int> answers,
    bool isCompleted,
    bool showingFeedback,
    bool isSaving,
    String? saveError,
  });
}

/// @nodoc
class __$$QuizStateImplCopyWithImpl<$Res>
    extends _$QuizStateCopyWithImpl<$Res, _$QuizStateImpl>
    implements _$$QuizStateImplCopyWith<$Res> {
  __$$QuizStateImplCopyWithImpl(
    _$QuizStateImpl _value,
    $Res Function(_$QuizStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentIndex = null,
    Object? answers = null,
    Object? isCompleted = null,
    Object? showingFeedback = null,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(
      _$QuizStateImpl(
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<Question>,
        currentIndex: null == currentIndex
            ? _value.currentIndex
            : currentIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        showingFeedback: null == showingFeedback
            ? _value.showingFeedback
            : showingFeedback // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        saveError: freezed == saveError
            ? _value.saveError
            : saveError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$QuizStateImpl extends _QuizState {
  const _$QuizStateImpl({
    required final List<Question> questions,
    this.currentIndex = 0,
    final Map<int, int> answers = const {},
    this.isCompleted = false,
    this.showingFeedback = false,
    this.isSaving = false,
    this.saveError,
  }) : _questions = questions,
       _answers = answers,
       super._();

  /// 出題される問題リスト
  final List<Question> _questions;

  /// 出題される問題リスト
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  /// 現在の問題インデックス (0から開始)
  @override
  @JsonKey()
  final int currentIndex;

  /// 回答マップ: key = 問題のインデックス, value = 選択した選択肢のインデックス
  final Map<int, int> _answers;

  /// 回答マップ: key = 問題のインデックス, value = 選択した選択肢のインデックス
  @override
  @JsonKey()
  Map<int, int> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  /// クイズが終了（結果画面表示中）かどうか
  @override
  @JsonKey()
  final bool isCompleted;

  /// 現在の問題の解説を表示中かどうか
  @override
  @JsonKey()
  final bool showingFeedback;

  /// データを保存中かどうか
  @override
  @JsonKey()
  final bool isSaving;

  /// 結果保存時のエラーメッセージ
  @override
  final String? saveError;

  @override
  String toString() {
    return 'QuizState(questions: $questions, currentIndex: $currentIndex, answers: $answers, isCompleted: $isCompleted, showingFeedback: $showingFeedback, isSaving: $isSaving, saveError: $saveError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStateImpl &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.showingFeedback, showingFeedback) ||
                other.showingFeedback == showingFeedback) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_questions),
    currentIndex,
    const DeepCollectionEquality().hash(_answers),
    isCompleted,
    showingFeedback,
    isSaving,
    saveError,
  );

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      __$$QuizStateImplCopyWithImpl<_$QuizStateImpl>(this, _$identity);
}

abstract class _QuizState extends QuizState {
  const factory _QuizState({
    required final List<Question> questions,
    final int currentIndex,
    final Map<int, int> answers,
    final bool isCompleted,
    final bool showingFeedback,
    final bool isSaving,
    final String? saveError,
  }) = _$QuizStateImpl;
  const _QuizState._() : super._();

  /// 出題される問題リスト
  @override
  List<Question> get questions;

  /// 現在の問題インデックス (0から開始)
  @override
  int get currentIndex;

  /// 回答マップ: key = 問題のインデックス, value = 選択した選択肢のインデックス
  @override
  Map<int, int> get answers;

  /// クイズが終了（結果画面表示中）かどうか
  @override
  bool get isCompleted;

  /// 現在の問題の解説を表示中かどうか
  @override
  bool get showingFeedback;

  /// データを保存中かどうか
  @override
  bool get isSaving;

  /// 結果保存時のエラーメッセージ
  @override
  String? get saveError;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
