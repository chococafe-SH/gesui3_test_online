// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initUserHash() => r'116dceb0fcf13271447f31217ca9c970020ff84b';

/// サインイン完了後にユーザードキュメントを初期化するプロバイダー。
/// オフライン時はタイムアウトでスキップし、アプリは継続利用可能。
///
/// Copied from [initUser].
@ProviderFor(initUser)
final initUserProvider = AutoDisposeFutureProvider<void>.internal(
  initUser,
  name: r'initUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitUserRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
