import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/register_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/detail_profile_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/edit_profile_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/profile_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/history_attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/dashboard/screen/dashboard_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/home_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/not_found_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/profile_shool_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/lab_room_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/lab_rooms_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/day_list_schedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/screen/list_user_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/screen/user_detail_screen.dart';

class RoutesConfig {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var argument = settings.arguments;

    switch (settings.name) {
      case RegisterScreen.path:
        return goTo(const RegisterScreen());
      case LoginScreen.path:
        return goTo(const LoginScreen());
      case DashboardScreen.path:
        return goTo(const DashboardScreen());
      case HomeScreen.path:
        return goTo(const HomeScreen());
      case AttendanceScreen.path:
        return goTo(AttendanceScreen(argument: argument as AttendanceArgument));
      case HistoryAttendanceScreen.path:
        return goTo(const HistoryAttendanceScreen());
      case AttendanceDetailScreen.path:
        return goTo(AttendanceDetailScreen(
          argument: argument as AttendanceDetailArgument,
        ));
      case ProfileSchoolScreen.path:
        return goTo(const ProfileSchoolScreen());
      case ListUserScreen.path:
        return goTo(const ListUserScreen());
      case UserDetailScreen.path:
        return goTo(UserDetailScreen(
          argument: argument as UserDetailArgument,
        ));
      case NotificationScreen.path:
        return goTo(const NotificationScreen());
      case ProfileScreen.path:
        return goTo(const ProfileScreen());
      case DetailProfileScreen.path:
        return goTo(
            DetailProfileScreen(argument: argument as DetailProfileArgument));
      case EditProfileScreen.path:
        return goTo(
            EditProfileScreen(argument: argument as EditProfileArgument));
      case SchedulesScreen.path:
        return goTo(const SchedulesScreen());
      case DayListScheduleScreen.path:
        return goTo(const DayListScheduleScreen());
      case ScheduleDetailScreen.path:
        return goTo(
            ScheduleDetailScreen(argument: argument as ScheduleDetailArgument));
      case LabRoomsScreen.path:
        return goTo(const LabRoomsScreen());
      case LabRoomDetailScreen.path:
        return goTo(
            LabRoomDetailScreen(argument: argument as LabRoomDetailArgument));
    }

    return goTo(const NotFoundScreen());
  }

  static MaterialPageRoute goTo(screen) {
    return MaterialPageRoute(builder: (context) => screen);
  }
}
