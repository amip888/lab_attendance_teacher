part of 'schedule_bloc.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

class GetScheduleEvent extends ScheduleEvent {
  GetScheduleEvent();
}

class AddScheduleEvent extends ScheduleEvent {
  final Map<String, dynamic> params;
  AddScheduleEvent(this.params);
}

class GetTeachersEvent extends ScheduleEvent {
  GetTeachersEvent();
}
