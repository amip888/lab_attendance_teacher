import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/navigator_key.dart';

class SessionProvider with ChangeNotifier {
  String? _sessionToken;
  final LocalStorageServices _sessionManager = LocalStorageServices();

  SessionProvider() {
    _sessionManager.setOnSessionTImeoutCallback(_handelSessionTimeout);
  }

  String? get sessionToken => _sessionToken;

  Future<void> loadSession() async {
    _sessionToken = await _sessionManager.getSessionToken();
    if (_sessionToken != null) {
      _sessionManager.resetSessionTimer();
    }
    notifyListeners();
  }

  Future<void> saveSession(String token) async {
    log('--$token');
    await _sessionManager.saveSessionToken(token);
    _sessionToken = token;
    notifyListeners();
  }

  Future<void> clearSession() async {
    await _sessionManager.clearSession();
    _sessionToken = null;
    notifyListeners();
  }

  void _handelSessionTimeout() {
    log('handle sesion time out');
    _sessionToken = null;
    notifyListeners();
    // navigatorKey.currentState?.pushNamed(LoginScreen.path);
  }

  LocalStorageServices get sessionManager => _sessionManager;
}
