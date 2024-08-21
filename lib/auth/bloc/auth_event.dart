part of 'auth_bloc.dart';

abstract class AuthUserEvent {
  const AuthUserEvent();
}

class GetAuthUserEvent extends AuthUserEvent {}

class PostRegisterUserEvent extends AuthUserEvent {
  Map<String, dynamic> body;
  PostRegisterUserEvent(this.body);
}

class PostLoginUserEvent extends AuthUserEvent {
  Map<String, dynamic> body;
  PostLoginUserEvent(this.body);
}

class GetTopProductEvent extends AuthUserEvent {
  GetTopProductEvent();
}
