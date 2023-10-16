import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';
import 'package:paino_tab/screens/login_screen.dart';
import 'package:paino_tab/screens/reset_password.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/colors.dart';
import '../utils/model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, required this.userName, required this.email});
  final String userName;
  final String email;
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  flex: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'Basic Information',
                              color: MyColors.blackColor,
                              fontSize: 22,
                            ),
                            Transform.flip(
                              flipX: true,
                              child: InkWell(
                                onTap: () async {
                                  HomeController.to.logoutSpData();
                                  Get.offAll(() => const LoginScreen());
                                  await LoginBox.setDefault();
                                  await UserDataBox.setDefault();
                                  await OfflineLibraryBox.setDefault();
                                  print(
                                      "UserBox data after signout ${UserDataBox.userBox!.values.first.toJson()}");
                                  print(
                                      "Login data after signout ${LoginBox.userBox!.values.first.toJson()}");
                                  print(
                                      "Offline Library after signout ${OfflineLibraryBox.userBox!.values.first.toJson()}");
                                },
                                child: Icon(
                                  Icons.logout,
                                  color: MyColors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          height: size.height * 0.2,
                          width: size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: MyColors.darkBlue),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: MyColors.whiteColor,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  TextWidget(
                                    text: widget.userName,
                                    fontSize: 18,
                                  )
                                ],
                              ),
                              Divider(
                                color: MyColors.lightGrey,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.mail,
                                    color: MyColors.whiteColor,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  TextWidget(
                                    text: widget.email,
                                    fontSize: 18,
                                  )
                                ],
                              ),
                              Divider(
                                color: MyColors.lightGrey,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const ResetPassword());
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.arrow_2_circlepath,
                                      color: MyColors.whiteColor,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.05,
                                    ),
                                    const TextWidget(
                                      text: 'Reset your password',
                                      fontSize: 18,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'Owned song/books',
                              color: MyColors.blackColor,
                              fontSize: 22,
                            ),
                            TextWidget(
                              text: 'See all',
                              color: MyColors.blueColor,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          height: 230.h,
                          width: size.width,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              width: size.width * 0.035,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: albumList.length,
                            itemBuilder: (context, index) =>
                                RecentReleasedWidget(list: albumList[index]),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'Favorites',
                              color: MyColors.blackColor,
                              fontSize: 22,
                            ),
                            TextWidget(
                              text: 'See all',
                              color: MyColors.blueColor,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          height: 230.h,
                          width: size.width,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              width: size.width * 0.035,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: albumList.length,
                            itemBuilder: (context, index) =>
                                RecentReleasedWidget(list: albumList[index]),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
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
