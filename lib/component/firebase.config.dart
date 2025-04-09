// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/login_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/routes_config.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/screen/notification_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/navigator_key.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseConfig {
  RoutesConfig routeConfig = RoutesConfig();
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
  static initFirebaseRequest() async {
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    messaging.onTokenRefresh.listen((event) {});

    if (token != null) {
      log('TOKEN FCM $token');
      LocalStorageServices.setTokenFCM(token);
    } else {
      log('Token null');
    }

    NotificationSettings notifSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static initConfigure() async {
    log('INITIALIZING FIREBASE MESSAGING');
    final FlutterLocalNotificationsPlugin localNotification =
        FlutterLocalNotificationsPlugin();

    var androidSettings = const AndroidInitializationSettings(
      'mipmap/ic_launcher',
    ); // <- default icon name is @mipmap/ic_launcher
    // var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var settings =
        InitializationSettings(android: androidSettings, macOS: null);

    FirebaseMessaging.instance
        .subscribeToTopic('lab_attendance_teacher')
        .then((value) {
      log('Berhasil berlangganan ke topik lab_attendance_teacher');
    }).catchError((error) {
      log('Error berlangganan topik: $error');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('on clicked background');
      log('NOTIF BACKGROUND: ${message.data}');

      // await handleNotification(message.data,
      //     notification: message.notification as RemoteNotification);
      // await NotificationManager.handleNotification(
      //   message.data,
      //   notification: message.notification as RemoteNotification,
      // );
      bool isLogin = await LocalStorageServices.getIsLogin();
      if (isLogin) {
        navigatorKey.currentState?.pushNamed(
          NotificationScreen.path,
        );
      } else {
        navigatorKey.currentState?.pushNamed(LoginScreen.path);
      }

      // switch (type) {
      //       case 'RESERVATION':
      //         // case 'ORDER':
      //         // if (RouteObservers.routeName != OrderDetailScreen.path) {
      //         //   navigatorKey.currentState?.pushNamed(
      //         //       OrderDetailScreen.path,
      //         //       arguments: OrderDetailArgument(
      //         //           '', message.data['target_id']));
      //         // }
      //         // if (RouteManager.routesName != OrderDetailScreen.path) {
      //         //   navigatorKey.currentState?.pushNamed(
      //         //       OrderDetailScreen.path,
      //         //       arguments: OrderDetailArgument(
      //         //           '', message.data['target_id']));
      //         // }
      //         else {
      //           return;
      //         }
      //         break;
      //       case 'CHAT':
      //         if (RouteObservers.routeName != '/chat/main') {
      //           navigatorKey.currentState?.push(MaterialPageRoute(
      //             builder: (_) => MaxChatTree(
      //               isLogin: true,
      //               apiKey: Environment.apikey,
      //               endpointApi: Environment.endpointCust,
      //               currentUserId: userId,
      //               messageGateWay: Environment.messageGateWay,
      //               fileGateWay: Environment.fileGateWay,
      //               accessToken: accessToken,
      //               isChatMainScreen: true,
      //               socket: SocketApi().socket,
      //               endpointMerchant: Environment.endpointApi,
      //               roomId: message.data['chat_room_id'],
      //               targetId: message.data['sender_id'],
      //             ),
      //             settings: const RouteSettings(name: '/chat/main'),
      //           ));
      //         } else {
      //           return;
      //         }
      //         break;
      //       case 'FOLLOWER':
      //         if (RouteObservers.routeName != FollowerScreen.path) {
      //           navigatorKey.currentState
      //               ?.pushNamed(FollowerScreen.path);
      //         }
      //         // if (RouteManager.routesName != FollowerScreen.path) {
      //         //   navigatorKey.currentState
      //         //       ?.pushNamed(FollowerScreen.path);
      //         // }
      //         else {
      //           return;
      //         }
      //         break;
      //       case 'WAITER_CALL':
      //         if (RouteObservers.routeName != WaiterCallScreen.path) {
      //           navigatorKey.currentState
      //               ?.pushNamed(WaiterCallScreen.path);
      //         } else {
      //           return;
      //         }
      //       default:
      //     }
    });

    localNotification.initialize(
      settings,
      // onSelectNotification: (payload) =>
      //     Fcm.selectNotification(context, payload),
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data['target_app'] == 'lab_attendance_teacher_app') {
        log('Notifikasi untuk aplikasi guru diterima');
      }
      log('on clicked foreground');
      log('NOTIF FOREGROUND: ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      BigPictureStyleInformation? bigPictureStyleInformation;

      if (message.notification!.android!.imageUrl != null) {
        final String largeIconPath = await _downloadAndSaveFile(
            '${message.notification!.android!.imageUrl}', 'largeIcon');
        final String bigPicturePath = await _downloadAndSaveFile(
            '${message.notification!.android!.imageUrl}', 'bigPicture');

        bigPictureStyleInformation = BigPictureStyleInformation(
            FilePathAndroidBitmap(bigPicturePath),
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            htmlFormatContent: true,
            htmlFormatSummaryText: true,
            summaryText: message.notification!.body);
      }

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              'high_importance_channel', 'Lab Attendance',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
              playSound: true,
              styleInformation: bigPictureStyleInformation);

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      if (notification != null) {
        localNotification.show(notification.hashCode, notification.title,
            notification.body, platformChannelSpecifics,
            payload: jsonEncode(message.data));

        String userId = await LocalStorageServices.getUserId();
        if (notification != null) {
          localNotification.show(notification.hashCode, notification.title,
              notification.body, platformChannelSpecifics,
              payload: jsonEncode(message.data));

          localNotification.initialize(
            settings,
            onDidReceiveNotificationResponse:
                (NotificationResponse notificationResponse) async {
              navigatorKey.currentState?.pushNamed(
                NotificationScreen.path,
              );

              // String accessToken = await LocalStorageServices.getAccessToken();
              // switch (notificationResponse.notificationResponseType) {
              //   case NotificationResponseType.selectedNotification:
              //     log('selectedNotification');
              //     String type = message.data['type'];
              //     switch (type) {
              //       case 'RESERVATION':
              //         // case 'ORDER':
              //         // if (RouteObservers.routeName != OrderDetailScreen.path) {
              //         //   navigatorKey.currentState?.pushNamed(
              //         //       OrderDetailScreen.path,
              //         //       arguments: OrderDetailArgument(
              //         //           '', message.data['target_id']));
              //         // }
              //         // if (RouteManager.routesName != OrderDetailScreen.path) {
              //         //   navigatorKey.currentState?.pushNamed(
              //         //       OrderDetailScreen.path,
              //         //       arguments: OrderDetailArgument(
              //         //           '', message.data['target_id']));
              //         // }
              //         else {
              //           return;
              //         }
              //         break;
              //       case 'CHAT':
              //         if (RouteObservers.routeName != '/chat/main') {
              //           navigatorKey.currentState?.push(MaterialPageRoute(
              //             builder: (_) => MaxChatTree(
              //               isLogin: true,
              //               apiKey: Environment.apikey,
              //               endpointApi: Environment.endpointCust,
              //               currentUserId: userId,
              //               messageGateWay: Environment.messageGateWay,
              //               fileGateWay: Environment.fileGateWay,
              //               accessToken: accessToken,
              //               isChatMainScreen: true,
              //               socket: SocketApi().socket,
              //               endpointMerchant: Environment.endpointApi,
              //               roomId: message.data['chat_room_id'],
              //               targetId: message.data['sender_id'],
              //             ),
              //             settings: const RouteSettings(name: '/chat/main'),
              //           ));
              //         } else {
              //           return;
              //         }
              //         break;
              //       case 'FOLLOWER':
              //         if (RouteObservers.routeName != FollowerScreen.path) {
              //           navigatorKey.currentState
              //               ?.pushNamed(FollowerScreen.path);
              //         }
              //         // if (RouteManager.routesName != FollowerScreen.path) {
              //         //   navigatorKey.currentState
              //         //       ?.pushNamed(FollowerScreen.path);
              //         // }
              //         else {
              //           return;
              //         }
              //         break;
              //       case 'WAITER_CALL':
              //         if (RouteObservers.routeName != WaiterCallScreen.path) {
              //           navigatorKey.currentState
              //               ?.pushNamed(WaiterCallScreen.path);
              //         } else {
              //           return;
              //         }
              //       default:
              //     }
              //     break;
              //   case NotificationResponseType.selectedNotificationAction:
              //     log('selectedNotificationAction');
              //     break;
              // }
            },
          );
        }
      }
    });
  }

  static void showNotification(BuildContext context, title, body) {
    final FlutterLocalNotificationsPlugin localNotification =
        FlutterLocalNotificationsPlugin();

    var androidSettings = const AndroidInitializationSettings(
      'mipmap/ic_launcher',
    );
    var settings =
        InitializationSettings(android: androidSettings, macOS: null);

    localNotification.initialize(
      settings,
      // onSelectNotification: (payload) =>
      //     Fcm.selectNotification(context, payload),
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'high_importance_channel',
      'lab_attendance_ID',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    localNotification.show(
      title.hashCode,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // static Future selectNotification(String? payload) async {
  //   NotificationManager.handleNotification(jsonDecode(payload!));
  // }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  // static _iosPermission() {
  //   _fcm.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }
}

Future<void> requestNotificationPermission() async {
  // var status = await Permission.notification.request();
  // if (status.isGranted) {
  // Permission is granted, show a notification
  // Fcm.showNotification();
  // }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

Future<void> handleNotification(Map<String, dynamic> data,
    {RemoteNotification? notification}) async {
  String userId = await LocalStorageServices.getUserId();
  String accessToken = await LocalStorageServices.getAccessToken();

  log('--------------------');
  log('title: ${notification?.title}');
  log('body: ${notification?.body}');
  log('data: $data');
  // log(data['code'].toString());
  // log(data['target_id']);
  log('--------------------');

  String type = data['type'];
  log(type);

  // switch (type) {
  //   case 'RESERVATION':
  //     if (RouteObservers.routeName != OrderDetailScreen.path) {
  //       navigatorKey.currentState?.pushNamed(OrderDetailScreen.path,
  //           arguments: OrderDetailArgument('', data['target_id']));
  //     } else {
  //       return;
  //     }
  //     break;
  //   case 'CHAT':
  //     log('routename: ${RouteObservers.routeName}');
  //     if (RouteObservers.routeName != '/chat/main') {
  //       final bolean =
  //           await navigatorKey.currentState?.push(MaterialPageRoute(
  //         builder: (_) => MaxChatTree(
  //           isLogin: true,
  //           apiKey: Environment.apikey,
  //           endpointApi: Environment.endpointCust,
  //           currentUserId: userId,
  //           messageGateWay: Environment.messageGateWay,
  //           fileGateWay: Environment.fileGateWay,
  //           accessToken: accessToken,
  //           isChatMainScreen: true,
  //           socket: SocketApi().socket,
  //           endpointMerchant: Environment.endpointApi,
  //           roomId: data['chat_room_id'],
  //           targetId: data['sender_id'],
  //         ),
  //         settings: const RouteSettings(name: '/chat/main'),
  //       ));
  //       if (bolean == true) {
  //         RouteManager().removeRoute('/chat/main');
  //       }
  //     }
  //     break;
  //   case 'FOLLOWER':
  //     if (RouteObservers.routeName != FollowerScreen.path) {
  //       navigatorKey.currentState?.pushNamed(FollowerScreen.path);
  //     } else {
  //       return;
  //     }
  //     break;
  //   case 'WAITER_CALL':
  //     if (RouteObservers.routeName != WaiterCallScreen.path) {
  //       navigatorKey.currentState?.pushNamed(WaiterCallScreen.path);
  //     } else {
  //       return;
  //     }
  //   default:
}

// if (data['type'] == 'order') {
//   // Navigator.pushNamed(context, OrderDetailScreen.path,
//   //     arguments: OrderDetailArgument(id: data['id']));
// }
// showToast('GROUP');
// }

class NotificationManager {
  static handleNotification(Map<String, dynamic> data,
      {RemoteNotification? notification}) async {
    String userId = await LocalStorageServices.getUserId();
    String accessToken = await LocalStorageServices.getAccessToken();

    log('--------------------');
    log('title: ${notification?.title}');
    log('body: ${notification?.body}');
    log('data: $data');
    // log(data['code'].toString());
    // log(data['target_id']);
    log('--------------------');

    String type = data['type'];
    log(type);

    // switch (type) {
    //   case 'RESERVATION':
    //     if (RouteObservers.routeName != OrderDetailScreen.path) {
    //       navigatorKey.currentState?.pushNamed(OrderDetailScreen.path,
    //           arguments: OrderDetailArgument('', data['target_id']));
    //     } else {
    //       return;
    //     }
    //     break;
    //   case 'CHAT':
    //     log('routename: ${RouteObservers.routeName}');
    //     if (RouteObservers.routeName != '/chat/main') {
    //       final bolean =
    //           await navigatorKey.currentState?.push(MaterialPageRoute(
    //         builder: (_) => MaxChatTree(
    //           isLogin: true,
    //           apiKey: Environment.apikey,
    //           endpointApi: Environment.endpointCust,
    //           currentUserId: userId,
    //           messageGateWay: Environment.messageGateWay,
    //           fileGateWay: Environment.fileGateWay,
    //           accessToken: accessToken,
    //           isChatMainScreen: true,
    //           socket: SocketApi().socket,
    //           endpointMerchant: Environment.endpointApi,
    //           roomId: data['chat_room_id'],
    //           targetId: data['sender_id'],
    //         ),
    //         settings: const RouteSettings(name: '/chat/main'),
    //       ));
    //       if (bolean == true) {
    //         RouteManager().removeRoute('/chat/main');
    //       }
    //     }
    //     break;
    //   case 'FOLLOWER':
    //     if (RouteObservers.routeName != FollowerScreen.path) {
    //       navigatorKey.currentState?.pushNamed(FollowerScreen.path);
    //     } else {
    //       return;
    //     }
    //     break;
    //   case 'WAITER_CALL':
    //     if (RouteObservers.routeName != WaiterCallScreen.path) {
    //       navigatorKey.currentState?.pushNamed(WaiterCallScreen.path);
    //     } else {
    //       return;
    //     }
    //   default:
    // }

    // if (data['type'] == 'order') {
    //   // Navigator.pushNamed(context, OrderDetailScreen.path,
    //   //     arguments: OrderDetailArgument(id: data['id']));
    // }
    // showToast('GROUP');
  }
}
