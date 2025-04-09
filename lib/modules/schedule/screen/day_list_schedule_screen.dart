import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';

class DayListScheduleScreen extends StatefulWidget {
  const DayListScheduleScreen({super.key});

  static const String path = '/dayListSchedule';
  static const String title = 'Daftar Hari';

  @override
  State<DayListScheduleScreen> createState() => _DayListScheduleScreenState();
}

class _DayListScheduleScreenState extends State<DayListScheduleScreen> {
  List<ComponentDayList> listDaysName = [
    ComponentDayList(
        dayName: 'Senin',
        key: 'Monday',
        status: 'Belum Diatur',
        totalSchedule: 0),
    ComponentDayList(
        dayName: 'Selasa',
        key: 'Tuesday',
        status: 'Belum Diatur',
        totalSchedule: 0),
    ComponentDayList(
        dayName: 'Rabu',
        key: 'Wednesday',
        status: 'Belum Diatur',
        totalSchedule: 0),
    ComponentDayList(
        dayName: 'Kamis',
        key: 'Thursday',
        status: 'Belum Diatur',
        totalSchedule: 0),
    ComponentDayList(
        dayName: 'Jum`at',
        key: 'Friday',
        status: 'Belum Diatur',
        totalSchedule: 0),
    ComponentDayList(
        dayName: 'Sabtu',
        key: 'Saturday',
        status: 'Belum Diatur',
        totalSchedule: 0),
    ComponentDayList(
        dayName: 'Minggu',
        key: 'Sunday',
        status: 'Belum Diatur',
        totalSchedule: 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          DayListScheduleScreen.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Pallete.primary2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listDaysName.length,
            itemBuilder: (BuildContext context, int index) {
              var item = listDaysName[index];
              return itemSchedule(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget itemSchedule(BuildContext context, ComponentDayList item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Pallete.primary2,
          border: Border.all(color: Pallete.border, width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.dayName!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                divide4,
                Text(
                  'Jumlah jadwal: ${item.totalSchedule}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: Text(
                item.status!,
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
  }
}

class ComponentDayList {
  final String? dayName, status, key;
  final int? totalSchedule;

  ComponentDayList({this.dayName, this.key, this.status, this.totalSchedule});
}
