part of 'schedule_bloc.dart';

abstract class ScheduleState {
  const ScheduleState();
}

class ScheduleInitial extends ScheduleState {}

class NoInternetConnectionState extends ScheduleState {
  NoInternetConnectionState();
}

class GetScheduleLoadingState extends ScheduleState {
  GetScheduleLoadingState();
}

class GetScheduleLoadedState extends ScheduleState {
  final ScheduleModel data;
  const GetScheduleLoadedState(this.data);
}

class GetScheduleErrorState extends ScheduleState {
  final String message;
  const GetScheduleErrorState(this.message);
}

class GetScheduleEmptyState extends ScheduleState {
  final String message;
  const GetScheduleEmptyState(this.message);
}
