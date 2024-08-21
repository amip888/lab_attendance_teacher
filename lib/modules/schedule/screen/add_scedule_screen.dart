import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/bloc/schedule_bloc.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class AddScheduleArgument {
  final String? title;
  final String dayKey;
  AddScheduleArgument({this.title, required this.dayKey});
}

class AddScheduleScreen extends StatefulWidget {
  final AddScheduleArgument? argument;
  const AddScheduleScreen({super.key, this.argument});

  static const String path = '/addSchedules';
  static const String title = 'Tambah Jadwal Praktikum';

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  String? title;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController subjectController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController formatDateController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController roomLabController = TextEditingController();
  TextEditingController beginController = TextEditingController();
  TextEditingController endController = TextEditingController();
  DateTime initialDateTime = DateTime.now();
  DateTime? currentHour;
  DateTime? _endHour;
  int? initialMinute;
  String nameLab = '';
  bool isGenerateQr = false;
  bool isCloseTime = false;
  bool enableButton = false;
  String selectedMajor = 'TKR';
  List<String> majors = ['TKR', 'TKJ', 'RPL', 'Akuntansi'];
  ScheduleBloc scheduleBloc = ScheduleBloc();
  bool isLoading = false;

  @override
  void initState() {
    if (widget.argument?.title != null) {
      title = widget.argument?.title;
    } else {
      title = AddScheduleScreen.title;
    }
    initialMinute = initialDateTime.minute;

    if (initialDateTime.minute % 30 != 0) {
      initialMinute = initialDateTime.minute - initialDateTime.minute % 30 + 30;
    }
    currentHour = DateTime(initialDateTime.year, initialDateTime.month,
        initialDateTime.day, initialDateTime.hour, initialMinute!);
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
            child: BlocProvider(
              create: (context) => scheduleBloc,
              child: BlocConsumer<ScheduleBloc, ScheduleState>(
                builder: (BuildContext context, ScheduleState state) {
                  return buildView(context);
                },
                listener: (BuildContext context, ScheduleState state) {
                  log(state.toString());
                  if (state is AddScheduleLoadingState) {
                    isLoading = true;
                  } else if (state is AddScheduleLoadedState) {
                    isLoading = false;
                    Navigator.pop(context, true);
                  } else if (state is AddScheduleFailedState) {
                    isLoading = false;
                    showToastError('Tambah Jadwal Gagal ${state.message}');
                  } else if (state is AddScheduleErrorState) {
                    isLoading = false;
                    showToastError('Error ${state.message}');
                  }
                },
              ),
            )));
  }

  Widget buildView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(padding: const EdgeInsets.all(16), children: [
            // CustomTextField(
            //   label: 'Hari',
            //   validator: requiredValidator,
            //   controller: dateController,
            //   hintText: 'Hari',
            //   readOnly: true,
            //   suffixIcon: const Icon(Iconly.calendar),
            //   onTap: () => changeDate(context,
            //       controller: dateController,
            //       formatDateController: formatDateController),
            // ),
            CustomTextField(
              label: 'Mata Pelajaran',
              validator: requiredValidator,
              controller: subjectController,
              hintText: 'Masukan Mata Pelajaran',
              textInputAction: TextInputAction.next,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 1,
                  child: CustomTextField(
                    label: 'Jam Mulai',
                    readOnly: true,
                    controller: beginController,
                    suffixIcon: const Icon(Iconly.timeCircle),
                    validator: requiredValidator,
                    onTap: () {
                      openTimePickerDialog('Jam Mulai', beginController);
                    },
                    hintText: '00:00:00',
                  ),
                ),
                divideW8,
                Flexible(
                  flex: 1,
                  child: CustomTextField(
                    label: 'Jam Selesai',
                    readOnly: true,
                    controller: endController,
                    suffixIcon: const Icon(Iconly.timeCircle),
                    validator: requiredValidator,
                    onTap: () {
                      if (isCloseTime == true) {
                        closeTimePickerDialog('Jam Selesai', endController);
                      }
                    },
                    hintText: '00:00:00',
                  ),
                ),
              ],
            ),
            const Text(
              'Jurusan',
              style: TextStyle(fontSize: 12),
            ),
            divide6,
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Pallete.borderTexField),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              value: selectedMajor,
              items: majors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMajor = value!;
                });
              },
              hint: const Text('Pilih jurusan'),
              validator: (value) {
                if (value == null || selectedMajor.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            divide16,
            if (selectedMajor.isNotEmpty)
              CustomTextField(
                label: 'Kelas',
                controller: classController,
                hintText: 'Cth: X TKR 1',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  } else if (!classController.text.contains(selectedMajor)) {
                    return 'Kelas tidak sesuai';
                  }
                  return null;
                },
              ),
            CustomTextField(
              label: 'Ruangan Lab',
              validator: requiredValidator,
              controller: roomController,
              hintText: 'Masukan Ruangan Lab',
              textInputAction: TextInputAction.next,
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Button(
            text: 'Simpan',
            press: enableButton
                ? () {
                    createSchedule();
                  }
                : null,
            buttonColor: Pallete.border,
            width: double.infinity,
          ),
        ),
      ],
    );
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

  createSchedule() {
    Map<String, dynamic> body = {
      "${widget.argument!.dayKey}]": [
        {
          "id_teacher": "68e16d02-af9d-4a45-82fb-d21f6c722510",
          "subject": subjectController.text,
          "major": selectedMajor,
          "Class": classController.text,
          "time": '${beginController.text}-${endController.text}',
          "lab_room": roomLabController.text,
          "status": false
        }
      ]
    };

    log(body.toString());
    scheduleBloc.add(AddScheduleEvent(body));
  }

  // Map<String, dynamic> body = {};
  // body["Monday"] = [
  //   {
  //     body["id_teacher"] = "68e16d02-af9d-4a45-82fb-d21f6c722510",
  //     body["subject"] = "Bahasa Pemrograman C++",
  //     body["major"] = "RPL",
  //     body["Class"] = "XII RPL 02",
  //     body["time"] = "09:00-10:00",
  //     body["lab_room"] = "RPL 01",
  //     body["status"] = false
  //   }
  // ];
  // body['id_teacher'] = '0c967f14-e919-4749-b713-d0665426025f';
  // body['day'] = formatDateController.text;
  // body['subject'] = subjectController.text;
  // body['major'] = selectedMajor;
  // body['Class'] = classController.text;
  // body['lab_room'] = roomController.text;
  // body['status'] = false;

  // log(body.toString());
  // scheduleBloc.add(AddScheduleEvent(body));
}
