import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/screen/list_user_screen.dart';

class UserDetailArgument {
  final UserDetail? userDetail;
  UserDetailArgument({this.userDetail});
}

class UserDetailScreen extends StatefulWidget {
  final UserDetailArgument? argument;
  const UserDetailScreen({super.key, this.argument});

  static const String path = '/userDetail';
  static const String title = 'Detail Pengguna';

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  UserDetail? userDetail;
  String gender = '';
  String? placeDateBirth;
  DateTime? dateBirthFormat;

  @override
  void initState() {
    userDetail = widget.argument!.userDetail;
    if (userDetail!.gender == true) {
      gender = 'Laki-laki';
    } else {
      gender = 'Perempuan';
    }
    if (userDetail!.dateBirth != null) {
      if (userDetail!.dateBirth != 'Belum Diatur') {
        dateBirthFormat = DateTime.parse(userDetail!.dateBirth!);
        placeDateBirth =
            '${userDetail!.placeBirth}, ${DateFormat('dd-MM-yy').format(dateBirthFormat!)}';
      } else {
        placeDateBirth = 'Belum Diatur';
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          UserDetailScreen.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Pallete.primary2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  border: Border.all(color: Pallete.border, width: 2.5),
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: NetworkImagePlaceHolder(
                  imageUrl: userDetail!.filePath,
                  width: 150,
                  height: 150,
                  isCircle: true,
                ),
              ),
            ),
            divide32,
            const Text('Data Pengguna'),
            divide12,
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
                          const Text('NIP'),
                          divide10,
                          const Text('Nama'),
                          if (userDetail!.role == 'teacher') divide10,
                          if (userDetail!.role == 'teacher')
                            const Text('Jurusan'),
                          divide10,
                          const Text('Nomor Handphone'),
                          divide10,
                          const Text('Jenis Kelamin'),
                          divide10,
                          const Text('Tempat, tanggal lahir'),
                          divide10,
                          const Text('Alamat'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(userDetail!.idUser!),
                          divide10,
                          Text(userDetail!.name!),
                          if (userDetail!.role == 'teacher') divide10,
                          if (userDetail!.role == 'teacher')
                            Text(userDetail!.major!),
                          divide10,
                          Text(userDetail!.phone ?? 'Belum Diatur'),
                          divide10,
                          Text(userDetail!.gender ?? 'Belum Diatur'),
                          divide10,
                          Text(placeDateBirth ?? 'Belum Diatur'),
                          // Text('${userDetail!.placeBirth}, $dateBirth' ??
                          //     'Belum Diatur'),
                          divide10,
                          Text(userDetail!.address ?? 'Belum Diatur'),
                        ],
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
