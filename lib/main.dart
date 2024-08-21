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
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/routes_config.dart';
import 'package:lab_attendance_mobile_teacher/component/splash_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/session/global_session_observer.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';
import 'package:lab_attendance_mobile_teacher/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  @override
  void initState() {
    super.initState();
    globalSessionObserver = GlobalSessionObserver(
        Provider.of<SessionProvider>(context, listen: false));
    WidgetsBinding.instance.addObserver(globalSessionObserver);
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
