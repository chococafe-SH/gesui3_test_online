// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizAnswer {
  String get questionId => throw _privateConstructorUsedError;
  int get selectedOption => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnswerCopyWith<QuizAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnswerCopyWith<$Res> {
  factory $QuizAnswerCopyWith(
    QuizAnswer value,
    $Res Function(QuizAnswer) then,
  ) = _$QuizAnswerCopyWithImpl<$Res, QuizAnswer>;
  @useResult
  $Res call({String questionId, int selectedOption, bool isCorrect});
}

/// @nodoc
class _$QuizAnswerCopyWithImpl<$Res, $Val extends QuizAnswer>
    implements $QuizAnswerCopyWith<$Res> {
  _$QuizAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? selectedOption = null,
    Object? isCorrect = null,
  }) {
    return _then(
      _value.copyWith(
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedOption: null == selectedOption
                ? _value.selectedOption
                : selectedOption // ignore: cast_nullable_to_non_nullable
                      as int,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnswerImplCopyWith<$Res>
    implements $QuizAnswerCopyWith<$Res> {
  factory _$$QuizAnswerImplCopyWith(
    _$QuizAnswerImpl value,
    $Res Function(_$QuizAnswerImpl) then,
  ) = __$$QuizAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String questionId, int selectedOption, bool isCorrect});
}

/// @nodoc
class __$$QuizAnswerImplCopyWithImpl<$Res>
    extends _$QuizAnswerCopyWithImpl<$Res, _$QuizAnswerImpl>
    implements _$$QuizAnswerImplCopyWith<$Res> {
  __$$QuizAnswerImplCopyWithImpl(
    _$QuizAnswerImpl _value,
    $Res Function(_$QuizAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? selectedOption = null,
    Object? isCorrect = null,
  }) {
    return _then(
      _$QuizAnswerImpl(
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedOption: null == selectedOption
            ? _value.selectedOption
            : selectedOption // ignore: cast_nullable_to_non_nullable
                  as int,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$QuizAnswerImpl extends _QuizAnswer {
  const _$QuizAnswerImpl({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
  }) : super._();

  @override
  final String questionId;
  @override
  final int selectedOption;
  @override
  final bool isCorrect;

  @override
  String toString() {
    return 'QuizAnswer(questionId: $questionId, selectedOption: $selectedOption, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnswerImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.selectedOption, selectedOption) ||
                other.selectedOption == selectedOption) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, questionId, selectedOption, isCorrect);

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      __$$QuizAnswerImplCopyWithImpl<_$QuizAnswerImpl>(this, _$identity);
}

abstract class _QuizAnswer extends QuizAnswer {
  const factory _QuizAnswer({
    required final String questionId,
    required final int selectedOption,
    required final bool isCorrect,
  }) = _$QuizAnswerImpl;
  const _QuizAnswer._() : super._();

  @override
  String get questionId;
  @override
  int get selectedOption;
  @override
  bool get isCorrect;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QuizRecord {
  String get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<QuizAnswer> get questions => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  DateTime get answeredAt => throw _privateConstructorUsedError;

  /// Create a copy of QuizRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizRecordCopyWith<QuizRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizRecordCopyWith<$Res> {
  factory $QuizRecordCopyWith(
    QuizRecord value,
    $Res Function(QuizRecord) then,
  ) = _$QuizRecordCopyWithImpl<$Res, QuizRecord>;
  @useResult
  $Res call({
    String id,
    String category,
    List<QuizAnswer> questions,
    int score,
    DateTime answeredAt,
  });
}

/// @nodoc
class _$QuizRecordCopyWithImpl<$Res, $Val extends QuizRecord>
    implements $QuizRecordCopyWith<$Res> {
  _$QuizRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? questions = null,
    Object? score = null,
    Object? answeredAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<QuizAnswer>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            answeredAt: null == answeredAt
                ? _value.answeredAt
                : answeredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizRecordImplCopyWith<$Res>
    implements $QuizRecordCopyWith<$Res> {
  factory _$$QuizRecordImplCopyWith(
    _$QuizRecordImpl value,
    $Res Function(_$QuizRecordImpl) then,
  ) = __$$QuizRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String category,
    List<QuizAnswer> questions,
    int score,
    DateTime answeredAt,
  });
}

/// @nodoc
class __$$QuizRecordImplCopyWithImpl<$Res>
    extends _$QuizRecordCopyWithImpl<$Res, _$QuizRecordImpl>
    implements _$$QuizRecordImplCopyWith<$Res> {
  __$$QuizRecordImplCopyWithImpl(
    _$QuizRecordImpl _value,
    $Res Function(_$QuizRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? questions = null,
    Object? score = null,
    Object? answeredAt = null,
  }) {
    return _then(
      _$QuizRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<QuizAnswer>,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        answeredAt: null == answeredAt
            ? _value.answeredAt
            : answeredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$QuizRecordImpl extends _QuizRecord {
  const _$QuizRecordImpl({
    required this.id,
    required this.category,
    required final List<QuizAnswer> questions,
    required this.score,
    required this.answeredAt,
  }) : _questions = questions,
       super._();

  @override
  final String id;
  @override
  final String category;
  final List<QuizAnswer> _questions;
  @override
  List<QuizAnswer> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final int score;
  @override
  final DateTime answeredAt;

  @override
  String toString() {
    return 'QuizRecord(id: $id, category: $category, questions: $questions, score: $score, answeredAt: $answeredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    const DeepCollectionEquality().hash(_questions),
    score,
    answeredAt,
  );

  /// Create a copy of QuizRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizRecordImplCopyWith<_$QuizRecordImpl> get copyWith =>
      __$$QuizRecordImplCopyWithImpl<_$QuizRecordImpl>(this, _$identity);
}

abstract class _QuizRecord extends QuizRecord {
  const factory _QuizRecord({
    required final String id,
    required final String category,
    required final List<QuizAnswer> questions,
    required final int score,
    required final DateTime answeredAt,
  }) = _$QuizRecordImpl;
  const _QuizRecord._() : super._();

  @override
  String get id;
  @override
  String get category;
  @override
  List<QuizAnswer> get questions;
  @override
  int get score;
  @override
  DateTime get answeredAt;

  /// Create a copy of QuizRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizRecordImplCopyWith<_$QuizRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
