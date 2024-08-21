import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/component_filter.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/network_image_placeholder.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/shimmer.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/bloc/list_user_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/model/list_user_model/list_user_model.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/model/list_user_model/user.dart';
import 'package:lab_attendance_mobile_teacher/modules/users/screen/user_detail_screen.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({super.key});

  static const String path = '/listUser';
  static const String title = 'Daftar Pengguna';

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  ListUserBloc? listUserBloc;
  List<ComponentFilter> listFilters = [
    ComponentFilter(
        id: '1', title: 'Semua', color: Pallete.primary, isSelected: true),
    ComponentFilter(
        id: '2', title: 'Guru', color: Pallete.primary, isSelected: false),
    ComponentFilter(
        id: '3', title: 'Siswa', color: Pallete.primary, isSelected: false),
    ComponentFilter(
        id: '4', title: 'Operator', color: Pallete.primary, isSelected: false)
  ];
  List<ComponentFilter> filters = [];
  List<User> listUsers = [];
  // List<User> listUsersFiltered = [];
  List<UserDetail> listUsersFiltered = [];
  List<UserDetail> listUserDetail = [];
  String userFilter = '';
  // List<Attendance> listAttendance = [];
  // List<Attendance> listFilterAttendance = [];
  bool isLoading = false;

  @override
  void initState() {
    filters = listFilters;
    listUserDetail = listUsersFiltered;
    // listUsers = listUsersFiltered;
    listUserBloc = ListUserBloc();
    listUserBloc!.add(GetListUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(ListUserScreen.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 45),
              child: isLoading ? shimmerFilter() : buildFilter()),
        ),
        body: BlocProvider(
          create: (context) => listUserBloc!,
          child: BlocConsumer<ListUserBloc, ListUserState>(
            builder: (BuildContext context, state) {
              if (state is GetListUserLoadingState) {
                return loading();
              } else if (state is GetListUserLoadedState) {
                return buildView();
              } else if (state is GetListUserEmptyState) {
                return IllustrationWidget(
                  type: IllustrationWidgetType.empty,
                  description: 'Daftar Pengguna Kosong',
                );
              } else if (state is GetListUserErrorState) {
                log(state.message);
                return IllustrationWidget(
                  type: IllustrationWidgetType.error,
                  textButton: 'Muat Ulang',
                  onButtonTap: () {
                    listUserBloc!.add(GetListUserEvent());
                  },
                );
              }
              return Container();
            },
            listener: (BuildContext context, Object? state) {
              if (state is GetListUserLoadedState) {
                // listUsers.addAll(state.data.users!);
                for (var item in state.data.users!
                    .where((element) => element.teacher != null)) {
                  listUserDetail.add(UserDetail(
                    idUser: item.id,
                    email: item.email,
                    role: item.role,
                    id: item.teacher!.id,
                    name: item.teacher!.name,
                    gender: item.teacher!.gender,
                    major: item.teacher!.major,
                    phone: item.teacher!.phone,
                    placeBirth: item.teacher!.placeBirth,
                    dateBirth: item.teacher!.dateBirth,
                    filePath: item.teacher!.filePath,
                    address: item.teacher!.address,
                  ));
                }
                for (var item in state.data.users!
                    .where((element) => element.student != null)) {
                  listUserDetail.add(UserDetail(
                    idUser: item.id,
                    email: item.email,
                    role: item.role,
                    id: item.student!.id,
                    name: item.student!.name,
                    gender: item.student!.gender,
                    major: item.student!.major,
                    studentClass: item.student!.studentClass,
                    phone: item.student!.phone,
                    placeBirth: item.student!.placeBirth,
                    dateBirth: item.student!.dateBirth,
                    filePath: item.student!.filePath,
                    address: item.student!.address,
                  ));
                }
              }
            },
          ),
        ));
  }

  buildView() {
    if (listUsersFiltered.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listUsersFiltered.length,
        itemBuilder: (context, index) {
          var item = listUsersFiltered[index];
          return cardUser(context, item);
        },
      );
    } else {
      return IllustrationWidget(
        type: IllustrationWidgetType.empty,
        description: 'Data Pengguna $userFilter Kosong',
      );
    }
  }

  cardUser(BuildContext context, UserDetail user) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, UserDetailScreen.path,
            arguments: UserDetailArgument(userDetail: user));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Pallete.border),
            borderRadius: BorderRadius.circular(16),
            color: Pallete.primary2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImagePlaceHolder(
              imageUrl: user.filePath,
              isRounded: true,
              borderRadius: BorderRadius.circular(100),
              width: 50,
              height: 50,
            ),
            divideW10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  divide4,
                  Container(
                    color: Pallete.border,
                    width: double.infinity,
                    height: 1.5,
                  ),
                  divide4,
                  Text(
                    user.idUser!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            divideW16,
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green,
              ),
              child: Text(
                user.role!,
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        itemCount: filters.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var item = listFilters[index];
          return Row(children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  for (var component in listFilters) {
                    if (component.id == item.id) {
                      component.isSelected = true;
                      userFilter = component.title!;
                      switch (component.title) {
                        case 'Guru':
                          listUsersFiltered = listUserDetail
                              .where((element) => element.role == 'teacher')
                              .toList();
                          break;
                        case 'Siswa':
                          listUsersFiltered = listUserDetail
                              .where((element) => element.role == 'student')
                              .toList();
                          break;
                        case 'Operator':
                          listUsersFiltered = listUserDetail
                              .where((element) => element.role == 'operator')
                              .toList();
                          break;
                        default:
                          listUsersFiltered = listUserDetail;
                      }
                    } else {
                      component.isSelected = false;
                    }
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.border, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    color: item.isSelected ? Pallete.border : Pallete.primary),
                child: Text(
                  item.title!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  shimmerFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        itemCount: 5,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Blink(
              height: 20,
              width: 80,
            ),
          );
        },
      ),
    );
  }

  // Widget buildView(AllAttendancesModel data) {
  //   return SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: DataTable(
  //           headingTextStyle: const TextStyle(color: Colors.amber),
  //           dataTextStyle: const TextStyle(color: Colors.blue),
  //           decoration: const BoxDecoration(color: Colors.red),
  //           border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
  //           columns: const [
  //             DataColumn(label: Text('Nama')),
  //             DataColumn(label: Text('Jurusan')),
  //             DataColumn(label: Text('Kelas')),
  //             DataColumn(label: Text('Status Kehadiran')),
  //           ],
  //           rows: List.generate(data.attendanceTeacher!.length, (index) {
  //             var item = data.attendanceTeacher![index];
  //             return DataRow(
  //               color: const MaterialStatePropertyAll(Colors.amber),
  //               cells: <DataCell>[
  //                 DataCell(Text(item.idTeacher!)),
  //                 DataCell(Text(item.idSchedule!)),
  //                 DataCell(Text(item.statusAttendance!)),
  //                 DataCell(Text(item.createdAt.toString())),
  //               ],
  //             );
  //           })));
  // }
}

class UserDetail {
  String? id;
  String? idUser;
  String? name;
  String? studentClass;
  String? major;
  String? phone;
  bool? gender;
  String? placeBirth;
  String? dateBirth;
  String? address;
  String? filePath;
  String? email;
  String? role;

  UserDetail(
      {this.id,
      this.idUser,
      this.name,
      this.studentClass,
      this.major,
      this.phone,
      this.gender,
      this.placeBirth,
      this.dateBirth,
      this.address,
      this.filePath,
      this.email,
      this.role});
}
