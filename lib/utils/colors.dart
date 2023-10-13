import 'package:flutter/material.dart';

class MyColors {
  static LinearGradient gradient = LinearGradient(colors: [
    MyColors.tealColor,
    MyColors.primaryColor.withOpacity(0.8),
  ], begin: Alignment.topLeft, end: Alignment.bottomCenter);
  static Color tealColor = const Color(0xff0ce1ef);
  static Color primaryColor = const Color(0xff0586c0);
  static Color bottomColor = const Color(0xff0180c3);
  static Color darkBlue = const Color(0xff01619b);
  static Color whiteColor = const Color(0xffffffff);
  static Color grey = const Color(0xffd9d9d9);
  static Color darkGrey = const Color(0xff808080);
  static Color textGrey = const Color.fromARGB(255, 184, 182, 182);
  static Color blueColor = Colors.blue;
  static Color greyColor = const Color(0xffC0BBBB);
  static Color blackColor = const Color(0xff000000);
  static Color yellowColor = const Color(0xffffd863);
  static Color greenColor = const Color(0xff68ca87);
  static Color lightGrey = Colors.white60;
  static Color red = Colors.red;
  static Color transparent = Colors.transparent;
}
