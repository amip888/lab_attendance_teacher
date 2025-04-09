import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:bloc/bloc.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final BatchApi _api;

  AccountBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(AccountInitial()) {
    on<GetUserAccountEvent>(_onGetUserLogin);
    on<PostPINEvent>(_onPostPIN);
    on<UpdateUserAccountEvent>(_onUpdateUserAccount);
  }

  void _onGetUserLogin(
      GetUserAccountEvent event, Emitter<AccountState> emit) async {
    emit(GetUserAccountLoadingState());
    try {
      final data = await _api.getUserAccount();
      ResponseData responseData = ResponseData.fromJson(data.data);
      UserLoginModel userLoginModel =
          UserLoginModel.fromJson(responseData.data);
      if (data.statusCode == 200) {
        emit(GetUserAccountLoadedState(userLoginModel));
      } else {
        emit(GetUserAccountEmptyState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(GetUserAccountErrorState(error.toString()));
      }
    }
  }

  void _onPostPIN(PostPINEvent event, Emitter<AccountState> emit) async {
    emit(PostPINLoadingState());
    try {
      final data = await _api.postPIN(body: event.params);
      if (data.statusCode == 200) {
        emit(const PostPINLoadedState());
      } else if (data.statusCode == 401 && ApiService.error == 'Wrong PIN') {
        emit(const PostPINFailedState('PIN Salah'));
      } else {
        emit(PostPINFailedState(data.statusMessage!));
      }
    } catch (error) {
      String message = '';
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else if (ApiService.errorCode == '401' &&
          ApiService.error == 'Wrong PIN') {
        message = 'PIN Salah';
        emit(PostPINErrorState(message));
      } else {
        message = error.toString();
        emit(PostPINErrorState(message));
      }
    }
  }

  void _onUpdateUserAccount(
      UpdateUserAccountEvent event, Emitter<AccountState> emit) async {
    emit(UpdateUserAccountLoadingState());
    try {
      final data = await _api.updateUserAccount(
          body: event.params, idTeacher: event.idStudent);
      if (data.statusCode == 200) {
        emit(const UpdateUserAccountLoadedState());
      } else {
        emit(UpdateUserAccountFailedState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(UpdateUserAccountErrorState(error.toString()));
      }
    }
  }
}
