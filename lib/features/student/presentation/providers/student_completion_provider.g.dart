// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_completion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentCompletionNotifierHash() =>
    r'd4c0fb3ad90a7f4c09a2fd3651c6a35dfef988ba';

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

abstract class _$StudentCompletionNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<StudentItemState>> {
  late final String listId;

  FutureOr<List<StudentItemState>> build(String listId);
}

/// See also [StudentCompletionNotifier].
@ProviderFor(StudentCompletionNotifier)
const studentCompletionNotifierProvider = StudentCompletionNotifierFamily();

/// See also [StudentCompletionNotifier].
class StudentCompletionNotifierFamily
    extends Family<AsyncValue<List<StudentItemState>>> {
  /// See also [StudentCompletionNotifier].
  const StudentCompletionNotifierFamily();

  /// See also [StudentCompletionNotifier].
  StudentCompletionNotifierProvider call(String listId) {
    return StudentCompletionNotifierProvider(listId);
  }

  @override
  StudentCompletionNotifierProvider getProviderOverride(
    covariant StudentCompletionNotifierProvider provider,
  ) {
    return call(provider.listId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'studentCompletionNotifierProvider';
}

/// See also [StudentCompletionNotifier].
class StudentCompletionNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          StudentCompletionNotifier,
          List<StudentItemState>
        > {
  /// See also [StudentCompletionNotifier].
  StudentCompletionNotifierProvider(String listId)
    : this._internal(
        () => StudentCompletionNotifier()..listId = listId,
        from: studentCompletionNotifierProvider,
        name: r'studentCompletionNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$studentCompletionNotifierHash,
        dependencies: StudentCompletionNotifierFamily._dependencies,
        allTransitiveDependencies:
            StudentCompletionNotifierFamily._allTransitiveDependencies,
        listId: listId,
      );

  StudentCompletionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listId,
  }) : super.internal();

  final String listId;

  @override
  FutureOr<List<StudentItemState>> runNotifierBuild(
    covariant StudentCompletionNotifier notifier,
  ) {
    return notifier.build(listId);
  }

  @override
  Override overrideWith(StudentCompletionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StudentCompletionNotifierProvider._internal(
        () => create()..listId = listId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listId: listId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    StudentCompletionNotifier,
    List<StudentItemState>
  >
  createElement() {
    return _StudentCompletionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentCompletionNotifierProvider && other.listId == listId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StudentCompletionNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<StudentItemState>> {
  /// The parameter `listId` of this provider.
  String get listId;
}

class _StudentCompletionNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          StudentCompletionNotifier,
          List<StudentItemState>
        >
    with StudentCompletionNotifierRef {
  _StudentCompletionNotifierProviderElement(super.provider);

  @override
  String get listId => (origin as StudentCompletionNotifierProvider).listId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
