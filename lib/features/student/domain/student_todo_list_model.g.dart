// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_todo_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentTodoListModel _$StudentTodoListModelFromJson(
  Map<String, dynamic> json,
) => _StudentTodoListModel(
  id: json['id'] as String,
  classId: json['class_id'] as String,
  classNameLabel: json['class_name_label'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
  completedCount: (json['completed_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StudentTodoListModelToJson(
  _StudentTodoListModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'class_id': instance.classId,
  'class_name_label': instance.classNameLabel,
  'title': instance.title,
  'description': instance.description,
  'due_date': instance.dueDate?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'item_count': instance.itemCount,
  'completed_count': instance.completedCount,
};
