import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/bloc/attendance_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/scedule_model/schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/home_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
// import 'package:pointycastle/export.dart' as assymetricKey;
import 'package:qr_code_scanner/qr_code_scanner.dart';

enum ScanMode { arrival, exchange }

class ScanQRArgument {
  // ScanMode scanMode;
  // String eventId;
  // ScanQRArgument({required this.scanMode, required this.eventId});
}

class AttendanceScreen extends StatefulWidget {
  final ScanQRArgument? argument;
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
  final LatLng schoolLatLng = LatLng(-6.937893132288915, 107.73815975163151);

  String? branchId;
  AttendanceBloc? attendanceBloc;
  ScheduleModel? scheduleModel;
  String idSchedule = '';
  double? distance;
  double? maxDistance = 200.0; // DALAM SATUAN METER
  bool isTooFar = true;
  // late RSAAlgorithmUtils rsaUtil;
  // late assymetricKey.AsymmetricKeyPair<assymetricKey.RSAPublicKey,
  //     assymetricKey.RSAPrivateKey> keyPair;

  @override
  void initState() {
    attendanceBloc = AttendanceBloc();
    attendanceBloc!.add(GetScheduleEvent('2024-01-20T08:00:00'));
    userLatLng = HomeScreen.userLatLng;
    setDistance();
    // attendanceBloc!.add(GetScheduleEvent(DateTime.now()));
    // rsaUtil = RSAAlgorithmUtils();
    // keyPair = rsaUtil.generateKeyPair();
    super.initState();
    // controller!.resumeCamera();
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
    // final publicKey = keyPair!.publicKey;
    // final privateKey = keyPair!.privateKey;
    const message = 'Hello RSA';

    //Encrypt using the public key
    // final encryptedMessage = rsaUtil.encrypt(message, publicKey);
    // log('Encrypted message: $encryptedMessage');

    //Decrypt using the private key
    // final decryptedMessage = rsaUtil.decrypt(encryptedMessage, privateKey);
    // log('Decrypt message: $decryptedMessage');
    return Scaffold(body: _buildView(context)
        //     BlocProvider(
        //   create: (context) => attendanceBloc!,
        //   child: BlocConsumer<AttendanceBloc, AttendanceState>(
        //       builder: (context, state) {
        //     if (state is GetScheduleLoadedState) {
        //       return _buildView(context);
        //     }
        //     return Container();
        //   }, listener: (context, state) {
        //     if (state is GetScheduleLoadedState) {
        //       log(state.toString());
        //       idSchedule = state.data!.id!;
        //       setState(() {
        //         scheduleModel = state.data;
        //       });
        //     } else if (state is GetScheduleEmptyState) {
        //       log(state.toString());
        //     } else if (state is GetScheduleErrorState) {
        //       log(state.toString());
        //     } else if (state is PostAttendanceLoadingState) {
        //       snackbarMessage(text: 'Memuat...');
        //     } else if (state is PostAttendanceLoadedState) {
        //       showToast('Sukses');
        //       Navigator.pop(context);
        //       // if (state.data.scan!.isScan == null)
        //       //   {
        //       //     showToast('Sukses'),
        //       //     // showDetailTicket(state.data, hasRedeemed: false)
        //       //   }
        //       // else
        //       // {showDetailTicket(state.data, hasRedeemed: true)}
        //     } else if (state is PostAttendanceErrorState) {
        //       snackbarMessage(
        //         text: 'Error to load',
        //         colors: Colors.red,
        //       );
        //       openCamera();
        //     } else if (state is PostAttendanceFailedState) {
        //       snackbarMessage(
        //         text: 'Failed to load',
        //         colors: Colors.red[900],
        //       );
        //       openCamera();
        //     }
        //   }),
        // )
        );
  }

