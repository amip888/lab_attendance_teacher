part of 'list_user_bloc.dart';

abstract class ListUserEvent {
  const ListUserEvent();
}

class GetListUserEvent extends ListUserEvent {
  GetListUserEvent();
}
