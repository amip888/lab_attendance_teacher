part of 'account_bloc.dart';

abstract class AccountEvent {
  const AccountEvent();
}

class GetUserAccountEvent extends AccountEvent {
  GetUserAccountEvent();
}

class UpdateUserAccountEvent extends AccountEvent {
  final Map<String, dynamic>? params;
  final String? idStudent;
  UpdateUserAccountEvent({this.params, this.idStudent});
}

class PostPINEvent extends AccountEvent {
  final Map<String, dynamic> params;
  PostPINEvent(this.params);
}
