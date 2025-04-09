import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule.dart';

class ScheduleDetailArgument {
  final Schedule? schedule;
  final String? day;
  ScheduleDetailArgument({this.schedule, this.day});
}

class ScheduleDetailScreen extends StatefulWidget {
  final ScheduleDetailArgument? argument;
  const ScheduleDetailScreen({super.key, this.argument});

  static const String path = '/seduleDetail';
  static const String title = 'Detail Jadwal Praktikum';

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  Schedule? schedule;

  @override
  void initState() {
    schedule = widget.argument!.schedule;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ScheduleDetailScreen.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Pallete.primary2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(100)),
                child: NetworkImagePlaceHolder(
                  imageUrl: widget.argument!.schedule!.teacher!.filePath,
                  width: 150,
                  height: 150,
                  isCircle: true,
                ),
              ),
            ),
            divide64,
            const Text('Data Jadwal Praktikum'),
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
                          const Text('Nama Guru'),
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
                          divide8,
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(schedule!.teacher!.name!),
                          divide8,
                          Text(widget.argument!.day!),
                          divide8,
                          Text(schedule!.subject!),
                          divide8,
                          Text(
                              '${schedule!.beginTime!} - ${schedule!.endTime}'),
                          divide8,
                          Text(schedule!.scheduleClass!),
                          divide8,
                          Text(schedule!.labRoom!.labName!),
                          divide8,
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status Jadwal'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        decoration: BoxDecoration(
                            color: schedule!.status == true
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          schedule!.status == true ? 'Aktif' : 'Belum Aktif',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
