import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
    } on DioException catch (error) {
      emit(GetUserAccountErrorState(error.message!));
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
    } on DioException catch (error) {
      emit(UpdateUserAccountErrorState(error.message!));
    }
  }
}
