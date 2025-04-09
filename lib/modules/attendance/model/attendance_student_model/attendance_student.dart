import 'package:json_annotation/json_annotation.dart';

import 'lab_room.dart';
import 'schedule.dart';
import 'student.dart';

part 'attendance_student.g.dart';

@JsonSerializable()
class AttendanceStudent {
  String? id;
  @JsonKey(name: 'id_student')
  String? idStudent;
  @JsonKey(name: 'id_schedule')
  String? idSchedule;
  @JsonKey(name: 'id_lab_room')
  String? idLabRoom;
  @JsonKey(name: 'status_attendance')
  String? statusAttendance;
  DateTime? createdAt;
  DateTime? updatedAt;
  Student? student;
  Schedule? schedule;
  @JsonKey(name: 'lab_room')
  LabRoom? labRoom;

  AttendanceStudent({
    this.id,
    this.idStudent,
    this.idSchedule,
    this.idLabRoom,
    this.statusAttendance,
    this.createdAt,
    this.updatedAt,
    this.student,
    this.schedule,
    this.labRoom,
  });

  @override
  String toString() {
    return 'AttendanceStudent(id: $id, idStudent: $idStudent, idSchedule: $idSchedule, idLabRoom: $idLabRoom, statusAttendance: $statusAttendance, createdAt: $createdAt, updatedAt: $updatedAt, student: $student, schedule: $schedule, labRoom: $labRoom)';
  }

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) {
    return _$AttendanceStudentFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AttendanceStudentToJson(this);

  AttendanceStudent copyWith({
    String? id,
    String? idStudent,
    String? idSchedule,
    String? idLabRoom,
    String? statusAttendance,
    DateTime? createdAt,
    DateTime? updatedAt,
    Student? student,
    Schedule? schedule,
    LabRoom? labRoom,
  }) {
    return AttendanceStudent(
      id: id ?? this.id,
      idStudent: idStudent ?? this.idStudent,
      idSchedule: idSchedule ?? this.idSchedule,
      idLabRoom: idLabRoom ?? this.idLabRoom,
      statusAttendance: statusAttendance ?? this.statusAttendance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      student: student ?? this.student,
      schedule: schedule ?? this.schedule,
      labRoom: labRoom ?? this.labRoom,
    );
  }
}
