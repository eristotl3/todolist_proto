import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/student_repository.dart';
import '../../domain/student_item_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';

part 'student_completion_provider.g.dart';

@riverpod
class StudentCompletionNotifier extends _$StudentCompletionNotifier {
  @override
  Future<List<StudentItemState>> build(String listId) async {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    if (profile == null) return [];

    // Real-time: watch for item additions/removals and student completions
    final channel = Supabase.instance.client
        .channel('student_completion_${listId}_${profile.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: AppConstants.todoItemsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'list_id',
            value: listId,
          ),
          callback: (_) => _silentRefresh(listId, profile.id),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: AppConstants.completionsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'student_id',
            value: profile.id,
          ),
          callback: (_) => _silentRefresh(listId, profile.id),
        )
        .subscribe();

    ref.onDispose(() => Supabase.instance.client.removeChannel(channel));

    return ref
        .read(studentRepositoryProvider)
        .getItemsWithCompletion(listId, profile.id);
  }

  void _silentRefresh(String listId, String studentId) async {
    try {
      final items = await ref
          .read(studentRepositoryProvider)
          .getItemsWithCompletion(listId, studentId);
      state = AsyncData(items);
    } catch (_) {
      // Keep current state on realtime refresh error
    }
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
      state = AsyncData(current);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(listId));
  }
}
