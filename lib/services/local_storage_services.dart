import 'dart:async';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  static const String kThemeMoode = 'initial dark mode';
  static const String kAccessToken = 'access_token';
  static const String kUserId = 'user_id';
  static const String kStudentId = 'student_id';
  static const String kTeacherId = 'teacher_id';
  static const String kIsLogin = 'isLogin';
  static const String ksessionToken = 'session_token';
  Timer? _sessionTimer;
  Function? _onSessionTimeoutCallback;

  static Future<bool?> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kThemeMoode);
  }

  static Future<void> setThemeMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(kThemeMoode, value);
  }

  static Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kUserId) ?? '';
  }

  static Future<bool> setUserId(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(kUserId, value ?? '');
  }

  static Future<String> getTeacherId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kTeacherId) ?? '';
  }

  static Future<bool> setTeacherId(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(kTeacherId, value ?? '');
  }

  static Future<String> getStudentId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kStudentId) ?? '';
  }

  static Future<bool> setStudentId(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(kStudentId, value ?? '');
  }

  static Future<String> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kAccessToken) ?? '';
  }

  static Future<bool> setAccessToken(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(kAccessToken, value ?? '');
  }

  Future<void> saveSessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ksessionToken, token);
    _startSessionTimer();
  }

  Future<String?> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ksessionToken);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ksessionToken);
    log('time out session');
    _sessionTimer?.cancel();
  }

  static Future<bool> getIsLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kIsLogin) ?? false;
  }

  static Future<bool> setIsLogin(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(kIsLogin, value);
  }

  static removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(kAccessToken);
    prefs.remove(kIsLogin);
    prefs.remove(kUserId);
    prefs.remove(ksessionToken);
  }

  //Mulai timer sesi
  void _startSessionTimer() {
    log('session start');
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(seconds: 20), _onSessionTimeOut);
  }

  //handel waktu habis sesi
  void _onSessionTimeOut() async {
    await clearSession();
    if (_onSessionTimeoutCallback != null) {
      _onSessionTimeoutCallback!();
    }
  }

  //Reset timer sesi saat ada aktivitas
  void resetSessionTimer() {
    if (_sessionTimer != null && _sessionTimer!.isActive) {
      _startSessionTimer();
    }
  }

  //set callback unutk waktu habis sesi
  void setOnSessionTImeoutCallback(Function callback) {
    _onSessionTimeoutCallback = callback;
  }
}
