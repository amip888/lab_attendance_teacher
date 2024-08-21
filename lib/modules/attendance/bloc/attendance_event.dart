part of 'attendance_bloc.dart';

abstract class AttendanceEvent {
  const AttendanceEvent();
}

class GetScheduleEvent extends AttendanceEvent {
  // final DateTime date;
  final String? date;
  GetScheduleEvent(this.date);
}

class GetAllAttendancesEvent extends AttendanceEvent {
  GetAllAttendancesEvent();
}

class PostAttendanceEvent extends AttendanceEvent {
  final Map<String, dynamic>? params;
  PostAttendanceEvent({this.params});
}
