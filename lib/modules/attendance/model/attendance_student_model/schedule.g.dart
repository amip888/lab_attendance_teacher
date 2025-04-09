// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: json['id'] as String?,
      idTeacher: json['id_teacher'] as String?,
      idLabRoom: json['id_lab_room'] as String?,
      subject: json['subject'] as String?,
      scheduleClass: json['class'] as String?,
      date: json['date'] as String?,
      beginTime: json['begin_time'] as String?,
      endTime: json['end_time'] as String?,
      status: json['status'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'id_teacher': instance.idTeacher,
      'id_lab_room': instance.idLabRoom,
      'subject': instance.subject,
      'class': instance.scheduleClass,
      'date': instance.date,
      'begin_time': instance.beginTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
