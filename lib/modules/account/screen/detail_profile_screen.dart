import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/edit_profile_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';

class DetailProfileArgument {
  UserLoginModel? userLogin;
  DetailProfileArgument({this.userLogin});
}

class DetailProfileScreen extends StatefulWidget {
  final DetailProfileArgument? argument;
  const DetailProfileScreen({super.key, this.argument});

  static const String path = '/DetailProfile';
  static const String title = 'Detail Profil';

  @override
  State<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  Files? photoProfile;
  List<ProfileItem> listItem = [];
  UserLoginModel? user;

  @override
  void initState() {
    user = widget.argument!.userLogin;
    DateTime date = DateTime.parse(user!.teacher!.dateBirth!);
    String birthDate = DateFormat('dd-MM-yyyy').format(date);
    listItem.addAll([
      ProfileItem(title: 'NIS', content: user!.teacher!.idUser),
      ProfileItem(title: 'Nama', content: user!.teacher!.name),
      ProfileItem(title: 'Jurusan', content: user!.teacher!.major),
      ProfileItem(title: 'No Handphone', content: user!.teacher!.phone),
      ProfileItem(
          title: 'Jenis Kelamin',
          content: user!.teacher!.gender! ? 'Laki-laki' : 'Perempuan'),
      ProfileItem(title: 'Tempat Lahir', content: user!.teacher!.placeBirth),
      ProfileItem(title: 'Tanggal Lahir', content: birthDate),
      ProfileItem(title: 'Alamat', content: user!.teacher!.address),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            DetailProfileScreen.title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          backgroundColor: Pallete.primary2,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Iconly.editSquare, size: 23),
              onPressed: () {
                Navigator.pushNamed(context, EditProfileScreen.path,
                    arguments: EditProfileArgument(userLogin: user));
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(100)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: NetworkImagePlaceHolder(
                    imageUrl: user!.teacher!.filePath,
                    width: 175,
                    height: 175,
                  ),
                ),
              ),
              divide32,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listItem.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = listItem[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.title!),
                              Text(item.content!),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ]),
          ),
        ));
  }
}

class ProfileItem {
  String? title, type, content;

  ProfileItem({this.title, this.content, this.type});
}
