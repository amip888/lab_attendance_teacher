// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:lab_attendance_mobile_teacher/home_page.dart';
// import 'package:lab_attendance_mobile_teacher/services/session/global_session_observer.dart';
// import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => SessionProvider()..loadSession(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late GlobalSessionObserver _globalSessionObserver;

//   @override
//   void initState() {
//     super.initState();
//     _globalSessionObserver = GlobalSessionObserver(
//         Provider.of<SessionProvider>(context, listen: false));
//     WidgetsBinding.instance.addObserver(_globalSessionObserver);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(_globalSessionObserver);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Consumer<SessionProvider>(
//         builder: (context, sessionProvider, child) {
//           if (sessionProvider.sessionToken == null) {
//             log('--sessioan time out');
//             return LoginPage();
//           } else {
//             return HomePage();
//           }
//         },
//       ),
//     );
//   }
// }

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final sessionProvider = Provider.of<SessionProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             // Simulasi login dan penyimpanan token sesi
//             await sessionProvider.saveSession('dummy_session_token');
//           },
//           child: Text('Login'),
//         ),
//       ),
//     );
//   }
// }

// Coding asli
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/routes_config.dart';
import 'package:lab_attendance_mobile_teacher/component/splash_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/session/global_session_observer.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';
import 'package:lab_attendance_mobile_teacher/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  // Memuat file .env sebelum menjalankan aplikasi
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  await initializeDateFormatting('id_ID', null);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(
        create: (_) => SessionProvider()..loadSession(),
      ),
    ], child: const LabAttendaanceMobileTeacher()),
  );
}

class LabAttendaanceMobileTeacher extends StatefulWidget {
  const LabAttendaanceMobileTeacher({super.key});

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

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              _resolved = true;
              initialMessage = value?.data.toString();
            },
          ),
        );
    getFcmToken();

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });

    globalSessionObserver = GlobalSessionObserver(
        Provider.of<SessionProvider>(context, listen: false));
    WidgetsBinding.instance.addObserver(globalSessionObserver);
  }

  getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      log('TOKEN FCM $token');
    } else {
      log('Token FCM null');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(globalSessionObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // return ChangeNotifierProvider(
    // create: (context) => ThemeProvider(),
    // child:
    return Consumer<ThemeProvider>(builder: (context, themeNotifier, child) {
      return MaterialApp(
        title: 'Absensi Lab Guru',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RoutesConfig.generateRoute,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.blue
                    // primary: Colors.blue
                    ))),
        darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Pallete.primary,
            appBarTheme: const AppBarTheme(backgroundColor: Pallete.primary),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style:
                    ElevatedButton.styleFrom(foregroundColor: Colors.indigo[900]
                        // primary: Colors.indigo[900]
                        )),
            primaryColor: Colors.blue),
        // themeMode: themeProvider.themeMode,
        themeMode: themeNotifier.themeMode,
        home: Consumer<SessionProvider>(
            builder: (context, sessionProvider, child) {
          if (sessionProvider.sessionToken == null) {
            log('--sessioan time out');
            // return const SchedulesScreen();
            return const LoginScreen();
          } else {
            return const SplashScreen();
          }
        }),
      );
    });
    // );
  }
}

// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';

// import 'pages/basics_example.dart';
// import 'pages/complex_example.dart';
// import 'pages/events_example.dart';
// import 'pages/multi_example.dart';
// import 'pages/range_example.dart';

// void main() {
//   initializeDateFormatting().then((_) => runApp(MyApp()));
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TableCalendar Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: StartPage(),
//     );
//   }
// }

// class StartPage extends StatefulWidget {
//   @override
//   _StartPageState createState() => _StartPageState();
// }

// class _StartPageState extends State<StartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TableCalendar Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               child: Text('Basics'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableBasicsExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Range Selection'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableRangeExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Events'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableEventsExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Multiple Selection'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableMultiExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Complex'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableComplexExample()),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
