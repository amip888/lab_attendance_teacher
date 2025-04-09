part of 'lab_room_bloc.dart';

abstract class LabRoomState {
  const LabRoomState();
}

class LabRoomInitial extends LabRoomState {}

class NoInternetConnectionState extends LabRoomState {
  NoInternetConnectionState();
}

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
