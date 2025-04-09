import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/bloc/lab_room_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/model/lab_room_model/lab_room_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/lab_room/screen/lab_room_detail_screen.dart';

class LabRoomsScreen extends StatefulWidget {
  const LabRoomsScreen({super.key});

  static const String path = '/roomLab';
  static const String title = 'Ruangan Lab';

  @override
  State<LabRoomsScreen> createState() => _LabRoomsScreenState();
}

class _LabRoomsScreenState extends State<LabRoomsScreen> {
  LabRoomBloc? labRoomBloc;

  @override
  void initState() {
    labRoomBloc = LabRoomBloc();
    labRoomBloc!.add(GetLabRoomEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            LabRoomsScreen.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Pallete.primary2,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: BlocProvider(
          create: (context) => labRoomBloc!,
          child: BlocConsumer<LabRoomBloc, LabRoomState>(
            builder: (BuildContext context, state) {
              if (state is GetLabRoomLoadingState) {
                return shimmerLabRoom();
              } else if (state is GetLabRoomLoadedState) {
                return buildView(state.data!);
              } else if (state is GetLabRoomEmptyState) {
                return IllustrationWidget(
                  type: IllustrationWidgetType.empty,
                  description: 'Data Ruangan Lab Kosong',
                );
              } else if (state is GetLabRoomErrorState) {
                return IllustrationWidget(
                  type: IllustrationWidgetType.error,
                  onButtonTap: () {
                    labRoomBloc!.add(GetLabRoomEvent());
                  },
                );
              } else if (state is NoInternetConnectionState) {
                return IllustrationWidget(
                  type: IllustrationWidgetType.notConnection,
                  onButtonTap: () {
                    labRoomBloc!.add(GetLabRoomEvent());
                  },
                );
              }
              return Container();
            },
            listener: (BuildContext context, Object? state) {},
          ),
        ));
  }

  buildView(LabRoomModel data) {
    return RefreshIndicator(
      backgroundColor: Pallete.background,
      color: Pallete.primary2,
      onRefresh: () async {
        labRoomBloc!.add(GetLabRoomEvent());
      },
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: data.labRoom!.length,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            var item = data.labRoom![index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LabRoomDetailScreen.path,
                    arguments: LabRoomDetailArgument(labRoom: item));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Pallete.primary2,
                    border: Border.all(color: Pallete.border, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    NetworkImagePlaceHolder(
                      imageUrl: item.labPhoto,
                      isCircle: true,
                      width: 50,
                      height: 50,
                    ),
                    divideW10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ruang ${item.labName!}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 8),
                              height: 2,
                              width: double.infinity,
                              color: Pallete.border),
                          Row(
                            children: [
                              const Text('Jam Operasional: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  )),
                              Text(
                                  '${item.openTime!.substring(0, 5)} - ${item.closeTime!.substring(0, 5)} WIB',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }

  shimmerLabRoom() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Pallete.primary2,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Blink(width: 50, height: 50, isCircle: true),
                divideW10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Blink(width: 100, height: 20),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, right: 8),
                          height: 2,
                          width: double.infinity,
                          color: Colors.grey.shade300),
                      const Row(
                        children: [Blink(width: 225, height: 20)],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
