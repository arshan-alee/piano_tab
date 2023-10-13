import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
  MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        onInit: () {
          Get.put(HomeController());
        },
        debugShowCheckedModeBanner: false,
        home: child,
      ),
      child: const SplashScreen(),
    );
  }
}
