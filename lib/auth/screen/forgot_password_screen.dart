import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String path = '/forgot-password';
  static const String title = 'Lupa Password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nipController,
          label: 'NIP',
          isNumber: true,
          validator: requiredValidator,
        ),
        CustomTextField(
          controller: emailController,
          label: 'Email',
          validator: requiredEmail,
        ),
        Button(
          press: () {},
          text: 'Reset Password',
        )
      ],
    );
  }
}
