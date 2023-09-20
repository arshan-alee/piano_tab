import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/screens/login_screen.dart';

import '../utils/colors.dart';
import '../utils/widget.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode user = FocusNode();
  FocusNode email = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();

  bool userFocused = false;
  bool emailFocused = false;
  bool passwordFocused = false;
  bool confirmPasswordFocused = false;

  bool userError = false;
  bool emailError = false;
  bool passwordError = false;
  bool confirmPasswordeError = false;
  bool isHide = true;
  bool isHide2 = true;

  @override
  void initState() {
    user.addListener(() {
      setState(() {
        userFocused = user.hasFocus;
      });
    });
    email.addListener(() {
      setState(() {
        emailFocused = email.hasFocus;
      });
    });
    password.addListener(() {
      passwordFocused = password.hasFocus;
    });
    confirmPassword.addListener(() {
      setState(() {
        confirmPasswordFocused = confirmPassword.hasFocus;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    user.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SkipButton(),
              SizedBox(
                height: size.height * 0.06,
              ),
              TextWidget(
                text: 'Lets get started!',
                color: MyColors.blackColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              TextWidget(
                text: 'Create your own account for free',
                color: MyColors.greyColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              SizedBox(
                height: size.height * 0.5,
                child: Column(
                  children: [
                    CustomTextFormFeild(
                      controller: userNameController,
                      obscureText: false,
                      onFieldSubmitted: (p0) {
                        FocusScope.of(context).requestFocus(email);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            userError = true;
                          });
                          return 'Please enter user name';
                        }
                        setState(() {
                          userError = false;
                        });
                        return null;
                      },
                      focusNode: user,
                      autofocus: true,
                      hintText: 'User name',
                      error: userError,
                      prefixIcon: Icon(
                        Icons.person,
                        color: userFocused
                            ? MyColors.whiteColor
                            : MyColors.lightGrey,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    CustomTextFormFeild(
                      controller: emailController,
                      obscureText: false,
                      validator: validateEmail,
                      autofocus: true,
                      hintText: 'Email',
                      error: emailError,
                      focusNode: email,
                      onFieldSubmitted: (p0) {
                        FocusScope.of(context).requestFocus(password);
                      },
                      prefixIcon: Icon(
                        Icons.mail,
                        size: 20,
                        color: emailFocused
                            ? MyColors.whiteColor
                            : MyColors.lightGrey,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    CustomTextFormFeild(
                        controller: passwordController,
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
                        focusNode: password,
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(confirmPassword);
                        },
                        autofocus: true,
                        hintText: 'Password',
                        error: passwordError,
                        prefixIcon: Icon(
                          CupertinoIcons.lock_fill,
                          size: 20,
                          color: passwordFocused
                              ? MyColors.whiteColor
                              : MyColors.lightGrey,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isHide = !isHide;
                            });
                          },
                          child: Icon(
                            isHide
                                ? CupertinoIcons.eye_solid
                                : CupertinoIcons.eye_slash_fill,
                            color: MyColors.whiteColor,
                          ),
                        )),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    CustomTextFormFeild(
                        controller: confirmPasswordController,
                        obscureText: isHide2,
                        focusNode: confirmPassword,
                        validator: (value) {
                          if (value != passwordController.text) {
                            setState(() {
                              confirmPasswordeError = true;
                            });
                            return 'Password does not match!';
                          }
                          setState(() {
                            confirmPasswordeError = false;
                          });
                          return null;
                        },
                        autofocus: true,
                        hintText: 'Confirm Password',
                        error: confirmPasswordeError,
                        prefixIcon: Icon(
                          CupertinoIcons.lock_fill,
                          size: 20,
                          color: confirmPasswordFocused
                              ? MyColors.whiteColor
                              : MyColors.lightGrey,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isHide2 = !isHide2;
                            });
                          },
                          child: Icon(
                            isHide2
                                ? CupertinoIcons.eye_solid
                                : CupertinoIcons.eye_slash_fill,
                            color: MyColors.whiteColor,
                          ),
                        ))
                  ],
                ),
              ),
              // SizedBox(
              //   height: size.height * 0.02,
              // ),
              CustomContainer(
                  onpressed: () {
                    if (_formKey.currentState!.validate()) {
                      HomeController.to.loginSpData();
                      HomeController.to.setEmail(emailController.text);
                      HomeController.to.setUserName(userNameController.text);
                      HomeController.to.index = 0;
                      Get.offAll(() => const HomeScreen(
                            isLoggedIn: true,
                          ));
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
                    text: 'Create',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: 'Already have an account? ',
                    fontWeight: FontWeight.w400,
                    color: MyColors.blackColor,
                  ),
                  TextWidget(
                    onTap: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    text: 'Login here',
                    fontWeight: FontWeight.w400,
                    color: MyColors.primaryColor,
                  ),
                ],
              )
            ]),
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
