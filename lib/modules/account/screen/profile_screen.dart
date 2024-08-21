import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/background.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_dialog_box.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/bloc/account_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/detail_profile_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/history_attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/screen/list_user_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';
import 'package:lab_attendance_mobile_teacher/theme/change_theme_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String path = '/profile';
  static const String title = 'Profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isValue = false;
  AccountBloc? accountBloc;
  Files? photoProfile;
  bool isDarkMode = false;

  @override
  void initState() {
    accountBloc = AccountBloc();
    accountBloc!.add(GetUserAccountEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Pallete.primary,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
        body: SafeArea(
            child: BlocProvider(
      create: (context) => accountBloc!,
      child: BlocConsumer<AccountBloc, AccountState>(
        builder: (BuildContext context, state) {
          if (state is GetUserAccountLoadingState) {
          } else if (state is GetUserAccountLoadedState) {
            photoProfile = Files(url: state.data!.teacher!.filePath);
            return buildView(state.data!);
          } else if (state is GetUserAccountEmptyState) {
          } else if (state is GetUserAccountErrorState) {}
          return Container();
        },
        listener: (BuildContext context, Object? state) {},
      ),
    )));
  }

  Widget buildView(UserLoginModel user) {
    return Stack(
      children: [
        const Background(
          isDashboard: true,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // IconButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       isDarkMode = !isDarkMode;
                    //     });
                    //   },
                    //   icon: Icon(
                    //     isDarkMode ? Icons.wb_sunny : Icons.nightlight,
                    //     color: isDarkMode ? Pallete.border : Pallete.primary,
                    //     size: 25,
                    //   ),
                    // ),
                    // divideW10,
                    GestureDetector(
                        onTap: () {
                          confirmLogout(context);
                        },
                        child: const SvgImage('ic_logout.svg')),
                  ],
                ),
                divide16,
                Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      border: Border.all(color: Pallete.border, width: 2.5),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: NetworkImagePlaceHolder(
                          imageUrl: photoProfile!.url,
                          width: 150,
                          height: 150,
                        ))),
                divide16,
                Text(
                  user.teacher!.name!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                divide16,
                Text(
                  user.teacher!.phone!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                divide48,
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.amber),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      componentProfile(
                          title: 'Detail Profil',
                          icon: 'assets/images/svgs/ic_edit_profile.svg',
                          onTap: () {
                            detailProfile(user);
                          },
                          isTop: true),
                      // const ChangeThemeButtonWidget(),
                      componentProfile(
                          title: 'Daftar Pengguna',
                          icon: 'assets/images/svgs/ic_edit_profile.svg',
                          onTap: () {
                            Navigator.pushNamed(context, ListUserScreen.path);
                          }),
                      componentProfile(
                          title: 'Riwayat Absensi',
                          icon: 'assets/images/svgs/ic_edit_profile.svg',
                          isBottom: true,
                          onTap: () {
                            Navigator.pushNamed(
                                context, HistoryAttendanceScreen.path);
                          }),
                      // componentProfile(
                      //     title: 'Jadwal Praktikum',
                      //     icon: 'assets/images/svgs/ic_history.svg',
                      //     onTap: () {
                      //       Navigator.pushNamed(context, SchedulesScreen.path);
                      //     }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  detailProfile(UserLoginModel user) async {
    var isUpdate = await Navigator.pushNamed(context, DetailProfileScreen.path,
        arguments: DetailProfileArgument(userLogin: user));

    if (isUpdate == true) {
      accountBloc!.add(GetUserAccountEvent());
    }
  }

  Widget componentProfile(
      {String? title,
      String? icon,
      Function()? onTap,
      bool isTop = false,
      bool isBottom = false}) {
    return InkWell(
      borderRadius: isTop
          ? const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))
          : isBottom
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))
              : BorderRadius.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              icon!,
            ),
            divideW10,
            Expanded(child: Text(title!)),
            IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.amber,
                  size: 20,
                )),
          ],
        ),
      ),
    );
  }

  confirmLogout(BuildContext context) {
    return showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return DialogBox(
          title: 'Logout',
          descriptions: 'Apakah anda yakin ingin logout?',
          onOkText: 'Ya, Logout',
          onCancleText: 'Batal',
          enableCancel: true,
          color: Pallete.border,
          onOkTap: () {
            LocalStorageServices.removeValues();
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.path, (route) => false);
          },
        );
      },
    );
  }
}
