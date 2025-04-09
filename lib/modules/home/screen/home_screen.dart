// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:lab_attendance_mobile_teacher/component/background.dart';
import 'package:lab_attendance_mobile_teacher/component/check_on_off_gps.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/rsa_algorithm.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_teacher_model/attendance_teacher.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_teacher_model/attendance_teacher_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/history_attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/bloc/home_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/carousel_slider_content.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/profile_shool_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/lab_room_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/lab_rooms_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/notification_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/notification_model/notification.dart'
    as notif;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String path = '/home';
  static const String title = 'Home';
  static late LatLng userLatLng;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc? homeBloc;
  bool isLoading = false;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late Position distancePosition;
  LatLng? userLatLng;
  LatLng? schoolLatLng;
  double? distance;
  bool isTooFar = true;
  double? maxDistante = 200.0; // DALAM SATUAN METER

  final CarouselSliderController _controller = CarouselSliderController();
  int current = 0;
  List<ScheduleComponent> listSchedule = [];
  List<AttendanceTeacher> listAttendance = [];
  DateTime now = DateTime.now();
  int countNotif = 0;
  List<notif.Notification> listNotification = [];
  List<notif.Notification> listNotification1 = [];
  String? userId, teacherId;
  RsaAlgorithm rsaAlgorithm = RsaAlgorithm();
  bool isDecrypt = false;

  @override
  void initState() {
    rsaAlgorithm.initializeRSA();
    homeBloc = HomeBloc();
    homeBloc!.add(GetHomeEvent());
    schoolLatLng = LatLng(-6.937893132288915, 107.73815975163151);
    checkGps();
    loadData();
    super.initState();
  }

  loadData() async {
    userId = await LocalStorageServices.getUserId();
    teacherId = await LocalStorageServices.getTeacherId();
    isDecrypt = await LocalStorageServices.getIsDecrypt();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Pallete.primary,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
        body: SafeArea(
            child: BlocProvider(
      create: (context) => homeBloc!,
      child: BlocConsumer<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
          if (state is GetHomeLoadingState) {
            log('Get user loading');
            isLoading = true;
            return shimmerHome();
          } else if (state is GetHomeLoadedState) {
            log('Get user loaded');
            isLoading = false;
            LocalStorageServices.setTeacherId(state.dataUser.user!.teacher!.id);
            return buildView(state.dataUser, state.dataLabRoom);
          } else if (state is GetHomeEmptyState) {
            log('Get user empty');
            isLoading = false;
          } else if (state is GetHomeErrorState) {
            log('Get user error: ${state.message}');
            isLoading = false;
            return IllustrationWidget(
              type: IllustrationWidgetType.error,
              onButtonTap: () {
                homeBloc!.add(GetHomeEvent());
              },
            );
          } else if (state is NoInternetConnectionState) {
            return IllustrationWidget(
              type: IllustrationWidgetType.notConnection,
              onButtonTap: () {
                homeBloc!.add(GetHomeEvent());
              },
            );
          }
          return Container();
        },
        listener: (BuildContext context, state) {
          if (state is GetHomeLoadedState) {
            listSchedule.clear();
            for (var item in state.dataSchedule.schedules!
                .where((element) => element.idTeacher == teacherId)) {
              DateTime dateFormat = DateTime.parse(item.date!);
              listSchedule.add(
                  ScheduleComponent(schedule: item, dateFormat: dateFormat));
            }
            listSchedule.sort((a, b) => a.dateFormat
                .difference(now)
                .abs()
                .compareTo(b.dateFormat.difference(now).abs()));
            listSchedule = listSchedule.take(3).toList();

            listAttendance.clear();
            listAttendance.addAll(state.dataAttendance.attendanceTeacher!);
            // listAttendance.addAll(state.dataAttendance.attendanceTeacher!
            //     .where((element) => element.idTeacher == teacherId));
            listAttendance.sort(
              (a, b) => a.createdAt!.compareTo(b.createdAt!),
            );
            listAttendance = listAttendance.length > 3
                ? listAttendance.sublist(listAttendance.length - 3)
                : listAttendance;
            listNotification.addAll(state.dataNotification.notification!);

            countNotif = 0;
            for (var item in state.dataNotification.notification!.where(
                (element) =>
                    element.type == 'teacher' &&
                    element.idTeacher == teacherId)) {
              if (item.users!.isEmpty ||
                  item.users!.every((element) => element.id != userId)) {
                countNotif += 1;
              }
            }
          }
        },
      ),
    )));
  }

  Widget buildView(
    UserLoginModel userLogin,
    LabRoomModel labRoomModel,
  ) {
    String? name, photoProfile;
    if (isDecrypt) {
      name = rsaAlgorithm.onDecrypt(userLogin.user!.teacher!.name!);
      photoProfile = rsaAlgorithm.onDecrypt(userLogin.user!.teacher!.filePath!);
    } else {
      name = userLogin.user!.teacher!.name;
      photoProfile = userLogin.user!.teacher!.filePath;
    }
    return RefreshIndicator(
      backgroundColor: Pallete.background,
      color: Pallete.primary2,
      onRefresh: () async {
        homeBloc!.add(GetHomeEvent());
      },
      child: Stack(
        children: [
          const Background(
            isDashboard: true,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NetworkImagePlaceHolder(
                      imageUrl: photoProfile,
                      // imageUrl: userLogin.user!.teacher!.filePath,
                      width: 55,
                      height: 55,
                      isCircle: true,
                    ),
                    divideW10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hallo $name',
                            // 'Hallo ${userLogin.user!.teacher!.name!}',
                            // 'Welcome back',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          divide4,
                          const Text('Welcome to Home',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          notifClick();
                        },
                        child: Stack(
                          children: [
                            const SvgImage(
                              'ic_notification.svg',
                              width: 30,
                              height: 30,
                            ),
                            if (countNotif != 0)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text(
                                      countNotif > 9 ? '9+' : '$countNotif',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ),
                              )
                          ],
                        )),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  shrinkWrap: true,
                  children: [
                    contentSlider(
                        listSlider: CarouselSliderContent.imageSliders),
                    divide16,
                    titleHeader('Jadwal Praktikum'),
                    divide16,
                    listBuilder(
                      count: listSchedule.length,
                      description: 'Jadwal Praktikum',
                      itemBuilder: (BuildContext context, int index) {
                        var itemSchedule = listSchedule[index];
                        String day = formatDayDate(itemSchedule.schedule.date!);
                        return cardSchedule(
                            name: itemSchedule.schedule.teacher!.name,
                            image: itemSchedule.schedule.teacher!.filePath,
                            day: day,
                            time:
                                'Jam ${itemSchedule.schedule.beginTime!.substring(0, 5)} - ${itemSchedule.schedule.endTime!.substring(0, 5)} WIB',
                            subject: itemSchedule.schedule.subject,
                            roomLab: itemSchedule.schedule.labRoom!.labName,
                            status: itemSchedule.schedule.status,
                            Class: itemSchedule.schedule.scheduleClass,
                            item: itemSchedule.schedule);
                      },
                      button: buttonSeeAll(SchedulesScreen.path),
                    ),
                    divide16,
                    titleHeader('Ruang Laboratorium'),
                    cardLabRoomGrid(labRoomModel),
                    titleHeader('Riwayat Absensi'),
                    divide16,
                    listBuilder(
                        count: listAttendance.length,
                        description: 'Riwayat Absensi',
                        itemBuilder: (BuildContext context, int index) {
                          var itemAttendance = listAttendance[index];
                          String day =
                              formatDayDate(itemAttendance.schedule!.date!);
                          return cardAttendance(
                              name: itemAttendance.teacher!.name!,
                              image: itemAttendance.teacher!.filePath,
                              day: day,
                              status: itemAttendance.statusAttendance,
                              attendanceTeacher: itemAttendance);
                        },
                        button: buttonSeeAll(HistoryAttendanceScreen.path)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  notifClick() async {
    var notification =
        await Navigator.pushNamed(context, NotificationScreen.path);
    if (notification == true) {
      homeBloc!.add(GetHomeEvent());
    }
  }

  buttonSeeAll(String path) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Pallete.border],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.3, 0.7])),
            height: 1.5,
            width: 70),
        divideW10,
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, path);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Pallete.border),
                borderRadius: BorderRadius.circular(10)),
            child: const Text(
              'Lihat Semua',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ),
        divideW10,
        Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      // Colors.white,
                      Pallete.border,
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.3, 0.7])),
            height: 1.5,
            width: 70),
      ],
    );
  }

  Widget listBuilder(
      {required Widget? Function(BuildContext, int) itemBuilder,
      Widget? button,
      int? count,
      String? description}) {
    if (count != 0) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Pallete.borderQrCode,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: count,
              itemBuilder: itemBuilder,
            ),
            button!,
          ],
        ),
      );
    } else {
      return IllustrationWidget(
          type: IllustrationWidgetType.empty,
          description: 'Data $description Kosong');
    }
  }

  contentSlider({required List<Widget> listSlider}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProfileSchoolScreen.path);
        },
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: CarouselSlider(
            items: listSlider,
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: isLoading ? false : true,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              animateToClosest: true,
              onPageChanged: (index, reason) {
                setState(() {
                  current = index;
                });
              },
            ),
          ),
        ),
      ),
    ]);
  }

  profileSchool() {
    return Column(children: [
      Image.asset('assets/images/pngs/logo_smk_talaga.png', width: 90),
      divide16,
      divide8,
      RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            text:
                'SMK Negeri 1 Talaga adalah sekolah kejuruan negeri pertama di wilayah selatan Kab. Majalengka. Sekolah ini berdiri pada tahun 2006 dan berlokasi di desa Talagkulon, Talaga Kab... ',
            style: const TextStyle(),
            children: <TextSpan>[
              TextSpan(
                  text: 'Baca selengkapnya',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.blue.shade300),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        Navigator.pushNamed(context, ProfileSchoolScreen.path)
                  // Navigator.pushNamed(
                  //       context,
                  //       WebViewScreen.path,
                  //       arguments: WebViewArgument(
                  //           LocaleKeys.auth_tos.tr(), Environment.term),
                  //     )
                  ),
            ]),
      ),
    ]);
  }

  titleHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.3, 0.7])),
            height: 1.5,
            width: 70),
        divideW10,
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        divideW10,
        Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.3, 0.7])),
            height: 1.5,
            width: 70),
      ],
    );
  }

  cardLabRoomGrid(LabRoomModel labRoom) {
    int remindLabRoom;
    if (labRoom.labRoom!.isNotEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: labRoom.labRoom!.length <= 4 ? labRoom.labRoom!.length : 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14),
        itemBuilder: (BuildContext context, int index) {
          var item = labRoom.labRoom![index];
          if (labRoom.labRoom!.length > 4 && index == 3) {
            remindLabRoom = labRoom.labRoom!.length - 3;
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LabRoomsScreen.path);
              },
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Pallete.primary2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NetworkImagePlaceHolder(
                              imageUrl: item.labPhoto,
                              isCircle: true,
                              width: 90,
                              height: 90),
                          divide12,
                          Text(
                            item.labName!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      )),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Center(
                    child: Text(
                      '+$remindLabRoom Lainnya',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LabRoomDetailScreen.path,
                  arguments: LabRoomDetailArgument(labRoom: item));
            },
            child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    // border: Border.all(width: 2, color: Pallete.border),
                    borderRadius: BorderRadius.circular(10),
                    color: Pallete.primary2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NetworkImagePlaceHolder(
                        imageUrl: item.labPhoto,
                        isCircle: true,
                        width: 90,
                        height: 90),
                    divide12,
                    Text(
                      item.labName!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${item.openTime!.substring(0, 5)} - ${item.closeTime!.substring(0, 5)} WIB',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
          );
        },
      );
    } else {
      return IllustrationWidget(
          type: IllustrationWidgetType.empty,
          description: 'Data Ruang Lab Kosong');
    }
  }

  cardSchedule(
      {day,
      time,
      subject,
      name,
      image,
      roomLab,
      status,
      Class,
      required Schedule item}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ScheduleDetailScreen.path,
            arguments: ScheduleDetailArgument(day: day, schedule: item));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Pallete.border),
            borderRadius: BorderRadius.circular(12),
            color: Pallete.primary2),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImagePlaceHolder(
                  imageUrl: image,
                  isRounded: true,
                  borderRadius: BorderRadius.circular(100),
                  width: 40,
                  height: 40,
                ),
                divideW10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      divide4,
                      Text(
                        time,
                      ),
                      divide4,
                      Text(
                        subject,
                      ),
                    ],
                  ),
                ),
                divideW8,
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: status == true ? Colors.green : Colors.red,
                  ),
                  child: Text(
                    status == true ? 'Aktif' : 'Belum Aktif',
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  cardAttendance(
      {required String name,
      image,
      day,
      status,
      required AttendanceTeacher attendanceTeacher}) {
    String? attendance;
    Color? colorAttendance;
    switch (attendanceTeacher.statusAttendance) {
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
        attendance = 'Tidak ada';
        colorAttendance = Colors.green;
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AttendanceDetailScreen.path,
            arguments:
                AttendanceDetailArgument(attendanceTeacher: attendanceTeacher));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Pallete.border),
            borderRadius: BorderRadius.circular(12),
            color: Pallete.primary2),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImagePlaceHolder(
                  imageUrl: image,
                  isRounded: true,
                  borderRadius: BorderRadius.circular(100),
                  width: 40,
                  height: 40,
                ),
                divideW10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      divide4,
                      Text(
                        day,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colorAttendance,
                  ),
                  child: Text(
                    attendance!,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  shimmerHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Blink(
                width: 55,
                height: 55,
                isCircle: true,
              ),
              divideW10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Blink(width: 150, height: 20),
                    divide4,
                    const Blink(width: 100, height: 20),
                  ],
                ),
              ),
              const Blink(
                width: 25,
                height: 25,
              ),
            ],
          ),
          divide32,
          contentSlider(listSlider: CarouselSliderContent.shimmerSliders),
          divide16,
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Blink(
                height: 20,
                width: 250,
              ),
            ],
          ),
          divide16,
          listBuilder(
            count: 3,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Pallete.primary2),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Blink(
                        width: 40,
                        height: 40,
                        isCircle: true,
                      ),
                      divideW10,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Blink(
                              width: 150,
                              height: 20,
                            ),
                            divide4,
                            const Blink(
                              width: 70,
                              height: 20,
                            ),
                            divide4,
                            const Blink(
                              width: 150,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const Blink(
                        width: 70,
                        height: 25,
                      ),
                    ],
                  ),
                ]),
              );
            },
            button: const Blink(height: 25, width: 150),
          ),
          divide16,
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Blink(
                height: 20,
                width: 250,
              ),
            ],
          ),
          GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14),
            itemBuilder: (BuildContext context, int index) {
              return const Blink();
            },
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Blink(
                height: 20,
                width: 250,
              ),
            ],
          ),
          divide16,
          listBuilder(
              count: 3,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Pallete.primary2),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Blink(
                            width: 40,
                            height: 40,
                            isCircle: true,
                          ),
                          divideW10,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Blink(
                                  width: 150,
                                  height: 20,
                                ),
                                divide4,
                                const Blink(
                                  width: 120,
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Blink(
                            width: 70,
                            height: 25,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              button: const Blink(height: 25, width: 150))
        ],
      ),
    );
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          log('Location permissions are permanently denied');
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });
        getLocation();
      }
    } else {
      OnOffGPS.checkOnOffGPS();
      log("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    log('get location');
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userLatLng = LatLng(position.latitude, position.longitude);
      log('lokasi user: $userLatLng');
      HomeScreen.userLatLng = userLatLng!;
      if (schoolLatLng != null) {
        setDistance();
      }
    });
  }

  setDistance() {
    log('SET DISTANCE LOADED');
    setState(() {
      distance =
          ((SphericalUtil.computeDistanceBetween(schoolLatLng!, userLatLng!) /
                      1000.0) *
                  1000)
              .ceilToDouble();
      if (distance! > maxDistante!) {
        isTooFar = true;
      } else {
        isTooFar = false;
      }
    });
    log(isTooFar.toString());
  }
}

class ScheduleComponent {
  Schedule schedule;
  DateTime dateFormat;
  ScheduleComponent({required this.schedule, required this.dateFormat});
}
