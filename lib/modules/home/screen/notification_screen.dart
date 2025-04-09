import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/modules/attendance/screen/attendance_screen.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/bloc/home_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/notification_model/notification.dart'
    as notif;
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const String path = '/notification';
  static const String title = 'Notifikasi';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  HomeBloc homeBloc = HomeBloc();
  List<NotificationComponent> listNotification = [];
  List<NotificationComponent> listNotificationNotDuplicate = [];
  String? userId, teacherId;

  @override
  void initState() {
    homeBloc.add(GetNotificationEvent());
    super.initState();
    loadData();
  }

  loadData() async {
    userId = await LocalStorageServices.getUserId();
    teacherId = await LocalStorageServices.getTeacherId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(NotificationScreen.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          backgroundColor: Pallete.primary2,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, true);
            return false;
          },
          child: BlocProvider(
              create: (context) => homeBloc,
              child: BlocConsumer<HomeBloc, HomeState>(
                builder: (BuildContext context, state) {
                  log(state.toString());
                  if (state is GetNotificationLoadingState) {
                    return shimmerNotification();
                  } else if (state is GetNotificationLoadedState) {
                    return buildView();
                  } else if (state is GetNotificationEmptyState) {
                    return IllustrationWidget(
                      type: IllustrationWidgetType.empty,
                      description: 'Notifikasi Kosong',
                    );
                  } else if (state is GetNotificationErrorState) {
                    return IllustrationWidget(
                      type: IllustrationWidgetType.error,
                      textButton: 'Muat Ulang',
                      onButtonTap: () {
                        homeBloc.add(GetNotificationEvent());
                      },
                    );
                  } else if (state is NoInternetConnectionState) {
                    return IllustrationWidget(
                      type: IllustrationWidgetType.notConnection,
                      onButtonTap: () {
                        homeBloc.add(GetNotificationEvent());
                      },
                    );
                  }
                  return Container();
                },
                listener: (BuildContext context, Object? state) {
                  if (state is GetNotificationLoadedState) {
                    listNotification.clear();
                    for (var item in state.data.notification!.where((element) =>
                        element.type == 'teacher' &&
                        element.idTeacher == teacherId)) {
                      if (item.users!.isNotEmpty) {
                        for (var element in item.users!) {
                          listNotification.add(NotificationComponent(
                              notification: item,
                              isRead: element.readNotification!.isRead!));
                        }
                        listNotificationNotDuplicate =
                            removeDuplicate(listNotification);
                        listNotificationNotDuplicate.sort((a, b) => b
                            .notification.createdAt!
                            .compareTo(a.notification.createdAt!));
                      } else {
                        listNotification
                            .add(NotificationComponent(notification: item));
                        listNotificationNotDuplicate =
                            removeDuplicate(listNotification);
                        listNotificationNotDuplicate.sort((a, b) => b
                            .notification.createdAt!
                            .compareTo(a.notification.createdAt!));
                      }
                    }
                  } else if (state is UpdateReadNotificationLoadedState) {
                    log('update notif loaded');
                  } else if (state is UpdateReadNotificationFailedState) {
                    log('update notif failed');
                  } else if (state is UpdateReadNotificationErrorState) {
                    log('update notif error');
                  }
                },
              )),
        ));
  }

  buildView() {
    if (listNotificationNotDuplicate.isNotEmpty) {
      return RefreshIndicator(
        backgroundColor: Pallete.background,
        color: Pallete.primary2,
        onRefresh: () async {
          listNotificationNotDuplicate.clear();
          homeBloc.add(GetNotificationEvent());
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listNotificationNotDuplicate.length,
          itemBuilder: (BuildContext context, int index) {
            var item = listNotificationNotDuplicate[index];
            String date = formatDayDate(item.notification.schedule!.date!);
            // String date = formatDayDate(item.notification.createdAt.toString());
            return GestureDetector(
              onTap: () {
                if (item.isRead != true) {
                  setState(() {
                    item.isRead = true;
                    updateReadNotification(
                        userId: userId!, notifId: item.notification.id!);
                  });
                }
                attendanceClick(itemNotif: item);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.border),
                    color: item.isRead ? Colors.transparent : Pallete.primary2,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NetworkImagePlaceHolder(
                      imageUrl: item.notification.teacher!.filePath,
                      width: 50,
                      height: 50,
                      isCircle: true,
                    ),
                    divideW10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.notification.title!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          divide4,
                          Text(
                            item.notification.description!,
                            style: const TextStyle(
                                fontSize: 13, overflow: TextOverflow.ellipsis),
                            maxLines: 2,
                          ),
                          divide12,
                          Text(
                            date,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            );
          },
        ),
      );
    } else {
      return IllustrationWidget(
        type: IllustrationWidgetType.empty,
        description: 'Notifikasi Kosong',
      );
    }
  }

  shimmerNotification() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Blink(
                  width: 50,
                  height: 50,
                  isCircle: true,
                ),
                divideW10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Blink(
                        width: 175,
                        height: 20,
                      ),
                      divide4,
                      const Blink(
                        width: 200,
                        height: 20,
                      ),
                      divide12,
                      const Blink(
                        width: 150,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<NotificationComponent> removeDuplicate(
      List<NotificationComponent> list) {
    // Set untuk menyimpan id unik
    Set<String> saveList = {};
    return list.where((element) {
      if (saveList.contains(element.notification.id)) {
        return false;
      } else {
        saveList.add(element.notification.id!);
        return true;
      }
    }).toList();
  }

  attendanceClick({required NotificationComponent itemNotif}) async {
    var attendance = await Navigator.pushNamed(context, AttendanceScreen.path,
        arguments: AttendanceArgument(
          isNotif: true,
          date: itemNotif.notification.schedule!.date,
          time: itemNotif.notification.schedule!.beginTime,
        ));
    if (attendance == true) {
      log('disini');
      homeBloc.add(GetNotificationEvent());
    }
  }

  updateReadNotification({required String userId, required String notifId}) {
    Map<String, dynamic> body = {};
    body['id_user'] = userId;
    body['id_notification'] = notifId;
    body['is_read'] = true;

    homeBloc.add(UpdateReadNotificationEvent(body: body));
  }
}

class NotificationComponent {
  notif.Notification notification;
  bool isRead;
  NotificationComponent({required this.notification, this.isRead = false});
}
