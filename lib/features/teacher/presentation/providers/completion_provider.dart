import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/completion_repository.dart';
import '../../domain/completion_matrix_state.dart';
import '../../domain/todo_item_model.dart';

part 'completion_provider.g.dart';

@riverpod
class CompletionMatrixNotifier extends _$CompletionMatrixNotifier {
  RealtimeChannel? _channel;

  @override
  Future<CompletionMatrixState> build(
      String listId, String classId) async {
    ref.onDispose(_unsubscribe);
    return _fetchAndSubscribe();
  }

  Future<CompletionMatrixState> _fetchAndSubscribe() async {
    final repo = ref.read(completionRepositoryProvider);

    final results = await Future.wait([
      repo.getStudentsForClass(classId),
      repo.getItemsForList(listId),
    ]);

    final students = results[0] as List<StudentSummary>;
    final items = results[1] as List<TodoItemModel>;
    final itemIds = items.map((i) => i.id).toList();
    final completedPairs = await repo.getCompletionsForItems(itemIds);

    _subscribeRealtime(itemIds);

    return CompletionMatrixState(
      students: students,
      items: items,
      completedPairs: completedPairs,
    );
  }

  void _subscribeRealtime(List<String> itemIds) {
    if (itemIds.isEmpty) return;
    _unsubscribe();

    _channel = Supabase.instance.client
        .channel('completion-matrix-$listId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'todo_completions',
          callback: (payload) => _handleChange(payload, isInsert: true),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'todo_completions',
          callback: (payload) => _handleChange(payload, isInsert: false),
        )
        .subscribe();
  }

  void _handleChange(PostgresChangePayload payload, {required bool isInsert}) {
    final current = state.valueOrNull;
    if (current == null) return;

    final record =
        isInsert ? payload.newRecord : payload.oldRecord;
    final itemId = record['item_id'] as String?;
    final studentId = record['student_id'] as String?;
    if (itemId == null || studentId == null) return;

    // Only update if this item belongs to our list
    final itemBelongsToList =
        current.items.any((i) => i.id == itemId);
    if (!itemBelongsToList) return;

    final pair = '$itemId:$studentId';
    final updated = Set<String>.from(current.completedPairs);

    if (isInsert) {
      updated.add(pair);
    } else {
      updated.remove(pair);
    }

    state = AsyncData(current.copyWith(completedPairs: updated));
  }

  void _unsubscribe() {
    _channel?.unsubscribe();
    _channel = null;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAndSubscribe);
  }
}
