import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_dialog_box.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/rsa_algorithm.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/bloc/attendance_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/home_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/get_one_schedule_model/schedule.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

enum AttendanceStatus { onTime, late, absent, notAllowed }

class AttendanceArgument {
  final bool isNotif;
  final String? date, time;

  AttendanceArgument({this.isNotif = false, this.date, this.time});
}

class AttendanceScreen extends StatefulWidget {
  final AttendanceArgument? argument;
  const AttendanceScreen({super.key, this.argument});

  static const String path = '/attendance/qrcode';
  static const title = 'Attendance QR Code';

  @override
  State<StatefulWidget> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Barcode? result;
  Barcode? resultReset;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isShowLoading = false;
  LatLng? userLatLng;
  LatLng? schoolLatLng;
  // final LatLng schoolLatLng = LatLng(-7.0396629, 108.3584456); //Lokasi Rumah
  // final LatLng schoolLatLng = LatLng(-6.937893132288915, 107.73815975163151); //Lokasi Sekolah

  String? branchId;
  AttendanceBloc? attendanceBloc;
  Map<String, dynamic> params = {};
  Schedule? schedule;
  String stateType = 'loading';
  String idSchedule = '';
  double? distance;
  double? maxDistance = 200.0; // DALAM SATUAN METER
  bool isTooFar = false;
  bool cameraIsPause = false;
  String? date, time, labName, dateNow, timeNow;
  RsaAlgorithm rsaAlgorithm = RsaAlgorithm();
  AttendanceStatus? attendanceStatus;

