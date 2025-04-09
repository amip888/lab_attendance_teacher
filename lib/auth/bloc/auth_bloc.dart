import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:lab_attendance_mobile_teacher/auth/model/auth_model/auth_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  final BatchApi _api;

  AuthUserBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(AuthUserInitial()) {
    on<PostRegisterUserEvent>(_onRegisterEvent);
    on<PostLoginUserEvent>(_onLoginEvent);
  }

  void _onRegisterEvent(
      PostRegisterUserEvent event, Emitter<AuthUserState> emit) async {
    emit(const PostRegisterLoadingState());
    try {
      final data = await _api.registerUser(body: event.body);
      if (data.statusCode == 201) {
        emit(const PostRegisterLoadedState());
      } else {
        if (data.statusCode == 400) {
          emit(const PostRegisterFailedState('Anda Sudah Terdaftar'));
        } else {
          emit(const PostRegisterFailedState('Daftar User Gagal'));
        }
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(PostRegisterErrorState(error.toString()));
      }
    }
  }

  void _onLoginEvent(
      PostLoginUserEvent event, Emitter<AuthUserState> emit) async {
    emit(const PostLoginLoadingState());
    try {
      final data = await _api.loginUser(body: event.body);
      ResponseData responseData = ResponseData.fromJson(data.data);
      AuthModel authModel = AuthModel.fromJson(responseData.data);
      if (data.statusCode == 200) {
        emit(PostLoginLoadedState(authModel));
      } else {
        emit(PostLoginFailedState(data.statusMessage!));
      }
    } catch (error) {
      log('error login: $error');
      String message = '';
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        if (ApiService.errorCode == '401' &&
            ApiService.error == 'Your email not registered') {
          message = 'Email tidak terdaftar';
        } else if (ApiService.errorCode == '401' &&
            ApiService.error == 'You aren`t registered') {
          message = 'Anda belum terdaftar';
        } else if (ApiService.errorCode == '401' &&
            ApiService.error == 'Wrong password') {
          message = 'Password Salah';
        } else {
          message = error.toString();
        }
        emit(PostLoginErrorState(message));
      }
    }
  }
}
