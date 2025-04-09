import 'package:json_annotation/json_annotation.dart';

import 'lab_room.dart';
import 'schedule.dart';
import 'teacher.dart';

part 'attendance_teacher.g.dart';

@JsonSerializable()
class AttendanceTeacher {
  String? id;
  @JsonKey(name: 'id_teacher')
  String? idTeacher;
  @JsonKey(name: 'id_schedule')
  String? idSchedule;
  @JsonKey(name: 'id_lab_room')
  String? idLabRoom;
  @JsonKey(name: 'status_attendance')
  String? statusAttendance;
  DateTime? createdAt;
  DateTime? updatedAt;
  Teacher? teacher;
  Schedule? schedule;
  @JsonKey(name: 'lab_room')
  LabRoom? labRoom;

  AttendanceTeacher({
    this.id,
    this.idTeacher,
    this.idSchedule,
    this.idLabRoom,
    this.statusAttendance,
    this.createdAt,
    this.updatedAt,
    this.teacher,
    this.schedule,
    this.labRoom,
  });

  @override
  String toString() {
    return 'AttendanceTeacher(id: $id, idTeacher: $idTeacher, idSchedule: $idSchedule, idLabRoom: $idLabRoom, statusAttendance: $statusAttendance, createdAt: $createdAt, updatedAt: $updatedAt, teacher: $teacher, schedule: $schedule, labRoom: $labRoom)';
  }

  factory AttendanceTeacher.fromJson(Map<String, dynamic> json) {
    return _$AttendanceTeacherFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AttendanceTeacherToJson(this);

  AttendanceTeacher copyWith({
    String? id,
    String? idTeacher,
    String? idSchedule,
    String? idLabRoom,
    String? statusAttendance,
    DateTime? createdAt,
    DateTime? updatedAt,
    Teacher? teacher,
    Schedule? schedule,
    LabRoom? labRoom,
  }) {
    return AttendanceTeacher(
      id: id ?? this.id,
      idTeacher: idTeacher ?? this.idTeacher,
      idSchedule: idSchedule ?? this.idSchedule,
      idLabRoom: idLabRoom ?? this.idLabRoom,
      statusAttendance: statusAttendance ?? this.statusAttendance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      teacher: teacher ?? this.teacher,
      schedule: schedule ?? this.schedule,
      labRoom: labRoom ?? this.labRoom,
    );
  }
}
