import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/screens/login_screen.dart';
import 'package:paino_tab/screens/reset_password.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/colors.dart';
import '../utils/model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, required this.email});
  final String email;
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<String> offlineLibrary =
      OfflineLibraryBox.userBox!.values.first.offlineLibrary;
  final List<String> favrites =
      OfflineLibraryBox.userBox!.values.first.favourites;
  List<ListItemModel> owned = [];
  List<ListItemModel> favourites = [];
  bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Get the userLibrary once and store it.
    final userLibrary = HomeController.to.getLibraryData(offlineLibrary);
    final fav = HomeController.to.getLibraryData(favrites);

    setState(() {
      owned = HomeController.to.itemModellList(songs: userLibrary);
      favourites = HomeController.to.itemModellList(songs: fav);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (OfflineLibraryBox.userBox!.values.first.isLoggedIn == true) {
      return loggedInView(size);
    } else {
      return notLoggedInView(size);
    }
  }

  Widget loggedInView(Size size) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CustomAppBar(
                  action: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  title: 'Account'),
              Expanded(
                  flex: 1,
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
                          height: size.height * 0.13,
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
                              text: 'Owned Songs & Books',
                              color: MyColors.blackColor,
                              fontSize: 22,
                            ),
                            TextWidget(
                              text: 'See all',
                              color: MyColors.blueColor,
                              onTap: () {
                                Get.to(HomeScreen(
                                    isLoggedIn: isLoggedIn, initialIndex: 3));
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          height: 230.h,
                          width: size.width,
                          child: owned.isEmpty
                              ? Center(
                                  child: TextWidget(
                                    text: "You don't own anything right now",
                                    fontSize: 18,
                                    color: MyColors.grey,
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: size.width * 0.035,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      owned.length < 5 ? owned.length : 5,
                                  itemBuilder: (context, index) =>
                                      RecentReleasedWidget(list: owned[index]),
                                ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'Wishlist',
                              color: MyColors.blackColor,
                              fontSize: 22,
                            ),
                            InkWell(
                              onTap: () {},
                              child: TextWidget(
                                text: 'See all',
                                color: MyColors.blueColor,
                                onTap: () {
                                  Get.to(HomeScreen(
                                      isLoggedIn: isLoggedIn, initialIndex: 3));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          height: 230.h,
                          width: size.width,
                          child: favourites.isEmpty
                              ? Center(
                                  child: TextWidget(
                                    text: 'Wishlist is empty',
                                    fontSize: 18,
                                    color: MyColors.grey,
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: size.width * 0.035,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: favourites.length < 5
                                      ? favourites.length
                                      : 5,
                                  itemBuilder: (context, index) =>
                                      RecentReleasedWidget(
                                          list: favourites[index]),
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

  Widget notLoggedInView(Size size) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CustomAppBar(
                  action: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  title: 'Account'),
              SizedBox(
                height: size.height * 0.06,
              ),
              TextWidget(
                text: 'You have to login\n           first!',
                fontSize: 26,
                color: MyColors.blackColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: "Don't have an account?",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: MyColors.greyColor,
                  ),
                  TextWidget(
                    onTap: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    text: 'Login',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: MyColors.primaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Image.asset('assets/images/library.png'),
            ],
          ),
        ),
      ),
    );
  }
}
