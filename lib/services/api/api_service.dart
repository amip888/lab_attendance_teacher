import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:lab_attendance_mobile_teacher/services/api/check_connection_internet.dart';
import 'package:lab_attendance_mobile_teacher/services/api/environment.dart';
import 'package:lab_attendance_mobile_teacher/services/api/error_state.dart';
import 'package:lab_attendance_mobile_teacher/services/api/logging_interceptor.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';

class ApiService {
  final Dio _dio = Dio();
  final CheckConnectionInternet connectionChecker = CheckConnectionInternet();
  static String errorCode = '';
  static String error = '';
  static String connectionInternet = '';

  Future<Response> get(url, {queryParam, page, withToken = true}) async {
    log('--- GET');
    log('--- URL : $url');
    log('--- params : $queryParam');
    _dio.interceptors.add(LoggingInterceptor());
    String accessToken = await LocalStorageServices.getAccessToken();
    log('--- GET : $accessToken');
    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['x-api-key'] = Environment.apiKey;

    // if (connectionChecker.hasConnection) {
    //   connectionInternet = 'Connected';
    try {
      Response response = await _dio.get(url, queryParameters: queryParam);
      return response;
    } on DioException catch (error) {
      log('---------------------');
      log('ERROR DISINI GAES');
      log(url.toString());
      log(error.message.toString());
      log(error.response!.statusCode.toString());
      log('---------------------');
      if (error.response!.statusCode == 401) {
        log('Error 401 di URL $url');
      }
      ApiService.errorCode = error.response!.statusCode.toString();
      return error.response!.data;
    }
    // } else {
    //   connectionInternet = 'Disconnect';
    //   log("No internet connection");
    //   throw Exception("No Internet Connection. Please check your connection.");
    // }
  }

  Future<Response> post(url, body,
      {bool withToken = true,
      bool formData = false,
      bool formUrlencoded = false,
      parameter}) async {
    log('--- POST');
    log('--- ${body.toString()}');
    log('--- URL : $url');
    log('--- PARAMS : $parameter');
    String accessToken = await LocalStorageServices.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());

    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['x-api-key'] = Environment.apiKey;
    var formBody = FormData.fromMap(body);

    // if (connectionChecker.hasConnection) {
    //   connectionInternet = 'Connected';
    try {
      Response response = await _dio.post(url,
          data: formData ? formBody : body,
          queryParameters: parameter,
          options: Options(
              contentType:
                  formUrlencoded ? 'application/x-www-form-urlencoded' : null));
      return response;
    } on DioException catch (error) {
      log('ERROR ${handleErrorDio(error).toString()}');
      log('ERROR ${error.response}');
      log(error.toString());
      log(errorCode);
      ApiService.errorCode = error.response!.statusCode.toString();
      ApiService.error = error.response.toString();
      return error.response!;
    }
    // } else {
    //   connectionInternet = 'Disconnect';
    //   log("No internet connection");
    //   throw Exception("No Internet Connection. Please check your connection.");
    // }
  }

  Future<Response> patch(url, body,
      {bool withToken = true,
      bool formData = false,
      bool formUrlencoded = false}) async {
    log('--- PATCH');
    log('--- ${body.toString()}');
    log('--- URL : $url');
    String accessToken = await LocalStorageServices.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());

    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['x-api-key'] = Environment.apiKey;
    var formBody = FormData.fromMap(body);

    // if (connectionChecker.hasConnection) {
    //   connectionInternet = 'Connected';
    try {
      Response response = await _dio.patch(url,
          data: formData ? formBody : body,
          options: Options(
              contentType:
                  formUrlencoded ? 'application/x-www-form-urlencoded' : null));
      return response;
    } on DioException catch (error) {
      log('ERROR ${handleErrorDio(error).toString()}');
      log('ERROR ${error.response}');
      return error.response!;
    }
    // } else {
    //   connectionInternet = 'Disconnect';
    //   log("No internet connection");
    //   throw Exception("No Internet Connection. Please check your connection.");
    // }
  }

  Future<Response> delete(url, {bool withToken = true}) async {
    log('--- DELETE');
    log('--- URL : $url');
    String accessToken = await LocalStorageServices.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());
    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      _dio.options.headers['Accept'] = 'application/json';
    }
    _dio.options.headers['x-api-key'] = Environment.apiKey;
    // if (connectionChecker.hasConnection) {
    //   connectionInternet = 'Connected';
    Response response = await _dio.delete(url);
    return response;
    // } else {
    //   connectionInternet = 'Disconnect';
    //   log("No internet connection");
    //   throw Exception("No Internet Connection. Please check your connection.");
    // }
  }

  Future<Response> downloadFile(url,
      {bool withToken = true,
      body,
      queryParam,
      savePath,
      Function(int, int)? progressDownload}) async {
    log('--- DOWNLOAD FILE');
    log('--- URL : $url');
    String accessToken = await LocalStorageServices.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());

    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['x-api-key'] = Environment.apiKey;

    dynamic formBody;
    if (body != null) {
      log('DIO POST BODY $body');
      formBody = FormData.fromMap(body);
    }
    log('params $queryParam');

    // if (connectionChecker.hasConnection) {
    //   connectionInternet = 'Connected';
    try {
      Response response = await _dio.download(url, savePath,
          queryParameters: queryParam,
          data: formBody,
          onReceiveProgress: progressDownload);
      log('DIO RESPONSE ${response.data}');
      return response;
    } on DioException catch (error) {
      log('DIO ERROR ${handleErrorDio(error)}');
      log('DIO ERROR ${error.response!.data}');
      return error.response!;
    }
    // } else {
    //   connectionInternet = 'Disconnect';
    //   log("No internet connection");
    //   throw Exception("No Internet Connection. Please check your connection.");
    // }
  }
}
