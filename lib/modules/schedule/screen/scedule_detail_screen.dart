import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/add_scedule_screen.dart';

class ScheduleDetailArgument {
  final Schedule? schedule;
  final String? day;
  final String dayKey;
  ScheduleDetailArgument({this.schedule, this.day, required this.dayKey});
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
        actions: [
          IconButton(
            icon: const Icon(
              Iconly.editSquare,
              size: 23,
              color: Pallete.border,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AddScheduleScreen.path,
                  arguments: AddScheduleArgument(
                    title: 'Edit Jadwal Praktikum',
                    dayKey: widget.argument!.dayKey,
                  ));
            },
          ),
        ],
        backgroundColor: Pallete.primary2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: NetworkImagePlaceHolder(
                    imageUrl: widget.argument!.schedule!.teacher!.filePath,
                    width: 150,
                    height: 150,
                  )),
            ),
            divide32,
            const Text('Data Jadwal'),
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
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          schedule!.status == true ? 'Aktif' : 'Belum Aktif',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  divide8,
                ],
              ),
            ),
            divide16,
            const Text('Status Absesni'),
            divide8,
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Pallete.border, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Belum Melakukan Absensi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
