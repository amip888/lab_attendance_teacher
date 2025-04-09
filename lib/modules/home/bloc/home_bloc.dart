import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_teacher_model/attendance_teacher_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/notification_model/notification_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:bloc/bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BatchApi _api;

  HomeBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(HomeInitial()) {
    on<GetHomeEvent>(_onGetHome);
    on<GetNotificationEvent>(_onGetNotification);
    on<UpdateReadNotificationEvent>(_onUpdateNotification);
  }

  void _onGetHome(GetHomeEvent event, Emitter<HomeState> emit) async {
    emit(GetHomeLoadingState());
    try {
      final dataUser = await _api.getUserLogin();
      ResponseData responseData = ResponseData.fromJson(dataUser.data);
      UserLoginModel userLoginModel =
          UserLoginModel.fromJson(responseData.data);

      final dataLabRoom = await _api.getLabRooms();
      ResponseData responseDataLabRoom =
          ResponseData.fromJson(dataLabRoom.data);
      LabRoomModel labRoomModel =
          LabRoomModel.fromJson(responseDataLabRoom.data);

      final dataSchedule = await _api.getSchedules();
      ResponseData responseDataSchedule =
          ResponseData.fromJson(dataSchedule.data);
      ScheduleModel schedulesModel =
          ScheduleModel.fromJson(responseDataSchedule.data);

      final dataAttendance = await _api.getAttendanceTeacher();
      ResponseData responseDataAttendance =
          ResponseData.fromJson(dataAttendance.data);
      AttendanceTeacherModel attendanceTeacherModel =
          AttendanceTeacherModel.fromJson(responseDataAttendance.data);

      final dataNotification = await _api.getNotification();
      ResponseData responseDataNotification =
          ResponseData.fromJson(dataNotification.data);
      NotificationModel notificationModel =
          NotificationModel.fromJson(responseDataNotification.data);

      if (dataUser.statusCode == 200 ||
          dataLabRoom.statusCode == 200 ||
          dataSchedule.statusCode == 200 ||
          dataAttendance.statusCode == 200 ||
          dataNotification.statusCode == 200) {
        emit(GetHomeLoadedState(
            dataUser: userLoginModel,
            dataLabRoom: labRoomModel,
            dataSchedule: schedulesModel,
            dataAttendance: attendanceTeacherModel,
            dataNotification: notificationModel));
      } else {
        emit(GetHomeEmptyState(dataUser.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(GetHomeErrorState(error.toString()));
      }
    }
  }

  void _onGetNotification(
      GetNotificationEvent event, Emitter<HomeState> emit) async {
    emit(GetNotificationLoadingState());
    try {
      final data = await _api.getNotification();
      ResponseData responseData = ResponseData.fromJson(data.data);
      NotificationModel notificationModel =
          NotificationModel.fromJson(responseData.data);

      if (notificationModel.notification!.isNotEmpty) {
        emit(GetNotificationLoadedState(notificationModel));
      } else {
        emit(GetNotificationEmptyState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(GetNotificationErrorState(error.toString()));
      }
    }
  }

  void _onUpdateNotification(
      UpdateReadNotificationEvent event, Emitter<HomeState> emit) async {
    emit(UpdateReadNotificationLoadingState());
    try {
      final data = await _api.readNotification(body: event.body);

      if (data.statusCode == 201) {
        emit(const UpdateReadNotificationLoadedState());
      } else {
        emit(UpdateReadNotificationFailedState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(UpdateReadNotificationErrorState(error.toString()));
      }
    }
  }
}
