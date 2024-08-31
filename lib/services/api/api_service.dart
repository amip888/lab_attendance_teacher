import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:lab_attendance_mobile_teacher/services/api/environment.dart';
import 'package:lab_attendance_mobile_teacher/services/api/error_state.dart';
import 'package:lab_attendance_mobile_teacher/services/api/logging_interceptor.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';

class ApiService {
  final Dio _dio = Dio();
  static String errorCode = '';
  static String error = '';

  bool isTokenExpired(String token) {
    try {
      DateTime expiryDate = Jwt.getExpiryDate(token)!;
      return expiryDate.isBefore(DateTime.now());
    } catch (e) {
      return true;
    }
  }

  Future<Response> getNew(url, {queryParam, page, withToken = true}) async {
    log('--- GET NEW');
    log('--- URL : $url');
    _dio.interceptors.add(LoggingInterceptor());
    String accessToken = await LocalStorageServices.getAccessToken();

    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      _dio.options.headers['Accept'] = 'application/json';
    }
    _dio.options.headers['ApiKey'] = Environment.apiKey;
    log('QUERY $queryParam');
    log('Url: $url');

    try {
      Response response = await _dio.get(url, queryParameters: queryParam);
      log('RESPONSE $response');
      return response;
    } on DioException catch (error) {
      log('===ERROR ${error.toString()}');
      log('ERROR ${error.stackTrace.toString()}');
      return error.response!.data;
    }
  }

  Future<Response> get(url, {queryParam, page, withToken = true}) async {
    log('--- GET');
    log('--- URL : $url');
    _dio.interceptors.add(LoggingInterceptor());
    String accessToken = await LocalStorageServices.getAccessToken();
    log('--- GET : $accessToken');
    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['ApiKey'] = Environment.apiKey;

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
      return error.response!.data;
    }
  }

  Future<Response> getMap(url, {query}) async {
    try {
      query['key'] = 'AIzaSyCbo7jjDTdFANGzFcWCc9MwXsmID-OXgiQ';
      log(query);
      Response response = await _dio.get(url, queryParameters: query);
      log(response.toString());
      return response;
    } on DioException catch (error) {
      log('ERROR ${error.stackTrace.toString()}');
      return error.response!.data;
    }
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
      // log('BEARER $accessToken');
    }
    _dio.options.headers['Content-Type'] = 'application/json';
    var formBody = FormData.fromMap(body);

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
  }

  Future<Response> put(url, body,
      {bool withToken = true,
      bool formData = false,
      bool formUrlencoded = false}) async {
    log('--- PUT');
    log('--- ${body.toString()}');
    log('--- URL : $url');
    String accessToken = await LocalStorageServices.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());

    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      // log('BEARER $accessToken');
    }
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['ApiKey'] = Environment.apiKey;
    var formBody = FormData.fromMap(body);

    try {
      Response response = await _dio.put(url,
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
      // log('BEARER $accessToken');
    }
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['ApiKey'] = Environment.apiKey;
    var formBody = FormData.fromMap(body);

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
    _dio.options.headers['ApiKey'] = Environment.apiKey;
    Response response = await _dio.delete(url);
    return response;
  }

  Future<Response> postNew(url,
      {bool withToken = true, body, queryParam}) async {
    log('--- POST NEW');
    log('--- URL : $url');
    String accessToken = await LocalStorageServices.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());

    if (withToken) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['ApiKey'] = Environment.apiKey;

    dynamic formBody;
    if (body != null) {
      log('DIO POST BODY $body');
      formBody = FormData.fromMap(body);
    }

    log('QUERY $queryParam');

    try {
      Response response =
          await _dio.post(url, data: formBody, queryParameters: queryParam);
      log('DIO RESPONSE ${response.data}');
      return response;
    } on DioException catch (error) {
      log('DIO ERROR ${handleErrorDio(error)}');
      log('DIO ERROR ${error.response!.data}');
      return error.response!;
    }
  }
}
