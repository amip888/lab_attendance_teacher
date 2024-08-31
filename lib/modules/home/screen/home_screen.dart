// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:lab_attendance_mobile_teacher/component/background.dart';
import 'package:lab_attendance_mobile_teacher/component/check_on_off_gps.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/history_attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/bloc/home_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/profile_shool_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/notification/screen/notification_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/screen/scedule_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:provider/provider.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String path = '/home';
  static const String title = 'Home';
  static late LatLng userLatLng;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SessionProvider sessionProvider;
  // RSAAlgorithmUtils rsaUtils = RSAAlgorithmUtils();
  // rsa.AsymmetricKeyPair<rsa.RSAPublicKey, rsa.RSAPrivateKey>? keyPair;

//   final publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
//  final privateKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');
//  final signer = Signer(RSASigner(RSASignDigest.SHA256, publicKey: publicKey, privateKey: privateKey));

//  print(signer.sign('hello world').base64);
//  print(signer.verify64('hello world', 'jfMhNM2v6hauQr6w3ji0xNOxGInHbeIH3DHlpf2W3vmSMyAuwGHG0KLcunggG4XtZrZPAib7oHaKEAdkHaSIGXAtEqaAvocq138oJ7BEznA4KVYuMcW9c8bRy5E4tUpikTpoO+okHdHr5YLc9y908CAQBVsfhbt0W9NClvDWegs='));

  HomeBloc? homeBloc;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late Position distancePosition;
  LatLng? userLatLng;
  LatLng? schoolLatLng;
  double? distance;
  bool isTooFar = true;
  double? maxDistante = 200.0; // DALAM SATUAN METER

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${imgList.indexOf(item)} image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  void initState() {
    homeBloc = HomeBloc();
    homeBloc!.add(GetUserLoginEvent());
    schoolLatLng = LatLng(-6.937893132288915, 107.73815975163151);
    checkGps();
    super.initState();
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    // keyPair = rsaUtils.generateKeyPair();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Pallete.primary,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    return GestureDetector(
      onTap: sessionProvider.sessionManager.resetSessionTimer,
      onPanUpdate: (details) =>
          sessionProvider.sessionManager.resetSessionTimer(),
      child: Scaffold(
          // appBar: AppBar(
          //   title: const Text(
          //     'Home',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          //   ),
          //   backgroundColor: Colors.red,
          //   actions: [
          //     // ChangeThemeButtonWidget(),

          //     IconButton(
          //         onPressed: () async {
          //           await sessionProvider.clearSession();
          //         },
          //         icon: const Icon(Icons.logout))
          //   ],
          //   centerTitle: true,
          //   leading: const SizedBox(),
          // ),
          body: SafeArea(
              child: BlocProvider(
        create: (context) => homeBloc!,
        child: BlocConsumer<HomeBloc, HomeState>(
          builder: (BuildContext context, state) {
            if (state is GetUserLoginLoadingState) {
              log('Get user loading');
              // return loading();
            } else if (state is GetUserLoginLoadedState) {
              log('Get user loaded');
              LocalStorageServices.setTeacherId(state.data.teacher!.id);
              return buildView(state.data, state.dataSchedule);
            } else if (state is GetUserLoginEmptyState) {
              log('Get user empty');
            } else if (state is GetUserLoginErrorState) {
              log('Get user error');
            }
            return Container();
          },
          listener: (BuildContext context, state) {},
        ),
      ))),
    );
  }

  Widget buildView(UserLoginModel userLogin, ScheduleModel schedulesModel) {
    return Stack(
      children: [
        const Background(
          isDashboard: true,
        ),
        // Container(
        //   height: 150,
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        //   width: double.infinity,
        //   color: Pallete.primary2,
        // ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NetworkImagePlaceHolder(
                    imageUrl: userLogin.teacher!.filePath,
                    width: 55,
                    height: 55,
                    isCircle: true,
                  ),
                  divideW10,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hallo ${userLogin.teacher!.name!}',
                          // 'Welcome back',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        divide4,
                        const Text('Welcome to Home',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, NotificationScreen.path);
                      },
                      child: const SvgImage('ic_notification.svg')),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                // padding: const EdgeInsets.only(top: 16),
                shrinkWrap: true,
                children: [
                  contentSlider(),
                  profileSchool(),
                  divide16,
                  titleHeader('Jadwal Praktikum'),
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 4),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      var item = schedulesModel.schedules![index];
                      DateTime initialDay = DateTime.parse(item.date!);
                      String formatDate = DateFormat('dd').format(initialDay);
                      String formatYear = DateFormat('yyyy').format(initialDay);
                      String dayName = formatDay(initialDay);
                      String monthName = formatMonth(initialDay);
                      String day =
                          '$dayName, $formatDate $monthName $formatYear';
                      String dayKey = DateFormat('EEEE').format(initialDay);
                      return cardSchedule(
                          name: item.teacher!.name,
                          image: item.teacher!.filePath,
                          day: day,
                          subject: item.subject,
                          roomLab: item.labRoom!.labName,
                          status: item.status,
                          Class: item.scheduleClass,
                          dayKey: dayKey,
                          item: item);
                    },
                  ),
                  titleHeader('Riwayat Absensi'),
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 4),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return cardAttendance(context);
                    },
                  ),
                ],
              ),
            ),
            // Container(
            //   height: 500,
            //   decoration: BoxDecoration(
            //       color: Pallete.primary2.withOpacity(0.8),
            //       borderRadius: BorderRadius.circular(15)),
            //   child: GridView.count(
            //     physics: const NeverScrollableScrollPhysics(),
            //     primary: false,
            //     padding: const EdgeInsets.all(20.0),
            //     crossAxisSpacing: 20.0,
            //     mainAxisSpacing: 20,
            //     crossAxisCount: 2,
            //     children: [
            //       Container(
            //           decoration: BoxDecoration(
            //               color: Colors.amber,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: const Icon(Icons.person)),
            //       Container(
            //           decoration: BoxDecoration(
            //               color: Colors.red,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: const Icon(Icons.person)),
            //       Container(
            //           decoration: BoxDecoration(
            //               color: Colors.blue,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: const Icon(Icons.person)),
            //       Container(
            //           decoration: BoxDecoration(
            //               color: Colors.indigo,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: const Icon(Icons.person)),
            //       Container(
            //           decoration: BoxDecoration(
            //               color: Colors.purple,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: const Icon(Icons.person)),
            //       Container(
            //           decoration: BoxDecoration(
            //               color: Colors.orange,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: const Icon(Icons.person)),
            //     ],
            //   ),
            // )
          ],
        ),
      ],
    );
    //   Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       ElevatedButton(
    //         onPressed: () {
    //           String message = 'Hello, RSA!';
    //           Uint8List encryptedMessage = rsaUtils.encrypt(message, keyPair!.publicKey);
    //           print('Encrypted Message: ${encryptedMessage.toString()}');
    //         },
    //         child: Text('Encrypt Message'),
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           String message = 'Hello, RSA!';
    //           Uint8List encryptedMessage = rsaUtils.encrypt(message, keyPair!.publicKey);
    //           String decryptedMessage = rsaUtils.decrypt(encryptedMessage, keyPair!.privateKey);
    //           print('Decrypted Message: $decryptedMessage');
    //         },
    //         child: Text('Decrypt Message'),
    //       ),
    //     ],
    //   ),
    // ),
    // SingleChildScrollView(
    //   padding: const EdgeInsets.all(10),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       divide64,
    //       Container(
    //         padding: const EdgeInsets.only(top: 16, right: 12, left: 12),
    //         decoration: BoxDecoration(
    //             color: Pallete.primary2.withOpacity(0.8),
    //             borderRadius: BorderRadius.circular(12)),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const Text(
    //               'Daftar Jadwal Praktikum',
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             ),
    //             divide8,
    //             ListView.builder(
    //               shrinkWrap: true,
    //               physics: const NeverScrollableScrollPhysics(),
    //               itemCount: 3,
    //               itemBuilder: (BuildContext context, int index) {
    //                 var item = schedulesModel.schedules![index];
    //                 DateTime initialDay = DateTime.parse(item.date!);
    //                 String formatDate = DateFormat('dd').format(initialDay);
    //                 String formatYear =
    //                     DateFormat('yyyy').format(initialDay);
    //                 String dayName = formatDay(initialDay);
    //                 String monthName = formatMonth(initialDay);
    //                 String day =
    //                     '$dayName, $formatDate $monthName $formatYear';
    //                 String dayKey = DateFormat('EEEE').format(initialDay);
    //                 return cardSchedule(
    //                     name: item.teacher!.name,
    //                     image: item.teacher!.filePath,
    //                     day: day,
    //                     subject: item.subject,
    //                     roomLab: item.labRoom!.labName,
    //                     status: item.status,
    //                     Class: item.scheduleClass,
    //                     dayKey: dayKey,
    //                     item: item);
    //               },
    //             ),
    //             const Text(
    //               'Riwayat Absensi',
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             ),
    //             divide8,
    //             ListView.builder(
    //               shrinkWrap: true,
    //               physics: const NeverScrollableScrollPhysics(),
    //               itemCount: 3,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return cardAttendance(context);
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //       // Container(
    //       //   height: 500,
    //       //   decoration: BoxDecoration(
    //       //       color: Pallete.primary2.withOpacity(0.8),
    //       //       borderRadius: BorderRadius.circular(15)),
    //       //   child: GridView.count(
    //       //     physics: const NeverScrollableScrollPhysics(),
    //       //     primary: false,
    //       //     padding: const EdgeInsets.all(20.0),
    //       //     crossAxisSpacing: 20.0,
    //       //     mainAxisSpacing: 20,
    //       //     crossAxisCount: 2,
    //       //     children: [
    //       //       Container(
    //       //           decoration: BoxDecoration(
    //       //               color: Colors.amber,
    //       //               borderRadius: BorderRadius.circular(15)),
    //       //           child: const Icon(Icons.person)),
    //       //       Container(
    //       //           decoration: BoxDecoration(
    //       //               color: Colors.red,
    //       //               borderRadius: BorderRadius.circular(15)),
    //       //           child: const Icon(Icons.person)),
    //       //       Container(
    //       //           decoration: BoxDecoration(
    //       //               color: Colors.blue,
    //       //               borderRadius: BorderRadius.circular(15)),
    //       //           child: const Icon(Icons.person)),
    //       //       Container(
    //       //           decoration: BoxDecoration(
    //       //               color: Colors.indigo,
    //       //               borderRadius: BorderRadius.circular(15)),
    //       //           child: const Icon(Icons.person)),
    //       //       Container(
    //       //           decoration: BoxDecoration(
    //       //               color: Colors.purple,
    //       //               borderRadius: BorderRadius.circular(15)),
    //       //           child: const Icon(Icons.person)),
    //       //       Container(
    //       //           decoration: BoxDecoration(
    //       //               color: Colors.orange,
    //       //               borderRadius: BorderRadius.circular(15)),
    //       //           child: const Icon(Icons.person)),
    //       //     ],
    //       //   ),
    //       // )
    //     ],
    //   ),
    // ),
    //   ],
    // );
  }

  contentSlider() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 180,
        child: Expanded(
          child: CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 2.3,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: imgList.asMap().entries.map((entry) {
      //     return GestureDetector(
      //       onTap: () => _controller.animateToPage(entry.key),
      //       child: Container(
      //         width: 7,
      //         height: 7,
      //         margin:
      //             const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      //         decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             color: (Theme.of(context).brightness == Brightness.dark
      //                     ? Colors.white
      //                     : Colors.black)
      //                 .withOpacity(_current == entry.key ? 0.9 : 0.4)),
      //       ),
      //     );
      //   }).toList(),
      // ),
    ]);
  }

  profileSchool() {
    return Column(children: [
      Image.asset('assets/images/pngs/logo_smk_talaga.png', width: 90),
      divide16,
      divide8,
      RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            text:
                'SMK Negeri 1 Talaga adalah sekolah kejuruan negeri pertama di wilayah selatan Kab. Majalengka. Sekolah ini berdiri pada tahun 2006 dan berlokasi di desa Talagkulon, Talaga Kab... ',
            style: const TextStyle(),
            children: <TextSpan>[
              TextSpan(
                  text: 'Baca selengkapnya',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.blue.shade300),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        Navigator.pushNamed(context, ProfileSchoolScreen.path)
                  // Navigator.pushNamed(
                  //       context,
                  //       WebViewScreen.path,
                  //       arguments: WebViewArgument(
                  //           LocaleKeys.auth_tos.tr(), Environment.term),
                  //     )
                  ),
            ]),
      ),
    ]);
  }

  titleHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(color: Colors.white, height: 1.5, width: 50),
        divideW16,
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        divideW16,
        Container(color: Colors.white, height: 1.5, width: 50),
      ],
    );
  }

  cardSchedule(
      {day,
      subject,
      name,
      image,
      roomLab,
      status,
      Class,
      required String dayKey,
      required Schedule item}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ScheduleDetailScreen.path,
            arguments: ScheduleDetailArgument(
                dayKey: dayKey, day: day, schedule: item));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Pallete.border),
            borderRadius: BorderRadius.circular(12),
            color: Pallete.primary2),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImagePlaceHolder(
                  imageUrl: image,
                  isRounded: true,
                  borderRadius: BorderRadius.circular(100),
                  width: 40,
                  height: 40,
                ),
                divideW10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      divide4,
                      Text(
                        subject,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: status == true ? Colors.green : Colors.red,
                  ),
                  child: Text(
                    status == true ? 'Aktif' : 'Belum Aktif',
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            // divide8,
            // Container(
            //   color: Pallete.border,
            //   width: double.infinity,
            //   height: 1.5,
            // ),
            // divide8,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('Hari/Tanggal'),
            //         Text('Mata Pelajaran'),
            //         Text('Kelas'),
            //       ],
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text(day),
            //         Text(subject),
            //         Text(Class),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  cardAttendance(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, HistoryAttendanceScreen.path);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Pallete.border),
            borderRadius: BorderRadius.circular(12),
            color: Pallete.primary2),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImagePlaceHolder(
                  imageUrl: 'image',
                  isRounded: true,
                  borderRadius: BorderRadius.circular(100),
                  width: 40,
                  height: 40,
                ),
                divideW10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sandi',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      divide4,
                      Text(
                        'Senin, 17 Juli 2024',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green,
                  ),
                  child: Text(
                    'Hadir',
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          log('Location permissions are permanently denied');
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });
        getLocation();
      }
    } else {
      OnOffGPS.checkOnOffGPS();
      log("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userLatLng = LatLng(position.latitude, position.longitude);
      log('lokasi user: $userLatLng');
      HomeScreen.userLatLng = userLatLng!;
      if (schoolLatLng != null) {
        setDistance();
      }
    });
  }

  setDistance() {
    log('SET DISTANCE LOADED');
    setState(() {
      distance =
          ((SphericalUtil.computeDistanceBetween(schoolLatLng!, userLatLng!) /
                      1000.0) *
                  1000)
              .ceilToDouble();
      if (distance! > maxDistante!) {
        isTooFar = true;
      } else {
        isTooFar = false;
      }
    });
    log(isTooFar.toString());
  }
}
