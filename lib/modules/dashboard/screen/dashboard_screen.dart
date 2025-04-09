import 'dart:async';
import 'package:lab_attendance_mobile_teacher/component/firebase.config.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/home_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_manager.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String path = '/dashboard';
  static const String title = 'Dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentTab = 0;
  DateTime? currentBackPressTime;

  List<BottomNavigationBarItem> navItems = [];
  final List<Widget> screen = [
    const HomeScreen(),
    const AttendanceScreen(),
    const ProfileScreen(),
  ];
  PageController? pageController;
  Timer? timer;

  void _onItemTapped(int index) {
    setState(() {
      currentTab = index;
      pageController!.jumpToPage(currentTab);
    });
  }

  @override
  void initState() {
    FirebaseConfig.initConfigure();
    pageController = PageController(initialPage: currentTab);
    getToken();
    super.initState();
  }

  getToken() async {
    String token = await LocalStorageServices.getAccessToken();
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    sessionManager.login(token);
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      sessionManager.checkTokenExpiry(
          context, token); // Redirect jika token expired
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    // sessionTimeoutManager
    //     .dispose(); // Pastikan untuk membatalkan timer saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    navItems = [
      BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset(
              'assets/images/svgs/ic_home_inactive.svg',
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset('assets/images/svgs/ic_home_active.svg'),
          ),
          label: 'Home'),
      const BottomNavigationBarItem(
          icon: SizedBox(
            height: 24,
            width: 24,
          ),
          label: 'Absensi'),
      BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset(
              'assets/images/svgs/ic_profile_inactive.svg',
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset('assets/images/svgs/ic_profile_active.svg'),
          ),
          label: 'Profil'),
    ];
    return Scaffold(
      body: WillPopScope(
          onWillPop: onExit,
          child: Stack(
            children: [
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: screen,
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          Navigator.pushNamed(context, AttendanceScreen.path,
              arguments: AttendanceArgument());
        },
        child: Stack(alignment: Alignment.center, children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Pallete.borderQrCode,
              border: Border.all(color: Pallete.border, width: 2),
            ),
          ),
          SvgPicture.asset(
            'assets/images/svgs/ic_scan_qrcode_active.svg',
            width: 25,
            height: 25,
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ]),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          child: BottomNavigationBar(
            backgroundColor: Pallete.primary2,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white,
            showSelectedLabels: true,
            selectedLabelStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
            ),
            elevation: 0.0,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: navItems,
            currentIndex: currentTab,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Future<bool> onExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Klik dua kali untuk keluar');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
