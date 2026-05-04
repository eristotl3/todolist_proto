// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => _ClassModel(
  id: json['id'] as String,
  name: json['name'] as String,
  code: json['code'] as String,
  teacherId: json['teacherId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  studentCount: (json['studentCount'] as num?)?.toInt() ?? 0,
  listCount: (json['listCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ClassModelToJson(_ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'teacherId': instance.teacherId,
      'createdAt': instance.createdAt.toIso8601String(),
      'studentCount': instance.studentCount,
      'listCount': instance.listCount,
    };
