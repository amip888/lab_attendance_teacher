import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule_model.dart';
// import 'package:lab_attendance_mobile_teacher/modules/schedule/model/teachers_model/teachers_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BatchApi _api;

  ScheduleBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(ScheduleInitial()) {
    on<GetScheduleEvent>(_onGetSchedule);
    on<AddScheduleEvent>(_onAddSchedule);
    // on<GetTeachersEvent>(_onGetTeachers);
  }

  void _onGetSchedule(
      GetScheduleEvent event, Emitter<ScheduleState> emit) async {
    emit(GetScheduleLoadingState());
    try {
      final data = await _api.getSchedules();
      ResponseData responseData = ResponseData.fromJson(data.data);
      ScheduleModel scheduleModel = ScheduleModel.fromJson(responseData.data);
      if (scheduleModel.schedules!.isNotEmpty) {
        emit(GetScheduleLoadedState(scheduleModel));
      } else {
        emit(GetScheduleEmptyState(data.statusMessage!));
      }
    } catch (error) {
      emit(GetScheduleErrorState(error.toString()));
    }
  }

  void _onAddSchedule(
      AddScheduleEvent event, Emitter<ScheduleState> emit) async {
    emit(AddScheduleLoadingState());
    try {
      final data = await _api.addSchedule(body: event.params);
      log(data.statusCode.toString());
      if (data.statusCode == 200 || data.statusCode == 201) {
        emit(const AddScheduleLoadedState());
      } else {
        emit(AddScheduleFailedState(data.statusMessage!));
      }
    } on DioException catch (error) {
      emit(AddScheduleErrorState(error.message!));
    }
  }

  // void _onGetTeachers(
  //     GetTeachersEvent event, Emitter<ScheduleState> emit) async {
  //   emit(GetTeachersLoadingState());
  //   try {
  //     final data = await _api.getSchedules();
  //     // final data = await _api.getTeachers();
  //     ResponseData responseData = ResponseData.fromJson(data.data);
  //     // TeachersModel teachersModel = TeachersModel.fromJson(responseData.data);
  //     if (teachersModel.teacher!.isNotEmpty) {
  //       emit(GetTeachersLoadedState(teachersModel));
  //     } else {
  //       emit(GetTeachersEmptyState(data.statusMessage!));
  //     }
  //   } on DioException catch (error) {
  //     emit(GetTeachersErrorState(error.message!));
  //   }
  // }
}
