import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/todo_item_model.dart';
import '../domain/completion_matrix_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

part 'completion_repository.g.dart';

@riverpod
CompletionRepository completionRepository(Ref ref) => CompletionRepository();

class CompletionRepository {
  final _client = Supabase.instance.client;

  Future<List<StudentSummary>> getStudentsForClass(String classId) async {
    try {
      final data = await _client
          .from(AppConstants.enrollmentsTable)
          .select('profiles(id, full_name)')
          .eq('class_id', classId)
          .order('enrolled_at');

      return (data as List).map((e) {
        final p = e['profiles'] as Map<String, dynamic>;
        return StudentSummary(
          id: p['id'] as String,
          fullName: p['full_name'] as String? ?? 'Unknown',
        );
      }).toList();
    } catch (e) {
      throw AppException('Failed to load students', cause: e);
    }
  }

  Future<Set<String>> getCompletionsForItems(List<String> itemIds) async {
    if (itemIds.isEmpty) return {};
    try {
      final data = await _client
          .from(AppConstants.completionsTable)
          .select('item_id, student_id')
          .inFilter('item_id', itemIds);

      return {
        for (final row in data as List)
          '${row['item_id']}:${row['student_id']}'
      };
    } catch (e) {
      throw AppException('Failed to load completions', cause: e);
    }
  }

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
}
