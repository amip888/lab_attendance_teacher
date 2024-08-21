part of 'schedule_bloc.dart';

abstract class ScheduleState {
  const ScheduleState();
}

class ScheduleInitial extends ScheduleState {}

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

class AddScheduleLoadingState extends ScheduleState {
  AddScheduleLoadingState();
}

class AddScheduleLoadedState extends ScheduleState {
  const AddScheduleLoadedState();
}

class AddScheduleFailedState extends ScheduleState {
  final String message;
  const AddScheduleFailedState(this.message);
}

class AddScheduleErrorState extends ScheduleState {
  final String message;
  const AddScheduleErrorState(this.message);
}

class GetTeachersLoadingState extends ScheduleState {
  GetTeachersLoadingState();
}

class GetTeachersLoadedState extends ScheduleState {
  // final TeachersModel data;
  const GetTeachersLoadedState();
}

class GetTeachersErrorState extends ScheduleState {
  final String message;
  const GetTeachersErrorState(this.message);
}

class GetTeachersEmptyState extends ScheduleState {
  final String message;
  const GetTeachersEmptyState(this.message);
}
