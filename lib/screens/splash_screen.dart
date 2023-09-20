import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/screens/login_screen.dart';

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
    Future.delayed(const Duration(seconds: 9), () {
      HomeController.to.getSpData().then((value) {
        if (value == null || value == false) {
          Get.offAll(() => const LoginScreen());
        } else {
          Get.offAll(() => const HomeScreen(
                isLoggedIn: true,
              ));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: Lottie.asset(
        'assets/images/Pianotab_v2.json',
        repeat: false,
        height: size.height,
        reverse: false,
      ),
    );
  }
}
