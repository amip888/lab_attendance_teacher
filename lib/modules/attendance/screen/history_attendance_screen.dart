import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/component_filter.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/bloc/attendance_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/model/all_attendances_model/all_attendances_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class HistoryAttendanceScreen extends StatefulWidget {
  const HistoryAttendanceScreen({super.key});

  static const String path = '/historyAttendance';
  static const String title = 'Riwayat Absensi';

  @override
  State<HistoryAttendanceScreen> createState() =>
      _HistoryAttendanceScreenState();
}

class _HistoryAttendanceScreenState extends State<HistoryAttendanceScreen> {
  AttendanceBloc? attendanceBloc;
  List<ComponentFilter> listFilters = [
    ComponentFilter(
        id: '1', title: 'Semua', color: Pallete.primary, isSelected: true),
    ComponentFilter(
        id: '2', title: 'Hari ini', color: Pallete.primary, isSelected: false),
    ComponentFilter(
        id: '3',
        title: 'Minggu ini',
        color: Pallete.primary,
        isSelected: false),
    ComponentFilter(
        id: '4', title: 'Bulan ini', color: Pallete.primary, isSelected: false),
    ComponentFilter(
        id: '5',
        title: 'Jadwal Saya',
        color: Pallete.primary,
        isSelected: false),
  ];
  List<ComponentFilter> filters = [];
  // List<Attendance> listAttendance = [];
  // List<Attendance> listFilterAttendance = [];
  bool isLoading = false;

  @override
  void initState() {
    filters = listFilters;
    attendanceBloc = AttendanceBloc();
    attendanceBloc!.add(GetAllAttendancesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(HistoryAttendanceScreen.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 45),
              child: isLoading ? shimmerFilter() : buildFilter()),
        ),
        body: buildView()
        // BlocProvider(
        //   create: (context) => attendanceBloc!,
        //   child: BlocConsumer<AttendanceBloc, AttendanceState>(
        //     builder: (BuildContext context, state) {
        //       if (state is GetAllAttendancesLoadingState) {
        //         return loading();
        //       } else if (state is GetAllAttendancesLoadedState) {
        //         return buildView(state.data!);
        //       } else if (state is GetAllAttendancesEmptyState) {
        //       } else if (state is GetAllAttendancesErrorState) {}
        //       return Container();
        //     },
        //     listener: (BuildContext context, Object? state) {},
        //   ),
        // )
        );
  }

  buildView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return cardAttendance(context);
      },
    );
  }

  cardAttendance(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AttendanceDetailScreen.path);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
                  imageUrl: 'image',
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
                        'Sandi',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Senin, 17 Juli 2024',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green,
                  ),
                  child: Text(
                    'Hadir',
                    style: const TextStyle(fontSize: 12),
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
                    Text('Lab RPL 01'),
                    Text('XI RPL 01'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        itemCount: filters.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var item = listFilters[index];
          return Row(children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  log('hari ini: ${DateTime.now()}');
                  for (var component in listFilters) {
                    if (component.id == item.id) {
                      component.isSelected = true;
                      // switch (component.title) {
                      //   case 'Hari ini':
                      //     listFilterSchedule = filterSchedulesByDay(
                      //         listSchedule, DateTime.now());
                      //     filterSchedule = 'Hari ini';
                      //     break;
                      //   case 'Minggu ini':
                      //     listFilterSchedule = filterSchedulesByWeek(
                      //         listSchedule, DateTime.now());
                      //     filterSchedule = 'Minggu ini';
                      //     break;
                      //   case 'Bulan ini':
                      //     listFilterSchedule = filterSchedulesByMonth(
                      //         listSchedule, DateTime.now());
                      //     filterSchedule = 'Bulan ini';
                      //     break;
                      //   case 'Jadwal Saya':
                      //     listFilterSchedule = listSchedule
                      //         .where(
                      //             (element) => element.idTeacher == teacherId)
                      //         .toList();
                      //     filterSchedule = 'Anda';
                      //     break;
                      //   default:
                      //     listFilterSchedule = listSchedule;
                      //     filterSchedule = '';
                      // }
                    } else {
                      component.isSelected = false;
                    }
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.border, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    color: item.isSelected ? Pallete.border : Pallete.primary),
                child: Text(
                  item.title!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]);
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

  // Widget buildView(AllAttendancesModel data) {
  //   return SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: DataTable(
  //           headingTextStyle: const TextStyle(color: Colors.amber),
  //           dataTextStyle: const TextStyle(color: Colors.blue),
  //           decoration: const BoxDecoration(color: Colors.red),
  //           border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
  //           columns: const [
  //             DataColumn(label: Text('Nama')),
  //             DataColumn(label: Text('Jurusan')),
  //             DataColumn(label: Text('Kelas')),
  //             DataColumn(label: Text('Status Kehadiran')),
  //           ],
  //           rows: List.generate(data.attendanceTeacher!.length, (index) {
  //             var item = data.attendanceTeacher![index];
  //             return DataRow(
  //               color: const MaterialStatePropertyAll(Colors.amber),
  //               cells: <DataCell>[
  //                 DataCell(Text(item.idTeacher!)),
  //                 DataCell(Text(item.idSchedule!)),
  //                 DataCell(Text(item.statusAttendance!)),
  //                 DataCell(Text(item.createdAt.toString())),
  //               ],
  //             );
  //           })));
  // }
}
