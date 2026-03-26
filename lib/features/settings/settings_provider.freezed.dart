// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppSettings {
  bool get isDarkMode => throw _privateConstructorUsedError;
  bool get enableNotifications => throw _privateConstructorUsedError;
  int get notificationHour => throw _privateConstructorUsedError;
  int get notificationMinute => throw _privateConstructorUsedError;
  List<int> get notificationDays => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    bool isDarkMode,
    bool enableNotifications,
    int notificationHour,
    int notificationMinute,
    List<int> notificationDays,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkMode = null,
    Object? enableNotifications = null,
    Object? notificationHour = null,
    Object? notificationMinute = null,
    Object? notificationDays = null,
  }) {
    return _then(
      _value.copyWith(
            isDarkMode: null == isDarkMode
                ? _value.isDarkMode
                : isDarkMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableNotifications: null == enableNotifications
                ? _value.enableNotifications
                : enableNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            notificationHour: null == notificationHour
                ? _value.notificationHour
                : notificationHour // ignore: cast_nullable_to_non_nullable
                      as int,
            notificationMinute: null == notificationMinute
                ? _value.notificationMinute
                : notificationMinute // ignore: cast_nullable_to_non_nullable
                      as int,
            notificationDays: null == notificationDays
                ? _value.notificationDays
                : notificationDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isDarkMode,
    bool enableNotifications,
    int notificationHour,
    int notificationMinute,
    List<int> notificationDays,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkMode = null,
    Object? enableNotifications = null,
    Object? notificationHour = null,
    Object? notificationMinute = null,
    Object? notificationDays = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        isDarkMode: null == isDarkMode
            ? _value.isDarkMode
            : isDarkMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableNotifications: null == enableNotifications
            ? _value.enableNotifications
            : enableNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        notificationHour: null == notificationHour
            ? _value.notificationHour
            : notificationHour // ignore: cast_nullable_to_non_nullable
                  as int,
        notificationMinute: null == notificationMinute
            ? _value.notificationMinute
            : notificationMinute // ignore: cast_nullable_to_non_nullable
                  as int,
        notificationDays: null == notificationDays
            ? _value._notificationDays
            : notificationDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc

class _$AppSettingsImpl with DiagnosticableTreeMixin implements _AppSettings {
  const _$AppSettingsImpl({
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.notificationHour = 19,
    this.notificationMinute = 0,
    final List<int> notificationDays = const [1, 2, 3, 4, 5, 6, 7],
  }) : _notificationDays = notificationDays;

  @override
  @JsonKey()
  final bool isDarkMode;
  @override
  @JsonKey()
  final bool enableNotifications;
  @override
  @JsonKey()
  final int notificationHour;
  @override
  @JsonKey()
  final int notificationMinute;
  final List<int> _notificationDays;
  @override
  @JsonKey()
  List<int> get notificationDays {
    if (_notificationDays is EqualUnmodifiableListView)
      return _notificationDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notificationDays);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppSettings(isDarkMode: $isDarkMode, enableNotifications: $enableNotifications, notificationHour: $notificationHour, notificationMinute: $notificationMinute, notificationDays: $notificationDays)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppSettings'))
      ..add(DiagnosticsProperty('isDarkMode', isDarkMode))
      ..add(DiagnosticsProperty('enableNotifications', enableNotifications))
      ..add(DiagnosticsProperty('notificationHour', notificationHour))
      ..add(DiagnosticsProperty('notificationMinute', notificationMinute))
      ..add(DiagnosticsProperty('notificationDays', notificationDays));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.isDarkMode, isDarkMode) ||
                other.isDarkMode == isDarkMode) &&
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(other.notificationHour, notificationHour) ||
                other.notificationHour == notificationHour) &&
            (identical(other.notificationMinute, notificationMinute) ||
                other.notificationMinute == notificationMinute) &&
            const DeepCollectionEquality().equals(
              other._notificationDays,
              _notificationDays,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isDarkMode,
    enableNotifications,
    notificationHour,
    notificationMinute,
    const DeepCollectionEquality().hash(_notificationDays),
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final bool isDarkMode,
    final bool enableNotifications,
    final int notificationHour,
    final int notificationMinute,
    final List<int> notificationDays,
  }) = _$AppSettingsImpl;

  @override
  bool get isDarkMode;
  @override
  bool get enableNotifications;
  @override
  int get notificationHour;
  @override
  int get notificationMinute;
  @override
  List<int> get notificationDays;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
