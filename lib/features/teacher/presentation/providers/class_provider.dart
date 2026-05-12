import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/class_repository.dart';
import '../../domain/class_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'class_provider.g.dart';

@riverpod
class ClassNotifier extends _$ClassNotifier {
  @override
  Future<List<ClassModel>> build() async {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    if (profile == null) return [];
    return ref.read(classRepositoryProvider).getTeacherClasses(profile.id);
  }

  Future<void> createClass(String name) async {
    final profile = ref.read(authNotifierProvider).valueOrNull;
    if (profile == null) return;
    final newClass = await ref
        .read(classRepositoryProvider)
        .createClass(name, profile.id);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, newClass]);
  }

  Future<void> deleteClass(String classId) async {
    await ref.read(classRepositoryProvider).deleteClass(classId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((c) => c.id != classId).toList());
  }

  Future<void> editClass(String classId, String name) async {
    final updated = await ref.read(classRepositoryProvider).updateClass(classId, name);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.map((c) {
      if (c.id != classId) return c;
      return updated.copyWith(studentCount: c.studentCount, listCount: c.listCount);
    }).toList());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