  @override
  void initState() {
    dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    timeNow = DateFormat('HH:mm').format(DateTime.now());
    log('time: $timeNow');
    if (widget.argument!.isNotif == true) {
      date = widget.argument!.date;
      time = widget.argument!.time;
    } else {
      date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      time = DateFormat('HH:mm').format(DateTime.now());
    }
    log('date: $date, jam: $time');
    // params['date'] = '2024-09-09';
    // params['time'] = '10:00';
    params['date'] = date;
    params['time'] = time;
    attendanceBloc = AttendanceBloc();
    attendanceBloc!.add(GetScheduleByDateEvent(params));
    userLatLng = HomeScreen.userLatLng;
    // setDistance();
    rsaAlgorithm.initializeRSA();
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => attendanceBloc!,
      child: BlocConsumer<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
        return statePageView(stateType);
      }, listener: (context, state) {
        log('state: $state');
        if (state is GetScheduleLoadingState) {
          stateType = 'loading';
        } else if (state is GetOneScheduleLoadedState) {
          stateType = 'loaded';
          schedule = state.data!.schedule;
          schoolLatLng =
              LatLng(schedule!.labRoom!.lat!, schedule!.labRoom!.lng!);
          setDistance();
        } else if (state is GetScheduleEmptyState) {
          stateType = 'empty';
        } else if (state is GetScheduleErrorState) {
          stateType = 'error';
        } else if (state is PostAttendanceLoadingState) {
          snackbarMessage(text: 'Memuat...');
        } else if (state is PostAttendanceLoadedState) {
          stateType = 'attendance success';
        } else if (state is PostAttendanceErrorState) {
          snackbarMessage(
            text: 'Error to load',
            colors: Colors.red,
          );
          openCamera();
        } else if (state is PostAttendanceFailedState) {
          snackbarMessage(
            text: 'Failed to load',
            colors: Colors.red[900],
          );
          openCamera();
        } else if (state is NoInternetConnectionState) {
          stateType = 'no internet connection';
        }
      }),
    ));
  }

  setDistance() {
    log('SET DISTANCE LOADED');
    log('lab lat lng: $schoolLatLng');
    setState(() {
      distance =
          ((SphericalUtil.computeDistanceBetween(schoolLatLng!, userLatLng!) /
                      1000.0) *
                  1000)
              .ceilToDouble();
      if (distance! > maxDistance!) {
        isTooFar = true;
      } else {
        isTooFar = false;
      }
    });
    log(isTooFar.toString());
  }

  snackbarMessage({required String text, Color? colors}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: colors,
      duration: const Duration(seconds: 1),
    ));
  }

  statePageView(String? type) {
    if (type == 'loading') {
      return loading();
    } else if (type == 'loaded') {
      return _buildView(context);
    } else if (type == 'empty') {
      return IllustrationWidget(
        type: IllustrationWidgetType.empty,
        description: 'Data Jadwal Kosong',
      );
    } else if (type == 'error') {
      return IllustrationWidget(
        type: IllustrationWidgetType.error,
        textButton: 'Muat Ulang',
        onButtonTap: () {
          attendanceBloc!.add(GetScheduleByDateEvent(params));
        },
      );
    } else if (type == 'attendance success') {
      return IllustrationWidget(type: IllustrationWidgetType.success);
    } else if (type == 'no internet connection') {
      return IllustrationWidget(
        type: IllustrationWidgetType.notConnection,
        onButtonTap: () {
          attendanceBloc!.add(GetScheduleByDateEvent(params));
        },
      );
    }
  }

  _buildView(BuildContext context) {
    return WillPopScope(
        onWillPop: willPopCallback,
        child: Stack(children: [
          _buildQrView(context),
          // scheduleModel!.status == true
          //     ? _buildQrView(context)
          //     : const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(220),
                    color: Pallete.primary.withAlpha(230)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.cameraswitch_rounded,
                          color: Colors.white,
                        )),
                    FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            icon: Icon(
                              snapshot.data == false
                                  ? Icons.flash_off
                                  : Icons.flash_on,
                              color: Colors.white,
                            ));
                        //return Text('Flash: ${snapshot.data}');
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          informationDialog();
                        },
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Arahkan kamera ke Qr-code yang ada di laboratorium",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 1.5,
                width: MediaQuery.of(context).size.width / 1.5,
              ),
              divide20,
              Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  width: 200,
                  child: Button(
                    color: Pallete.border,
                    text: cameraIsPause ? 'Coba Lagi' : 'Batal Scan',
                    press: cameraIsPause
                        ? () {
                            resumeCamera();
                          }
                        : () {
                            Navigator.pop(context);
                          },
                  )),
            ],
          ),
          Visibility(
            visible: isShowLoading,
            child: const SpinKitRing(
              color: Colors.white,
              lineWidth: 5,
              size: 50,
            ),
          )
        ]));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width / 1.5;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Pallete.border,
          borderRadius: 10,
          borderLength: 15,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    if (Platform.isAndroid) {
      await controller.resumeCamera();
    }
    // controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        pauseCamera();
        result = scanData;
        log('SCANNED ${result!.code}');
      });
      decryptLabRoom(result!.code!);
      // FlutterBeep.beep();
      attendanceStatus = getTimeAttendance(DateTime.now());
      // attendanceStatus = getTimeAttendance(DateTime.parse(timeNow!));
      log('status: $attendanceStatus');
      // logic attendance
      if (!isTooFar) {
        log('lokasi sesuai');
        if (labName == schedule!.labRoom!.labName) {
          if (dateNow == schedule!.date) {
            if (attendanceStatus == AttendanceStatus.notAllowed) {
              showToastError('Saat ini anda belum bisa melakukan absensi');
            } else if (attendanceStatus == AttendanceStatus.absent) {
              showToastError(
                  'Anda tidak bisa melakukan absensi \nWaktu absensi sudah habis');
            } else {
              postScan();
            }
          } else {
            showToastError('Anda tidak bisa melakukan absensi hari ini');
          }
        } else {
          showToastError('Ruang Lab Tidak Sesuai');
        }
      } else {
        showToastError('Absensi Gagal... \nLokasi Anda Terlalu Jauh Dari Lab');
        log('Anda berada diluar lokasi');
      }
    });
  }

  AttendanceStatus getTimeAttendance(DateTime attendanceTime) {
    DateTime time = DateFormat('HH:mm').parse(schedule!.beginTime!);
    // DateTime scheduleTime = DateTime.parse(schedule!.beginTime!);
    DateTime scheduleTime = DateTime(attendanceTime.year, attendanceTime.month,
        attendanceTime.day, time.hour, time.minute);
    DateTime allowedStartTime = scheduleTime.subtract(const Duration(hours: 1));
    DateTime lateThreshold = scheduleTime.add(const Duration(minutes: 15));
    DateTime absentThreshold = scheduleTime.add(const Duration(minutes: 30));
    if (attendanceTime.isBefore(allowedStartTime)) {
      return AttendanceStatus.notAllowed;
    } else if (attendanceTime.isBefore(scheduleTime)) {
      return AttendanceStatus.onTime;
    } else if (attendanceTime.isBefore(lateThreshold)) {
      return AttendanceStatus.onTime;
    } else if (attendanceTime.isBefore(absentThreshold)) {
      return AttendanceStatus.late;
    } else {
      return AttendanceStatus.absent;
    }
  }

  decryptLabRoom(String encryptedMessage) {
    log('encryptd message: $encryptedMessage');
    labName = encryptedMessage;
    // labName = rsaAlgorithm.onDecrypt(encryptedMessage);
    log('lab name: $labName');
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void openCamera() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        resumeCamera();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void pauseCamera() async {
    await controller?.pauseCamera();
    cameraIsPause = true;
  }

  void resumeCamera() async {
    await controller?.resumeCamera();
  }

  postScan() async {
    String attendance = '';
    Map<String, dynamic> body = {};
    switch (attendanceStatus) {
      case AttendanceStatus.onTime:
        attendance = 'present';
        break;
      case AttendanceStatus.late:
        attendance = 'late';
        break;
      case AttendanceStatus.absent:
        attendance = 'absent';
        break;
      default:
        attendance = 'absent';
    }
    body['id_teacher'] = schedule!.idTeacher;
    body['id_schedule'] = schedule!.id;
    body['id_lab_room'] = schedule!.idLabRoom;
    body['status_attendance'] = rsaAlgorithm.onEncrypt(attendance);

    log(body.toString());
    attendanceBloc!.add(PostAttendanceEvent(params: body));
  }

  informationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogBox(
          title: 'Informasi!',
          descriptions:
              'Scan qr code ini berfungsi untuk melakukan absensi praktikum untuk guru pengajar.',
          descriptionsWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              divide10,
              const Text(
                'Keterangan Absensi: ',
                style: TextStyle(
                    color: Pallete.greyDark, fontWeight: FontWeight.w600),
              ),
              contentMission(
                  'Hadir: Jika guru melakukan absensi 1 jam sebelum praktikum dimulai dan setelah 15 menit praktikum dimulai'),
              contentMission(
                  'Terlambat: Jika guru melakukan absensi 15 menit atau lebih setelah jam praktikum dimulai'),
              contentMission(
                  'Tidak Hadir: Jika guru melakukan absensi lebih dari 30 menit atau lebih setelah jam praktikum dimulai'),
            ],
          ),
          color: Pallete.border,
        );
      },
    );
  }

  contentMission(String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          height: 5,
          width: 5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Pallete.greyDark),
        ),
        divideW6,
        Expanded(
          child: Text(content,
              textAlign: TextAlign.justify,
              maxLines: 5,
              style: const TextStyle(
                  color: Pallete.greyDark, overflow: TextOverflow.ellipsis)),
        ),
      ],
    );
  }

  Future<bool> willPopCallback() async {
    resumeCamera();
    Navigator.pop(context, true);
    return true;
  }
}
