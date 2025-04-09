// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      operator: json['operator'] == null
          ? null
          : Operator.fromJson(json['operator'] as Map<String, dynamic>),
      teacher: json['teacher'] == null
          ? null
          : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      student: json['student'] == null
          ? null
          : Student.fromJson(json['student'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'operator': instance.operator,
      'teacher': instance.teacher,
      'student': instance.student,
    };
