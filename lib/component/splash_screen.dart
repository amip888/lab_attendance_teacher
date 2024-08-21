import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/dashboard/screen/dashboard_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  late SessionProvider _sessionProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // _sessionProvider.saveSession('dvdvdda2');
    // _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    startSplashScreen();
    super.initState();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _sessionProvider.loadSession();
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

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
    bool isLogin = await LocalStorageServices.getIsLogin();
    String accessToken = await LocalStorageServices.getAccessToken();
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      // logout();
      log('isLogin: $isLogin');
      log('Access Token $accessToken');
      if (isLogin == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, DashboardScreen.path, (state) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.path, (state) => false);
      }
    });
  }

  // logout() {
  //   LocalStorageServices.removeValues();
  //   Navigator.pushNamedAndRemoveUntil(
  //       context, LoginScreen.path, (state) => false);
  // }
}
