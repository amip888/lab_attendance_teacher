import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lab_attendance_mobile_teacher/auth/bloc/auth_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/background.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/iconly.dart';
import 'package:lab_attendance_mobile_teacher/component/file_image/image_upload.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String path = '/register';
  static const String title = 'Register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  TextEditingController formatDateBirthController = TextEditingController();
  TextEditingController adresssController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool enableRegisterButton = false;
  bool isLoading = false;
  String selectedMajor = 'TKR';
  List<String> majors = ['TKR', 'TKJ', 'RPL', 'Akuntansi'];

  AuthUserBloc? authUserBloc;
  Files? photoProfile;
  String gender = 'Laki-laki';

  @override
  void initState() {
    authUserBloc = AuthUserBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocProvider(
        create: (context) => authUserBloc!,
        child: BlocConsumer<AuthUserBloc, AuthUserState>(
          builder: (BuildContext context, state) {
            return buildView();
          },
          listener: (BuildContext context, Object? state) {
            if (state is PostRegisterLoadingState) {
              log('register loading');
              isLoading = true;
            } else if (state is PostRegisterLoadedState) {
              log('register loaded');
              isLoading = false;
              showToast('Daftar User Berhasil');
              Navigator.pop(context);
            } else if (state is PostRegisterFailedState) {
              log('register failed: ${state.message}');
              showToastError(state.message);
              isLoading = false;
            } else if (state is PostRegisterErrorState) {
              log('register error');
              showToastError('Error');
              isLoading = false;
            }
          },
        ),
      )),
    );
  }

  Widget buildView() {
    return Stack(
      children: [
        const Background(
          isDashboard: false,
        ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            setState(() {
              enableRegisterButton = _formKey.currentState!.validate();
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      top: 50, left: 16, right: 16, bottom: 16),
                  children: [
                    const Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    divide32,
                    CustomTextField(
                      label: 'NIP',
                      validator: requiredValidator,
                      controller: nipController,
                      hintText: 'NIP',
                      isNumber: true,
                      textInputAction: TextInputAction.next,
                    ),
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
                            borderSide:
                                BorderSide(color: Pallete.borderTexField),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      value: selectedMajor,
                      items:
                          majors.map<DropdownMenuItem<String>>((String value) {
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
                    CustomTextField(
                      label: 'Email',
                      validator: requiredEmail,
                      controller: emailController,
                      hintText: 'Email',
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email_rounded),
                    ),
                    CustomTextField(
                      label: 'Password',
                      isPassword: true,
                      showPassword: true,
                      validator: requiredValidator,
                      textInputAction: TextInputAction.next,
                      controller: passwordController,
                      hintText: 'Password',
                    ),
                    CustomTextField(
                      label: 'Confirm Password',
                      isPassword: true,
                      showPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tidak boleh kosong';
                        } else if (value != passwordController.text) {
                          return 'Konfirmasi Password tidak sesuai';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                    ),
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
                          controller: dateBirthController,
                          formatDateController: formatDateBirthController),
                    ),
                    CustomTextField(
                      label: 'Alamat',
                      validator: validateAddress,
                      controller: addressController,
                      hintText: 'Alamat',
                      textInputAction: TextInputAction.next,
                    ),
                    ImageUpload(
                      file: photoProfile,
                      label: 'Foto profil',
                      aspectRatio: 1 / 1,
                      fixedCropRatio: CropAspectRatioPreset.square,
                      height: 200,
                      width: 200,
                      onUpload: (pickedFile) {
                        setState(() {
                          photoProfile = pickedFile;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Button(
                    buttonColor: Pallete.border,
                    width: double.infinity,
                    text: 'Daftar',
                    isLoading: isLoading,
                    press: enableRegisterButton && selectedMajor.isNotEmpty
                        ? () {
                            register();
                          }
                        : null),
              )
            ],
          ),
        ),
      ],
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

  register() {
    Map<String, dynamic> body = {};
    body['nip'] = nipController.text;
    body['name'] = nameController.text;
    body['major'] = selectedMajor;
    if (gender == 'Laki-laki') {
      body['gender'] = true;
    } else {
      body['gender'] = false;
    }
    body['phone'] = '+62${phoneController.text}';
    body['email'] = emailController.text;
    body['password'] = passwordController.text;
    body['role'] = 'teacher';
    body['place_birth'] = placeBirthController.text;
    body['date_birth'] = formatDateBirthController.text;
    body['address'] = addressController.text;
    body['filePath'] = photoProfile?.url;

    log(body.toString());
    authUserBloc!.add(PostRegisterUserEvent(body));
  }
}
