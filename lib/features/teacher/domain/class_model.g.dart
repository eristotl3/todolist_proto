// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => _ClassModel(
  id: json['id'] as String,
  name: json['name'] as String,
  code: json['code'] as String,
  teacherId: json['teacher_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  studentCount: (json['student_count'] as num?)?.toInt() ?? 0,
  listCount: (json['list_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ClassModelToJson(_ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'teacher_id': instance.teacherId,
      'created_at': instance.createdAt.toIso8601String(),
      'student_count': instance.studentCount,
      'list_count': instance.listCount,
    };
