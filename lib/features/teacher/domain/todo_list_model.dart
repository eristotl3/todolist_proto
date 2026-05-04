import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list_model.freezed.dart';
part 'todo_list_model.g.dart';

@freezed
abstract class TodoListModel with _$TodoListModel {
  const factory TodoListModel({
    required String id,
    required String classId,
    required String teacherId,
    required String title,
    String? description,
    DateTime? dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int itemCount,
  }) = _TodoListModel;

  factory TodoListModel.fromJson(Map<String, dynamic> json) =>
      _$TodoListModelFromJson(json);
}
