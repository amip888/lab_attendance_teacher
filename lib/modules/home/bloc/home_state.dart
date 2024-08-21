part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class GetUserLoginLoadingState extends HomeState {
  GetUserLoginLoadingState();
}

class GetUserLoginLoadedState extends HomeState {
  final UserLoginModel data;
  final ScheduleModel dataSchedule;
  const GetUserLoginLoadedState(
      {required this.data, required this.dataSchedule});
}

class GetUserLoginErrorState extends HomeState {
  final String message;
  const GetUserLoginErrorState(this.message);
}

class GetUserLoginEmptyState extends HomeState {
  final String message;
  const GetUserLoginEmptyState(this.message);
}
