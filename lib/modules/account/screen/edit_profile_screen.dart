import 'dart:developer';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/image_upload.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/component/svg_image.dart';
import 'package:lab_attendance_mobile_teacher/modules/account/bloc/account_bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/home/model/user_login_model/user_login_model.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileArgument {
  UserLoginModel? userLogin;
  EditProfileArgument({this.userLogin});
}

class EditProfileScreen extends StatefulWidget {
  final EditProfileArgument? argument;
  const EditProfileScreen({super.key, this.argument});

  static const String path = '/editProfile';
  static const String title = 'Edit Profil';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nisController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  TextEditingController adresssController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Files? photoProfile;
  List<ProfileComponent> listItem = [
    ProfileComponent(title: 'Data User', type: 'data_user'),
    ProfileComponent(title: 'Data Akun', type: 'data_account'),
  ];
  List<EditProfileComponent> listComponent = [];

  String selectedMajor = 'TKR';
  List<String> majors = ['TKR', 'TKJ', 'RPL', 'Akuntansi'];
  String gender = 'Laki-laki';

  bool isLoading = false;
  String? url;
  AccountBloc? accountBloc;

  @override
  void initState() {
    accountBloc = AccountBloc();
    if (widget.argument!.userLogin != null) {
      setInitial(widget.argument!.userLogin!);
    }
    super.initState();
  }

  setInitial(UserLoginModel user) {
    DateTime date = DateTime.parse(user.teacher!.dateBirth!);
    String birthDate = DateFormat('dd-MM-yyyy').format(date);
    nameController.text = user.teacher!.name!;
    placeBirthController.text = user.teacher!.placeBirth!;
    dateBirthController.text = birthDate;
    adresssController.text = user.teacher!.address!;
    phoneController.text = user.teacher!.phone!.substring(3);
    emailController.text = user.email!;
    selectedMajor = user.teacher!.major!;
    addressController.text = user.teacher!.address!;
    url = user.teacher!.filePath;
    gender = user.teacher!.gender == true ? 'Laki-laki' : 'Perempuan';
  }

