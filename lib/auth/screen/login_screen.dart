import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab_attendance_mobile_teacher/auth/bloc/auth_bloc.dart';
import 'package:lab_attendance_mobile_teacher/auth/screen/register_screen.dart';
import 'package:lab_attendance_mobile_teacher/component/background.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/custom_text_field.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/modules/dashboard/screen/dashboard_screen.dart';
import 'package:lab_attendance_mobile_teacher/services/local_storage_services.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String path = '/login';
  static const String title = 'Login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailNipController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool enableRegisterButton = false;
  bool isLoading = false;
  bool isEmail = false;
  AuthUserBloc? authUserBloc;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    authUserBloc = AuthUserBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: onExit,
        child: SafeArea(
          child: BlocProvider(
              create: (context) => authUserBloc!,
              child: BlocConsumer<AuthUserBloc, AuthUserState>(
                builder: (BuildContext context, state) {
                  return buildView(context);
                },
                listener: (BuildContext context, Object? state) {
                  if (state is PostLoginLoadingState) {
                    log('login loading');
                    isLoading = true;
                  } else if (state is PostLoginLoadedState) {
                    log('login loaded');
                    isLoading = false;
                    LocalStorageServices.setUserId(state.authModel.user!.id);
                    LocalStorageServices.setAccessToken(state.authModel.token);
                    LocalStorageServices.setIsLogin(true);
                    sessionProvider.saveSession(state.authModel.token!);
                    Navigator.pushNamedAndRemoveUntil(
                        context, DashboardScreen.path, (route) => false);
                  } else if (state is PostLoginFailedState) {
                    log('login failed');
                    isLoading = false;
                    showToastError(state.message);
                  } else if (state is PostLoginErrorState) {
                    log('login error');
                    isLoading = false;
                    log(state.message);
                    showToastError(state.message);
                  }
                },
              )),
        ),
      ),
    );
  }

  Widget buildView(BuildContext context) {
    return Stack(
      children: [
        const Background(),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            setState(() {
              enableRegisterButton = _formKey.currentState!.validate();
            });
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  divide16,
                  CustomTextField(
                    label: isEmail ? 'Email' : 'NIP',
                    validator: isEmail ? requiredEmail : requiredValidator,
                    controller: emailNipController,
                    hintText: isEmail ? 'Email' : 'NIP',
                    prefixIcon: isEmail
                        ? const Icon(Icons.email_rounded)
                        : const Icon(Icons.person_rounded),
                    isNumber: isEmail ? false : true,
                  ),
                  CustomTextField(
                    label: 'Password',
                    isPassword: true,
                    showPassword: true,
                    validator: requiredValidator,
                    controller: passwordController,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_rounded),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          isEmail ? 'Dengan NIP' : 'Dengan Email',
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isEmail = !isEmail;
                            emailNipController.clear();
                          });
                        },
                      ),
                      divideW10
                    ],
                  ),
                  divide32,
                  Button(
                      buttonColor: Pallete.border,
                      isLoading: isLoading,
                      width: double.infinity,
                      text: 'Login',
                      fontWeight: FontWeight.w600,
                      press: enableRegisterButton
                          ? () {
                              login();
                            }
                          : null),
                  divide10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Lupa password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      divideW10
                    ],
                  ),
                  divide48,
                  Button(
                    color: Pallete.border,
                    text: 'Daftar',
                    fontWeight: FontWeight.w600,
                    press: () {
                      // Navigator.pushNamed(context, DashboardScreen.path);
                      Navigator.pushNamed(context, RegisterScreen.path);
                    },
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  login() {
    Map<String, dynamic> body = {};
    if (isEmail) {
      body['email'] = emailNipController.text;
    } else {
      body['nip'] = emailNipController.text;
    }
    body['password'] = passwordController.text;
    body['via'] = isEmail ? 'email' : 'nip';

    authUserBloc!.add(PostLoginUserEvent(body));
  }

  Future<bool> onExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Klik dua kali untuk keluar');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
