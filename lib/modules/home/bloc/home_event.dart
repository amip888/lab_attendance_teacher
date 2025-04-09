part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class GetHomeEvent extends HomeEvent {
  GetHomeEvent();
}

class GetNotificationEvent extends HomeEvent {
  GetNotificationEvent();
}

class UpdateReadNotificationEvent extends HomeEvent {
  final Map<String, dynamic> body;
  UpdateReadNotificationEvent({required this.body});
}