  @override
  Widget build(BuildContext context) {
    log('url: $url');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            EditProfileScreen.title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          backgroundColor: Pallete.primary2,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
            child: BlocProvider(
          create: (context) => accountBloc!,
          child: BlocConsumer<AccountBloc, AccountState>(
            builder: (BuildContext context, state) {
              return buildView();
            },
            listener: (BuildContext context, Object? state) {
              if (state is UpdateUserAccountLoadingState) {
                log(state.toString());
                isLoading = true;
              } else if (state is UpdateUserAccountLoadedState) {
                log(state.toString());
                isLoading = false;
                Navigator.pop(context);
                Navigator.pop(context, true);
              } else if (state is UpdateUserAccountFailedState) {
                log(state.toString());
                isLoading = false;
              } else if (state is UpdateUserAccountErrorState) {
                log(state.toString());
                isLoading = false;
              }
            },
          ),
        )));
  }

  Widget buildView() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ListView(
                  padding: const EdgeInsets.only(
                      top: 32, left: 16, right: 16, bottom: 16),
                  shrinkWrap: true,
                  children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 2),
                            borderRadius: BorderRadius.circular(100)),
                        child: ImageUpload(
                          file: photoProfile,
                          label: 'Foto Profil Resto',
                          isCircle: true,
                          isEdit: true,
                          url: url,
                          imageOnlyMode: true,
                          labelsize: 12,
                          aspectRatio: 1 / 1,
                          height: 150,
                          width: 150,
                          fixedCropRatio: CropAspectRatioPreset.square,
                          onUpload: (pickedFile) {
                            setState(() {
                              photoProfile = pickedFile;
                            });
                          },
                        ),
                      ),
                      const Positioned(
                        bottom: 13,
                        right: 13,
                        child: SvgImage(
                          'ic_edit_pencil.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                divide32,
                CustomTextField(
                  validator: validateLetterOnly,
                  controller: nameController,
                  hintText: 'Nama',
                  textInputAction: TextInputAction.next,
                  label: 'Nama',
                ),
                const Text(
                  'Jurusan',
                  style: TextStyle(fontSize: 12),
                ),
                divide6,
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Pallete.borderTexField),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  value: selectedMajor,
                  items: majors.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMajor = value!;
                    });
                  },
                  hint: const Text('Pilih jurusan'),
                  validator: (value) {
                    if (value == null || selectedMajor.isEmpty) {
                      return 'Tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                divide16,
                // if (selectedMajor.isNotEmpty)
                //   CustomTextField(
                //     label: 'Kelas',
                //     controller: classController,
                //     hintText: 'Kelas',
                //     textInputAction: TextInputAction.next,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Tidak boleh kosong';
                //       } else if (!classController.text
                //           .contains(selectedMajor)) {
                //         return 'Kelas tidak sesuai';
                //       }
                //       return null;
                //     },
                //   ),
                const Text('Jenis Kelamin'),
                Row(
                  children: [
                    radioGender('Laki-laki'),
                    divideW16,
                    radioGender('Perempuan'),
                  ],
                ),
                divide8,
                CustomTextField(
                  label: 'No Handphone',
                  prefixPhone: true,
                  validator: validateMobile,
                  controller: phoneController,
                  hintText: 'No Handphone',
                  isNumber: true,
                  textInputAction: TextInputAction.next,
                  limit: 12,
                ),
                // CustomTextField(
                //   label: 'Email',
                //   validator: requiredEmail,
                //   controller: emailController,
                //   hintText: 'Email',
                //   textInputAction: TextInputAction.next,
                // ),
                CustomTextField(
                  label: 'Tempat Lahir',
                  validator: validateLetterOnly,
                  controller: placeBirthController,
                  hintText: 'Tempat Lahir',
                  textInputAction: TextInputAction.next,
                ),
                CustomTextField(
                  label: 'Tanggal Lahir ',
                  validator: requiredValidator,
                  controller: dateBirthController,
                  hintText: 'Tanggal Lahir ',
                  readOnly: true,
                  suffixIcon: const Icon(Iconly.calendar),
                  onTap: () => changeDate(context,
                      controller: dateBirthController, isReverse: true),
                ),
                CustomTextField(
                  label: 'Alamat',
                  validator: validateAddress,
                  controller: addressController,
                  hintText: 'Alamat',
                  textInputAction: TextInputAction.next,
                ),
              ])),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Button(
                buttonColor: Pallete.border,
                width: double.infinity,
                text: 'Simpan',
                fontWeight: FontWeight.w600,
                isLoading: isLoading,
                press: () {
                  updateUser();
                }),
          )
        ],
      ),
    );
  }

  radioGender(String genderValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = genderValue;
        });
      },
      child: Row(
        children: [
          Radio(
            value: genderValue,
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),
          Text(genderValue)
        ],
      ),
    );
  }

  updateUser() {
    Map<String, dynamic> body = {};
    body['name'] = nameController.text;
    body['major'] = selectedMajor;
    if (gender == 'Laki-laki') {
      body['gender'] = true;
    } else {
      body['gender'] = false;
    }
    body['phone'] = '+62${phoneController.text}';
    // body['email'] = emailController.text;
    body['place_birth'] = placeBirthController.text;
    body['date_birth'] = dateBirthController.text;
    body['address'] = addressController.text;
    body['filePath'] = photoProfile == null ? url : photoProfile?.url;

    log(body.toString());
    accountBloc!.add(UpdateUserAccountEvent(
        params: body, idStudent: widget.argument!.userLogin!.teacher!.id));
  }
}

class ProfileComponent {
  String? title, type;

  ProfileComponent({this.title, this.type});
}

class EditProfileComponent {
  String? title, type;
  List<UserLoginModel>? userLogin;

  EditProfileComponent({this.title, this.userLogin});
}
