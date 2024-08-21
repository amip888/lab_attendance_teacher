import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';

enum IllustrationWidgetType {
  notFound,
  success,
  error,
  empty,
  notLogin,
}

enum IllustrationMode { vertical, horizontal }

class IllustrationWidget extends StatelessWidget {
  String? illustration;
  String? title;
  String? description;
  String? textButton;
  double? width;
  Function()? onButtonTap;
  IllustrationWidgetType? type;
  IllustrationMode? mode;
  bool? showButton;
  IllustrationWidget(
      {super.key,
      this.illustration,
      this.title,
      this.description,
      this.textButton,
      this.type,
      this.width,
      this.onButtonTap,
      this.showButton = false,
      this.mode = IllustrationMode.vertical});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case IllustrationWidgetType.notLogin:
        illustration = 'ic_illustration_notfound.svg';
        description = 'Please login first';
        title = 'Unauthorized';
        showButton = true;
        onButtonTap = () {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.path, (route) => false);
        };
        textButton = 'Masuk';
        break;

      case IllustrationWidgetType.notFound:
        illustration = 'ic_illustration_notfound.svg';
        description = 'The page that you enter is not found!';
        title = 'Page not found!';
        showButton = true;
        onButtonTap = () {
          Navigator.pop(context);
        };
        textButton = 'Back to previous screen';
        break;

      case IllustrationWidgetType.success:
        illustration = 'ic_illustration_success.svg';
        description = 'Your registration is success!';
        title = 'Success';
        showButton = true;
        onButtonTap = () {
          Navigator.pop(context);
        };
        textButton = 'Back to login';
        break;

      case IllustrationWidgetType.error:
        illustration = 'ic_illustration_error.svg';
        description = 'Error to connect to server!';
        title = 'Error';
        showButton = true;
        onButtonTap = onButtonTap;
        textButton = 'Muat Ulang';
        break;

      case IllustrationWidgetType.empty:
        illustration = 'ic_illustration_empty.svg';
        title = title ?? 'Data Kosong!';
        description = description ?? 'Data Kosong';
        showButton = textButton != null ? true : false;
        break;
      default:
    }

    switch (mode) {
      case IllustrationMode.horizontal:
        return Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgImage(
                'illustration/$illustration',
                width: 120,
                // height: 300,
              ),
              divideW10,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$description',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Pallete.greyDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      default:
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgImage(
                '$illustration',
                width: width ?? 250,
                // height: 300,
              ),
              divide10,
              Text(
                '$title',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (description != '') divide10,
              if (description != '')
                Text(
                  '$description',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (showButton!) divide32,
              if (showButton!)
                Button(
                  text: '$textButton',
                  press: onButtonTap,
                  color: Pallete.border,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                )
            ],
          ),
        ));
    }
  }
}
