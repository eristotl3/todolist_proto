import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/todo_repository.dart';
import '../../domain/todo_list_model.dart';
import '../../domain/todo_item_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'todo_list_provider.g.dart';

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  @override
  Future<List<TodoListModel>> build(String classId) async {
    return ref.read(todoRepositoryProvider).getListsForClass(classId);
  }

  Future<TodoListModel> createList({
    required String title,
    String? description,
    DateTime? dueDate,
  }) async {
    final profile = ref.read(authNotifierProvider).valueOrNull;
    if (profile == null) throw Exception('Not authenticated');

    final newList = await ref.read(todoRepositoryProvider).createList(
          classId: classId,
          teacherId: profile.id,
          title: title,
          description: description,
          dueDate: dueDate,
        );
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, newList]);
    return newList;
  }

  Future<void> deleteList(String listId) async {
    await ref.read(todoRepositoryProvider).deleteList(listId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((l) => l.id != listId).toList());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(classId));
  }
}

@riverpod
class TodoItemNotifier extends _$TodoItemNotifier {
  @override
  Future<List<TodoItemModel>> build(String listId) async {
    return ref.read(todoRepositoryProvider).getItemsForList(listId);
  }

  Future<void> createItem({
    required String title,
    String? description,
    DateTime? dueDate,
  }) async {
    final current = state.valueOrNull ?? [];
    final newItem = await ref.read(todoRepositoryProvider).createItem(
          listId: listId,
          title: title,
          description: description,
          dueDate: dueDate,
          position: current.length,
        );
    state = AsyncData([...current, newItem]);
  }

  Future<void> deleteItem(String itemId) async {
    await ref.read(todoRepositoryProvider).deleteItem(itemId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((i) => i.id != itemId).toList());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(listId));
  }
}