  setDistance() {
    log('SET DISTANCE LOADED');
    setState(() {
      distance =
          ((SphericalUtil.computeDistanceBetween(schoolLatLng, userLatLng!) /
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

  _buildView(BuildContext context) {
    // log(scheduleModel!.roomLab!);
    String formatedDate =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(scheduleModel!.day!.toLocal());
    DateTime date = scheduleModel!.day!.toLocal();
    String oneHourBefore = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime(
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second)
        .subtract(const Duration(hours: 1)));
    String oneHourAfter = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime(
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second)
        .add(const Duration(minutes: 30)));
    log('Date: $formatedDate, before: $oneHourBefore, after: $oneHourAfter');
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
                          // informationDialog();
                        },
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  scheduleModel!.status == true
                      ? "Arahkan kamera ke Qr-code yang ada di laboratorium"
                      : 'Tidak bisa melakukan absensi karena jadwal belum aktif',
                  style: const TextStyle(
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
                    textColor: Colors.white,
                    text: 'Batal scan',
                    press: () {
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
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = MediaQuery.of(context).size.width / 1.5;
    // To ensure the Scanner view is properly sizes after rotationp
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Pallete.primary,
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
      // FlutterBeep.beep();
      if (!isTooFar) {
        log('lokasi sesuai');
        if (result!.code == scheduleModel!.roomLab) {
          postScan(result!.code!);
        } else {
          showToastError('Ruangan tidak sesuai');
        }
      } else {
        showToastError('Absensi Gagal Anda berada diluar lokasi');
        log('Anda berada diluar lokasi');
      }
    });

    // } else {
    //   snackbarMessage(text: 'Attendance Failed because schedule no active yet');
    // }
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
  }

  void resumeCamera() async {
    await controller?.resumeCamera();
  }

  postScan(String data) async {
    Map<String, dynamic> body = {};
    String studentId = await LocalStorageServices.getStudentId();
    body['id_schedule'] = idSchedule;
    body['id_student'] = studentId;
    body['status_attendance'] = 'present';

    log(body.toString());
    attendanceBloc!.add(PostAttendanceEvent(params: body));
  }

  // informationDialog() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return DialogBox(
  //         title: 'Informasi!',
  //         descriptions:
  //             // widget.argument!.scanMode == ScanMode.exchange
  //             //     ? 'Scan barcode ini berfungsi untuk melakukan penukaran E-Ticket menjadi gelang.'
  //             //     :
  //             'Scan barcode ini berfungsi untuk melakukan validasi kedatangan pelanggan.',
  //       );
  //     },
  //   );
  // }

  Future<bool> willPopCallback() async {
    resumeCamera();
    Navigator.pop(context, true);
    return true;
  }

  // showDialogExisting({required String title, required String description}) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return DialogBox(
  //         title: title,
  //         descriptions: description,
  //         onOkText: 'Tutup',
  //         onOkTap: () {
  //           Navigator.pop(context);
  //           setState(() {
  //             openCamera();
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  // showDetailTicket(ScanExchangeResult data, {bool? hasRedeemed}) {
  //   bottomSheet(
  //       title: 'Detail Pesanan',
  //       context: context,
  //       enableDrag: false,
  //       onTapOk: () {
  //         setState(() {
  //           Navigator.pop(context);
  //           openCamera();
  //         });
  //       },
  //       height: MediaQuery.of(context).size.height * 0.7,
  //       child: Expanded(
  //           child: ListView(
  //         children: [
  //           if (hasRedeemed == true)
  //             ListTile(
  //               title: TextWidget(
  //                 'Admin : ${data.scan!.createdBy!.name}',
  //                 size: TextWidgetSize.h6,
  //                 weight: FontWeight.w600,
  //                 textColor: Pallete.greyDark,
  //               ),
  //               subtitle: TextWidget(
  //                 'Ditukar pada ${DateFormat('yyyy-MM-dd HH:mm:ss').format(data.scan!.createdAt!)}',
  //                 size: TextWidgetSize.h6,
  //                 weight: FontWeight.w600,
  //                 textColor: Colors.red,
  //                 maxLines: 1,
  //               ),
  //               trailing: Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                 decoration: const BoxDecoration(
  //                     borderRadius:
  //                         BorderRadius.all(Radius.circular(Dimens.size128)),
  //                     color: Colors.green),
  //                 child: TextWidget(
  //                   'Sudah ditukar',
  //                   size: TextWidgetSize.h8,
  //                   weight: FontWeight.w600,
  //                   textColor: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ListTile(
  //             title: TextWidget(
  //               'Nama Pemesan',
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.greyDark,
  //             ),
  //             subtitle: TextWidget(
  //               '${data.scan!.user!.fullname}'.toTitleCase(),
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.primary,
  //               maxLines: 1,
  //             ),
  //           ),
  //           divideThick(),
  //           ListTile(
  //             title: TextWidget(
  //               'Nomor HP',
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.greyDark,
  //             ),
  //             subtitle: TextWidget(
  //               data.scan!.user!.phone ?? '-',
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.primary,
  //               maxLines: 1,
  //             ),
  //           ),
  //           divideThick(),
  //           ListTile(
  //             title: TextWidget(
  //               'Email',
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.greyDark,
  //             ),
  //             subtitle: TextWidget(
  //               data.scan!.user!.email ?? '-',
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.primary,
  //               maxLines: 1,
  //             ),
  //           ),
  //           divideThick(),
  //           ListTile(
  //             contentPadding:
  //                 const EdgeInsets.symmetric(horizontal: Dimens.size16),
  //             title: TextWidget(
  //               'Detail Tiket :',
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.greyDark,
  //             ),
  //             subtitle: TextWidget(
  //               data.scan!.orderDetail!.isEmpty ? '-' : '',
  //               size: TextWidgetSize.h6,
  //               weight: FontWeight.w600,
  //               textColor: Pallete.primary,
  //               maxLines: 1,
  //             ),
  //           ),
  //           ListView.separated(
  //             physics: const NeverScrollableScrollPhysics(),
  //             shrinkWrap: true,
  //             itemCount: data.scan!.orderDetail!.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               var subTotal = data.scan!.orderDetail![index];
  //               return ListTile(
  //                 title: TextWidget(
  //                   '${subTotal.ticket!.title}',
  //                   size: TextWidgetSize.h6,
  //                   weight: FontWeight.w500,
  //                   textColor: Pallete.primary,
  //                   maxLines: 2,
  //                   ellipsed: true,
  //                 ),
  //                 trailing: TextWidget(
  //                   '${rupiahFormatter(value: subTotal.totalPrice.toString())}\n(x${subTotal.quantity})',
  //                   size: TextWidgetSize.h6,
  //                   textAlign: TextAlign.right,
  //                   weight: FontWeight.w500,
  //                   textColor: Pallete.primary,
  //                 ),
  //               );
  //             },
  //             separatorBuilder: (BuildContext context, int index) {
  //               return divideThick();
  //             },
  //           ),
  //         ],
  //       )));
  // }
}
