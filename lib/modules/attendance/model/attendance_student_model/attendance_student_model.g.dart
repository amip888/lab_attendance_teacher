// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceStudentModel _$AttendanceStudentModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceStudentModel(
      attendanceStudents: (json['attendanceStudents'] as List<dynamic>?)
          ?.map((e) => AttendanceStudent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceStudentModelToJson(
        AttendanceStudentModel instance) =>
    <String, dynamic>{
      'attendanceStudents': instance.attendanceStudents,
    };
