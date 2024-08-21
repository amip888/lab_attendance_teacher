import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/rsa_algorithm.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddLabRoomArgument {
  final String? title;
  final LabRoomModel? labRoomModel;
  AddLabRoomArgument({this.title, this.labRoomModel});
}

class AddLabRoomScreen extends StatefulWidget {
  final AddLabRoomArgument? argument;
  const AddLabRoomScreen({super.key, this.argument});

  static const String path = '/addLabRoom';
  static const String title = 'Tambah Ruangan Lab';

  @override
  State<AddLabRoomScreen> createState() => _AddLabRoomScreenState();
}

class _AddLabRoomScreenState extends State<AddLabRoomScreen> {
  String? title;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameLabController = TextEditingController();
  TextEditingController openController = TextEditingController();
  TextEditingController closeController = TextEditingController();
  DateTime initialDateTime = DateTime.now();
  DateTime? currentHour;
  DateTime? _endHour;
  int? initialMinute;
  String nameLab = '';
  bool isGenerateQr = false;
  bool isCloseTime = false;
  bool enableButton = false;
  @override
  void initState() {
    initialMinute = initialDateTime.minute;

    if (initialDateTime.minute % 30 != 0) {
      initialMinute = initialDateTime.minute - initialDateTime.minute % 30 + 30;
    }
    currentHour = DateTime(initialDateTime.year, initialDateTime.month,
        initialDateTime.day, initialDateTime.hour, initialMinute!);

    if (widget.argument!.labRoomModel != null) {
      title = widget.argument?.title;
      enableButton = true;
      for (var item in widget.argument!.labRoomModel!.labRoom!) {
        initialData(item);
      }
    } else {
      title = AddLabRoomScreen.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Pallete.primary2,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            setState(() {
              enableButton = formKey.currentState!.validate();
            });
          },
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: [
                    CustomTextField(
                      label: 'Nama Ruang Lab',
                      validator: requiredValidator,
                      controller: nameLabController,
                      hintText: 'Nama Ruang Lab',
                      textInputAction: TextInputAction.next,
                    ),
                    // CustomTextField(
                    //   label: 'Jam Operational Lab',
                    //   validator: requiredValidator,
                    //   controller: timeOperationalLabController,
                    //   hintText: 'Jam Operational Lab',
                    //   readOnly: true,
                    //   suffixIcon: const Icon(Iconly.calendar),
                    //   onTap: () => changeDate(context,
                    //       controller: timeOperationalLabController),
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 1,
                          child: CustomTextField(
                            label: 'Jam Buka',
                            readOnly: true,
                            controller: openController,
                            suffixIcon: const Icon(Iconly.timeCircle),
                            validator: requiredValidator,
                            onTap: () {
                              openTimePickerDialog('Jam Buka', openController);
                            },
                            hintText: '00:00:00',
                          ),
                        ),
                        divideW8,
                        Flexible(
                          flex: 1,
                          child: CustomTextField(
                            label: 'Jam Tutup',
                            readOnly: true,
                            controller: closeController,
                            suffixIcon: const Icon(Iconly.timeCircle),
                            validator: requiredValidator,
                            onTap: () {
                              if (isCloseTime == true) {
                                closeTimePickerDialog(
                                    'Jam Tutup', closeController);
                              }
                            },
                            hintText: '00:00:00',
                          ),
                        ),
                      ],
                    ),
                    divide16,
                    isGenerateQr
                        ? Center(
                            child: QrImageView(
                              data: nameLab,
                              errorCorrectionLevel: 3,
                              version: QrVersions.auto,
                              embeddedImageStyle: const QrEmbeddedImageStyle(
                                  size: Size(80, 80)),
                              embeddedImage: const AssetImage(
                                  'assets/images/pngs/logo.png'),
                              size: 250,
                              gapless: false,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : const SizedBox(),
                  ])),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Button(
                    color: Colors.amber,
                    width: double.infinity,
                    text: isGenerateQr ? 'Simpan' : 'Generate Qr Code',
                    press:
                        // enableButton
                        //     ?
                        () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RSADemo();
                        // return RSAAlgorithm();
                      }));
                      // isGenerateQr == false
                      //     ? setState(() {
                      //         Navigator.push(context,
                      //             MaterialPageRoute(builder: (context) {
                      //           return RSAAlgorithm();
                      //         }));
                      //         isGenerateQr = true;
                      //         nameLab = nameLabController.text;
                      //       })
                      //     : createLabRoom();
                    }
                    // : null,
                    ),
              )
            ],
          ),
        ));
  }

  void openTimePickerDialog(title, TextEditingController? controller) {
    var minumumClose = DateTime(initialDateTime.year, initialDateTime.month,
        initialDateTime.day, initialDateTime.hour, initialMinute!);
    String time;
    // if (isEditOperarional == true) {
    //   time = DateFormat('HH:mm:ss').format(_initialOpenTime!);
    // } else if (_endHour != null) {
    //   time = DateFormat('HH:mm:ss').format(_endHour!);
    // } else {
    time = DateFormat('HH:mm:ss').format(DateTime(
        initialDateTime.year,
        initialDateTime.month,
        initialDateTime.day,
        initialDateTime.hour,
        initialMinute!));
    // }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.30,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  divide16,
                  Expanded(
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        maximumDate: _endHour,
                        minuteInterval: 30,
                        onDateTimeChanged: (value) {
                          setState(() {
                            time = DateFormat('HH:mm:ss').format(value);
                            minumumClose = value;
                          });
                          log(DateFormat('HH:mm:ss').format(value));
                        },
                        initialDateTime:
                            // isEditOperarional
                            //     ? _initialOpenTime
                            //     :
                            DateTime(
                                initialDateTime.year,
                                initialDateTime.month,
                                initialDateTime.day,
                                initialDateTime.hour,
                                initialMinute!)),
                  ),
                  divide16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Button(
                            text: 'Batal',
                            borderColor: Pallete.accent,
                            width: double.infinity,
                            color: Colors.white,
                            textColor: Pallete.accent,
                            press: () {
                              Navigator.pop(context);
                            }),
                      ),
                      divideW16,
                      Flexible(
                        flex: 1,
                        child: Button(
                            text: 'Atur',
                            width: double.infinity,
                            color: Pallete.border,
                            press: () {
                              setState(() {
                                controller!.text = time;
                                currentHour =
                                    minumumClose.add(const Duration(hours: 1));
                                log('time: $time');
                                log('currentHour: $currentHour');
                                isCloseTime = true;
                              });
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void closeTimePickerDialog(title, TextEditingController? controller) {
    String time;
    // if (isEditOperarional == true) {
    //   time = DateFormat('HH:mm:ss').format(_initialCloseTime!);
    // } else {
    //   time = DateFormat('HH:mm:ss').format(_currentHour!);
    // }
    time = DateFormat('HH:mm:ss').format(currentHour!);
    var maxOpen = currentHour!.subtract(const Duration(hours: 1));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.30,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  divide16,
                  Expanded(
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        minimumDate: currentHour,
                        use24hFormat: true,
                        minuteInterval: 30,
                        onDateTimeChanged: (value) {
                          setState(() {
                            time = DateFormat('HH:mm:ss').format(value);
                            maxOpen = value.subtract(const Duration(hours: 1));
                          });
                        },
                        initialDateTime:
                            // isEditOperarional
                            // ? _initialCloseTime
                            // :
                            currentHour),
                  ),
                  divide16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Button(
                            text: 'Batal',
                            borderColor: Pallete.accent,
                            width: double.infinity,
                            color: Colors.white,
                            textColor: Pallete.accent,
                            press: () {
                              Navigator.pop(context);
                            }),
                      ),
                      divideW16,
                      Flexible(
                        flex: 1,
                        child: Button(
                            text: 'Atur',
                            width: double.infinity,
                            color: Pallete.border,
                            press: () {
                              setState(() {
                                controller!.text = time;
                                _endHour = maxOpen;
                                log('time: $time');
                                log('endHour: $_endHour');
                              });
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  initialData(LabRoom data) {
    nameLabController.text = data.labName!;
    openController.text = data.openTime!;
    closeController.text = data.closeTime!;
  }

  createLabRoom() {
    Map<String, dynamic> body = {};
    body['name'] = nameLabController.text;
    body['time'] = '${openController.text}-${closeController.text}';
  }
}
