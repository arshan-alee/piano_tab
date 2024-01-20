import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';
import 'package:paino_tab/screens/forgot_password.dart';
import 'package:paino_tab/screens/onboarding_screen.dart';
import 'package:paino_tab/screens/sign_up.dart';
import 'package:paino_tab/services/ad_mob_service.dart';
import 'package:paino_tab/utils/colors.dart';
import 'package:paino_tab/utils/widget.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FocusNode _email = FocusNode();
  final FocusNode _password = FocusNode();

  bool _emailFocused = false;
  bool _passwordFocused = false;
  bool isHide = true;
  bool emailError = false;
  bool passwordError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    _email.addListener(() {
      setState(() {
        _emailFocused = _email.hasFocus;
      });
      _password.addListener(() {
        setState(() {
          _passwordFocused = _password.hasFocus;
        });
      });
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.whiteColor,
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SkipButton(),
                SizedBox(
                  height: size.height * 0.06,
                ),
                TextWidget(
                    text: 'Welcome Back!',
                    color: MyColors.blackColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    onTap: () {}),
                TextWidget(
                  text: 'Login to your existent account',
                  color: MyColors.greyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                SizedBox(
                  height: size.height * 0.24,
                  child: Column(
                    children: [
                      CustomTextFormFeild(
                        error: emailError,
                        focusNode: _email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(_password);
                        },
                        obscureText: false,
                        validator: validateEmail,
                        autofocus: true,
                        prefixIcon: Icon(
                          Icons.mail,
                          size: 20,
                          color: _emailFocused
                              ? MyColors.whiteColor
                              : MyColors.lightGrey,
                        ),
                        hintText: 'Email',
                      ),
                      SizedBox(
                        height: size.height * 0.035,
                      ),
                      CustomTextFormFeild(
                        error: passwordError,
                        controller: passwordController,
                        autofocus: true,
                        obscureText: isHide,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            setState(() {
                              passwordError = true;
                            });
                            return 'Please enter 6 digit password';
                          }
                          setState(() {
                            passwordError = false;
                          });
                          return null;
                        },
                        focusNode: _password,
                        hintText: 'Password',
                        prefixIcon: Icon(
                          CupertinoIcons.lock_fill,
                          size: 20,
                          color: _passwordFocused
                              ? MyColors.whiteColor
                              : MyColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const ForgotPassword());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextWidget(
                        text: 'Forgot Password?',
                        color: MyColors.primaryColor,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomContainer(
                    onpressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var _ = await HomeController.to.login(
                            emailController.value.text.trim().toLowerCase(),
                            passwordController.value.text);
                        var _data = await HomeController.to.getuserData(
                            LoginBox.userBox!.values.first.authToken);
                        print(UserDataBox.userBox!.values.first.toJson());
                        if (_ && _data) {
                          await OfflineLibraryBox.setDefault();

                          await HomeController.to.setAdsWatched(0);
                          OfflineLibraryBox.updateIsLoggedIn(true);
                          var message = LoginBox.userBox!.values.first.message;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(message,
                                      textAlign: TextAlign.center),
                                  content: Text(
                                      ''), // Add any additional content here if needed
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              });
                          // Get.snackbar(message, '');
                          HomeController.to.index = 0;
                          Get.offAll(() => HomeScreen(
                                isLoggedIn: OfflineLibraryBox
                                    .userBox!.values.first.isLoggedIn,
                                initialIndex: 0,
                              ));

                          final userDataLibrary =
                              UserDataBox.userBox!.values.first.userDataLibrary;
                          final offlineLibrary = OfflineLibraryBox
                              .userBox!.values.first.offlineLibrary;

                          if (userDataLibrary != []) {
                            for (final item in userDataLibrary) {
                              if (!offlineLibrary.contains(item)) {
                                OfflineLibraryBox.updateLibrary(item);
                              }
                            }
                          }
                          print("Logged in ??");
                          print(OfflineLibraryBox
                              .userBox!.values.first.isLoggedIn);
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Invalid Credentials",
                                      textAlign: TextAlign.center),
                                  content: Text(
                                      ''), // Add any additional content here if needed
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              });
                          Get.snackbar("Invalid Credentials", '');
                        }
                      }
                    },
                    height: size.height * 0.07,
                    width: size.width * 0.4,
                    color: MyColors.primaryColor,
                    borderRadius: 40,
                    borderColor: MyColors.transparent,
                    borderWidth: 0,
                    boxShadow: [
                      BoxShadow(
                          color: MyColors.blueColor.withOpacity(0.1),
                          spreadRadius: 7,
                          blurRadius: 8)
                    ],
                    widget: const TextWidget(
                      text: 'LOG IN',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: size.height * 0.04,
                ),
                // TextWidget(
                //   text: 'or connect using',
                //   color: MyColors.greyColor,
                // ),
                // SizedBox(
                //   height: size.height * 0.04,
                // ),
                // const OtherSignIn(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Dont have an account? ',
                      fontWeight: FontWeight.w400,
                      color: MyColors.blackColor,
                    ),
                    TextWidget(
                      onTap: () {
                        Get.to(() => const SignUpScreen());
                      },
                      text: 'Sign up',
                      fontWeight: FontWeight.w400,
                      color: MyColors.primaryColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      setState(() {
        emailError = true;
      });
      return 'Enter a valid email address';
    }
    setState(() {
      emailError = false;
    });
    return null;
  }
}
