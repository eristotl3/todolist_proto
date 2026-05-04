import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_todo_list_model.freezed.dart';
part 'student_todo_list_model.g.dart';

@freezed
abstract class StudentTodoListModel with _$StudentTodoListModel {
  const factory StudentTodoListModel({
    required String id,
    required String classId,
    required String classNameLabel,
    required String title,
    String? description,
    DateTime? dueDate,
    required DateTime createdAt,
    @Default(0) int itemCount,
    @Default(0) int completedCount,
  }) = _StudentTodoListModel;

  factory StudentTodoListModel.fromJson(Map<String, dynamic> json) =>
      _$StudentTodoListModelFromJson(json);
}
