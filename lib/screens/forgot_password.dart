import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode otpFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  bool emailError = false;
  bool otpError = false;
  bool newPasswordError = false;
  bool confirmPasswordError = false;

  bool isHide = true;
  bool isPasswordHide = true;
  bool isConfirmPasswordHide = true;

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _confirmPasswordFormKey = GlobalKey<FormState>();

  bool showOtpInput = false;
  bool isCountdownActive = false;

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
                  title: 'Forgot Password',
                ),
              ),
              Expanded(
                flex: 9,
                child: Form(
                  key: _emailFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      CustomTextFormFeild(
                        controller: emailController,
                        focusNode: emailFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              emailError = true;
                            });
                            return 'Please enter your email';
                          }
                          setState(() {
                            emailError = false;
                          });
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (_emailFormKey.currentState!.validate()) {
                            setState(() {
                              showOtpInput = true;
                            });
                            // Call your API for sending OTP here
                            // You can show OTP input field after receiving OTP
                          }
                        },
                        hintText: 'Email',
                        error: emailError,
                        prefixIcon: Icon(
                          Icons.mail,
                          size: 20,
                          color: emailFocus.hasFocus
                              ? MyColors.whiteColor
                              : MyColors.lightGrey,
                        ),
                        autofocus: true,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      CustomContainer(
                        onpressed: () async {
                          String email = emailController.text.trim();
                          Map<String, dynamic> response =
                              await HomeController.to.forgotpassword(email);
                          var status = response["status"];
                          if (_emailFormKey.currentState != null &&
                              _emailFormKey.currentState!.validate() &&
                              status == "success" &&
                              !isCountdownActive) {
                            setState(() {
                              showOtpInput = true;
                              isCountdownActive =
                                  true; // Start the countdown timer
                            });

                            // Call your API for sending OTP here
                            // You can show OTP input field after receiving OTP

                            // Call API to send email and print the message to console
                          }

                          Get.snackbar(response["message"], '');
                        },
                        height: size.height * 0.07,
                        width:
                            !showOtpInput ? size.width * 0.4 : size.width * 0.5,
                        color: isCountdownActive
                            ? MyColors.darkGrey
                            : MyColors.primaryColor,
                        borderRadius: 40,
                        borderColor: MyColors.transparent,
                        borderWidth: 0,
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.blueColor.withOpacity(0.1),
                            spreadRadius: 7,
                            blurRadius: 8,
                          )
                        ],
                        widget: !showOtpInput
                            ? TextWidget(
                                text: 'Send OTP',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: 'Resend OTP',
                                    fontSize: isCountdownActive ? 12 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  isCountdownActive
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            CountdownTimer(
                                              endTime: DateTime.now()
                                                      .millisecondsSinceEpoch +
                                                  60000,
                                              onEnd: () async {
                                                setState(() {
                                                  isCountdownActive =
                                                      false; // Countdown ended, reset status
                                                });
                                              },
                                              textStyle: TextStyle(
                                                fontSize: 12,
                                                color: MyColors.whiteColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Visibility(
                        visible: showOtpInput,
                        child: Form(
                          key: _otpFormKey,
                          child: Column(
                            children: [
                              CustomTextFormFeild(
                                controller: otpController,
                                focusNode: otpFocus,
                                obscureText: isHide,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      otpError = true;
                                    });
                                    return 'Please enter OTP';
                                  }
                                  setState(() {
                                    otpError = false;
                                  });
                                  return null;
                                },
                                hintText: 'Enter OTP',
                                error: otpError,
                                prefixIcon: Icon(
                                  CupertinoIcons.lock_fill,
                                  size: 20,
                                  color: otpFocus.hasFocus
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
                                ),
                                autofocus: true,
                              ),
                              SizedBox(
                                height: size.height * 0.025,
                              ),
                              CustomTextFormFeild(
                                controller: newPasswordController,
                                focusNode: newPasswordFocus,
                                obscureText: isPasswordHide,
                                validator: (value) {
                                  // Your password validation logic
                                },
                                hintText: 'New Password',
                                error: newPasswordError,
                                prefixIcon: Icon(
                                  CupertinoIcons.lock_fill,
                                  size: 20,
                                  color: newPasswordFocus.hasFocus
                                      ? MyColors.whiteColor
                                      : MyColors.lightGrey,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPasswordHide = !isPasswordHide;
                                    });
                                  },
                                  child: Icon(
                                    isPasswordHide
                                        ? CupertinoIcons.eye_solid
                                        : CupertinoIcons.eye_slash_fill,
                                    color: MyColors.whiteColor,
                                  ),
                                ),
                                autofocus: true,
                              ),
                              SizedBox(
                                height: size.height * 0.025,
                              ),
                              CustomTextFormFeild(
                                controller: confirmPasswordController,
                                focusNode: confirmPasswordFocus,
                                obscureText: isConfirmPasswordHide,
                                validator: (value) {
                                  // Your confirm password validation logic
                                },
                                hintText: 'Confirm Password',
                                error: confirmPasswordError,
                                prefixIcon: Icon(
                                  CupertinoIcons.lock_fill,
                                  size: 20,
                                  color: confirmPasswordFocus.hasFocus
                                      ? MyColors.whiteColor
                                      : MyColors.lightGrey,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isConfirmPasswordHide =
                                          !isConfirmPasswordHide;
                                    });
                                  },
                                  child: Icon(
                                    isConfirmPasswordHide
                                        ? CupertinoIcons.eye_solid
                                        : CupertinoIcons.eye_slash_fill,
                                    color: MyColors.whiteColor,
                                  ),
                                ),
                                autofocus: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Visibility(
                        visible: showOtpInput,
                        child: CustomContainer(
                          onpressed: () async {
                            if (_otpFormKey.currentState != null &&
                                _otpFormKey.currentState!.validate()) {
                              String otp = otpController.text;
                              String newPassword = newPasswordController.text;
                              String confirmPassword =
                                  confirmPasswordController.text;

                              // Check if passwords match
                              if (newPassword != confirmPassword) {
                                // Passwords don't match
                                Get.snackbar("Passwords don't match", '');
                                return;
                              }

                              // Call your API for password reset
                              Map<String, dynamic> response =
                                  await HomeController.to
                                      .resetpassword(otp, newPassword);

                              if (response['status'] == 'success') {
                                // Password reset successful
                                Get.snackbar(response["message"], '');

                                // Navigate back to login screen
                                Navigator.of(context).pop();
                              } else {
                                // Password reset failed
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
                              blurRadius: 8,
                            )
                          ],
                          widget: const TextWidget(
                            text: 'Verify',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
