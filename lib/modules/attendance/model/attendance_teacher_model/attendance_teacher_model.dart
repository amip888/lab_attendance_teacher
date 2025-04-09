import 'package:json_annotation/json_annotation.dart';

import 'attendance_teacher.dart';

part 'attendance_teacher_model.g.dart';

@JsonSerializable()
class AttendanceTeacherModel {
  List<AttendanceTeacher>? attendanceTeacher;

  AttendanceTeacherModel({this.attendanceTeacher});

  @override
  String toString() {
    return 'AttendanceTeacherModel(attendanceTeacher: $attendanceTeacher)';
  }

  factory AttendanceTeacherModel.fromJson(Map<String, dynamic> json) {
    return _$AttendanceTeacherModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AttendanceTeacherModelToJson(this);

  AttendanceTeacherModel copyWith({
    List<AttendanceTeacher>? attendanceTeacher,
  }) {
    return AttendanceTeacherModel(
      attendanceTeacher: attendanceTeacher ?? this.attendanceTeacher,
    );
  }
}
