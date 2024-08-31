import 'package:json_annotation/json_annotation.dart';

import 'attendance_student.dart';

part 'attendance_student_model.g.dart';

@JsonSerializable()
class AttendanceStudentModel {
  List<AttendanceStudent>? attendanceStudents;

  AttendanceStudentModel({this.attendanceStudents});

  @override
  String toString() {
    return 'AttendanceStudentModel(attendanceStudents: $attendanceStudents)';
  }

  factory AttendanceStudentModel.fromJson(Map<String, dynamic> json) {
    return _$AttendanceStudentModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AttendanceStudentModelToJson(this);

  AttendanceStudentModel copyWith({
    List<AttendanceStudent>? attendanceStudents,
  }) {
    return AttendanceStudentModel(
      attendanceStudents: attendanceStudents ?? this.attendanceStudents,
    );
  }
}
