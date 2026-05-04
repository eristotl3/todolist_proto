// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoItemModel _$TodoItemModelFromJson(Map<String, dynamic> json) =>
    _TodoItemModel(
      id: json['id'] as String,
      listId: json['listId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      position: (json['position'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completionCount: (json['completionCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TodoItemModelToJson(_TodoItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listId': instance.listId,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate?.toIso8601String(),
      'position': instance.position,
      'createdAt': instance.createdAt.toIso8601String(),
      'completionCount': instance.completionCount,
    };
