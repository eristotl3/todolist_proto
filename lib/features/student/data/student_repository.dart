import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/enrolled_class_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

part 'student_repository.g.dart';

@riverpod
StudentRepository studentRepository(Ref ref) => StudentRepository();

class StudentRepository {
  final _client = Supabase.instance.client;

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
      // Look up the class by code
      final classData = await _client
          .from(AppConstants.classesTable)
          .select()
          .eq('code', code.trim().toUpperCase())
          .maybeSingle();

      if (classData == null) {
        throw const AppException('Class not found. Check the code and try again.');
      }

      final classId = classData['id'] as String;

      // Check not already enrolled
      final existing = await _client
          .from(AppConstants.enrollmentsTable)
          .select()
          .eq('class_id', classId)
          .eq('student_id', studentId)
          .maybeSingle();

      if (existing != null) {
        throw const AppException('You are already enrolled in this class.');
      }

      // Insert enrollment
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
}
