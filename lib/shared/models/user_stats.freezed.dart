// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CategoryStat {
  int get total => throw _privateConstructorUsedError;
  int get correct => throw _privateConstructorUsedError;

  /// Create a copy of CategoryStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryStatCopyWith<CategoryStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryStatCopyWith<$Res> {
  factory $CategoryStatCopyWith(
    CategoryStat value,
    $Res Function(CategoryStat) then,
  ) = _$CategoryStatCopyWithImpl<$Res, CategoryStat>;
  @useResult
  $Res call({int total, int correct});
}

/// @nodoc
class _$CategoryStatCopyWithImpl<$Res, $Val extends CategoryStat>
    implements $CategoryStatCopyWith<$Res> {
  _$CategoryStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? correct = null}) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            correct: null == correct
                ? _value.correct
                : correct // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryStatImplCopyWith<$Res>
    implements $CategoryStatCopyWith<$Res> {
  factory _$$CategoryStatImplCopyWith(
    _$CategoryStatImpl value,
    $Res Function(_$CategoryStatImpl) then,
  ) = __$$CategoryStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int correct});
}

/// @nodoc
class __$$CategoryStatImplCopyWithImpl<$Res>
    extends _$CategoryStatCopyWithImpl<$Res, _$CategoryStatImpl>
    implements _$$CategoryStatImplCopyWith<$Res> {
  __$$CategoryStatImplCopyWithImpl(
    _$CategoryStatImpl _value,
    $Res Function(_$CategoryStatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? correct = null}) {
    return _then(
      _$CategoryStatImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        correct: null == correct
            ? _value.correct
            : correct // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CategoryStatImpl extends _CategoryStat {
  const _$CategoryStatImpl({this.total = 0, this.correct = 0})
    : assert(total >= 0, 'total must be non-negative'),
      assert(correct >= 0, 'correct must be non-negative'),
      assert(correct <= total, 'correct cannot exceed total'),
      super._();

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int correct;

  @override
  String toString() {
    return 'CategoryStat(total: $total, correct: $correct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryStatImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.correct, correct) || other.correct == correct));
  }

  @override
  int get hashCode => Object.hash(runtimeType, total, correct);

  /// Create a copy of CategoryStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryStatImplCopyWith<_$CategoryStatImpl> get copyWith =>
      __$$CategoryStatImplCopyWithImpl<_$CategoryStatImpl>(this, _$identity);
}

abstract class _CategoryStat extends CategoryStat {
  const factory _CategoryStat({final int total, final int correct}) =
      _$CategoryStatImpl;
  const _CategoryStat._() : super._();

  @override
  int get total;
  @override
  int get correct;

  /// Create a copy of CategoryStat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryStatImplCopyWith<_$CategoryStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserStats {
  int get totalAnswered => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  DateTime? get lastQuizDate => throw _privateConstructorUsedError;
  DateTime? get lastActive => throw _privateConstructorUsedError;
  List<String> get weakQuestions => throw _privateConstructorUsedError;
  Map<String, CategoryStat> get categoryStats =>
      throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call({
    int totalAnswered,
    int correctCount,
    int xp,
    int level,
    int currentStreak,
    DateTime? lastQuizDate,
    DateTime? lastActive,
    List<String> weakQuestions,
    Map<String, CategoryStat> categoryStats,
  });
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAnswered = null,
    Object? correctCount = null,
    Object? xp = null,
    Object? level = null,
    Object? currentStreak = null,
    Object? lastQuizDate = freezed,
    Object? lastActive = freezed,
    Object? weakQuestions = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _value.copyWith(
            totalAnswered: null == totalAnswered
                ? _value.totalAnswered
                : totalAnswered // ignore: cast_nullable_to_non_nullable
                      as int,
            correctCount: null == correctCount
                ? _value.correctCount
                : correctCount // ignore: cast_nullable_to_non_nullable
                      as int,
            xp: null == xp
                ? _value.xp
                : xp // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastQuizDate: freezed == lastQuizDate
                ? _value.lastQuizDate
                : lastQuizDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastActive: freezed == lastActive
                ? _value.lastActive
                : lastActive // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            weakQuestions: null == weakQuestions
                ? _value.weakQuestions
                : weakQuestions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            categoryStats: null == categoryStats
                ? _value.categoryStats
                : categoryStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, CategoryStat>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
    _$UserStatsImpl value,
    $Res Function(_$UserStatsImpl) then,
  ) = __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalAnswered,
    int correctCount,
    int xp,
    int level,
    int currentStreak,
    DateTime? lastQuizDate,
    DateTime? lastActive,
    List<String> weakQuestions,
    Map<String, CategoryStat> categoryStats,
  });
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
    _$UserStatsImpl _value,
    $Res Function(_$UserStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAnswered = null,
    Object? correctCount = null,
    Object? xp = null,
    Object? level = null,
    Object? currentStreak = null,
    Object? lastQuizDate = freezed,
    Object? lastActive = freezed,
    Object? weakQuestions = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _$UserStatsImpl(
        totalAnswered: null == totalAnswered
            ? _value.totalAnswered
            : totalAnswered // ignore: cast_nullable_to_non_nullable
                  as int,
        correctCount: null == correctCount
            ? _value.correctCount
            : correctCount // ignore: cast_nullable_to_non_nullable
                  as int,
        xp: null == xp
            ? _value.xp
            : xp // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastQuizDate: freezed == lastQuizDate
            ? _value.lastQuizDate
            : lastQuizDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastActive: freezed == lastActive
            ? _value.lastActive
            : lastActive // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        weakQuestions: null == weakQuestions
            ? _value._weakQuestions
            : weakQuestions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        categoryStats: null == categoryStats
            ? _value._categoryStats
            : categoryStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, CategoryStat>,
      ),
    );
  }
}

