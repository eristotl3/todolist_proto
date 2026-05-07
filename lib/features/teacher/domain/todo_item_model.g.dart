// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoItemModel _$TodoItemModelFromJson(Map<String, dynamic> json) =>
    _TodoItemModel(
      id: json['id'] as String,
      listId: json['list_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      position: (json['position'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      completionCount: (json['completion_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TodoItemModelToJson(_TodoItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'list_id': instance.listId,
      'title': instance.title,
      'description': instance.description,
      'due_date': instance.dueDate?.toIso8601String(),
      'position': instance.position,
      'created_at': instance.createdAt.toIso8601String(),
      'completion_count': instance.completionCount,
    };
