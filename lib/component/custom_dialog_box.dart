import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

enum ButtonMode { vertical, horizontal }

class DialogBox extends StatefulWidget {
  final String? title, descriptions, onOkText, onCancleText, image;
  final bool enableCancel;
  final bool isOkPrimary;
  final bool isImage;
  final bool isSvg;
  final bool isPrefixPhone;
  final String? svgImage;
  final Function()? onOkTap, onCancleTap;
  final Function(String value)? onChanged;
  final Widget? descriptionsWidget;
  final String? prefixSymbol;
  final String? label;
  final String? initialValue;
  final String? hint;
  final int? maxLines;
  final int? limit;
  final bool? isNumber;
  final bool disableSymbol;
  final bool? decimalNumber;
  final TextEditingController? inputController;
  final bool isLoading;
  final bool isEditText;
  final bool isDescription;
  final bool isDelete;
  final bool isTopImage;
  final String? topImage;
  final String? suffixSymbol;
  final Color? color;
  final String? Function(String?)? validator;
  const DialogBox(
      {super.key,
      this.title,
      this.descriptions,
      this.onOkText,
      this.onOkTap,
      this.onCancleText,
      this.onCancleTap,
      this.enableCancel = false,
      this.isOkPrimary = false,
      this.image,
      this.isImage = false,
      this.descriptionsWidget,
      this.prefixSymbol,
      this.hint,
      this.maxLines,
      this.limit,
      this.isNumber = false,
      this.disableSymbol = false,
      this.label,
      this.isLoading = false,
      this.initialValue,
      this.inputController,
      this.color,
      this.isEditText = false,
      this.onChanged,
      this.isDescription = false,
      this.isSvg = false,
      this.svgImage,
      this.isTopImage = false,
      this.topImage,
      this.isDelete = false,
      this.isPrefixPhone = false,
      this.decimalNumber = false,
      this.suffixSymbol,
      this.validator});

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool enableOkButton = false;
  String countyCode = '62';

  @override
  void initState() {
    if (widget.isEditText == true) {
      if (widget.initialValue != null) {
        widget.inputController!.text = widget.initialValue!;
      }
    } else {
      enableOkButton = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () =>
          setState(() => enableOkButton = _formKey.currentState!.validate()),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // shape: BoxShape.,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.isTopImage == true)
              ClipRRect(
                  borderRadius: BorderRadius.circular(
                    112,
                  ),
                  child: NetworkImagePlaceHolder(
                    imageUrl: widget.topImage,
                    width: 100,
                    height: 100,
                  )),
            if (widget.isTopImage == true) divide16,
            Text(
              widget.title!,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primary),
              textAlign: TextAlign.center,
            ),
            divide8,
            widget.descriptions != null
                ? Text(
                    widget.descriptions!,
                    style:
                        const TextStyle(fontSize: 14, color: Pallete.greyDark),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
            widget.descriptionsWidget != null
                ? widget.descriptionsWidget!
                : const SizedBox(),
            divide10,
            widget.isSvg
                ? SvgImage(
                    widget.svgImage,
                    width: 120,
                    height: 120,
                  )
                : const SizedBox(),
            widget.isImage ? Image.asset('${widget.image}') : const SizedBox(),
            widget.isEditText
                ? CustomTextField(
                    label: widget.label ?? '',
                    controller: widget.inputController!,
                    isNumber: widget.isNumber!,
                    limit: widget.limit ?? 1000,
                    validator: widget.validator ?? requiredValidator,
                    hintText: widget.hint,
                  )
                : const SizedBox(),
            divide20,
            Column(
              children: [
                Button(
                  isLoading: widget.isLoading,
                  text: widget.onOkText != null ? '${widget.onOkText}' : 'Ok',
                  press: enableOkButton
                      ? widget.onOkTap ??
                          () {
                            Navigator.pop(context);
                          }
                      : null,
                  width: double.infinity,
                  borderColor: Colors.transparent,
                  color: enableOkButton == false
                      ? Colors.transparent
                      : widget.enableCancel
                          ? widget.color ?? Pallete.primary
                          : widget.isOkPrimary
                              ? Pallete.primary
                              : Colors.white,
                  textColor: widget.isDelete ? Colors.white : Colors.black,
                ),
                if (widget.enableCancel) divide10,
                if (widget.enableCancel)
                  Button(
                      width: double.infinity,
                      text: widget.onCancleText != null
                          ? '${widget.onCancleText}'
                          : 'Batal',
                      press: widget.onCancleTap ??
                          () {
                            Navigator.pop(context);
                          },
                      color: Colors.white,
                      borderColor: Colors.grey,
                      textColor: Colors.black),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DownloadDialogBox extends StatefulWidget {
  const DownloadDialogBox({super.key});

  @override
  _DownloadDialogBoxState createState() => _DownloadDialogBoxState();
}

class _DownloadDialogBoxState extends State<DownloadDialogBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // shape: BoxShape.,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loading(),
                divideW16,
                const Text('Mengunduh laporan...')
              ],
            )
          ],
        ));
  }
}
