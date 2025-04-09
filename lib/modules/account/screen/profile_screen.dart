import 'dart:developer';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/background.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_dialog_box.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/rsa_algorithm.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/bloc/account_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/account_user_decrypted.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/detail_profile_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/history_attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/screen/list_user_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String path = '/profile';
  static const String title = 'Profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController pinController = TextEditingController();
  AccountBloc? accountBloc;
  Files? photoProfile;
  String? userId;
  RsaAlgorithm rsaAlgorithm = RsaAlgorithm();
  bool isDarkMode = false;
  bool isError = false;
  bool isDecrypt = false;
  UserAccountEncryptDecrypt? accountDecrypt;
  UserAccountEncryptDecrypt? accountEncrypt;

  @override
  void initState() {
    rsaAlgorithm.initializeRSA();
    loadData();
    accountBloc = AccountBloc();
    accountBloc!.add(GetUserAccountEvent());
    super.initState();
  }

  loadData() async {
    userId = await LocalStorageServices.getUserId();
    isDecrypt = await LocalStorageServices.getIsDecrypt();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Pallete.primary,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
        appBar: isError
            ? AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                        onTap: () {
                          confirmLogout(context);
                        },
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Pallete.border,
                        )),
                  ),
                ],
              )
            : null,
        body: SafeArea(
            child: BlocProvider(
          create: (context) => accountBloc!,
          child: BlocConsumer<AccountBloc, AccountState>(
            builder: (BuildContext context, state) {
              if (state is GetUserAccountLoadingState) {
                return shimmerProfile();
              } else if (state is GetUserAccountLoadedState) {
                loadData();
                if (isDecrypt) {
                  decryptData(state.data!);
                }
                // else {
                //   userModel = state.data;
                // }
                photoProfile = Files(url: state.data!.user!.teacher!.filePath);
                return buildView(state.data!);
              } else if (state is GetUserAccountEmptyState) {
              } else if (state is GetUserAccountErrorState) {
                return IllustrationWidget(
                    type: IllustrationWidgetType.error,
                    onButtonTap: () {
                      accountBloc!.add(GetUserAccountEvent());
                    });
              } else if (state is NoInternetConnectionState) {
                return IllustrationWidget(
                  type: IllustrationWidgetType.notConnection,
                  onButtonTap: () {
                    accountBloc!.add(GetUserAccountEvent());
                  },
                );
              }
              return Container();
            },
            listener: (BuildContext context, Object? state) {
              if (state is GetUserAccountErrorState) {
                setState(() {
                  isError = true;
                });
              } else if (state is PostPINLoadingState) {
              } else if (state is PostPINLoadedState) {
                pinController.clear();
                accountBloc!.add(GetUserAccountEvent());
                LocalStorageServices.setIsDecrypt(true);
                // LocalStorageServices.saveUserAccountDecrypted(accountDecrypt!);
              } else if (state is PostPINFailedState) {
                pinController.clear();
                showToastError(state.message);
              } else if (state is PostPINErrorState) {
                pinController.clear();
                showToastError(state.message);
              }
            },
          ),
        )));
  }

  decryptData(UserLoginModel data) async {
    // decryptData(UserAccountEncryptDecrypt data) async {
    log('masuk decrypt');

    String email,
        role,
        id,
        idUser,
        name,
        major,
        phone,
        placeBirth,
        dateBirth,
        address,
        filePath,
        gender;
    email = rsaAlgorithm.onDecrypt(data.user!.email!);
    role = data.user!.role!;
    id = data.user!.teacher!.id!;
    idUser = rsaAlgorithm.onDecrypt(data.user!.teacher!.idUser!);
    name = rsaAlgorithm.onDecrypt(data.user!.teacher!.name!);
    major = rsaAlgorithm.onDecrypt(data.user!.teacher!.major!);
    phone = data.user!.teacher!.phone != null
        ? rsaAlgorithm.onDecrypt(data.user!.teacher!.phone!)
        : 'Belum Diatur';
    placeBirth = data.user!.teacher!.placeBirth != null
        ? rsaAlgorithm.onDecrypt(data.user!.teacher!.placeBirth!)
        : 'Belum Diatur';
    dateBirth = data.user!.teacher!.dateBirth != null
        ? data.user!.teacher!.dateBirth!
        // ? rsaAlgorithm.onDecrypt(data.user!.teacher!.dateBirth!)
        : 'Belum Diatur';
    address = data.user!.teacher!.address != null
        ? rsaAlgorithm.onDecrypt(data.user!.teacher!.address!)
        : 'Belum Diatur';
    filePath = data.user!.teacher!.filePath != null
        ? rsaAlgorithm.onDecrypt(data.user!.teacher!.filePath!)
        : '';
    gender = data.user!.teacher!.gender != null
        ? rsaAlgorithm.onDecrypt(data.user!.teacher!.gender!)
        : 'Belum Diatur';
    // email = rsaAlgorithm.onDecrypt(data.email!);
    // role = rsaAlgorithm.onDecrypt(data.role!);
    // id = rsaAlgorithm.onDecrypt(data.id!);
    // idUser = rsaAlgorithm.onDecrypt(data.idUser!);
    // name = rsaAlgorithm.onDecrypt(data.name!);
    // phone = rsaAlgorithm.onDecrypt(data.phone!);
    // placeBirth = rsaAlgorithm.onDecrypt(data.placeBirth!);
    // dateBirth = rsaAlgorithm.onDecrypt(data.dateBirth!);
    // address = rsaAlgorithm.onDecrypt(data.address!);
    // filePath = rsaAlgorithm.onDecrypt(data.filePath!);
    // gender = rsaAlgorithm.onDecrypt(data.gender!);

    log('email decrypt: $email');

    accountDecrypt = UserAccountEncryptDecrypt(
      email: email,
      role: role,
      id: id,
      idUser: idUser,
      name: name,
      major: major,
      phone: phone,
      gender: gender,
      placeBirth: placeBirth,
      dateBirth: dateBirth,
      address: address,
      filePath: filePath,
    );
    // statePageView('loaded');
  }

  Widget buildView(UserLoginModel user) {
    if (isDecrypt == false) {
      showSnackbar(context);
      accountEncrypt = UserAccountEncryptDecrypt(
        email: user.user!.email!,
        role: user.user!.role,
        id: user.user!.teacher!.id,
        idUser: user.user!.teacher!.idUser,
        name: user.user!.teacher!.name,
        major: user.user!.teacher!.major,
        phone: user.user!.teacher!.phone,
        gender: user.user!.teacher!.gender,
        placeBirth: user.user!.teacher!.placeBirth,
        dateBirth: user.user!.teacher!.dateBirth,
        address: user.user!.teacher!.address,
        filePath: user.user!.teacher!.filePath,
      );
    }
    return Stack(
      children: [
        const Background(
          isDashboard: true,
        ),
        Positioned(
          top: 20,
          right: 20,
          width: 30,
          child: GestureDetector(
              onTap: () {
                confirmLogout(context);
              },
              child: const Icon(
                Icons.logout_rounded,
                color: Pallete.border,
              )),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      border: Border.all(color: Pallete.border, width: 2.5),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: NetworkImagePlaceHolder(
                      imageUrl: isDecrypt
                          ? accountDecrypt?.filePath
                          : photoProfile!.url,
                      // imageUrl: photoProfile!.url,
                      width: 150,
                      height: 150,
                      isCircle: true,
                    )),
                divide16,
                Text(
                  isDecrypt
                      ? accountDecrypt?.name ?? ''
                      : user.user!.teacher!.name!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                divide16,
                Text(
                  isDecrypt
                      ? accountDecrypt?.phone ?? ''
                      : user.user!.teacher!.phone ?? 'No HP Belum Diatur',
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
                          icon: 'assets/images/svgs/ic_profile_active.svg',
                          onTap: () {
                            detailProfile(
                                isDecrypt ? accountDecrypt! : accountEncrypt!);
                            // detailProfile(user);
                          },
                          isTop: true),
                      componentProfile(
                          title: 'Data Pengguna',
                          icon: 'assets/images/svgs/ic_list_users.svg',
                          onTap: () {
                            Navigator.pushNamed(context, ListUserScreen.path);
                          }),
                      componentProfile(
                          title: 'Jadwal Praktikum',
                          icon: 'assets/images/svgs/ic_calendar_active.svg',
                          onTap: () {
                            Navigator.pushNamed(context, SchedulesScreen.path);
                          }),
                      componentProfile(
                          title: 'Riwayat Absensi',
                          icon: 'assets/images/svgs/ic_history_attendance.svg',
                          isBottom: true,
                          onTap: () {
                            Navigator.pushNamed(
                                context, HistoryAttendanceScreen.path);
                          }),
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

  detailProfile(UserAccountEncryptDecrypt user) async {
    var isUpdate = await Navigator.pushNamed(context, DetailProfileScreen.path,
        arguments:
            DetailProfileArgument(userLogin: user, isDecrypt: isDecrypt));

    if (isUpdate == true) {
      accountBloc!.add(GetUserAccountEvent());
    }
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
        content: Row(
          children: [
            const Expanded(
              child: Text(
                'Untuk Mengakses Penuh Halaman Ini Silahkan Masukan PIN Anda',
                maxLines: 2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            divideW8,
            GestureDetector(
              onTap: () {
                inputPIN();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Pallete.border),
                child: const Text('Input PIN',
                    style: TextStyle(
                        fontSize: 12,
                        color: Pallete.primary,
                        fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 5));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  inputPIN() {
    return showDialog(
      useSafeArea: true,
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: DialogBox(
            title: 'Masukan PIN',
            descriptions:
                'Untuk Mengakses Penuh Halaman Ini Silahkan Masukan PIN Anda',
            descriptionsWidget: CustomTextField(
              label: 'PIN',
              textColor: Pallete.primary,
              borderColor: Pallete.primary,
              hintTextColor: Pallete.primary,
              isPassword: true,
              showPassword: true,
              validator: requiredValidator,
              controller: pinController,
              hintText: 'Masukan PIN',
              prefixIcon: const Icon(Icons.lock_rounded),
              isNumber: true,
            ),
            onOkText: 'Kirim PIN',
            onCancleText: 'Tetap Lanjut',
            enableCancel: true,
            color: Pallete.border,
            onOkTap: () {
              isDecrypt = true;
              Navigator.pop(context);
              Map<String, dynamic> body = {};
              body['id_user'] = userId;
              body['pin'] = rsaAlgorithm.onEncrypt(pinController.text);
              accountBloc!.add(PostPINEvent(body));
            },
          ),
        );
      },
    );
  }

  shimmerProfile() {
    return Stack(
      children: [
        const Background(
          isDashboard: true,
        ),
        const Positioned(
            top: 20, right: 20, width: 30, child: Blink(height: 30, width: 30)),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300, width: 2.5),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: const Blink(
                      height: 150,
                      width: 150,
                      isCircle: true,
                    ),
                  ),
                  divide16,
                  const Blink(
                    height: 25,
                    width: 150,
                  ),
                  divide16,
                  const Blink(
                    height: 25,
                    width: 200,
                  ),
                  divide48,
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        componentShimmerProfile(),
                        componentShimmerProfile(),
                        componentShimmerProfile(),
                        componentShimmerProfile(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  componentShimmerProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          const Blink(
            height: 25,
            width: 25,
          ),
          divideW10,
          const Expanded(
            child: Blink(
              height: 25,
              width: 25,
            ),
          ),
          divideW64,
          const Blink(
            height: 25,
            width: 25,
          ),
        ],
      ),
    );
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
