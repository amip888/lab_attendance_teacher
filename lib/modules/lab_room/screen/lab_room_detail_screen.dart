import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/image_upload.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/add_lab_room_screen.dart';

class LabRoomDetailArgument {
  final LabRoomModel labRoomModel;
  LabRoomDetailArgument({required this.labRoomModel});
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
  @override
  Widget build(BuildContext context) {
    LabRoom? labRoom;
    for (var item in widget.argument!.labRoomModel.labRoom!) {
      labRoom = item;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            LabRoomDetailScreen.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Pallete.primary2,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                  color: Pallete.border,
                )),
            IconButton(
              icon: const Icon(
                Iconly.editSquare,
                size: 23,
                color: Pallete.border,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AddLabRoomScreen.path,
                    arguments: AddLabRoomArgument(
                        title: 'Edit Ruangan Lab',
                        labRoomModel: widget.argument!.labRoomModel));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 2),
                      borderRadius: BorderRadius.circular(100)),
                  child: NetworkImagePlaceHolder(
                    imageUrl: labRoom!.labPhoto,
                    width: 150,
                    height: 150,
                    isCircle: true,
                  ),
                ),
              ),
              divide24,
              const Text('Data Ruangan'),
              divide8,
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
                        Text('Ruang ${labRoom.labName!}'),
                      ],
                    ),
                    divide8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jam Operasional'),
                        Text(
                            '${labRoom.openTime!.substring(0, 5)} - ${labRoom.closeTime!.substring(0, 5)} WIB'),
                      ],
                    ),
                    divide16,
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: NetworkImagePlaceHolder(
                          imageUrl: labRoom.qrPhoto!,
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
