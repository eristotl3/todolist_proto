import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/enrolled_class_model.dart';
import '../domain/student_todo_list_model.dart';
import '../domain/student_item_state.dart';
import '../../teacher/domain/todo_item_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

part 'student_repository.g.dart';

@riverpod
StudentRepository studentRepository(Ref ref) => StudentRepository();

class StudentRepository {
  final _client = Supabase.instance.client;

  // ── Enrollment ─────────────────────────────────────────────────────────────

  Future<List<EnrolledClassModel>> getEnrolledClasses(String studentId) async {
    try {
      final data = await _client
          .from(AppConstants.enrollmentsTable)
          .select('class_id, classes(id, name, code, teacher_id, created_at)')
          .eq('student_id', studentId)
          .order('enrolled_at');

      return (data as List).map((e) {
        final classData = e['classes'] as Map<String, dynamic>;
        return EnrolledClassModel.fromJson(classData);
      }).toList();
    } catch (e) {
      throw AppException('Failed to load enrolled classes', cause: e);
    }
  }

  Future<EnrolledClassModel> joinClass(String code, String studentId) async {
    try {
      final classData = await _client
          .from(AppConstants.classesTable)
          .select()
          .eq('code', code.trim().toUpperCase())
          .maybeSingle();

      if (classData == null) {
        throw const AppException(
            'Class not found. Check the code and try again.');
      }

      final classId = classData['id'] as String;

      final existing = await _client
          .from(AppConstants.enrollmentsTable)
          .select()
          .eq('class_id', classId)
          .eq('student_id', studentId)
          .maybeSingle();

      if (existing != null) {
        throw const AppException('You are already enrolled in this class.');
      }

      await _client.from(AppConstants.enrollmentsTable).insert({
        'class_id': classId,
        'student_id': studentId,
      });

      return EnrolledClassModel.fromJson(classData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to join class', cause: e);
    }
  }

  // ── Assigned lists with progress ───────────────────────────────────────────

  Future<List<StudentTodoListModel>> getAssignedLists(
      String studentId, List<EnrolledClassModel> enrolledClasses) async {
    if (enrolledClasses.isEmpty) return [];
    try {
      final classIds = enrolledClasses.map((c) => c.id).toList();
      final classNameMap = {for (final c in enrolledClasses) c.id: c.name};

      final listData = await _client
          .from(AppConstants.todoListsTable)
          .select()
          .inFilter('class_id', classIds)
          .order('created_at', ascending: false);

      final lists = (listData as List)
          .map((e) => StudentTodoListModel.fromJson({
                ...e,
                'class_name_label':
                    classNameMap[e['class_id'] as String] ?? '',
              }))
          .toList();

      // Enrich with item count and student's completion count
      final enriched = await Future.wait(lists.map((l) async {
        final items = await _client
            .from(AppConstants.todoItemsTable)
            .select('id')
            .eq('list_id', l.id);
        final itemIds =
            (items as List).map((i) => i['id'] as String).toList();

        int completedCount = 0;
        if (itemIds.isNotEmpty) {
          final completions = await _client
              .from(AppConstants.completionsTable)
              .select('id')
              .eq('student_id', studentId)
              .inFilter('item_id', itemIds);
          completedCount = (completions as List).length;
        }

        return l.copyWith(
          itemCount: itemIds.length,
          completedCount: completedCount,
        );
      }));

      return enriched;
    } catch (e) {
      throw AppException('Failed to load assigned lists', cause: e);
    }
  }

  // ── Items with completion state ────────────────────────────────────────────

  Future<List<StudentItemState>> getItemsWithCompletion(
      String listId, String studentId) async {
    try {
      final itemData = await _client
          .from(AppConstants.todoItemsTable)
          .select()
          .eq('list_id', listId)
          .order('position');

      final items =
          (itemData as List).map((e) => TodoItemModel.fromJson(e)).toList();

      if (items.isEmpty) return [];

      final itemIds = items.map((i) => i.id).toList();
      final completionData = await _client
          .from(AppConstants.completionsTable)
          .select('item_id')
          .eq('student_id', studentId)
          .inFilter('item_id', itemIds);

      final completedIds = {
        for (final c in completionData as List) c['item_id'] as String
      };

      return items
          .map((item) => StudentItemState(
                item: item,
                isCompleted: completedIds.contains(item.id),
              ))
          .toList();
    } catch (e) {
      throw AppException('Failed to load items', cause: e);
    }
  }

  // ── Completions ────────────────────────────────────────────────────────────

  Future<void> completeItem(String itemId, String studentId) async {
    try {
      await _client.from(AppConstants.completionsTable).upsert({
        'item_id': itemId,
        'student_id': studentId,
      });
    } catch (e) {
      throw AppException('Failed to complete item', cause: e);
    }
  }

  Future<void> uncompleteItem(String itemId, String studentId) async {
    try {
      await _client
          .from(AppConstants.completionsTable)
          .delete()
          .eq('item_id', itemId)
          .eq('student_id', studentId);
    } catch (e) {
      throw AppException('Failed to uncomplete item', cause: e);
    }
  }
}
