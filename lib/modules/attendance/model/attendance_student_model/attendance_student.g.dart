// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceStudent _$AttendanceStudentFromJson(Map<String, dynamic> json) =>
    AttendanceStudent(
      id: json['id'] as String?,
      idStudent: json['id_student'] as String?,
      idSchedule: json['id_schedule'] as String?,
      idLabRoom: json['id_lab_room'] as String?,
      statusAttendance: json['status_attendance'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AttendanceStudentToJson(AttendanceStudent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_student': instance.idStudent,
      'id_schedule': instance.idSchedule,
      'id_lab_room': instance.idLabRoom,
      'status_attendance': instance.statusAttendance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
