// ignore_for_file: non_constant_identifier_names
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/component_filter.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/download_file.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/rsa_algorithm.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/bloc/attendance_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_student_model/attendance_student.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/attendance_teacher_model/attendance_teacher.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class HistoryAttendanceScreen extends StatefulWidget {
  const HistoryAttendanceScreen({super.key});

  static const String path = '/historyAttendance';
  static const String title = 'Riwayat Absensi';

  @override
  State<HistoryAttendanceScreen> createState() =>
      _HistoryAttendanceScreenState();
}

class _HistoryAttendanceScreenState extends State<HistoryAttendanceScreen>
    with SingleTickerProviderStateMixin {
  AttendanceBloc? attendanceBloc;
  late TabController _tabController;
  List<ComponentFilter> filtersMonth = [];
  List<ComponentAttendance> listAttendances = [];
  List<ComponentAttendance> listFilteredAttendance = [];
  List<String> listMonth = [];
  bool isLoading = false;
  int activeTabIndex = 0;
  String teacherId = '';
  bool isDecrypt = false;
  RsaAlgorithm rsaAlgorithm = RsaAlgorithm();

  @override
  void initState() {
    rsaAlgorithm.initializeRSA();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        activeTabIndex = _tabController.index;
      });
    });
    attendanceBloc = AttendanceBloc();
    attendanceBloc!.add(GetAllAttendancesEvent());
    // listFilteredAttendance = listAttendances;
    loadTeacher();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  loadTeacher() async {
    teacherId = await LocalStorageServices.getTeacherId();
    isDecrypt = await LocalStorageServices.getIsDecrypt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
                child: Text(HistoryAttendanceScreen.title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Pallete.primary2,
            actions: [
              DownloadFile(
                roleDownload: activeTabIndex == 0 ? 'teacher' : 'student',
              )
            ],
            bottom: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicator: BoxDecoration(color: Colors.amber.withOpacity(0.4)),
                labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 15, color: Colors.white),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2.5,
                tabs: const [
                  Tab(
                    text: 'Guru',
                  ),
                  Tab(
                    text: 'Siswa',
                  ),
                ])),
        body: BlocProvider(
          create: (context) => attendanceBloc!,
          child: BlocConsumer<AttendanceBloc, AttendanceState>(
            builder: (BuildContext context, state) {
              if (state is GetAllAttendancesLoadingState) {
                return loading();
              } else if (state is GetAllAttendancesLoadedState) {
                return buildTabBar();
                // return buildView(state.data!);
              } else if (state is GetAllAttendancesEmptyState) {
                return IllustrationWidget(
                    type: IllustrationWidgetType.empty,
                    description: 'Riwayat Absensi Kosong');
              } else if (state is GetAllAttendancesErrorState) {
                return IllustrationWidget(
                  type: IllustrationWidgetType.error,
                  onButtonTap: () {
                    attendanceBloc!.add(GetAllAttendancesEvent());
                  },
                );
              } else if (state is NoInternetConnectionState) {
                return IllustrationWidget(
                  type: IllustrationWidgetType.notConnection,
                  onButtonTap: () {
                    attendanceBloc!.add(GetAllAttendancesEvent());
                  },
                );
              }
              return Container();
            },
            listener: (BuildContext context, Object? state) {
              String month;
              DateTime date;
              if (state is GetAllAttendancesLoadedState) {
                listAttendances.clear();

                for (var item
                    in state.dataAttendanceTeacher!.attendanceTeacher!) {
                  date = DateTime.parse(item.schedule!.date!);
                  month = DateFormat('MM').format(date);
                  listMonth.add(item.schedule!.date!);
                  setState(() {
                    filtersMonth = createFilterList(listMonth);
                    filtersMonth.insert(
                        0,
                        ComponentFilter(
                            id: 'all',
                            title: 'Semua',
                            color: Pallete.primary,
                            isSelected: true));
                  });
                  listAttendances.add(ComponentAttendance(
                      id: item.id,
                      userId: item.idTeacher,
                      statusAttendance: item.statusAttendance,
                      labName: item.labRoom!.labName,
                      name: item.teacher!.name,
                      Class: item.schedule!.scheduleClass,
                      date: item.schedule!.date,
                      subject: item.schedule!.subject,
                      beginTime: item.schedule!.beginTime,
                      endTime: item.schedule!.endTime,
                      filePath: item.teacher!.filePath,
                      role: 'teacher',
                      month: month));
                }

                for (var item
                    in state.dataAttendanceStudent!.attendanceStudents!) {
                  date = DateTime.parse(item.schedule!.date!);
                  month = DateFormat('MM').format(date);
                  listAttendances.add(ComponentAttendance(
                      id: item.id,
                      userId: item.idStudent,
                      teacherId: item.schedule!.idTeacher,
                      statusAttendance: item.statusAttendance,
                      labName: item.labRoom!.labName,
                      name: item.student!.name,
                      Class: item.student!.studentClass,
                      date: item.schedule!.date,
                      subject: item.schedule!.subject,
                      beginTime: item.schedule!.beginTime,
                      endTime: item.schedule!.endTime,
                      filePath: item.student!.filePath,
                      role: 'student',
                      month: month));
                }
                listAttendances.sort((a, b) => a.date!.compareTo(b.date!));

                if (isDecrypt) {
                  for (var item in listAttendances) {
                    listFilteredAttendance.add(ComponentAttendance(
                        id: item.id!,
                        userId: item.userId!,
                        teacherId: item.teacherId,
                        statusAttendance:
                            rsaAlgorithm.onDecrypt(item.statusAttendance!),
                        labName: item.labName!,
                        name: rsaAlgorithm.onDecrypt(item.name!),
                        Class: item.Class!,
                        date: item.date!,
                        subject: item.subject!,
                        beginTime: item.beginTime!,
                        endTime: item.endTime!,
                        filePath: item.filePath != null
                            ? rsaAlgorithm.onDecrypt(item.filePath)
                            : item.filePath,
                        role: item.role!,
                        month: item.month!));
                  }
                } else {
                  listFilteredAttendance = listAttendances;
                }
              }
            },
          ),
        ));
  }

  buildTabBar() {
    return TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildViewAttendance(listFilteredAttendance
              .where((element) => element.role == 'teacher')
              // element.role == 'teacher' && element.userId == teacherId)
              .toList()),
          buildViewAttendance(listFilteredAttendance
              .where((element) =>
                  element.role == 'student' && element.teacherId == teacherId)
              .toList()),
          // Text('Riwayat Absensi Guru'),
          // Text('Riwayat Absensi Siswa'),
        ]);
  }

  buildViewAttendance(List<ComponentAttendance> listAttendance) {
    log('tab: $activeTabIndex');
    return RefreshIndicator(
      backgroundColor: Pallete.background,
      color: Pallete.primary2,
      onRefresh: () async {
        filtersMonth.clear();
        listAttendances.clear();
        attendanceBloc!.add(GetAllAttendancesEvent());
        listFilteredAttendance = listAttendances;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFilter(),
          listAttendance.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemCount: listAttendance.length,
                    itemBuilder: (context, index) {
                      var item = listAttendance[index];
                      return cardAttendance(item);
                    },
                  ),
                )
              : IllustrationWidget(
                  type: IllustrationWidgetType.empty,
                  description: 'Data Absensi Kosong',
                )
        ],
      ),
    );
  }

  cardAttendance(ComponentAttendance item) {
    String day = formatDayDate(item.date!);
    String? attendance;
    Color? colorAttendance;
    switch (item.statusAttendance) {
      case 'present':
        attendance = 'Hadir';
        colorAttendance = Colors.green;
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
        attendance = 'Tidak Hadir';
        colorAttendance = Colors.red;
    }
    return GestureDetector(
      onTap: () {
        attendanceDetail(item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Pallete.border),
            borderRadius: BorderRadius.circular(16),
            color: Pallete.primary2),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NetworkImagePlaceHolder(
                  imageUrl: item.filePath,
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
                        item.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        day,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                divideW10,
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colorAttendance,
                  ),
                  child: Text(
                    attendance,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                )
              ],
            ),
            divide8,
            Container(
              color: Pallete.border,
              width: double.infinity,
              height: 1.5,
            ),
            divide8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ruangan Lab'),
                    Text('Kelas'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(item.labName!),
                    Text(item.Class!),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ComponentFilter> createFilterList(List<String> dates) {
    // Set untuk menyimpan bulan yang unik
    Set<String> uniqueMonths = {};

    // Daftar ComponentFilter
    List<ComponentFilter> filters = [];

    // Mapping bulan dengan nama bulan
    Map<String, String> monthNames = {
      "01": "Januari",
      "02": "Februari",
      "03": "Maret",
      "04": "April",
      "05": "Mei",
      "06": "Juni",
      "07": "Juli",
      "08": "Agustus",
      "09": "September",
      "10": "Oktober",
      "11": "November",
      "12": "Desember",
    };

    for (String date in dates) {
      // Split tanggal menjadi list [YYYY, MM, DD]
      List<String> parts = date.split('-');
      String month = parts[1]; // Mengambil bulan

      // Cek apakah bulan sudah ada di Set
      if (!uniqueMonths.contains(month)) {
        uniqueMonths.add(month);
        filters.add(
          ComponentFilter(
              id: month,
              title: monthNames[month], // Menggunakan nama bulan
              color: Pallete.primary,
              isSelected: false),
        );
      }
    }
    return filters;
  }

  buildFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Pallete.primary2,
      height: 58,
      width: double.infinity,
      child: ListView.builder(
        itemCount: filtersMonth.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var item = filtersMonth[index];
          log('list id: ${item.id}, ${item.title}');
          return GestureDetector(
            onTap: () {
              setState(() {
                for (var element in filtersMonth) {
                  if (element.id == item.id) {
                    element.isSelected = true;
                    if (element.title != 'Semua') {
                      listFilteredAttendance = listAttendances
                          .where((element) => element.month == item.id)
                          .toList();
                    } else {
                      listFilteredAttendance = listAttendances;
                    }
                  } else {
                    element.isSelected = false;
                  }
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.border, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  color: item.isSelected ? Pallete.border : Pallete.primary),
              child: Text(
                item.title!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  shimmerFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        itemCount: 5,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Blink(
              height: 20,
              width: 80,
            ),
          );
        },
      ),
    );
  }

  attendanceDetail(ComponentAttendance componentAttendance) async {
    var update = await Navigator.pushNamed(context, AttendanceDetailScreen.path,
        arguments: AttendanceDetailArgument(
          componentAttendance: componentAttendance,
          roleUser: activeTabIndex == 0 ? 'teacher' : 'student',
        ));
    if (update == true) {
      attendanceBloc!.add(GetAllAttendancesEvent());
    }
  }
}

class ComponentAttendance {
  String? id,
      userId,
      teacherId,
      statusAttendance,
      labName,
      name,
      Class,
      date,
      subject,
      beginTime,
      endTime,
      role,
      month;
  dynamic filePath;
  ComponentAttendance(
      {this.id,
      this.userId,
      this.teacherId,
      this.statusAttendance,
      this.labName,
      this.name,
      this.Class,
      this.filePath,
      this.date,
      this.subject,
      this.beginTime,
      this.endTime,
      this.month,
      this.role});
}

class ComponentFilterAttendance {
  // ComponentAttendance? data;
  AttendanceTeacher? dataAttendanceTeacher;
  AttendanceStudent? dataAttendanceStudent;
  String? month;

  ComponentFilterAttendance(
      {this.dataAttendanceTeacher, this.dataAttendanceStudent, this.month});
}
