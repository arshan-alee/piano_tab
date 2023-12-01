import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/screens/login_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Get.put(HomeController());
    Future.delayed(
      const Duration(seconds: 5),
      () {
        HomeController.to.getSongs().then(
          (value) {
            if (HomeController.to.status.value == 0) {
              var userBox = LoginBox.userBox!;
              if (userBox.values.isEmpty) {
                Get.offAll(() => const LoginScreen());
              } else {
                if (userBox.values.first.authToken == '') {
                  Get.offAll(() => const LoginScreen());
                } else {
                  Get.offAll(() => HomeScreen(
                        isLoggedIn:
                            OfflineLibraryBox.userBox!.values.first.isLoggedIn,
                        initialIndex: 0,
                      ));
                }
              }

              // HomeController.to.getSpData().then(
              //   (value) {
              //     if (value == null || value == false) {
              //       Get.offAll(() => const LoginScreen());
              //     } else {
              //       Get.offAll(() => const HomeScreen(
              //             isLoggedIn: true,
              //           ));
              //     }
              //   },
              // );
            }
          },
        );
      },
    );
    super.initState();
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Los_Angeles'));
    scheduleDailyTask();
  }

  void scheduleDailyTask() {
    // Get the current time in the local time zone
    final now = tz.TZDateTime.now(tz.local);

    // Calculate the next day at 12 am PST
    final nextDay =
        tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, 0, 0);

    // Calculate the duration until the next day
    final duration = nextDay.difference(now);

    // Schedule a daily task at 12 am PST
    Timer(duration, () async {
      await OfflineLibraryBox.setDefault();
      scheduleDailyTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (HomeController.to.status.value == 1) {
          SystemNavigator.pop();
        }

        return false;
      },
      child: Scaffold(
          backgroundColor: MyColors.whiteColor,
          body: Stack(
            children: [
              Lottie.asset(
                'assets/images/Pianotab_v2.json',
                repeat: false,
                height: size.height,
                reverse: false,
              ),
              Obx(
                () => HomeController.to.status.value == 1
                    ? Container(
                        height: size.height,
                        width: size.width,
                        color: Colors.transparent.withOpacity(0.7),
                        child: AlertDialog(
                          elevation: 0,
                          content: const Text('No internet connection'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              child: const Text(
                                'OK',
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          )),
    );
  }
}
