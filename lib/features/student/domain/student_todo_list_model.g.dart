// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_todo_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentTodoListModel _$StudentTodoListModelFromJson(
  Map<String, dynamic> json,
) => _StudentTodoListModel(
  id: json['id'] as String,
  classId: json['classId'] as String,
  classNameLabel: json['classNameLabel'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
  completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StudentTodoListModelToJson(
  _StudentTodoListModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'classId': instance.classId,
  'classNameLabel': instance.classNameLabel,
  'title': instance.title,
  'description': instance.description,
  'dueDate': instance.dueDate?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'itemCount': instance.itemCount,
  'completedCount': instance.completedCount,
};
