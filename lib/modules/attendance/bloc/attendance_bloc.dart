import 'package:bloc/bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_student_model/attendance_student_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_teacher_model/attendance_teacher_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/get_one_schedule_model/get_one_schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final BatchApi _api;

  AttendanceBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(AttendanceInitial()) {
    on<GetScheduleByDateEvent>(_onGetScheduleByDate);
    on<GetAllAttendancesEvent>(_onGetAllAttendances);
    on<GetOneAttendanceStudentEvent>(_onGetOneAttendanceStudent);
    on<PostAttendanceEvent>(_onPostAttendance);
    on<UpdateAttendanceStudentEvent>(_onUpdateAttendanceStudent);
  }

  void _onGetScheduleByDate(
      GetScheduleByDateEvent event, Emitter<AttendanceState> emit) async {
    emit(GetScheduleLoadingState());
    try {
      final data = await _api.getScheduleByDate(params: event.params);
      ResponseData responseData = ResponseData.fromJson(data.data);
      GetOneScheduleModel getOneScheduleModel =
          GetOneScheduleModel.fromJson(responseData.data);
      if (getOneScheduleModel.schedule != null) {
        emit(GetOneScheduleLoadedState(getOneScheduleModel));
      } else {
        emit(GetScheduleEmptyState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else if (ApiService.errorCode == '404') {
        emit(const GetScheduleEmptyState('Jadwal Praktikum Kosong'));
      } else {
        emit(GetScheduleErrorState(error.toString()));
      }
    }
  }

  void _onGetAllAttendances(
      GetAllAttendancesEvent event, Emitter<AttendanceState> emit) async {
    emit(GetAllAttendancesLoadingState());
    try {
      final dataAttendanceTeacher = await _api.getAttendanceTeacher();
      ResponseData responseDataTeacher =
          ResponseData.fromJson(dataAttendanceTeacher.data);
      AttendanceTeacherModel attendanceTeacherModel =
          AttendanceTeacherModel.fromJson(responseDataTeacher.data);
      final dataAttendanceStudent = await _api.getAttendanceStudent();
      ResponseData responseDataStudent =
          ResponseData.fromJson(dataAttendanceStudent.data);
      AttendanceStudentModel attendanceStudentModel =
          AttendanceStudentModel.fromJson(responseDataStudent.data);

      if (dataAttendanceTeacher.statusCode == 200 ||
          dataAttendanceStudent.statusCode == 200) {
        emit(GetAllAttendancesLoadedState(
            attendanceTeacherModel, attendanceStudentModel));
      } else {
        emit(GetAllAttendancesEmptyState(dataAttendanceTeacher.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(GetAllAttendancesErrorState(error.toString()));
      }
    }
  }

  void _onGetOneAttendanceStudent(
      GetOneAttendanceStudentEvent event, Emitter<AttendanceState> emit) async {
    emit(GetOneAttendanceStudentLoadingState());
    try {
      final dataAttendanceStudent = await _api.getAttendanceStudent();
      ResponseData responseDataStudent =
          ResponseData.fromJson(dataAttendanceStudent.data);
      AttendanceStudentModel attendanceStudentModel =
          AttendanceStudentModel.fromJson(responseDataStudent.data);

      if (dataAttendanceStudent.statusCode == 200) {
        emit(GetOneAttendanceStudentLoadedState(attendanceStudentModel));
      } else {
        emit(GetOneAttendanceStudentEmptyState(
            dataAttendanceStudent.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(GetOneAttendanceStudentErrorState(error.toString()));
      }
    }
  }

  void _onPostAttendance(
      PostAttendanceEvent event, Emitter<AttendanceState> emit) async {
    emit(PostAttendanceLoadingState());
    try {
      final data = await _api.postAttendance(body: event.params);
      if (data.statusCode == 201) {
        emit(const PostAttendanceLoadedState());
      } else {
        emit(PostAttendanceFailedState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(PostAttendanceErrorState(error.toString()));
      }
    }
  }

  void _onUpdateAttendanceStudent(
      UpdateAttendanceStudentEvent event, Emitter<AttendanceState> emit) async {
    emit(UpdateAttendanceStudentLoadingState());
    try {
      final data = await _api.updateAttendanceStudent(
          body: event.body, id: event.attendanceId);
      if (data.statusCode == 200) {
        emit(const UpdateAttendanceStudentLoadedState());
      } else {
        emit(UpdateAttendanceStudentFailedState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(UpdateAttendanceStudentErrorState(error.toString()));
      }
    }
  }
}
