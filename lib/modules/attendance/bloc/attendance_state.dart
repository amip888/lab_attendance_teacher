part of 'attendance_bloc.dart';

abstract class AttendanceState {
  const AttendanceState();
}

class AttendanceInitial extends AttendanceState {}

class GetScheduleLoadingState extends AttendanceState {
  GetScheduleLoadingState();
}

class GetScheduleLoadedState extends AttendanceState {
  final ScheduleModel? data;
  const GetScheduleLoadedState(this.data);
}

class GetScheduleErrorState extends AttendanceState {
  final String message;
  const GetScheduleErrorState(this.message);
}

class GetScheduleEmptyState extends AttendanceState {
  final String message;
  const GetScheduleEmptyState(this.message);
}

class GetAllAttendancesLoadingState extends AttendanceState {
  GetAllAttendancesLoadingState();
}

class GetAllAttendancesLoadedState extends AttendanceState {
  final AllAttendancesModel? data;
  const GetAllAttendancesLoadedState(this.data);
}

class GetAllAttendancesErrorState extends AttendanceState {
  final String message;
  const GetAllAttendancesErrorState(this.message);
}

class GetAllAttendancesEmptyState extends AttendanceState {
  final String message;
  const GetAllAttendancesEmptyState(this.message);
}

class PostAttendanceLoadingState extends AttendanceState {
  PostAttendanceLoadingState();
}

class PostAttendanceLoadedState extends AttendanceState {
  const PostAttendanceLoadedState();
}

class PostAttendanceFailedState extends AttendanceState {
  final String message;
  const PostAttendanceFailedState(this.message);
}

class PostAttendanceErrorState extends AttendanceState {
  final String message;
  const PostAttendanceErrorState(this.message);
}
