// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['id'] as String?,
      idTeacher: json['id_teacher'] as String?,
      idSchedule: json['id_schedule'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      teacher: json['teacher'] == null
          ? null
          : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      schedule: json['schedule'] == null
          ? null
          : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_teacher': instance.idTeacher,
      'id_schedule': instance.idSchedule,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'teacher': instance.teacher,
      'schedule': instance.schedule,
      'users': instance.users,
    };
