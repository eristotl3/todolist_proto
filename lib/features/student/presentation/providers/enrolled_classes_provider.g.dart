// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrolled_classes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$enrolledClassesNotifierHash() =>
    r'19368ee05a78e7178b77170ceee89f6d3ef6b17a';

/// See also [EnrolledClassesNotifier].
@ProviderFor(EnrolledClassesNotifier)
final enrolledClassesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      EnrolledClassesNotifier,
      List<EnrolledClassModel>
    >.internal(
      EnrolledClassesNotifier.new,
      name: r'enrolledClassesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$enrolledClassesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EnrolledClassesNotifier =
    AutoDisposeAsyncNotifier<List<EnrolledClassModel>>;
String _$assignedListsNotifierHash() =>
    r'948b27f9492d2165f514035ce8e79df407fabb7f';

/// See also [AssignedListsNotifier].
@ProviderFor(AssignedListsNotifier)
final assignedListsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      AssignedListsNotifier,
      List<StudentTodoListModel>
    >.internal(
      AssignedListsNotifier.new,
      name: r'assignedListsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$assignedListsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AssignedListsNotifier =
    AutoDisposeAsyncNotifier<List<StudentTodoListModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
