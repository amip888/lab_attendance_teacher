part of 'account_bloc.dart';

abstract class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {}

class NoInternetConnectionState extends AccountState {
  NoInternetConnectionState();
}

class GetUserAccountLoadingState extends AccountState {
  GetUserAccountLoadingState();
}

class GetUserAccountLoadedState extends AccountState {
  final UserLoginModel? data;
  const GetUserAccountLoadedState(this.data);
}

class GetUserAccountErrorState extends AccountState {
  final String message;
  const GetUserAccountErrorState(this.message);
}

class GetUserAccountEmptyState extends AccountState {
  final String message;
  const GetUserAccountEmptyState(this.message);
}

class PostPINLoadingState extends AccountState {
  PostPINLoadingState();
}

class PostPINLoadedState extends AccountState {
  const PostPINLoadedState();
}

class PostPINFailedState extends AccountState {
  final String message;
  const PostPINFailedState(this.message);
}

class PostPINErrorState extends AccountState {
  final String message;
  const PostPINErrorState(this.message);
}

class UpdateUserAccountLoadingState extends AccountState {
  UpdateUserAccountLoadingState();
}

class UpdateUserAccountLoadedState extends AccountState {
  const UpdateUserAccountLoadedState();
}

class UpdateUserAccountFailedState extends AccountState {
  final String message;
  const UpdateUserAccountFailedState(this.message);
}

class UpdateUserAccountErrorState extends AccountState {
  final String message;
  const UpdateUserAccountErrorState(this.message);
}
