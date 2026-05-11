// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonalTaskModel _$PersonalTaskModelFromJson(Map<String, dynamic> json) =>
    _PersonalTaskModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      isCompleted: json['is_completed'] as bool,
      position: (json['position'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      groupName: json['group_name'] as String?,
    );

Map<String, dynamic> _$PersonalTaskModelToJson(_PersonalTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'is_completed': instance.isCompleted,
      'position': instance.position,
      'created_at': instance.createdAt.toIso8601String(),
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'group_name': instance.groupName,
    };
