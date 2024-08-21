part of 'lab_room_bloc.dart';

abstract class LabRoomState {
  const LabRoomState();
}

class LabRoomInitial extends LabRoomState {}

class GetLabRoomLoadingState extends LabRoomState {
  GetLabRoomLoadingState();
}

class GetLabRoomLoadedState extends LabRoomState {
  final LabRoomModel? data;
  const GetLabRoomLoadedState(this.data);
}

class GetLabRoomErrorState extends LabRoomState {
  final String message;
  const GetLabRoomErrorState(this.message);
}

class GetLabRoomEmptyState extends LabRoomState {
  final String message;
  const GetLabRoomEmptyState(this.message);
}

class PostLabRoomLoadingState extends LabRoomState {
  PostLabRoomLoadingState();
}

class PostLabRoomLoadedState extends LabRoomState {
  const PostLabRoomLoadedState();
}

class PostLabRoomFailedState extends LabRoomState {
  final String message;
  const PostLabRoomFailedState(this.message);
}

class PostLabRoomErrorState extends LabRoomState {
  final String message;
  const PostLabRoomErrorState(this.message);
}
