part of 'account_bloc.dart';

abstract class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {}

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
