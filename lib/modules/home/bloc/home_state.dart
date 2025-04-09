part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class NoInternetConnectionState extends HomeState {
  NoInternetConnectionState();
}

class GetHomeLoadingState extends HomeState {
  GetHomeLoadingState();
}

class GetHomeLoadedState extends HomeState {
  final UserLoginModel dataUser;
  final LabRoomModel dataLabRoom;
  final ScheduleModel dataSchedule;
  final AttendanceTeacherModel dataAttendance;
  final NotificationModel dataNotification;
  const GetHomeLoadedState({
    required this.dataUser,
    required this.dataLabRoom,
    required this.dataSchedule,
    required this.dataAttendance,
    required this.dataNotification,
  });
}

class GetHomeErrorState extends HomeState {
  final String message;
  const GetHomeErrorState(this.message);
}

class GetHomeEmptyState extends HomeState {
  final String message;
  const GetHomeEmptyState(this.message);
}

class GetNotificationLoadingState extends HomeState {
  GetNotificationLoadingState();
}

class GetNotificationLoadedState extends HomeState {
  final NotificationModel data;
  const GetNotificationLoadedState(this.data);
}

class GetNotificationErrorState extends HomeState {
  final String message;
  const GetNotificationErrorState(this.message);
}

class GetNotificationEmptyState extends HomeState {
  final String message;
  const GetNotificationEmptyState(this.message);
}

class UpdateReadNotificationLoadingState extends HomeState {
  UpdateReadNotificationLoadingState();
}

class UpdateReadNotificationLoadedState extends HomeState {
  const UpdateReadNotificationLoadedState();
}

class UpdateReadNotificationFailedState extends HomeState {
  final String message;
  const UpdateReadNotificationFailedState(this.message);
}

class UpdateReadNotificationErrorState extends HomeState {
  final String message;
  const UpdateReadNotificationErrorState(this.message);
}
