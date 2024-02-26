import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/colors.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void initState() {
    currentPassword.addListener(() {
      setState(() {
        currentPasswordFocused = currentPassword.hasFocus;
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

  ///Text Editing Controller///
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
//Focus Node//
  FocusNode currentPassword = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();

  ///bool//
  bool currentPasswordFocused = false;
  bool passwordFocused = false;
  bool confirmPasswordFocused = false;
  bool currentPasswordError = false;
  bool passwordError = false;
  bool confirmPasswordeError = false;
  bool isHide = true;
  bool isHide2 = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                  child: CustomAppBar(
                      action: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      title: 'Account')),
              Expanded(
                  flex: 9,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                        CustomTextFormFeild(
                            controller: currentPasswordController,
                            obscureText: isHide,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 6) {
                                setState(() {
                                  currentPasswordError = true;
                                });
                                return 'Please enter 6 digit password';
                              }
                              setState(() {
                                currentPasswordError = false;
                              });
                              return null;
                            },
                            focusNode: currentPassword,
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context).requestFocus(password);
                            },
                            autofocus: true,
                            hintText: 'Current Password',
                            error: passwordError,
                            prefixIcon: Icon(
                              CupertinoIcons.lock_fill,
                              size: 20,
                              color: currentPasswordFocused
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
                            controller: passwordController,
                            obscureText: isHide2,
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
                              FocusScope.of(context)
                                  .requestFocus(confirmPassword);
                            },
                            autofocus: true,
                            hintText: 'New Password',
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
                                  isHide2 = !isHide2;
                                });
                              },
                              child: Icon(
                                isHide2
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
                          focusNode: confirmPassword,
                          obscureText: isHide2,
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
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        CustomContainer(
                            onpressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                String currentPassword =
                                    currentPasswordController.text;
                                String newPassword = passwordController.text;

                                // Check if new password and confirm password match
                                if (newPassword !=
                                    confirmPasswordController.text) {
                                  // Passwords don't match
                                  Get.snackbar("Passwords donot match", '');
                                  return;
                                }

                                // Call your API for password change
                                var response = await HomeController.to
                                    .changepassword(
                                        LoginBox
                                            .userBox!.values.first.authToken,
                                        currentPassword,
                                        newPassword);

                                if (response['status'] == 'success') {
                                  // Password change successful
                                  Get.snackbar(response["message"], '');

                                  // Navigate back to login screen
                                  Navigator.of(context).pop();
                                } else {
                                  // Password change failed
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text(response['message']),
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
                                    },
                                  );
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
                              text: 'Save',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
