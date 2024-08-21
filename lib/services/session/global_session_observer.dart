import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';

class GlobalSessionObserver with WidgetsBindingObserver {
  final SessionProvider sessionProvider;

  GlobalSessionObserver(this.sessionProvider);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      sessionProvider.loadSession();
    }
  }
}
