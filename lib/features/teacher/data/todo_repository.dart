import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/todo_list_model.dart';
import '../domain/todo_item_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

part 'todo_repository.g.dart';

@riverpod
TodoRepository todoRepository(Ref ref) => TodoRepository();

class TodoRepository {
  final _client = Supabase.instance.client;
  final _uuid = const Uuid();

  // ── Todo Lists ─────────────────────────────────────────────────────────────

  Future<List<TodoListModel>> getListsForClass(String classId) async {
    try {
      final data = await _client
          .from(AppConstants.todoListsTable)
          .select()
          .eq('class_id', classId)
          .order('created_at');

      final lists =
          (data as List).map((e) => TodoListModel.fromJson(e)).toList();

      final enriched = await Future.wait(lists.map((l) async {
        final items = await _client
            .from(AppConstants.todoItemsTable)
            .select('id')
            .eq('list_id', l.id);
        return l.copyWith(itemCount: (items as List).length);
      }));

      return enriched;
    } catch (e) {
      throw AppException('Failed to load todo lists', cause: e);
    }
  }

  Future<TodoListModel> createList({
    required String classId,
    required String teacherId,
    required String title,
    String? description,
    DateTime? dueDate,
  }) async {
    try {
      final data = await _client
          .from(AppConstants.todoListsTable)
          .insert({
            'id': _uuid.v4(),
            'class_id': classId,
            'teacher_id': teacherId,
            'title': title,
            if (description != null && description.isNotEmpty)
              'description': description,
            if (dueDate != null) 'due_date': dueDate.toIso8601String(),
          })
          .select()
          .single();
      return TodoListModel.fromJson(data);
    } catch (e) {
      throw AppException('Failed to create list', cause: e);
    }
  }

  Future<void> deleteList(String listId) async {
    try {
      await _client
          .from(AppConstants.todoListsTable)
          .delete()
          .eq('id', listId);
    } catch (e) {
      throw AppException('Failed to delete list', cause: e);
    }
  }

  Future<TodoListModel> updateList({
    required String listId,
    required String title,
    String? description,
    DateTime? dueDate,
  }) async {
    try {
      final data = await _client
          .from(AppConstants.todoListsTable)
          .update({
            'title': title,
            'description': (description != null && description.isNotEmpty) ? description : null,
            'due_date': dueDate?.toIso8601String(),
          })
          .eq('id', listId)
          .select()
          .single();
      return TodoListModel.fromJson(data);
    } catch (e) {
      throw AppException('Failed to update list', cause: e);
    }
  }

  // ── Todo Items ─────────────────────────────────────────────────────────────

  Future<List<TodoItemModel>> getItemsForList(String listId) async {
    try {
      final data = await _client
          .from(AppConstants.todoItemsTable)
          .select()
          .eq('list_id', listId)
          .order('position');
      return (data as List).map((e) => TodoItemModel.fromJson(e)).toList();
    } catch (e) {
      throw AppException('Failed to load items', cause: e);
    }
  }

  Future<TodoItemModel> createItem({
    required String listId,
    required String title,
    String? description,
    DateTime? dueDate,
    required int position,
  }) async {
    try {
      final data = await _client
          .from(AppConstants.todoItemsTable)
          .insert({
            'id': _uuid.v4(),
            'list_id': listId,
            'title': title,
            if (description != null && description.isNotEmpty)
              'description': description,
            if (dueDate != null) 'due_date': dueDate.toIso8601String(),
            'position': position,
          })
          .select()
          .single();
      return TodoItemModel.fromJson(data);
    } catch (e) {
      throw AppException('Failed to create item', cause: e);
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await _client
          .from(AppConstants.todoItemsTable)
          .delete()
          .eq('id', itemId);
    } catch (e) {
      throw AppException('Failed to delete item', cause: e);
    }
  }

  Future<TodoItemModel> updateItem({
    required String itemId,
    required String title,
    String? description,
    DateTime? dueDate,
  }) async {
    try {
      final data = await _client
          .from(AppConstants.todoItemsTable)
          .update({
            'title': title,
            'description': (description != null && description.isNotEmpty) ? description : null,
            'due_date': dueDate?.toIso8601String(),
          })
          .eq('id', itemId)
          .select()
          .single();
      return TodoItemModel.fromJson(data);
    } catch (e) {
      throw AppException('Failed to update item', cause: e);
    }
  }
}
