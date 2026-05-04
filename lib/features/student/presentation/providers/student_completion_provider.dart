import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/student_repository.dart';
import '../../domain/student_item_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'student_completion_provider.g.dart';

@riverpod
class StudentCompletionNotifier extends _$StudentCompletionNotifier {
  @override
  Future<List<StudentItemState>> build(String listId) async {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    if (profile == null) return [];
    return ref
        .read(studentRepositoryProvider)
        .getItemsWithCompletion(listId, profile.id);
  }

  Future<void> toggle(String itemId) async {
    final profile = ref.read(authNotifierProvider).valueOrNull;
    if (profile == null) return;

    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((s) => s.item.id == itemId);
    if (index == -1) return;

    final wasCompleted = current[index].isCompleted;

    // Optimistic update
    final updated = List<StudentItemState>.from(current);
    updated[index] = current[index].copyWith(isCompleted: !wasCompleted);
    state = AsyncData(updated);

    try {
      final repo = ref.read(studentRepositoryProvider);
      if (wasCompleted) {
        await repo.uncompleteItem(itemId, profile.id);
      } else {
        await repo.completeItem(itemId, profile.id);
      }
    } catch (e) {
      // Revert on failure
      state = AsyncData(current);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(listId));
  }
}
