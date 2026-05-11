import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/personal_task_repository.dart';
import '../../domain/personal_task_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'personal_task_provider.g.dart';

@riverpod
class PersonalTaskNotifier extends _$PersonalTaskNotifier {
  @override
  Future<List<PersonalTaskModel>> build() async {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    if (profile == null) return [];
    return ref.read(personalTaskRepositoryProvider).getTasks(profile.id);
  }

  Future<void> addTask(String title) async {
    final profile = ref.read(authNotifierProvider).valueOrNull;
    if (profile == null) return;
    final current = state.valueOrNull ?? [];
    final task = await ref.read(personalTaskRepositoryProvider).createTask(
          userId: profile.id,
          title: title,
          position: current.length,
        );
    state = AsyncData([...current, task]);
  }

  Future<void> deleteTask(String taskId) async {
    await ref.read(personalTaskRepositoryProvider).deleteTask(taskId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((t) => t.id != taskId).toList());
  }

  Future<void> toggleTask(String taskId) async {
    final current = state.valueOrNull ?? [];
    final task = current.firstWhere((t) => t.id == taskId);
    final updated = !task.isCompleted;
    await ref.read(personalTaskRepositoryProvider).toggleTask(taskId, updated);
    state = AsyncData(
      current
          .map((t) => t.id == taskId ? t.copyWith(isCompleted: updated) : t)
          .toList(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
