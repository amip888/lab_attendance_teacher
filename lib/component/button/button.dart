import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/button/fading_cube.dart';
import 'package:lab_attendance_mobile_teacher/component/button/three_bounce.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';

class Button extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final String text;
  final Function()? press;
  final bool isLoading;
  final double? height;
  final double? width;
  final Color? color;
  final Color? textColor;
  final Color? buttonColor;
  final Color? borderColor;
  final double? textSize;
  final double? borderRadius;
  final FontWeight? fontWeight;

  const Button(
      {super.key,
      this.padding,
      required this.text,
      required this.press,
      this.isLoading = false,
      this.height,
      this.width,
      this.textColor,
      this.buttonColor,
      this.color,
      this.textSize,
      this.borderRadius,
      this.fontWeight,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor ?? Pallete.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
            onPressed: !isLoading ? press : null,
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(
                    padding ?? const EdgeInsets.all(16)),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Pallete.border1;
                  } else if (states.contains(MaterialState.disabled)) {
                    return Pallete.secondary;
                  } else if (states.contains(MaterialState.focused)) {
                    return Colors.transparent;
                  }
                  return color ?? Colors.transparent;
                }),
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                    color: textColor ?? Pallete.dark1, fontSize: textSize)),
                shape:
                    MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                        (states) {
                  return RoundedRectangleBorder(
                      side: !(states.contains(MaterialState.pressed))
                          ? BorderSide(color: borderColor ?? Colors.transparent)
                          : const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(borderRadius ?? 10));
                })),
            child: isLoading
                ? loading(color: Pallete.dark1)
                : Text(text,
                    style: TextStyle(
                      color: textColor ?? Colors.black,
                      fontSize: textSize ?? 14,
                      fontWeight: fontWeight ?? FontWeight.w600,
                    ),
                    textAlign: TextAlign.center)));
  }

  Widget loading({color, bool foldingCube = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        foldingCube
            ? SpinKitFadingCube(
                color: color ?? Pallete.primary,
                size: 10,
              )
            : SpinKitThreeBounce(
                color: color ?? Pallete.primary,
                size: 20,
              )
      ],
    );
  }
}
