import 'dart:async';
import 'package:dio/dio.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/environment.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';

class BatchApi {
  final ApiService _apiService;

  BatchApi() : _apiService = ApiService();
  static const String api = Environment.endpointApi;
  static const String teacher = 'teacher';
  static const String register = '/register';
  static const String login = '/login';
  static const String saveFile = '/upload-file';
  static const String attendanceTeacher = '/attendance_teacher';
  static const String attendanceTeachers = 'attendance_teachers';
  static const String generateSchedule = 'generate-schedule';
  static const String schedules = 'schedules';
  static const String schedule = 'schedule';
  static const String labRooms = 'lab-rooms';
  static const String labRoom = 'lab-room';
  static const String teachers = 'teachers';
  static const String users = 'users';

  Future<Response> registerUser({body}) async {
    Response response = await _apiService.post('$api$teacher$register', body);
    return response;
  }

  Future<Response> loginUser({body}) async {
    Response response = await _apiService.post('$api$teacher$login', body);
    return response;
  }

  Future<Response> getUserLogin() async {
    String userId = await LocalStorageServices.getUserId();
    Response response = await _apiService.get('$api$teacher/$userId');
    return response;
  }

  Future<Response> getUserAccount() async {
    String userId = await LocalStorageServices.getUserId();
    Response response = await _apiService.get('$api$teacher/$userId');
    return response;
  }

  Future<Response> updateUserAccount({body, idTeacher}) async {
    String userId = await LocalStorageServices.getUserId();
    Response response =
        await _apiService.patch('$api$teacher$idTeacher/$userId', body);
    return response;
  }

  Future<Response> postSaveFile({body}) async {
    Response response =
        await _apiService.post('$api$teacher$saveFile', body, formData: true);
    return response;
  }

  Future<Response> getLabRooms() async {
    Response response = await _apiService.get('$api$labRooms');
    return response;
  }

  Future<Response> postLabRoom({body}) async {
    Response response = await _apiService.post('$api$labRoom', body);
    return response;
  }

  Future<Response> getSchedules() async {
    Response response = await _apiService.get('$api$schedules');
    return response;
  }

  Future<Response> getSchedule({date}) async {
    Response response = await _apiService.get('$api$schedule/$date');
    return response;
  }

  Future<Response> getTeachers({date}) async {
    Response response = await _apiService.get('$api$teachers');
    return response;
  }

  Future<Response> getListUsers() async {
    Response response = await _apiService.get('$api$users');
    return response;
  }

  Future<Response> addSchedule({body}) async {
    Response response = await _apiService.post('$api$generateSchedule', body);
    // Response response = await _apiService.post('$api$schedule', body);
    return response;
  }

  Future<Response> getAllAttendance({body}) async {
    Response response = await _apiService.get('$api$attendanceTeachers');
    return response;
  }

  Future<Response> postAttendance({body}) async {
    Response response =
        await _apiService.post('$api$teacher$attendanceTeacher', body);
    return response;
  }
}
