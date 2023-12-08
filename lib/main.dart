import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/LoginModel.dart';
import 'package:paino_tab/models/OfflineLibrary.dart';
import 'package:paino_tab/models/UserDataModel.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';
import 'package:paino_tab/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LoginModelAdapter());
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(OfflineLibraryAdapter());
  await Hive.openBox<LoginModel>("hiveuser");
  await Hive.openBox<UserData>("userdata");
  await Hive.openBox<OfflineLibrary>("offlineLibraryBox'");
  LoginBox.init();
  UserDataBox.init();
  OfflineLibraryBox.init();
  List<String> testDeviceIds = ['8C02E8645CDC75745523EA92A4D2B10C'];
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  MobileAds.instance.initialize();
  FlutterDownloader.initialize();
  final dir = Directory("storage/emulated/0/PianoTab");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await dir.exists())) {
    print("PianoTab directory exist");
  } else {
    print("PianoTab directory doesnot exist");
    dir.create();
  }
  runApp(const MyApp());
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
