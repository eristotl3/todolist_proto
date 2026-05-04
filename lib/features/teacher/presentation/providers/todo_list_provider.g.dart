// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListNotifierHash() => r'c300a60281f416de3faac724321b09f453b63816';

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

abstract class _$TodoListNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<TodoListModel>> {
  late final String classId;

  FutureOr<List<TodoListModel>> build(String classId);
}

/// See also [TodoListNotifier].
@ProviderFor(TodoListNotifier)
const todoListNotifierProvider = TodoListNotifierFamily();

/// See also [TodoListNotifier].
class TodoListNotifierFamily extends Family<AsyncValue<List<TodoListModel>>> {
  /// See also [TodoListNotifier].
  const TodoListNotifierFamily();

  /// See also [TodoListNotifier].
  TodoListNotifierProvider call(String classId) {
    return TodoListNotifierProvider(classId);
  }

  @override
  TodoListNotifierProvider getProviderOverride(
    covariant TodoListNotifierProvider provider,
  ) {
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
  String? get name => r'todoListNotifierProvider';
}

/// See also [TodoListNotifier].
class TodoListNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TodoListNotifier,
          List<TodoListModel>
        > {
  /// See also [TodoListNotifier].
  TodoListNotifierProvider(String classId)
    : this._internal(
        () => TodoListNotifier()..classId = classId,
        from: todoListNotifierProvider,
        name: r'todoListNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todoListNotifierHash,
        dependencies: TodoListNotifierFamily._dependencies,
        allTransitiveDependencies:
            TodoListNotifierFamily._allTransitiveDependencies,
        classId: classId,
      );

  TodoListNotifierProvider._internal(
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
  FutureOr<List<TodoListModel>> runNotifierBuild(
    covariant TodoListNotifier notifier,
  ) {
    return notifier.build(classId);
  }

  @override
  Override overrideWith(TodoListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TodoListNotifierProvider._internal(
        () => create()..classId = classId,
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
  AutoDisposeAsyncNotifierProviderElement<TodoListNotifier, List<TodoListModel>>
  createElement() {
    return _TodoListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoListNotifierProvider && other.classId == classId;
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
mixin TodoListNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<TodoListModel>> {
  /// The parameter `classId` of this provider.
  String get classId;
}

class _TodoListNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TodoListNotifier,
          List<TodoListModel>
        >
    with TodoListNotifierRef {
  _TodoListNotifierProviderElement(super.provider);

  @override
  String get classId => (origin as TodoListNotifierProvider).classId;
}

String _$todoItemNotifierHash() => r'2e55283dcb730d396f5f1b82b494a7cb70c9d8fd';

abstract class _$TodoItemNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<TodoItemModel>> {
  late final String listId;

  FutureOr<List<TodoItemModel>> build(String listId);
}

/// See also [TodoItemNotifier].
@ProviderFor(TodoItemNotifier)
const todoItemNotifierProvider = TodoItemNotifierFamily();

/// See also [TodoItemNotifier].
class TodoItemNotifierFamily extends Family<AsyncValue<List<TodoItemModel>>> {
  /// See also [TodoItemNotifier].
  const TodoItemNotifierFamily();

  /// See also [TodoItemNotifier].
  TodoItemNotifierProvider call(String listId) {
    return TodoItemNotifierProvider(listId);
  }

  @override
  TodoItemNotifierProvider getProviderOverride(
    covariant TodoItemNotifierProvider provider,
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
  String? get name => r'todoItemNotifierProvider';
}

/// See also [TodoItemNotifier].
class TodoItemNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TodoItemNotifier,
          List<TodoItemModel>
        > {
  /// See also [TodoItemNotifier].
  TodoItemNotifierProvider(String listId)
    : this._internal(
        () => TodoItemNotifier()..listId = listId,
        from: todoItemNotifierProvider,
        name: r'todoItemNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todoItemNotifierHash,
        dependencies: TodoItemNotifierFamily._dependencies,
        allTransitiveDependencies:
            TodoItemNotifierFamily._allTransitiveDependencies,
        listId: listId,
      );

  TodoItemNotifierProvider._internal(
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
  FutureOr<List<TodoItemModel>> runNotifierBuild(
    covariant TodoItemNotifier notifier,
  ) {
    return notifier.build(listId);
  }

  @override
  Override overrideWith(TodoItemNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TodoItemNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TodoItemNotifier, List<TodoItemModel>>
  createElement() {
    return _TodoItemNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoItemNotifierProvider && other.listId == listId;
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
mixin TodoItemNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<TodoItemModel>> {
  /// The parameter `listId` of this provider.
  String get listId;
}

class _TodoItemNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TodoItemNotifier,
          List<TodoItemModel>
        >
    with TodoItemNotifierRef {
  _TodoItemNotifierProviderElement(super.provider);

  @override
  String get listId => (origin as TodoItemNotifierProvider).listId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
