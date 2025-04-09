import 'dart:developer';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/account_user_decrypted.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/edit_profile_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';

class DetailProfileArgument {
  UserAccountEncryptDecrypt? userLogin;
  final bool isDecrypt;
  // UserLoginModel? userLogin;
  DetailProfileArgument({this.userLogin, this.isDecrypt = false});
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
  UserAccountEncryptDecrypt? user;
  // UserLoginModel? user;

  @override
  void initState() {
    user = widget.argument!.userLogin;
    log(user.toString());
    String? birthDate;
    if (user!.dateBirth != null && user!.dateBirth != 'Belum Diatur') {
      DateTime date = DateTime.parse(user!.dateBirth!);
      birthDate = DateFormat('dd-MM-yyyy').format(date);
    } else {
      birthDate = user!.dateBirth;
    }
    String placeDateBirth = '${user!.placeBirth}, $birthDate';
    String placeDateBirthUser = '';
    if (placeDateBirth.contains('null')) {
      placeDateBirthUser = 'Belum diatur';
    } else {
      placeDateBirthUser = placeDateBirth;
    }

    listItem.addAll([
      ProfileItem(title: 'NIP', content: user!.idUser),
      ProfileItem(title: 'Nama', content: user!.name),
      ProfileItem(title: 'Tempat, tanggal lahir', content: placeDateBirthUser),
      ProfileItem(
          title: 'Jenis Kelamin', content: user!.gender ?? 'Belum Diatur'),
      // ProfileItem(
      //     title: 'Jenis Kelamin',
      //     content: user!.gender == null
      //         ? 'Belum diatur'
      //         : user!.gender == true
      //             ? 'Laki-laki'
      //             : 'Perempuan'),
      ProfileItem(title: 'Jurusan', content: user!.major),
      ProfileItem(
          title: 'No Handphone', content: user!.phone ?? 'Belum Diatur'),
      ProfileItem(title: 'Alamat', content: user!.address ?? 'Belum Diatur'),
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
            if (widget.argument!.isDecrypt)
              IconButton(
                icon: const Icon(
                  Iconly.editSquare,
                  size: 23,
                  color: Colors.amber,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditProfileScreen.path,
                      arguments: EditProfileArgument(userLogin: user));
                },
              ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 2),
                      borderRadius: BorderRadius.circular(100)),
                  child: NetworkImagePlaceHolder(
                    imageUrl: user!.filePath,
                    width: 175,
                    height: 175,
                    isCircle: true,
                  ),
                ),
              ),
              divide64,
              const Text('Data Pengguna'),
              divide8,
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: listItem
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(e.title!),
                                ))
                            .toList(),
                      ),
                      divideW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listItem
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      e.content!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ))
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.amber),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: listItem.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       var item = listItem[index];
              //       return Column(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 8),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(item.title!),
              //                 Text(item.content ?? 'Belum diatur'),
              //               ],
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // )
            ]),
          ),
        ));
  }
}

class ProfileItem {
  String? title, type, content;

  ProfileItem({this.title, this.content, this.type});
}
