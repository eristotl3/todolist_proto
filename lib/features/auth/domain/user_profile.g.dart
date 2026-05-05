// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  avatarUrl: json['avatar_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.teacher: 'teacher',
  UserRole.student: 'student',
};
