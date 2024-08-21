import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/component_filter.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/bloc/schedule_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/day_list_schedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  static const String path = '/schedules';
  static const String title = 'Jadwal Praktikum';

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
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
  List<Schedule> listSchedule = [];
  List<Schedule> listFilterSchedule = [];
  String? filterSchedule;
  ScheduleBloc? scheduleBloc;
  String? teacherId;
  bool isLoading = false;

  @override
  void initState() {
    scheduleBloc = ScheduleBloc();
    scheduleBloc!.add(GetScheduleEvent());
    listFilterSchedule = listSchedule;
    getTeacherId();
    super.initState();
  }

  getTeacherId() async {
    teacherId = await LocalStorageServices.getTeacherId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SchedulesScreen.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Pallete.primary2,
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 45),
            child: isLoading ? shimmerFilter() : buildFilter()),
      ),
      body: BlocProvider(
        create: (context) => scheduleBloc!,
        child: BlocConsumer<ScheduleBloc, ScheduleState>(
          builder: (BuildContext context, state) {
            if (state is GetScheduleLoadingState) {
              return loadingShimmer();
            } else if (state is GetScheduleLoadedState) {
              return buildView();
            } else if (state is GetScheduleEmptyState) {
              isLoading = false;
              return IllustrationWidget(
                  type: IllustrationWidgetType.empty,
                  description: 'Data Jadwal Praktikum Kosong',
                  textButton: 'Tambah Jadwal Praktikum',
                  onButtonTap: () {
                    Navigator.pushNamed(context, DayListScheduleScreen.path);
                  });
            } else if (state is GetScheduleErrorState) {
              isLoading = false;
              return IllustrationWidget(
                type: IllustrationWidgetType.error,
                onButtonTap: () {
                  scheduleBloc!.add(GetScheduleEvent());
                },
              );
            }
            return Container();
          },
          listener: (BuildContext context, Object? state) {
            log(state.toString());
            if (state is GetScheduleLoadingState) {
              setState(() {
                isLoading = true;
              });
            } else if (state is GetScheduleLoadedState) {
              setState(() {
                isLoading = false;
              });
              filters.addAll(listFilters);
              listSchedule.addAll(state.data.schedules!);
              listSchedule.sort((a, b) => a.date!.compareTo(b.date!));
            }
          },
        ),
      ),
    );
  }

  buildView() {
    if (listFilterSchedule.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listFilterSchedule.length,
              itemBuilder: (BuildContext context, int index) {
                log('count list: ${listFilterSchedule.length}');
                var item = listFilterSchedule[index];
                DateTime initialDay = DateTime.parse(item.date!);
                String formatDate = DateFormat('dd').format(initialDay);
                String formatYear = DateFormat('yyyy').format(initialDay);
                String dayKey = DateFormat('EEEE').format(initialDay);
                String dayName = formatDay(initialDay);
                String monthName = formatMonth(initialDay);
                String day = '$dayName, $formatDate $monthName $formatYear';
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ScheduleDetailScreen.path,
                        arguments: ScheduleDetailArgument(
                            dayKey: dayKey, day: day, schedule: item));
                  },
                  child: cardSchedule(
                      name: item.teacher!.name,
                      image: item.teacher!.filePath,
                      day: day,
                      subject: item.subject,
                      roomLab: item.labRoom!.labName,
                      status: item.status,
                      Class: item.scheduleClass,
                      dayKey: dayKey,
                      item: item),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Button(
                text: 'Tambah Jadwal Praktikum',
                color: Pallete.border,
                width: double.infinity,
                press: () {
                  Navigator.pushNamed(context, DayListScheduleScreen.path);
                  // Navigator.pushNamed(context, AddScheduleScreen.path);
                }),
          )
        ],
      );
    } else {
      return IllustrationWidget(
          type: IllustrationWidgetType.empty,
          description: 'Jadwal Praktikum $filterSchedule Kosong',
          textButton: 'Tambah Jadwal Praktikum',
          onButtonTap: () {
            Navigator.pushNamed(context, DayListScheduleScreen.path);
          });
    }
  }

  cardSchedule(
      {String? day,
      subject,
      name,
      image,
      roomLab,
      status,
      Class,
      required String dayKey,
      required Schedule item}) {
    return Container(
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
                      name ?? 'Sandi',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Ruang $roomLab',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                  Text('Hari/Tanggal'),
                  Text('Mata Pelajaran'),
                  Text('Kelas'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(day!),
                  Text(subject),
                  Text(Class),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  loadingShimmer() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
                color: Pallete.primary2),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Blink(
                      isCircle: true,
                      width: 40,
                      height: 40,
                    ),
                    divideW10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Blink(
                            width: 110,
                            height: 20,
                          ),
                          divide4,
                          const Blink(
                            width: 130,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const Blink(
                      width: 80,
                      height: 25,
                    )
                  ],
                ),
                divide8,
                const Blink(
                  height: 1.5,
                ),
                divide8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Blink(
                          width: 100,
                          height: 20,
                        ),
                        divide4,
                        const Blink(
                          width: 120,
                          height: 20,
                        ),
                        divide4,
                        const Blink(
                          width: 80,
                          height: 20,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Blink(
                          width: 100,
                          height: 20,
                        ),
                        divide4,
                        const Blink(
                          width: 130,
                          height: 20,
                        ),
                        divide4,
                        const Blink(
                          width: 100,
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
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
                      switch (component.title) {
                        case 'Hari ini':
                          listFilterSchedule = filterSchedulesByDay(
                              listSchedule, DateTime.now());
                          filterSchedule = 'Hari ini';
                          break;
                        case 'Minggu ini':
                          listFilterSchedule = filterSchedulesByWeek(
                              listSchedule, DateTime.now());
                          filterSchedule = 'Minggu ini';
                          break;
                        case 'Bulan ini':
                          listFilterSchedule = filterSchedulesByMonth(
                              listSchedule, DateTime.now());
                          filterSchedule = 'Bulan ini';
                          break;
                        case 'Jadwal Saya':
                          listFilterSchedule = listSchedule
                              .where(
                                  (element) => element.idTeacher == teacherId)
                              .toList();
                          filterSchedule = 'Anda';
                          break;
                        default:
                          listFilterSchedule = listSchedule;
                          filterSchedule = '';
                      }
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
}
