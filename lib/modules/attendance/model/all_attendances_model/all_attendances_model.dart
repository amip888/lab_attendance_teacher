import 'package:json_annotation/json_annotation.dart';

import 'attendance_teacher.dart';

part 'all_attendances_model.g.dart';

@JsonSerializable()
class AllAttendancesModel {
  List<AttendanceTeacher>? attendanceTeacher;

  AllAttendancesModel({this.attendanceTeacher});

  @override
  String toString() {
    return 'AllAttendancesModel(attendanceTeacher: $attendanceTeacher)';
  }

  factory AllAttendancesModel.fromJson(Map<String, dynamic> json) {
    return _$AllAttendancesModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AllAttendancesModelToJson(this);

  AllAttendancesModel copyWith({
    List<AttendanceTeacher>? attendanceTeacher,
  }) {
    return AllAttendancesModel(
      attendanceTeacher: attendanceTeacher ?? this.attendanceTeacher,
    );
  }
}
