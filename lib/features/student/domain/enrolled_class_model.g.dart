// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrolled_class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnrolledClassModel _$EnrolledClassModelFromJson(Map<String, dynamic> json) =>
    _EnrolledClassModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      teacherId: json['teacherId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$EnrolledClassModelToJson(_EnrolledClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'teacherId': instance.teacherId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
