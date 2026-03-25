// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onlineQuestionsHash() => r'43507a935c7d5444c41b649a26f5dec93f54411b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [onlineQuestions].
@ProviderFor(onlineQuestions)
const onlineQuestionsProvider = OnlineQuestionsFamily();

/// See also [onlineQuestions].
class OnlineQuestionsFamily extends Family<AsyncValue<List<Question>>> {
  /// See also [onlineQuestions].
  const OnlineQuestionsFamily();

  /// See also [onlineQuestions].
  OnlineQuestionsProvider call(String category) {
    return OnlineQuestionsProvider(category);
  }

  @override
  OnlineQuestionsProvider getProviderOverride(
    covariant OnlineQuestionsProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'onlineQuestionsProvider';
}

/// See also [onlineQuestions].
class OnlineQuestionsProvider
    extends AutoDisposeFutureProvider<List<Question>> {
  /// See also [onlineQuestions].
  OnlineQuestionsProvider(String category)
    : this._internal(
        (ref) => onlineQuestions(ref as OnlineQuestionsRef, category),
        from: onlineQuestionsProvider,
        name: r'onlineQuestionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$onlineQuestionsHash,
        dependencies: OnlineQuestionsFamily._dependencies,
        allTransitiveDependencies:
            OnlineQuestionsFamily._allTransitiveDependencies,
        category: category,
      );

  OnlineQuestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<Question>> Function(OnlineQuestionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OnlineQuestionsProvider._internal(
        (ref) => create(ref as OnlineQuestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Question>> createElement() {
    return _OnlineQuestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OnlineQuestionsProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OnlineQuestionsRef on AutoDisposeFutureProviderRef<List<Question>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _OnlineQuestionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Question>>
    with OnlineQuestionsRef {
  _OnlineQuestionsProviderElement(super.provider);

  @override
  String get category => (origin as OnlineQuestionsProvider).category;
}

String _$sampleQuestionsHash() => r'32b8a2ad370f03e2fc6cc34b3ef8e18374c02359';

/// See also [sampleQuestions].
@ProviderFor(sampleQuestions)
final sampleQuestionsProvider = AutoDisposeProvider<List<Question>>.internal(
  sampleQuestions,
  name: r'sampleQuestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sampleQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SampleQuestionsRef = AutoDisposeProviderRef<List<Question>>;
String _$weakQuestionsHash() => r'cba40b9e1c38ab5add03ef796c7ffb165d72693d';

/// See also [weakQuestions].
@ProviderFor(weakQuestions)
const weakQuestionsProvider = WeakQuestionsFamily();

/// See also [weakQuestions].
class WeakQuestionsFamily extends Family<AsyncValue<List<Question>>> {
  /// See also [weakQuestions].
  const WeakQuestionsFamily();

  /// See also [weakQuestions].
  WeakQuestionsProvider call(List<String> weakIds, bool isPremium) {
    return WeakQuestionsProvider(weakIds, isPremium);
  }

  @override
  WeakQuestionsProvider getProviderOverride(
    covariant WeakQuestionsProvider provider,
  ) {
    return call(provider.weakIds, provider.isPremium);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'weakQuestionsProvider';
}

/// See also [weakQuestions].
class WeakQuestionsProvider extends AutoDisposeFutureProvider<List<Question>> {
  /// See also [weakQuestions].
  WeakQuestionsProvider(List<String> weakIds, bool isPremium)
    : this._internal(
        (ref) => weakQuestions(ref as WeakQuestionsRef, weakIds, isPremium),
        from: weakQuestionsProvider,
        name: r'weakQuestionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weakQuestionsHash,
        dependencies: WeakQuestionsFamily._dependencies,
        allTransitiveDependencies:
            WeakQuestionsFamily._allTransitiveDependencies,
        weakIds: weakIds,
        isPremium: isPremium,
      );

  WeakQuestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.weakIds,
    required this.isPremium,
  }) : super.internal();

  final List<String> weakIds;
  final bool isPremium;

  @override
  Override overrideWith(
    FutureOr<List<Question>> Function(WeakQuestionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeakQuestionsProvider._internal(
        (ref) => create(ref as WeakQuestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        weakIds: weakIds,
        isPremium: isPremium,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Question>> createElement() {
    return _WeakQuestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeakQuestionsProvider &&
        other.weakIds == weakIds &&
        other.isPremium == isPremium;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, weakIds.hashCode);
    hash = _SystemHash.combine(hash, isPremium.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeakQuestionsRef on AutoDisposeFutureProviderRef<List<Question>> {
  /// The parameter `weakIds` of this provider.
  List<String> get weakIds;

  /// The parameter `isPremium` of this provider.
  bool get isPremium;
}

class _WeakQuestionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Question>>
    with WeakQuestionsRef {
  _WeakQuestionsProviderElement(super.provider);

  @override
  List<String> get weakIds => (origin as WeakQuestionsProvider).weakIds;
  @override
  bool get isPremium => (origin as WeakQuestionsProvider).isPremium;
}

String _$quizNotifierHash() => r'ba7d4ae6b84819aa8f866fc9195e2107f3192c5d';

/// See also [QuizNotifier].
@ProviderFor(QuizNotifier)
final quizNotifierProvider = NotifierProvider<QuizNotifier, QuizState>.internal(
  QuizNotifier.new,
  name: r'quizNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuizNotifier = Notifier<QuizState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
