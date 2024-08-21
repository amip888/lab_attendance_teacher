part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class GetUserLoginEvent extends HomeEvent {
  GetUserLoginEvent();
}
