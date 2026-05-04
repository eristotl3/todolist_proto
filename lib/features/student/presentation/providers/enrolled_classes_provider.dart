import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/student_repository.dart';
import '../../domain/enrolled_class_model.dart';
import '../../domain/student_todo_list_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'enrolled_classes_provider.g.dart';

@riverpod
class EnrolledClassesNotifier extends _$EnrolledClassesNotifier {
  @override
  Future<List<EnrolledClassModel>> build() async {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    if (profile == null) return [];
    return ref
        .read(studentRepositoryProvider)
        .getEnrolledClasses(profile.id);
  }

  Future<String?> joinClass(String code) async {
    final profile = ref.read(authNotifierProvider).valueOrNull;
    if (profile == null) return null;
    try {
      final newClass = await ref
          .read(studentRepositoryProvider)
          .joinClass(code, profile.id);
      final current = state.valueOrNull ?? [];
      state = AsyncData([...current, newClass]);
      // Invalidate assigned lists so they refresh
      ref.invalidate(assignedListsNotifierProvider);
      return null;
    } on Exception catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

@riverpod
class AssignedListsNotifier extends _$AssignedListsNotifier {
  @override
  Future<List<StudentTodoListModel>> build() async {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    if (profile == null) return [];
    final classes =
        await ref.watch(enrolledClassesNotifierProvider.future);
    return ref
        .read(studentRepositoryProvider)
        .getAssignedLists(profile.id, classes);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
