import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab_attendance_mobile_teacher/component/button/fading_cube.dart';
import 'package:lab_attendance_mobile_teacher/component/button/three_bounce.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule.dart';

String? Function(String?) requiredValidator = (String? value) {
  if (value!.isEmpty) {
    return 'Tidak boleh kosong';
  }
};

String? Function(String?) requiredEmail = (String? value) {
  if (value!.isEmpty) {
    return 'Tidak boleh kosong';
  }
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);
  bool emojiRegex = RegExp(r'[\uD800-\uDBFF][\uDC00-\uDFFF]').hasMatch(value);
  if (!emailValid || emojiRegex) {
    return 'Format email tidak sesusai';
  }
  return null;
};

String? Function(String?) validateMobile = (String? value) {
  String patttern = r'^[\s-]?8[1-9]{1}\d{1}[\s-]?\d{4}[\s-]?\d{2,5}$';
  RegExp regExp = RegExp(patttern);
  if (value!.isEmpty) {
    return 'Tidak boleh kosong';
  } else if (!regExp.hasMatch(value)) {
    return 'Nomor HP belum sesuai';
  }
  return null;
};

String? Function(String?) validateLetterOnly = (String? value) {
  String patttern = r"^[a-zA-Z_ ]*$";
  RegExp regExp = RegExp(patttern);
  if (value!.isEmpty) {
    return 'Tidak boleh kosong';
  } else if (!regExp.hasMatch(value)) {
    return 'Hanya boleh menggunakan abjad';
  }
  return null;
};

String? validateAddress(String? value) {
  String patttern = r"^[ A-Za-z0-9_.',-/]*$";
  RegExp regExp = RegExp(patttern);
  if (value!.isEmpty) {
    return 'Tidak boleh kosong';
  } else if (!regExp.hasMatch(value)) {
    return 'Tidak boleh menggunakan simbol tersebut';
  }
  return null;
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      fontSize: 16.0);
}

void showToastError(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      fontSize: 16.0);
}

Widget loading({color, bool foldingCube = false, String? text}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      foldingCube
          ? SpinKitFadingCube(
              color: color ?? Pallete.border,
              size: 20,
              duration: const Duration(seconds: 3),
            )
          : SpinKitThreeBounce(
              color: color ?? Pallete.border,
              size: 20,
            ),
    ],
  );
}

ShapeBorder modalShape() {
  return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)));
}

Future<void> changeDate(BuildContext context,
    {required TextEditingController controller,
    TextEditingController? formatDateController,
    bool isReverse = false}) async {
  String dayFormat = '';
  String day = '';
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950, 1),
    lastDate: DateTime.now(),
  );
  if (pickedDate != null) {
    String dateFormat = DateFormat('yyyy-MM-dd').format(pickedDate);
    formatDateController!.text = dateFormat;
    dayFormat = DateFormat('EEEE').format(pickedDate);
    log(dayFormat);

    switch (dayFormat) {
      case 'Sunday':
        day = 'Minggu';
        break;
      case 'Monday':
        day = 'Senin';
        break;
      case 'Tuesday':
        day = 'Selasa';
        break;
      case 'Wednesday':
        day = 'Rabu';
        break;
      case 'Thursday':
        day = 'Kamis';
        break;
      case 'Friday':
        day = 'Jum`at';
        break;
      case 'Saturday':
        day = 'Sabtu';
        break;
      default:
    }
    String date =
        DateFormat(isReverse ? 'yyyy-MM-dd' : 'dd-MM-yyyy').format(pickedDate);
    controller.text = '$day, $date';
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);

String formatDayDate(String date) {
  DateTime initialDay = DateTime.parse(date);
  String formatDate = DateFormat('dd').format(initialDay);
  String formatYear = DateFormat('yyyy').format(initialDay);
  String dayName = formatDay(initialDay);
  String monthName = formatMonth(initialDay);
  String day = '$dayName, $formatDate $monthName $formatYear';
  return day;
}

formatDay(DateTime initialDate) {
  String day = DateFormat('EEEE').format(initialDate);
  String dayName = '';
  switch (day) {
    case 'Sunday':
      dayName = 'Minggu';
      break;
    case 'Monday':
      dayName = 'Senin';
      break;
    case 'Tuesday':
      dayName = 'Selasa';
      break;
    case 'Wednesday':
      dayName = 'Rabu';
      break;
    case 'Thursday':
      dayName = 'Kamis';
      break;
    case 'Friday':
      dayName = 'Jum`at';
      break;
    case 'Saturday':
      dayName = 'Sabtu';
      break;
    default:
  }
  return dayName;
}

formatMonth(DateTime initialDate) {
  String day = DateFormat('MMMM').format(initialDate);
  String monthName = '';
  switch (day) {
    case 'January':
      monthName = 'Januari';
      break;
    case 'February':
      monthName = 'Februari';
      break;
    case 'March':
      monthName = 'Maret';
      break;
    case 'April':
      monthName = 'April';
      break;
    case 'May':
      monthName = 'Mei';
      break;
    case 'June':
      monthName = 'Juni';
      break;
    case 'July':
      monthName = 'Juli';
      break;
    case 'August':
      monthName = 'Agustus';
      break;
    case 'September':
      monthName = 'September';
      break;
    case 'October':
      monthName = 'Oktober';
      break;
    case 'November':
      monthName = 'November';
      break;
    case 'December':
      monthName = 'Desember';
      break;
    default:
  }
  return monthName;
}

extension DateTimeExtension on DateTime {
  int get weekOfYear {
    int dayOfYear = int.parse(DateFormat("D").format(this));
    return ((dayOfYear - weekday + 10) / 7).floor();
  }
}

List<Schedule> filterSchedulesByDay(
    List<Schedule> schedules, DateTime selectedDate) {
  return schedules
      .where((element) =>
          element.date == DateFormat('yyyy-MM-dd').format(selectedDate))
      .toList();
}

List<Schedule> filterSchedulesByWeek(
    List<Schedule> schedules, DateTime selectedDate) {
  int selectedWeek = selectedDate.weekOfYear;
  return schedules
      .where((element) =>
          DateFormat('yyyy-MM-dd').parse(element.date!.toString()).weekOfYear ==
          selectedWeek)
      .toList();
}

List<Schedule> filterSchedulesByMonth(
    List<Schedule> schedules, DateTime selectedDate) {
  return schedules
      .where((element) =>
          DateFormat('yyyy-MM-dd').parse(element.date!.toString()).year ==
              selectedDate.year &&
          DateFormat('yyyy-MM-dd').parse(element.date!.toString()).month ==
              selectedDate.month)
      .toList();
}

void logPrint(String message, {String color = 'yellow'}) {
  // Map color names to ANSI color codes
  final Map<String, int> colorMap = {
    'yellow': 33, // Yellow color code
    'red': 31, // Red color code
    'green': 32, // Green color code
    // Add more colors as needed
  };

  // Get the ANSI color code based on the provided color name
  final int colorCode = colorMap[color.toLowerCase()] ??
      33; // Default to yellow if color is not found

  // Start and end ANSI color sequences
  final String startColor = '\x1B[${colorCode}m';
  const String endColor = '\x1B[0m';

  // Print the message with the specified color
  print('$startColor$message$endColor');
}
