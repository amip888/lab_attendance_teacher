import 'package:bloc/bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/model/list_user_model/list_user_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'list_user_event.dart';
part 'list_user_state.dart';

class ListUserBloc extends Bloc<ListUserEvent, ListUserState> {
  final BatchApi _api;

  ListUserBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(ListUserInitial()) {
    on<GetListUserEvent>(_onGetListUser);
  }

  void _onGetListUser(
      GetListUserEvent event, Emitter<ListUserState> emit) async {
    emit(GetListUserLoadingState());
    try {
      final data = await _api.getListUsers();
      ResponseData responseData = ResponseData.fromJson(data.data);
      ListUserModel listUserModel = ListUserModel.fromJson(responseData.data);
      if (listUserModel.users!.isNotEmpty) {
        emit(GetListUserLoadedState(listUserModel));
      } else {
        emit(GetListUserEmptyState(data.statusMessage!));
      }
    } catch (error) {
      emit(GetListUserErrorState(error.toString()));
    }
  }
}
