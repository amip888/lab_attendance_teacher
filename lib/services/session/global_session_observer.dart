import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_manager.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class GlobalSessionObserver with WidgetsBindingObserver {
  final SessionManager sessionManager;
  GlobalSessionObserver(this.sessionManager);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Memantau perubahan lifecycle aplikasi
    if (state == AppLifecycleState.paused) {
      // Ketika aplikasi diminimalkan atau dibawa ke background
      logPrint("App is in the background.");
    } else if (state == AppLifecycleState.resumed) {
      // Ketika aplikasi kembali ke foreground
      logPrint("App is in the foreground.");
    } else if (state == AppLifecycleState.detached) {
      // Ketika aplikasi ditutup sepenuhnya
      logPrint("App is detached (closed).");
      LocalStorageServices.setIsLogin(false);
      LocalStorageServices.removeValues();
    }
    // else if (state == AppLifecycleState.inactive) {
    //   // Ketika aplikasi ditutup sepenuhnya
    //   logPrint("App is inactive.");
    //   LocalStorageServices.removeValues();
    // }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // sessionManager.loadSession();
  //   }
  // }
}
