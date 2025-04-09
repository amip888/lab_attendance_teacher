part of 'attendance_bloc.dart';

abstract class AttendanceState {
  const AttendanceState();
}

class AttendanceInitial extends AttendanceState {}

class NoInternetConnectionState extends AttendanceState {
  NoInternetConnectionState();
}

class GetScheduleLoadingState extends AttendanceState {
  GetScheduleLoadingState();
}

class GetScheduleLoadedState extends AttendanceState {
  final ScheduleModel? data;
  const GetScheduleLoadedState(this.data);
}

class GetOneScheduleLoadedState extends AttendanceState {
  final GetOneScheduleModel? data;
  const GetOneScheduleLoadedState(this.data);
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
  final AttendanceTeacherModel? dataAttendanceTeacher;
  final AttendanceStudentModel? dataAttendanceStudent;
  const GetAllAttendancesLoadedState(
      this.dataAttendanceTeacher, this.dataAttendanceStudent);
}

class GetAllAttendancesErrorState extends AttendanceState {
  final String message;
  const GetAllAttendancesErrorState(this.message);
}

class GetAllAttendancesEmptyState extends AttendanceState {
  final String message;
  const GetAllAttendancesEmptyState(this.message);
}

class GetOneAttendanceStudentLoadingState extends AttendanceState {
  GetOneAttendanceStudentLoadingState();
}

class GetOneAttendanceStudentLoadedState extends AttendanceState {
  final AttendanceStudentModel? dataAttendanceStudent;
  const GetOneAttendanceStudentLoadedState(this.dataAttendanceStudent);
}

class GetOneAttendanceStudentErrorState extends AttendanceState {
  final String message;
  const GetOneAttendanceStudentErrorState(this.message);
}

class GetOneAttendanceStudentEmptyState extends AttendanceState {
  final String message;
  const GetOneAttendanceStudentEmptyState(this.message);
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

class UpdateAttendanceStudentLoadingState extends AttendanceState {
  UpdateAttendanceStudentLoadingState();
}

class UpdateAttendanceStudentLoadedState extends AttendanceState {
  const UpdateAttendanceStudentLoadedState();
}

class UpdateAttendanceStudentFailedState extends AttendanceState {
  final String message;
  const UpdateAttendanceStudentFailedState(this.message);
}

class UpdateAttendanceStudentErrorState extends AttendanceState {
  final String message;
  const UpdateAttendanceStudentErrorState(this.message);
}
