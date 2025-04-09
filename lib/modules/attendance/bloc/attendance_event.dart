part of 'attendance_bloc.dart';

abstract class AttendanceEvent {
  const AttendanceEvent();
}

class GetScheduleByDateEvent extends AttendanceEvent {
  final Map<String, dynamic> params;
  GetScheduleByDateEvent(this.params);
}

class GetAllAttendancesEvent extends AttendanceEvent {
  GetAllAttendancesEvent();
}

class GetOneAttendanceStudentEvent extends AttendanceEvent {
  GetOneAttendanceStudentEvent();
}

class PostAttendanceEvent extends AttendanceEvent {
  final Map<String, dynamic>? params;
  PostAttendanceEvent({this.params});
}

class UpdateAttendanceStudentEvent extends AttendanceEvent {
  final Map<String, dynamic>? body;
  final String? attendanceId;
  UpdateAttendanceStudentEvent({this.body, this.attendanceId});
}