/// @nodoc

class _$UserStatsImpl extends _UserStats {
  const _$UserStatsImpl({
    this.totalAnswered = 0,
    this.correctCount = 0,
    this.xp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.lastQuizDate,
    this.lastActive,
    final List<String> weakQuestions = const [],
    final Map<String, CategoryStat> categoryStats = const {},
  }) : _weakQuestions = weakQuestions,
       _categoryStats = categoryStats,
       super._();

  @override
  @JsonKey()
  final int totalAnswered;
  @override
  @JsonKey()
  final int correctCount;
  @override
  @JsonKey()
  final int xp;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  final DateTime? lastQuizDate;
  @override
  final DateTime? lastActive;
  final List<String> _weakQuestions;
  @override
  @JsonKey()
  List<String> get weakQuestions {
    if (_weakQuestions is EqualUnmodifiableListView) return _weakQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weakQuestions);
  }

  final Map<String, CategoryStat> _categoryStats;
  @override
  @JsonKey()
  Map<String, CategoryStat> get categoryStats {
    if (_categoryStats is EqualUnmodifiableMapView) return _categoryStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryStats);
  }

  @override
  String toString() {
    return 'UserStats(totalAnswered: $totalAnswered, correctCount: $correctCount, xp: $xp, level: $level, currentStreak: $currentStreak, lastQuizDate: $lastQuizDate, lastActive: $lastActive, weakQuestions: $weakQuestions, categoryStats: $categoryStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.totalAnswered, totalAnswered) ||
                other.totalAnswered == totalAnswered) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.lastQuizDate, lastQuizDate) ||
                other.lastQuizDate == lastQuizDate) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            const DeepCollectionEquality().equals(
              other._weakQuestions,
              _weakQuestions,
            ) &&
            const DeepCollectionEquality().equals(
              other._categoryStats,
              _categoryStats,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalAnswered,
    correctCount,
    xp,
    level,
    currentStreak,
    lastQuizDate,
    lastActive,
    const DeepCollectionEquality().hash(_weakQuestions),
    const DeepCollectionEquality().hash(_categoryStats),
  );

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);
}

abstract class _UserStats extends UserStats {
  const factory _UserStats({
    final int totalAnswered,
    final int correctCount,
    final int xp,
    final int level,
    final int currentStreak,
    final DateTime? lastQuizDate,
    final DateTime? lastActive,
    final List<String> weakQuestions,
    final Map<String, CategoryStat> categoryStats,
  }) = _$UserStatsImpl;
  const _UserStats._() : super._();

  @override
  int get totalAnswered;
  @override
  int get correctCount;
  @override
  int get xp;
  @override
  int get level;
  @override
  int get currentStreak;
  @override
  DateTime? get lastQuizDate;
  @override
  DateTime? get lastActive;
  @override
  List<String> get weakQuestions;
  @override
  Map<String, CategoryStat> get categoryStats;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
