import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/class_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

part 'class_repository.g.dart';

@riverpod
ClassRepository classRepository(Ref ref) => ClassRepository();

class ClassRepository {
  final _client = Supabase.instance.client;
  final _uuid = const Uuid();

  Future<List<ClassModel>> getTeacherClasses(String teacherId) async {
    try {
      final data = await _client
          .from(AppConstants.classesTable)
          .select()
          .eq('teacher_id', teacherId)
          .order('created_at');

      final classes = (data as List).map((e) => ClassModel.fromJson(e)).toList();

      // Fetch student counts for all classes in parallel
      final enriched = await Future.wait(classes.map((c) async {
        final countResult = await _client
            .from(AppConstants.enrollmentsTable)
            .select()
            .eq('class_id', c.id);
        final listResult = await _client
            .from(AppConstants.todoListsTable)
            .select()
            .eq('class_id', c.id);
        return c.copyWith(
          studentCount: (countResult as List).length,
          listCount: (listResult as List).length,
        );
      }));

      return enriched;
    } catch (e) {
      throw AppException('Failed to load classes', cause: e);
    }
  }

  Future<ClassModel> createClass(String name, String teacherId) async {
    try {
      final code = _generateCode(name);
      final data = await _client
          .from(AppConstants.classesTable)
          .insert({
            'id': _uuid.v4(),
            'name': name,
            'code': code,
            'teacher_id': teacherId,
          })
          .select()
          .single();
      return ClassModel.fromJson(data);
    } catch (e) {
      throw AppException('Failed to create class', cause: e);
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      await _client
          .from(AppConstants.classesTable)
          .delete()
          .eq('id', classId);
    } catch (e) {
      throw AppException('Failed to delete class', cause: e);
    }
  }

  Future<ClassModel> updateClass(String classId, String name) async {
    try {
      final data = await _client
          .from(AppConstants.classesTable)
          .update({'name': name})
          .eq('id', classId)
          .select()
          .single();
      return ClassModel.fromJson(data);
    } catch (e) {
      throw AppException('Failed to update class', cause: e);
    }
  }

  Future<List<Map<String, dynamic>>> getEnrolledStudents(String classId) async {
    try {
      final data = await _client
          .from(AppConstants.enrollmentsTable)
          .select('student_id, enrolled_at, profiles(id, full_name, email, avatar_url)')
          .eq('class_id', classId)
          .order('enrolled_at');
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      throw AppException('Failed to load students', cause: e);
    }
  }

  String _generateCode(String name) {
    final prefix = name
        .replaceAll(RegExp(r'[^a-zA-Z]'), '')
        .toUpperCase()
        .substring(0, name.replaceAll(RegExp(r'[^a-zA-Z]'), '').length.clamp(0, 4));
    final suffix = _uuid.v4().replaceAll('-', '').substring(0, 4).toUpperCase();
    return '$prefix-$suffix';
  }
}
