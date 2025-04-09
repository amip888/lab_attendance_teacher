import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room.dart';

class LabRoomDetailArgument {
  final LabRoom labRoom;
  LabRoomDetailArgument({required this.labRoom});
}

class LabRoomDetailScreen extends StatefulWidget {
  final LabRoomDetailArgument? argument;
  const LabRoomDetailScreen({super.key, this.argument});

  static const String path = '/labRoomDetail';
  static const String title = 'Detail Ruangan Lab';

  @override
  State<LabRoomDetailScreen> createState() => _LabRoomDetailScreenState();
}

class _LabRoomDetailScreenState extends State<LabRoomDetailScreen> {
  LabRoom? labRoom;

  @override
  void initState() {
    labRoom = widget.argument!.labRoom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              LabRoomDetailScreen.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            backgroundColor: Pallete.primary2,
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 50, right: 16, left: 16, bottom: 16),
          child: Column(
            children: [
              const Text(
                'Data Ruangan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              divide20,
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Pallete.border, width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Nama Ruangan'),
                        Text('Ruang ${labRoom!.labName!}'),
                      ],
                    ),
                    divide16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jam Operasional'),
                        Text(
                            '${labRoom!.openTime!.substring(0, 5)} - ${labRoom!.closeTime!.substring(0, 5)} WIB'),
                      ],
                    ),
                    divide32,
                    AspectRatio(
                        aspectRatio: 16 / 14,
                        child: NetworkImagePlaceHolder(
                          borderRadius: BorderRadius.circular(12),
                          imageUrl: labRoom!.labPhoto!,
                          width: double.infinity,
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
