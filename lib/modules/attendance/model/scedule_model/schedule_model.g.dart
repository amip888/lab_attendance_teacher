// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      id: json['id'] as String?,
      idTeacher: json['id_teacher'] as String?,
      day: json['day'] == null ? null : DateTime.parse(json['day'] as String),
      subject: json['subject'] as String?,
      major: json['major'] as String?,
      scheduleModelClass: json['class'] as String?,
      roomLab: json['lab_room'] as String?,
      status: json['status'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_teacher': instance.idTeacher,
      'day': instance.day?.toIso8601String(),
      'subject': instance.subject,
      'major': instance.major,
      'class': instance.scheduleModelClass,
      'lab_room': instance.roomLab,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
