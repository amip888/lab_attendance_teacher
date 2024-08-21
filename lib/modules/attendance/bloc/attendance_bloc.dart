import 'package:lab_attendance_mobile_teacher/modules/attendance/model/all_attendances_model/all_attendances_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/scedule_model/schedule_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final BatchApi _api;

  AttendanceBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(AttendanceInitial()) {
    on<GetScheduleEvent>(_onGetSchedule);
    on<GetAllAttendancesEvent>(_onGetAllAttendances);
    on<PostAttendanceEvent>(_onPostAttendance);
  }

  void _onGetSchedule(
      GetScheduleEvent event, Emitter<AttendanceState> emit) async {
    emit(GetScheduleLoadingState());
    try {
      final data = await _api.getSchedule(date: event.date);
      ResponseData responseData = ResponseData.fromJson(data.data);
      ScheduleModel scheduleModel = ScheduleModel.fromJson(responseData.data);
      if (data.statusCode == 200) {
        emit(GetScheduleLoadedState(scheduleModel));
      } else {
        emit(GetScheduleEmptyState(data.statusMessage!));
      }
    } on DioException catch (error) {
      emit(GetScheduleErrorState(error.message!));
    }
  }

  void _onGetAllAttendances(
      GetAllAttendancesEvent event, Emitter<AttendanceState> emit) async {
    emit(GetAllAttendancesLoadingState());
    try {
      final data = await _api.getAllAttendance();
      ResponseData responseData = ResponseData.fromJson(data.data);
      AllAttendancesModel allAttendancesModel =
          AllAttendancesModel.fromJson(responseData.data);
      if (data.statusCode == 200) {
        emit(GetAllAttendancesLoadedState(allAttendancesModel));
      } else {
        emit(GetAllAttendancesEmptyState(data.statusMessage!));
      }
    } on DioException catch (error) {
      emit(GetAllAttendancesErrorState(error.message!));
    }
  }

  void _onPostAttendance(
      PostAttendanceEvent event, Emitter<AttendanceState> emit) async {
    emit(PostAttendanceLoadingState());
    try {
      final data = await _api.postAttendance(body: event.params);
      if (data.statusCode == 200) {
        emit(const PostAttendanceLoadedState());
      } else {
        emit(PostAttendanceFailedState(data.statusMessage!));
      }
    } on DioException catch (error) {
      emit(PostAttendanceErrorState(error.message!));
    }
  }
}
