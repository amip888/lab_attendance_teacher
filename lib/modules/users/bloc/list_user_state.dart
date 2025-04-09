part of 'list_user_bloc.dart';

abstract class ListUserState {
  const ListUserState();
}

class ListUserInitial extends ListUserState {}

class NoInternetConnectionState extends ListUserState {
  NoInternetConnectionState();
}

class GetListUserLoadingState extends ListUserState {
  GetListUserLoadingState();
}

class GetListUserLoadedState extends ListUserState {
  final ListUserModel data;
  const GetListUserLoadedState(this.data);
}

class GetListUserErrorState extends ListUserState {
  final String message;
  const GetListUserErrorState(this.message);
}

class GetListUserEmptyState extends ListUserState {
  final String message;
  const GetListUserEmptyState(this.message);
}
