// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$completionMatrixNotifierHash() =>
    r'0a41d37d1e8b3ff4e8907c5a3635d94161bb69cb';

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

abstract class _$CompletionMatrixNotifier
    extends BuildlessAutoDisposeAsyncNotifier<CompletionMatrixState> {
  late final String listId;
  late final String classId;

  FutureOr<CompletionMatrixState> build(String listId, String classId);
}

/// See also [CompletionMatrixNotifier].
@ProviderFor(CompletionMatrixNotifier)
const completionMatrixNotifierProvider = CompletionMatrixNotifierFamily();

/// See also [CompletionMatrixNotifier].
class CompletionMatrixNotifierFamily
    extends Family<AsyncValue<CompletionMatrixState>> {
  /// See also [CompletionMatrixNotifier].
  const CompletionMatrixNotifierFamily();

  /// See also [CompletionMatrixNotifier].
  CompletionMatrixNotifierProvider call(String listId, String classId) {
    return CompletionMatrixNotifierProvider(listId, classId);
  }

  @override
  CompletionMatrixNotifierProvider getProviderOverride(
    covariant CompletionMatrixNotifierProvider provider,
  ) {
    return call(provider.listId, provider.classId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'completionMatrixNotifierProvider';
}

/// See also [CompletionMatrixNotifier].
class CompletionMatrixNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CompletionMatrixNotifier,
          CompletionMatrixState
        > {
  /// See also [CompletionMatrixNotifier].
  CompletionMatrixNotifierProvider(String listId, String classId)
    : this._internal(
        () => CompletionMatrixNotifier()
          ..listId = listId
          ..classId = classId,
        from: completionMatrixNotifierProvider,
        name: r'completionMatrixNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$completionMatrixNotifierHash,
        dependencies: CompletionMatrixNotifierFamily._dependencies,
        allTransitiveDependencies:
            CompletionMatrixNotifierFamily._allTransitiveDependencies,
        listId: listId,
        classId: classId,
      );

  CompletionMatrixNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listId,
    required this.classId,
  }) : super.internal();

  final String listId;
  final String classId;

  @override
  FutureOr<CompletionMatrixState> runNotifierBuild(
    covariant CompletionMatrixNotifier notifier,
  ) {
    return notifier.build(listId, classId);
  }

  @override
  Override overrideWith(CompletionMatrixNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CompletionMatrixNotifierProvider._internal(
        () => create()
          ..listId = listId
          ..classId = classId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listId: listId,
        classId: classId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    CompletionMatrixNotifier,
    CompletionMatrixState
  >
  createElement() {
    return _CompletionMatrixNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletionMatrixNotifierProvider &&
        other.listId == listId &&
        other.classId == classId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listId.hashCode);
    hash = _SystemHash.combine(hash, classId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompletionMatrixNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<CompletionMatrixState> {
  /// The parameter `listId` of this provider.
  String get listId;

  /// The parameter `classId` of this provider.
  String get classId;
}

class _CompletionMatrixNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CompletionMatrixNotifier,
          CompletionMatrixState
        >
    with CompletionMatrixNotifierRef {
  _CompletionMatrixNotifierProviderElement(super.provider);

  @override
  String get listId => (origin as CompletionMatrixNotifierProvider).listId;
  @override
  String get classId => (origin as CompletionMatrixNotifierProvider).classId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
