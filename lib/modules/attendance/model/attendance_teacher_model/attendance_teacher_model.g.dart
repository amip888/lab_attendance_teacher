// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceTeacherModel _$AttendanceTeacherModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceTeacherModel(
      attendanceTeacher: (json['attendanceTeacher'] as List<dynamic>?)
          ?.map((e) => AttendanceTeacher.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceTeacherModelToJson(
        AttendanceTeacherModel instance) =>
    <String, dynamic>{
      'attendanceTeacher': instance.attendanceTeacher,
    };
