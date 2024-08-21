// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_attendances_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllAttendancesModel _$AllAttendancesModelFromJson(Map<String, dynamic> json) =>
    AllAttendancesModel(
      attendanceTeacher: (json['attendanceTeacher'] as List<dynamic>?)
          ?.map((e) => AttendanceTeacher.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllAttendancesModelToJson(
        AllAttendancesModel instance) =>
    <String, dynamic>{
      'attendanceTeacher': instance.attendanceTeacher,
    };
