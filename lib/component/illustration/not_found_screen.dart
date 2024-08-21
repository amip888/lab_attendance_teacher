import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  static const String path = '/notfound';
  static const String title = 'Not Found';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(45),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SvgImage(
              'ic_illustration_notfound.svg',
              width: 300,
              // height: 300,
              fit: BoxFit.contain,
            ),
            divide10,
            const Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            divide10,
            const Text(
              'The page that you enter is not found!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            divide32,
            Button(
              text: 'Back to previous screen',
              press: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            )
          ],
        ),
      ),
    )));
  }
}
