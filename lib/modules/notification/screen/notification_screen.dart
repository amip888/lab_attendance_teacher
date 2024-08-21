import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const String path = '/notification';
  static const String title = 'Notifikasi';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(NotificationScreen.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Pallete.primary2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: Pallete.border),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Judul'),
                divide4,
                Text('Deskripsi'),
                divide4,
                Text('Tanggal'),
              ],
            ),
          );
        },
      ),
    );
  }
}
