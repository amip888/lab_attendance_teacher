import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BatchApi _api;

  HomeBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(HomeInitial()) {
    on<GetUserLoginEvent>(_onGetUserLogin);
  }

  void _onGetUserLogin(GetUserLoginEvent event, Emitter<HomeState> emit) async {
    emit(GetUserLoginLoadingState());
    try {
      final data = await _api.getUserLogin();
      ResponseData responseData = ResponseData.fromJson(data.data);
      UserLoginModel userLoginModel =
          UserLoginModel.fromJson(responseData.data);

      final dataSchedule = await _api.getSchedules();
      ResponseData responseDataSchedule =
          ResponseData.fromJson(dataSchedule.data);
      ScheduleModel schedulesModel =
          ScheduleModel.fromJson(responseDataSchedule.data);

      if (data.statusCode == 200 || dataSchedule.statusCode == 200) {
        emit(GetUserLoginLoadedState(
            data: userLoginModel, dataSchedule: schedulesModel));
      } else {
        emit(GetUserLoginEmptyState(data.statusMessage!));
      }
    } on DioException catch (error) {
      emit(GetUserLoginErrorState(error.message!));
    }
  }

  // void _onLoginEvent(
  //     PostLoginUserEvent event, Emitter<HomeState> emit) async {
  //   emit(const PostLoginLoadingState());
  //   try {
  //     final data = await _api.loginUser(body: event.body);
  //     if (data.statusCode == 200) {
  //       emit(const PostLoginLoadedState());
  //     } else {
  //       emit(PostLoginFailedState(data.statusMessage!));
  //     }
  //   } on DioException catch (error) {
  //     log('error login: $error');
  //     emit(PostLoginErrorState(error.message!));
  //   }
  // }
}
