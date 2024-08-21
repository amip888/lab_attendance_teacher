// import 'package:lab_attendance_mobile_teacher/service/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final savedThemeMode = await LocalStorageServices.getThemeMode();
    if (savedThemeMode != null) {
      _themeMode = savedThemeMode ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    LocalStorageServices.setThemeMode(_themeMode == ThemeMode.dark);
    notifyListeners();
  }

  // Future<void> darkModeTheme() async {
  //   bool isDarkMode = await LocalStorageServices.getDarkTheme();

  //   if (isDarkMode == true) {
  //     themeMode = ThemeMode.dark;
  //   } else {
  //     themeMode = ThemeMode.light;
  //   }
  // }

  // bool get isDarkMode {
  //   if (themeMode == ThemeMode.system) {
  //     final brightness = SchedulerBinding.instance.window.platformBrightness;
  //     return brightness == Brightness.dark;
  //   } else {
  //     return themeMode == ThemeMode.dark;
  //   }
  // }

  // void toggleTheme(bool isOn) {
  //   _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
  //   notifyListeners();
  // }
}

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Pallete.primary,
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.dark(),
      iconTheme: const IconThemeData(color: Colors.amber, opacity: 0.8));
  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.amber,
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(color: Colors.red, opacity: 0.8));
}
