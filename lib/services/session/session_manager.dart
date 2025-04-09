import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_dialog_box.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';

class SessionManager extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  bool _isAuthenticated = false;

  // Getter untuk token
  String? get token => _token;

  // Mengecek apakah user masih login
  bool get isAuthenticated => _isAuthenticated;

  // Mengecek apakah session aktif berdasarkan expiry date
  bool get isSessionActive {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  // Login user dan simpan token serta expiry time
  // void login(String token, int expiryDuration) {
  void login(String token) {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    DateTime? expiryDate = Jwt.getExpiryDate(token);
    log('payload jwt: $payload, expire: $expiryDate, now: ${DateTime.now()}');
    _token = token;
    // _expiryDate = DateTime.now().add(Duration(seconds: expiryDuration));
    _isAuthenticated = true;
    notifyListeners();
  }

  // Logout user dan hapus data sesi
  void logout() {
    _token = null;
    _expiryDate = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Method untuk cek apakah token masih valid, jika tidak logout
  checkTokenExpiry(BuildContext context, String token,
      {bool isSplash = false}) {
    DateTime now = DateTime.now().toUtc();
    DateTime? expire = Jwt.getExpiryDate(token);
    log('now: $now, exp: $expire');
    bool isTokenExpired = now.isAfter(expire!);
    // bool isTokenExpired = Jwt.isExpired(token);
    log('token expired: $isTokenExpired');
    if (isTokenExpired && isSplash) {
      logout();
      Navigator.pushNamed(context, LoginScreen.path);
    } else if (isTokenExpired) {
      logout();
      handleSessionTimeout(context);
    }
    return isTokenExpired;
    // if (!isSessionActive) {
    //   logout();
    //   handleSessionTimeout(context);
    //   // Navigator.pushReplacementNamed(
    //   //     context, LoginScreen.path); // Redirect ke halaman login
    // }
  }

  handleSessionTimeout(BuildContext context) {
    return showDialog(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: DialogBox(
            title: 'Sesi Berakhir',
            descriptions: 'Sesi anda telah berakhir, \nSilahkan Login kembali',
            color: Pallete.border,
            onOkTap: () {
              LocalStorageServices.removeValues();
              LocalStorageServices.setIsLogin(false);
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.path, (route) => false);
            },
          ),
        );
      },
    );
  }
}
