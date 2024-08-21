import 'package:json_annotation/json_annotation.dart';

part 'attendance_teacher.g.dart';

@JsonSerializable()
class AttendanceTeacher {
  String? id;
  @JsonKey(name: 'id_schedule')
  String? idSchedule;
  @JsonKey(name: 'id_teacher')
  String? idTeacher;
  @JsonKey(name: 'status_attendance')
  String? statusAttendance;
  DateTime? createdAt;
  DateTime? updatedAt;

  AttendanceTeacher({
    this.id,
    this.idSchedule,
    this.idTeacher,
    this.statusAttendance,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'AttendanceTeacher(id: $id, idSchedule: $idSchedule, idTeacher: $idTeacher, statusAttendance: $statusAttendance, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory AttendanceTeacher.fromJson(Map<String, dynamic> json) {
    return _$AttendanceTeacherFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AttendanceTeacherToJson(this);

  AttendanceTeacher copyWith({
    String? id,
    String? idSchedule,
    String? idTeacher,
    String? statusAttendance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceTeacher(
      id: id ?? this.id,
      idSchedule: idSchedule ?? this.idSchedule,
      idTeacher: idTeacher ?? this.idTeacher,
      statusAttendance: statusAttendance ?? this.statusAttendance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
