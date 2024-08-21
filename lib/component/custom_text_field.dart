import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';

class CustomTextField extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final Color? textColor;
  final bool isNumber;
  final bool isPassword;
  final bool readOnly;
  bool showPassword;
  bool prefixPhone;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Function()? onTap;
  final int? limit;

  CustomTextField({
    super.key,
    this.validator,
    required this.controller,
    required this.label,
    this.hintText,
    this.textColor,
    this.isNumber = false,
    this.showPassword = false,
    this.isPassword = false,
    this.textInputAction,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.prefixPhone = false,
    this.limit,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: widget.textColor, fontSize: 12),
        ),
        divide6,
        TextFormField(
          readOnly: widget.readOnly,
          style: TextStyle(color: widget.textColor),
          obscureText: widget.showPassword,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
              counterText: '',
              border: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Pallete.borderTexField, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Pallete.borderTexField, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: widget.prefixPhone
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          divideW10,
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(
                              //     context, CountryScreen.path);
                            },
                            child: Row(
                              children: [
                                const SvgImage(
                                  'ic_locale_id.svg',
                                ),
                                divideW4,
                                const Text('+62')
                              ],
                            ),
                          ),
                          divideW6,
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey.shade300,
                          )
                        ],
                      ),
                    )
                  : widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.showPassword = !widget.showPassword;
                          });
                        },
                        child: SvgImage(
                            widget.showPassword
                                ? 'ic_eye_password.svg'
                                : 'ic_eye_slash_password.svg',
                            color: Colors.white),
                      ),
                    )
                  : widget.suffixIcon),
          validator: widget.validator,
          controller: widget.controller,
          keyboardType:
              widget.isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: [
            if (widget.isNumber)
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onTap: widget.onTap,
          maxLength: widget.limit,
        ),
        divide10
      ],
    );
  }
}
