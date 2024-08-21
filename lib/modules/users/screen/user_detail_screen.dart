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
  String dateBirth = '';

  @override
  void initState() {
    userDetail = widget.argument!.userDetail;
    if (userDetail!.gender == true) {
      gender = 'Laki-laki';
    } else {
      gender = 'Perempuan';
    }
    DateTime dateBirthFormat = DateTime.parse(userDetail!.dateBirth!);
    dateBirth = DateFormat('dd-MM-yy').format(dateBirthFormat);
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
        padding:
            const EdgeInsets.only(top: 40, right: 16, left: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: NetworkImagePlaceHolder(
                    imageUrl: userDetail!.filePath,
                    width: 150,
                    height: 150,
                  )),
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
                          divide10,
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
                          divide10,
                          Text(userDetail!.major!),
                          divide10,
                          Text(userDetail!.phone!),
                          divide10,
                          Text(gender),
                          divide10,
                          Text('${userDetail!.placeBirth!}, $dateBirth'),
                          divide10,
                          Text(userDetail!.address!),
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
