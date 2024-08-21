part of 'lab_room_bloc.dart';

abstract class LabRoomEvent {
  const LabRoomEvent();
}

class GetLabRoomEvent extends LabRoomEvent {
  GetLabRoomEvent();
}

class PostLabRoomEvent extends LabRoomEvent {
  final Map<String, dynamic>? params;
  PostLabRoomEvent({this.params});
}
