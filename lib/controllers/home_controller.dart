import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  Future<bool?> getSpData() async {
    final prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool('isLoggedIn');
    return isLoggedIn;
  }

  Future<bool?> loginSpData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    return null;
  }

  Future<bool?> logoutSpData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    return null;
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('UserName');
    return userName;
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('Email');
    return email;
  }

  Future<String?> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('UserName', userName);
    return null;
  }

  Future<String?> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Email', email);
    return null;
  }

  String emailAddress = '';
  String userName = '';

  PageController homePageController = PageController(initialPage: 0);
  int index = 0;
}
