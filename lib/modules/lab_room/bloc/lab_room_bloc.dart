import 'package:bloc/bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'lab_room_event.dart';
part 'lab_room_state.dart';

class LabRoomBloc extends Bloc<LabRoomEvent, LabRoomState> {
  final BatchApi _api;

  LabRoomBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(LabRoomInitial()) {
    on<GetLabRoomEvent>(_onGetLabRoom);
  }

  void _onGetLabRoom(GetLabRoomEvent event, Emitter<LabRoomState> emit) async {
    emit(GetLabRoomLoadingState());
    try {
      final data = await _api.getLabRooms();
      ResponseData responseData = ResponseData.fromJson(data.data);
      LabRoomModel labRoomModel = LabRoomModel.fromJson(responseData.data);
      if (data.statusCode == 200) {
        emit(GetLabRoomLoadedState(labRoomModel));
      } else {
        emit(GetLabRoomEmptyState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(GetLabRoomErrorState(error.toString()));
      }
    }
  }
}
