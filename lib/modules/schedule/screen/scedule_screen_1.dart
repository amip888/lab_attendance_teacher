import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/add_lab_room_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/bloc/schedule_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule.dart';
// import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model_old/schedule_model.dart';
// import 'package:lab_attendance_mobile_teacher/modules/schedule/model/teachers_model/schedule.dart';
// import 'package:lab_attendance_mobile_teacher/modules/schedule/model/teachers_model/teacher.dart';
// import 'package:lab_attendance_mobile_teacher/modules/schedule/model/teachers_model/teachers_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/add_scedule_screen.dart';
// import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/add_schedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/day_list_schedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_detail_screen.dart';
// import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/schedule_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
// import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  static const String path = '/schedules';
  static const String title = 'Jadwal Praktikum';

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dateScheduleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool enableButton = false;
  ScheduleBloc? scheduleBloc;

  // List<Teacher> listTeacher = [];
  List<Schedule> listSchedule = [];
  // List<Schedule> listScheduleSelected = [];
  // List<Schedule> listScheduleMe = [];
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _focusedDay = DateTime.now();
  DateTime currentDate = DateTime.now();
  bool isFirstLaunch = true;
  bool _isFabAtBottom = true;
  Map<String, dynamic> params = {};
  List<String> calendar = [];
  // Calendar currentDate = Calendar(
  //     fulldate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //     isClosed: true,
  //     fullLevel: 'LOW');

  // Table Calendar
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late TabController _tabController;

  @override
  void initState() {
    scheduleBloc = ScheduleBloc();
    // scheduleBloc!.add(GetTeachersEvent());
    scheduleBloc!.add(GetScheduleEvent());
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SchedulesScreen.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,

        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     icon: const SvgImage(
        //       'ic_appbar_back.svg',
        //       width: 30,
        //       height: 30,
        //       color: Colors.white,
        //     )),
        bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelStyle: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.amber),
            unselectedLabelStyle: const TextStyle(fontSize: 15),
            indicatorColor: Colors.amber,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.5,
            tabs: const [
              Tab(
                text: 'Semua Jadwal',
              ),
              Tab(
                text: 'Jadwal Saya',
              ),
            ]),
      ),
      body: BlocProvider(
        create: (context) => scheduleBloc!,
        child: BlocConsumer<ScheduleBloc, ScheduleState>(
          builder: (BuildContext context, state) {
            return buildTabBar();
          },
          listener: (BuildContext context, Object? state) {
            log(state.toString());
            if (state is GetScheduleLoadingState) {
            } else if (state is GetScheduleLoadedState) {
              listSchedule.addAll(state.data.schedules!);
            } else if (state is GetScheduleEmptyState) {
            } else if (state is GetScheduleErrorState) {
              showToastError(state.message);
            }
          },
        ),
      ),
    );
  }

  void showAnimatedDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            width: 300,
            height: 200,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'This is a popup',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  TabBarView buildTabBar() {
    return TabBarView(controller: _tabController, children: [
      Stack(
        children: [
          allSchedules(),
          Positioned(
            bottom: 100,
            right: 20,
            child: GestureDetector(
              onTap: () {
                changeDate(
                  context,
                  controller: dateScheduleController,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Pallete.border,
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: Pallete.primary2,
                ),
              ),
            ),
          )
        ],
      ),
      // schedulesMe(),
    ]);
  }

  Widget allSchedules() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          // TableCalendar<Event>(
          //   locale: 'id',
          //   firstDay: kFirstDay,
          //   lastDay: kLastDay,
          //   focusedDay: _focusedDay,
          //   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          //   rangeStartDay: _rangeStart,
          //   rangeEndDay: _rangeEnd,
          //   calendarFormat: _calendarFormat,
          //   rangeSelectionMode: _rangeSelectionMode,
          //   eventLoader: _getEventsForDay,
          //   startingDayOfWeek: StartingDayOfWeek.monday,
          //   headerStyle: const HeaderStyle(
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(10),
          //         topRight: Radius.circular(10),
          //       )),
          //       titleCentered: true),
          //   daysOfWeekStyle: const DaysOfWeekStyle(
          //       weekdayStyle: TextStyle(color: Colors.white),
          //       weekendStyle: TextStyle(color: Colors.white)),
          //   availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          //   calendarStyle: const CalendarStyle(
          //     outsideDaysVisible: false,
          //     markerSize: 5,
          //     markerDecoration: BoxDecoration(color: Colors.white),
          //     markerMargin: EdgeInsets.only(right: 2),
          //     holidayTextStyle: TextStyle(color: Colors.red),
          //     holidayDecoration: BoxDecoration(color: Colors.red),
          //     weekendTextStyle: TextStyle(color: Colors.red),
          //     // weekendDecoration: BoxDecoration(
          //     //     color: Colors.red, borderRadius: BorderRadius.circular(10)),
          //     // defaultDecoration: BoxDecoration(
          //     //     color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          //     selectedDecoration:
          //         BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
          //     todayDecoration:
          //         BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
          //   ),
          //   onDaySelected: (selectedDay, focusedDay) {
          //     log(selectedDay.toString());
          //     setState(() {
          //       _focusedDay = selectedDay;
          //       _selectedDay = selectedDay;
          //     });
          //     listScheduleSelected.clear();
          //     listScheduleSelected.addAll(listSchedule.where((element) =>
          //         DateFormat('yyyy-MM-dd').format(element.day!).toString() ==
          //         DateFormat('yyyy-MM-dd').format(_selectedDay!)));
          //   },
          //   onRangeSelected: _onRangeSelected,
          //   onFormatChanged: (format) {
          //     if (_calendarFormat != format) {
          //       setState(() {
          //         _calendarFormat = format;
          //       });
          //     }
          //   },
          //   onPageChanged: (focusedDay) {
          //     _focusedDay = focusedDay;
          //   },
          // ),
          divide8,
          Expanded(
            child: listSchedules(),
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
      ),
    );
  }

  Widget listSchedules() {
    log(listSchedule.length.toString());
    // if (listScheduleSelected.isNotEmpty) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      // itemCount: 3,
      itemCount: listSchedule.length,
      // itemCount: listScheduleSelected.length,
      itemBuilder: (BuildContext context, int index) {
        var item = listSchedule[index];
        // var item = listScheduleSelected[index];
        // DateTime day = DateFormat('EEEE, dd MMMM yyyy').parse(item.date!);
        // String day1 = DateFormat('EEEE, dd MMMM yyyy').format(day);
        // String day = DateFormat('EEEE, dd MMMM yyyy').format(item.day!);
        String? nameTeacher, photoTeacher;
        // for (var itemTeacher
        //     in listTeacher.where((element) => element.id == item.idTeacher)) {
        //   nameTeacher = itemTeacher.name!;
        //   photoTeacher = itemTeacher.filePath!;
        // }
        // return Container(
        //   color: Colors.amber,
        //   width: 200,
        //   height: 50,
        // );
        // return cardSchedule(
        //     name: 'Sandi',
        //     image: 'photoTeacher.jpg',
        //     day: 'Senin, 07 Juli 2024',
        //     subject: 'Database',
        //     labRoom: 'Lab RPL 01',
        //     status: 'Aktif',
        //     Class: 'XI RPL 01');
        return cardSchedule(
            name: nameTeacher,
            image: photoTeacher,
            day: 'day1',
            subject: item.subject,
            // roomLab: item.roomLab,
            status: item.status,
            Class: 'X RPL 01');
      },
    );
    // } else {
    //   return SingleChildScrollView(
    //     child: IllustrationWidget(
    //       type: IllustrationWidgetType.empty,
    //       title: 'Jadwal Praktikum Kosong',
    //     ),
    //   );
    // }
  }

  // Widget schedulesMe() {
  //   listScheduleMe.clear();
  //   listScheduleMe.addAll(listSchedule.where((element) =>
  //       element.idTeacher == 'f790d951-5eeb-4bec-ade5-c5db1e1d7ac1'));
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     padding: const EdgeInsets.all(16),
  //     itemCount: listScheduleMe.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       var item = listScheduleMe[index];
  //       log(item.idTeacher!);
  //       String day = DateFormat('EEEE, dd MMMM yyyy').format(item.day!);
  //       String? nameTeacher, photoTeacher;
  //       for (var itemTeacher
  //           in listTeacher.where((element) => element.id == item.idTeacher)) {
  //         nameTeacher = itemTeacher.name!;
  //         photoTeacher = itemTeacher.filePath!;
  //       }
  //       return cardSchedule(
  //           name: nameTeacher,
  //           image: photoTeacher,
  //           day: day,
  //           subject: item.subject,
  //           labRoom: item.roomLab,
  //           status: item.status);
  //     },
  //   );
  // }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  cardSchedule(
      {required String day, subject, name, image, roomLab, status, Class}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ScheduleDetailScreen.path);
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        roomLab ?? 'Lab RPL 01',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
                    Text('Ruangan Lab'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(day),
                    Text(subject),
                    Text(Class),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createSchedule() async {
    var createSchedule =
        await Navigator.pushNamed(context, AddScheduleScreen.path);
    if (createSchedule == true) {
      scheduleBloc!.add(GetScheduleEvent());
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
    // paramsCalendar['year'] = focusedDay.year;
    // paramsCalendar['month'] = focusedDay.month;

    // params['date'] = _formatDate(focusedDay);
    // _refreshBloc();
    // _refreshBlocOrder();
  }

  CalendarBuilders _calendarBuilders() {
    return CalendarBuilders(
      todayBuilder: (context, day, focusedDay) {
        return AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            // margin: const EdgeInsets.all(Dimens.size4),
            decoration: BoxDecoration(
              color: _dayColor(currentDate),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
      selectedBuilder: (context, day, focusedDay) {
        return AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            // margin: const EdgeInsets.all(Dimens.size4),
            decoration: BoxDecoration(
              color: _dayColor(currentDate),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
      defaultBuilder: _dayBuilder,
    );
  }

  Widget _dayBuilder(BuildContext context, DateTime day, DateTime? focusedDay) {
    // final foundData = calendar!.firstWhere(
    //   (element) =>
    //       DateTime.tryParse(element.fulldate!)!.year == day.year &&
    //       DateTime.tryParse(element.fulldate!)!.day == day.day &&
    //       DateTime.tryParse(element.fulldate!)!.month == day.month,
    //   orElse: () => Calendar(
    //       fulldate: _formatDate(DateTime.now()),
    //       isClosed: true,
    //       fullLevel: 'LOW'),
    // );

    return AspectRatio(
      aspectRatio: 1 / 1,
      child:
          // isCalendarLoading
          //     ?
          // const Padding(
          //     padding: EdgeInsets.all(4),
          //     child: Blink(
          //       isCircle: true,
          //     ),
          //   )
          // :
          Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.amber,
          // color: _dayColor(foundData),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Color? _dayColor(data) {
    // Color? _dayColor(Calendar data) {
    if (data.isClosed!) {
      return Colors.grey;
    } else {
      switch (data.fullLevel) {
        case 'CLOSE':
          return Colors.grey;
        case 'LOW':
          return Colors.green;
        case 'MEDIUM':
          return Colors.orange;
        case 'HIGHT':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }
  }

  void _refreshBloc() {
    // orderBloc!.add(GetCalendarListEvent(params: paramsCalendar));
  }

  void _refreshBlocOrder() {
    // orderBloc!
    //     .add(GetOrderEvent(params: params, endpointApi: 'order-reservation'));
  }
}

class BouncingFloatingActionButtonAnimator
    extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({Offset? begin, Offset? end, double? progress}) {
    // Membuat efek memantul sederhana
    double bounce = progress! < 0.5
        ? 4 * progress! * progress * progress
        : (progress! - 1) * (2 * (progress - 1)) * (2 * (progress - 1)) + 1;
    return Offset.lerp(begin, end, bounce)!;
  }

  @override
  Animation<double> getRotationAnimation({Animation<double>? parent}) {
    // Mengembalikan animasi rotasi dasar
    return parent!;
  }

  @override
  Animation<double> getScaleAnimation({Animation<double>? parent}) {
    // Mengembalikan animasi skala dasar
    return parent!;
  }
}
