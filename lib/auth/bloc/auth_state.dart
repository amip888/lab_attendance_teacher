part of 'auth_bloc.dart';

abstract class AuthUserState {
  const AuthUserState();
}

class AuthUserInitial extends AuthUserState {}

class GetAuthUserLoadingState extends AuthUserState {
  GetAuthUserLoadingState();
}

class GetAuthUserLoadedState extends AuthUserState {
  // final AuthUserResult data;
  // // final UserResult data;
  // const GetAuthUserLoadedState(this.data);
}

class GetAuthUserErrorState extends AuthUserState {
  final String message;
  const GetAuthUserErrorState(this.message);
}

class GetAuthUserEmptyState extends AuthUserState {
  final String message;
  const GetAuthUserEmptyState(this.message);
}

class PostRegisterLoadingState extends AuthUserState {
  const PostRegisterLoadingState();
}

class PostRegisterLoadedState extends AuthUserState {
  const PostRegisterLoadedState();
}

class PostRegisterFailedState extends AuthUserState {
  final String message;
  const PostRegisterFailedState(this.message);
}

class PostRegisterErrorState extends AuthUserState {
  final String message;
  const PostRegisterErrorState(this.message);
}

class PostLoginLoadingState extends AuthUserState {
  const PostLoginLoadingState();
}

class PostLoginLoadedState extends AuthUserState {
  final AuthModel authModel;
  const PostLoginLoadedState(this.authModel);
}

class PostLoginFailedState extends AuthUserState {
  final String message;
  const PostLoginFailedState(this.message);
}

class PostLoginErrorState extends AuthUserState {
  final String message;
  const PostLoginErrorState(this.message);
}
