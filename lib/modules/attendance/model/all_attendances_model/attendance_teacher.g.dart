// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceTeacher _$AttendanceTeacherFromJson(Map<String, dynamic> json) =>
    AttendanceTeacher(
      id: json['id'] as String?,
      idSchedule: json['id_schedule'] as String?,
      idTeacher: json['id_teacher'] as String?,
      statusAttendance: json['status_attendance'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AttendanceTeacherToJson(AttendanceTeacher instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_schedule': instance.idSchedule,
      'id_teacher': instance.idTeacher,
      'status_attendance': instance.statusAttendance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
