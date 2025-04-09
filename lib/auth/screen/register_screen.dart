import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_attendance_mobile_teacher/auth/bloc/auth_bloc.dart';
import 'package:lab_attendance_mobile_teacher/component/background.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/illustration/illustration_widget.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/component/rsa_algorithm.dart';
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
  TextEditingController pinController = TextEditingController();
  bool enableRegisterButton = false;
  bool isLoading = false;
  String selectedMajor = 'TKR';
  List<String> majors = ['TKR', 'TKJ', 'RPL', 'Akuntansi'];

  AuthUserBloc? authUserBloc;
  Files? photoProfile;
  String gender = 'Laki-laki';
  RsaAlgorithm rsaAgorithm = RsaAlgorithm();

  @override
  void initState() {
    rsaAgorithm.initializeRSA();
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
            if (state is NoInternetConnectionState) {
              isLoading = false;
              return IllustrationWidget(
                type: IllustrationWidgetType.notConnection,
                onButtonTap: () {
                  register();
                },
              );
            } else {
              return buildView();
            }
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
              showToastError(state.message);
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
              divide32,
              const Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              divide24,
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: [
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
                      prefixIcon: const Icon(Icons.lock_rounded),
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
                      prefixIcon: const Icon(Icons.lock_rounded),
                    ),
                    CustomTextField(
                      label: 'PIN',
                      isPassword: true,
                      showPassword: true,
                      validator: requiredValidator,
                      textInputAction: TextInputAction.next,
                      controller: pinController,
                      hintText: 'PIN',
                      prefixIcon: const Icon(Icons.pin_rounded),
                      isNumber: true,
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
    body['nip'] = rsaAgorithm.onEncrypt(nipController.text);
    body['name'] = rsaAgorithm.onEncrypt(nameController.text);
    body['major'] = rsaAgorithm.onEncrypt(selectedMajor);
    body['email'] = rsaAgorithm.onEncrypt(emailController.text);
    body['password'] = rsaAgorithm.onEncrypt(passwordController.text);
    body['pin'] = rsaAgorithm.onEncrypt(pinController.text);
    body['role'] = 'teacher';
    body['gender'] = null;
    body['phone'] = null;
    body['place_birth'] = null;
    body['date_birth'] = null;
    body['address'] = null;
    body['file_path'] = null;

    log(body.toString());
    authUserBloc!.add(PostRegisterUserEvent(body));
  }
}
