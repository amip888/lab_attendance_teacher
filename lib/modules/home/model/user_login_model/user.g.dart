// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String?,
      role: json['role'] as String?,
      teacher: json['teacher'] == null
          ? null
          : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'role': instance.role,
      'teacher': instance.teacher,
    };
