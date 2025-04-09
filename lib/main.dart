import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab_attendance_mobile_teacher/component/firebase.config.dart';
import 'package:lab_attendance_mobile_teacher/component/routes_config.dart';
import 'package:lab_attendance_mobile_teacher/component/splash_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/session/global_session_observer.dart';
import 'package:lab_attendance_mobile_teacher/services/session/navigator_key.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_manager.dart';
import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   print('Handling a background message ${message.messageId}');
// }

// late AndroidNotificationChannel channel;

// bool isFlutterLocalNotificationsInitialized = false;

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           icon: 'launch_background',
//         ),
//       ),
//     );
//   }
// }

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  // Memuat file .env sebelum menjalankan aplikasi
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Permission.notification.isDenied.then((value) {
  //   if (value) {
  //     Permission.notification.request();
  //   }
  // },
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }

  runApp(
    ChangeNotifierProvider(
        create: (_) => SessionManager(), child: LabAttendaanceMobileTeacher()),
  );
}

class LabAttendaanceMobileTeacher extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  LabAttendaanceMobileTeacher({super.key});

  @override
  State<LabAttendaanceMobileTeacher> createState() =>
      _LabAttendaanceMobileTeacherState();
}

class _LabAttendaanceMobileTeacherState
    extends State<LabAttendaanceMobileTeacher> {
  late GlobalSessionObserver globalSessionObserver;

  String? _token;
  String? initialMessage;
  bool _resolved = false;

  @override
  initState() {
    super.initState();
    FirebaseConfig.initFirebaseRequest();
    // FirebaseMessaging.instance.getInitialMessage().then(
    //       (value) => setState(
    //         () {
    //           _resolved = true;
    //           initialMessage = value?.data.toString();
    //         },
    //       ),
    //     );
    // getFcmToken();

    // FirebaseMessaging.onMessage.listen(showFlutterNotification);

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   // Navigator.pushNamed(
    //   //   context,
    //   //   '/message',
    //   //   arguments: MessageArguments(message, true),
    //   // );
    // });

    globalSessionObserver = GlobalSessionObserver(
        Provider.of<SessionManager>(context, listen: false));
    WidgetsBinding.instance.addObserver(globalSessionObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(globalSessionObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Absensi Lab Guru',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: RoutesConfig.generateRoute,
        theme: ThemeData.dark(),
        home: const SplashScreen());
  }
}
