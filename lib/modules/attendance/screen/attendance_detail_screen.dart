import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/bloc/attendance_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_teacher_model/attendance_teacher.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/history_attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class AttendanceDetailArgument {
  final AttendanceTeacher? attendanceTeacher;
  final ComponentAttendance? componentAttendance;
  final String? roleUser;
  AttendanceDetailArgument(
      {this.roleUser, this.attendanceTeacher, this.componentAttendance});
}

class AttendanceDetailScreen extends StatefulWidget {
  final AttendanceDetailArgument? argument;
  const AttendanceDetailScreen({super.key, this.argument});

  static const String path = '/attendanceDetail';
  static const String title = 'Detail Absensi';

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  AttendanceTeacher? attendanceTeacher;
  ComponentAttendance? componentAttendance;
  AttendanceBloc attendanceBloc = AttendanceBloc();
  bool isLoading = false;
  bool isDataTeacher = false;
  bool isLoadGetAttendance = false;
  String selectedAttendance = 'Tanpa Keterangan';
  List<String> statusAttendance = ['Tanpa Keterangan', 'Sakit', 'Izin'];

  @override
  void initState() {
    if (widget.argument!.attendanceTeacher != null) {
      attendanceTeacher = widget.argument!.attendanceTeacher;
      componentAttendance = ComponentAttendance(
          Class: attendanceTeacher!.schedule!.scheduleClass,
          beginTime: attendanceTeacher!.schedule!.beginTime,
          date: attendanceTeacher!.schedule!.date,
          endTime: attendanceTeacher!.schedule!.endTime,
          filePath: attendanceTeacher!.teacher!.filePath,
          userId: attendanceTeacher!.id,
          labName: attendanceTeacher!.labRoom!.labName,
          name: attendanceTeacher!.teacher!.name,
          statusAttendance: attendanceTeacher!.statusAttendance,
          subject: attendanceTeacher!.schedule!.subject);
      isDataTeacher = true;
    } else {
      componentAttendance = widget.argument!.componentAttendance;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? attendance;
    Color? colorAttendance;
    switch (componentAttendance!.statusAttendance) {
      case 'present':
        attendance = 'Hadir';
        colorAttendance = Colors.green;
        break;
      case 'absent':
        attendance = 'Tidak Hadir';
        colorAttendance = Colors.red;
        break;
      case 'sick':
        attendance = 'Sakit';
        colorAttendance = Colors.blue;
        break;
      case 'permission':
        attendance = 'Izin';
        colorAttendance = Colors.amber;
        break;
      default:
    }
    String day = formatDayDate(componentAttendance!.date!);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AttendanceDetailScreen.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Pallete.primary2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return false;
        },
        child: BlocProvider(
          create: (context) => attendanceBloc,
          child: BlocConsumer<AttendanceBloc, AttendanceState>(
            builder: (BuildContext context, state) {
              log(state.toString());
              if (isLoadGetAttendance == false) {
                return buildView(day, attendance, colorAttendance);
              } else {
                if (state is GetOneAttendanceStudentLoadingState) {
                  return loading();
                } else if (state is GetOneAttendanceStudentLoadedState) {
                  return buildView(day, attendance, colorAttendance);
                } else if (state is GetOneAttendanceStudentEmptyState) {
                } else if (state is GetOneAttendanceStudentErrorState) {
                  return IllustrationWidget(
                    type: IllustrationWidgetType.error,
                    onButtonTap: () {
                      attendanceBloc.add(GetOneAttendanceStudentEvent());
                    },
                  );
                }
              }
              return Container();
            },
            listener: (BuildContext context, Object? state) {
              log(state.toString());
              if (state is UpdateAttendanceStudentLoadingState) {
                isLoading = true;
              } else if (state is UpdateAttendanceStudentLoadedState) {
                isLoading = false;
                isLoadGetAttendance = true;
                attendanceBloc.add(GetOneAttendanceStudentEvent());
              } else if (state is UpdateAttendanceStudentFailedState) {
                isLoading = false;
              } else if (state is UpdateAttendanceStudentErrorState) {
                isLoading = false;
              } else if (state is GetOneAttendanceStudentLoadedState) {
                isLoading = false;
                for (var item
                    in state.dataAttendanceStudent!.attendanceStudents!) {
                  setState(() {
                    componentAttendance = ComponentAttendance(
                        Class: item.student!.studentClass,
                        beginTime: item.schedule!.beginTime,
                        date: item.schedule!.date,
                        endTime: item.schedule!.endTime,
                        filePath: item.student!.filePath,
                        userId: item.id,
                        labName: item.labRoom!.labName,
                        name: item.student!.name,
                        statusAttendance: item.statusAttendance,
                        subject: item.schedule!.subject);
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildView(String day, String? attendance, Color? colorAttendance) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: NetworkImagePlaceHolder(
                        imageUrl: componentAttendance!.filePath,
                        width: 150,
                        height: 150,
                      )),
                ),
                divide32,
                const Text('Data Absensi Praktikum'),
                divide8,
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Pallete.border),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nama'),
                              divide8,
                              const Text('Hari/Tanggal'),
                              divide8,
                              const Text('Mata Pelajaran'),
                              divide8,
                              const Text('Jam Praktikum'),
                              divide8,
                              const Text('Kelas'),
                              divide8,
                              const Text('Ruangan Lab'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(componentAttendance!.name!),
                              divide8,
                              Text(day),
                              divide8,
                              Text(componentAttendance!.subject!),
                              divide8,
                              Text(
                                  '${componentAttendance!.beginTime!}-${componentAttendance!.endTime!}'),
                              divide8,
                              Text(componentAttendance!.Class!),
                              divide8,
                              Text(componentAttendance!.labName!),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                divide16,
                const Text('Status Absesni'),
                divide8,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorAttendance,
                    border: Border.all(color: Pallete.border, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        attendance!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SvgImage(
                        'assets/images/svgs/ic_profile_active.svg',
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                divide10,
                if (widget.argument!.roleUser == 'student' &&
                    attendance == 'Tidak Hadir')
                  const Text('Alasan Ketidakhadiran'),
                divide8,
                if (widget.argument!.roleUser == 'student' &&
                    attendance == 'Tidak Hadir')
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Pallete.borderTexField),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    value: selectedAttendance,
                    items: statusAttendance
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAttendance = value!;
                      });
                    },
                    hint: const Text('Alasan Ketidak Hadiran'),
                    validator: (value) {
                      if (value == null || selectedAttendance.isEmpty) {
                        return 'Tidak boleh kosong';
                      }
                      return null;
                    },
                  )
                // else
              ])),
          divide16,
          if (widget.argument!.roleUser == 'student' &&
              attendance == 'Tidak Hadir')
            Padding(
              padding: const EdgeInsets.all(16),
              child: Button(
                text: 'Simpan',
                width: double.infinity,
                color: Pallete.border,
                press: () {
                  updateAttendanceStudent();
                },
              ),
            )
        ],
      ),
    );
  }

  updateAttendanceStudent() {
    Map<String, dynamic> body = {};
    String changeAttendance = '';
    switch (selectedAttendance) {
      case 'Tanpa Keterangan':
        changeAttendance = 'absent';
        break;
      case 'Sakit':
        changeAttendance = 'sick';
        break;
      case 'Izin':
        changeAttendance = 'permission';
        break;
      default:
    }
    body['status_attendance'] = changeAttendance;

    attendanceBloc.add(UpdateAttendanceStudentEvent(
        body: body, attendanceId: componentAttendance!.id));
  }
}
