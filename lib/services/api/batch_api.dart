import 'dart:async';
import 'package:dio/dio.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/environment.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';

class BatchApi {
  final ApiService _apiService;

  BatchApi() : _apiService = ApiService();
  static String api = Environment.endpointApi;
  static const String teacher = 'teacher';
  static const String register = '/register';
  static const String login = '/login';
  static const String pinUser = '/pin-user';
  static const String file = 'file';
  static const String saveFile = '/upload-file';
  static const String downloadExcel = '/download-excel';
  static const String downloadPdf = '/download-pdf';
  static const String attendanceTeacher = 'attendance_teacher';
  static const String attendanceTeachers = 'attendance_teachers';
  static const String attendanceStudents = 'attendance_students';
  static const String attendanceStudent = 'attendance_student';
  static const String generateSchedule = 'generate-schedule';
  static const String schedules = 'schedules';
  static const String schedule = 'schedule';
  static const String scheduleByDate = 'schedule-date';
  static const String labRooms = 'lab-rooms';
  static const String labRoom = 'lab-room';
  static const String teachers = 'teachers';
  static const String users = 'users';
  static const String notifications = 'notifications';
  static const String readNotif = 'read-notifications';

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

  Future<Response> getNotification() async {
    Response response = await _apiService.get('$api$notifications');
    return response;
  }

  Future<Response> readNotification({body}) async {
    Response response = await _apiService.post('$api$readNotif', body);
    return response;
  }

  Future<Response> getUserAccount() async {
    String userId = await LocalStorageServices.getUserId();
    Response response = await _apiService.get('$api$teacher/$userId');
    return response;
  }

  Future<Response> postPIN({body}) async {
    Response response = await _apiService.post('$api$teacher$pinUser', body);
    return response;
  }

  Future<Response> updateUserAccount({body, idTeacher}) async {
    Response response =
        await _apiService.patch('$api$teacher/$idTeacher', body);
    return response;
  }

  Future<Response> postSaveFile({body}) async {
    Response response =
        await _apiService.post('$api$file$saveFile', body, formData: true);
    return response;
  }

  Future<Response> downloadFile(
      {fileType, path, progressDownload, params}) async {
    Response response = fileType == 'excel'
        ? await _apiService.downloadFile('$api$file$downloadExcel',
            queryParam: params,
            savePath: path,
            progressDownload: progressDownload)
        : await _apiService.downloadFile('$api$file$downloadPdf',
            queryParam: params, savePath: path);
    return response;
  }

  Future<Response> getLabRooms() async {
    Response response = await _apiService.get('$api$labRooms');
    return response;
  }

  Future<Response> getSchedules() async {
    Response response = await _apiService.get('$api$schedules');
    return response;
  }

  Future<Response> getScheduleByDate({params}) async {
    Response response =
        await _apiService.get('$api$scheduleByDate', queryParam: params);
    return response;
  }

  Future<Response> getListUsers() async {
    Response response = await _apiService.get('$api$users');
    return response;
  }

  Future<Response> getAttendanceTeacher({body}) async {
    Response response = await _apiService.get('$api$attendanceTeachers');
    return response;
  }

  Future<Response> getAttendanceStudent({body}) async {
    Response response = await _apiService.get('$api$attendanceStudents');
    return response;
  }

  Future<Response> postAttendance({body}) async {
    Response response = await _apiService.post('$api$attendanceTeacher', body);
    return response;
  }

  Future<Response> updateAttendanceStudent({body, id}) async {
    Response response =
        await _apiService.patch('$api$attendanceStudent/$id', body);
    return response;
  }
}
