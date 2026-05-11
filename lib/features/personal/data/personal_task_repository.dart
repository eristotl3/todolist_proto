import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/personal_task_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

part 'personal_task_repository.g.dart';

@riverpod
PersonalTaskRepository personalTaskRepository(Ref ref) =>
    PersonalTaskRepository();

class PersonalTaskRepository {
  final _client = Supabase.instance.client;
  final _uuid = const Uuid();

  Future<List<PersonalTaskModel>> getTasks(String userId) async {
    try {
      final data = await _client
          .from(AppConstants.personalTasksTable)
          .select()
          .eq('user_id', userId)
          .order('position');
      return (data as List).map((e) => PersonalTaskModel.fromJson(e)).toList();
    } catch (e) {
      throw AppException('Failed to load tasks', cause: e);
    }
  }

  Future<PersonalTaskModel> createTask({
    required String userId,
    required String title,
    required int position,
    DateTime? startDate,
    DateTime? endDate,
    String? groupName,
  }) async {
    try {
      final data = await _client
          .from(AppConstants.personalTasksTable)
          .insert({
            'id': _uuid.v4(),
            'user_id': userId,
            'title': title,
            'position': position,
            if (startDate != null) 'start_date': _fmtDate(startDate),
            if (endDate != null) 'end_date': _fmtDate(endDate),
            if (groupName != null && groupName.isNotEmpty) 'group_name': groupName,
          })
          .select()
          .single();
      return PersonalTaskModel.fromJson(data);
    } catch (e) {
      throw AppException('Failed to create task', cause: e);
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> deleteTask(String taskId) async {
    try {
      await _client
          .from(AppConstants.personalTasksTable)
          .delete()
          .eq('id', taskId);
    } catch (e) {
      throw AppException('Failed to delete task', cause: e);
    }
  }

  Future<void> toggleTask(String taskId, bool isCompleted) async {
    try {
      await _client
          .from(AppConstants.personalTasksTable)
          .update({'is_completed': isCompleted})
          .eq('id', taskId);
    } catch (e) {
      throw AppException('Failed to update task', cause: e);
    }
  }
}
