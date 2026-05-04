// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_detail_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentsHash() => r'f07fc416b47f659b612ed2cc1b2f09477752683f';

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

/// See also [students].
@ProviderFor(students)
const studentsProvider = StudentsFamily();

/// See also [students].
class StudentsFamily extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [students].
  const StudentsFamily();

  /// See also [students].
  StudentsProvider call(String classId) {
    return StudentsProvider(classId);
  }

  @override
  StudentsProvider getProviderOverride(covariant StudentsProvider provider) {
    return call(provider.classId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'studentsProvider';
}

/// See also [students].
class StudentsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [students].
  StudentsProvider(String classId)
    : this._internal(
        (ref) => students(ref as StudentsRef, classId),
        from: studentsProvider,
        name: r'studentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$studentsHash,
        dependencies: StudentsFamily._dependencies,
        allTransitiveDependencies: StudentsFamily._allTransitiveDependencies,
        classId: classId,
      );

  StudentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.classId,
  }) : super.internal();

  final String classId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(StudentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StudentsProvider._internal(
        (ref) => create(ref as StudentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        classId: classId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _StudentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentsProvider && other.classId == classId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, classId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StudentsRef on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `classId` of this provider.
  String get classId;
}

class _StudentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with StudentsRef {
  _StudentsProviderElement(super.provider);

  @override
  String get classId => (origin as StudentsProvider).classId;
}

String _$classCodeHash() => r'342eaa9a166771f91d4d7ade225e41927c9dcebb';

/// See also [classCode].
@ProviderFor(classCode)
const classCodeProvider = ClassCodeFamily();

/// See also [classCode].
class ClassCodeFamily extends Family<AsyncValue<String>> {
  /// See also [classCode].
  const ClassCodeFamily();

  /// See also [classCode].
  ClassCodeProvider call(String classId) {
    return ClassCodeProvider(classId);
  }

  @override
  ClassCodeProvider getProviderOverride(covariant ClassCodeProvider provider) {
    return call(provider.classId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'classCodeProvider';
}

/// See also [classCode].
class ClassCodeProvider extends AutoDisposeFutureProvider<String> {
  /// See also [classCode].
  ClassCodeProvider(String classId)
    : this._internal(
        (ref) => classCode(ref as ClassCodeRef, classId),
        from: classCodeProvider,
        name: r'classCodeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$classCodeHash,
        dependencies: ClassCodeFamily._dependencies,
        allTransitiveDependencies: ClassCodeFamily._allTransitiveDependencies,
        classId: classId,
      );

  ClassCodeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.classId,
  }) : super.internal();

  final String classId;

  @override
  Override overrideWith(
    FutureOr<String> Function(ClassCodeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClassCodeProvider._internal(
        (ref) => create(ref as ClassCodeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        classId: classId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _ClassCodeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClassCodeProvider && other.classId == classId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, classId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClassCodeRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `classId` of this provider.
  String get classId;
}

class _ClassCodeProviderElement extends AutoDisposeFutureProviderElement<String>
    with ClassCodeRef {
  _ClassCodeProviderElement(super.provider);

  @override
  String get classId => (origin as ClassCodeProvider).classId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
