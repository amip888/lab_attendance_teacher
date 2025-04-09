// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/dashboard/screen/dashboard_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_manager.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/images/pngs/logo.png',
        width: 150,
        height: 150,
      )),
    );
  }

  startSplashScreen() async {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    bool sessionTimeOut = false;
    bool isLogin = await LocalStorageServices.getIsLogin();
    String accessToken = await LocalStorageServices.getAccessToken();
    if (accessToken != '') {
      sessionTimeOut =
          sessionManager.checkTokenExpiry(context, accessToken, isSplash: true);
    }
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      log('sessionTimeOut: $sessionTimeOut');
      log('isLogin: $isLogin');
      log('Access Token $accessToken');
      if (sessionTimeOut) {
        isLogin = false;
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.path, (state) => false);
      } else if (isLogin == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, DashboardScreen.path, (state) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.path, (state) => false);
      }
    });
  }
}
