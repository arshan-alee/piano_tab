import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paino_tab/models/OfflineLibrary.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';
import 'package:paino_tab/pages/search_page.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/screens/login_screen.dart';
import 'package:paino_tab/screens/onboarding_screen.dart';
import 'package:paino_tab/services/ad_mob_service.dart';
import 'package:paino_tab/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/home_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'colors.dart';
import 'model.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
  });
  final Widget? action;
  final String title;
  // final bool isLoggedIn;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  RewardedInterstitialAd? _rewardedAd;
  int userPoints = int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;
  int offlineUserPoints =
      int.tryParse(OfflineLibraryBox.userBox!.values.first.points) ?? 0;
  bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;

  @override
  void initState() {
    super.initState();
    createRewardedAd();
  }

  void createRewardedAd() {
    if (EasyLoading.isShow) {
      return;
    }
    EasyLoading.show(status: 'loading...');
    EasyLoading.dismiss();
    RewardedInterstitialAd.load(
      adUnitId: AdMobService.rewardedInterstitialAdUnitId!,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          setState(() {
            _rewardedAd = ad;
            print(' ad is loading');
            EasyLoading.dismiss();
          });
          await OfflineLibraryBox.updateAdsWatched(
              OfflineLibraryBox.userBox!.values.first.adsWatched + 1);
        },
        onAdFailedToLoad: (error) async {
          setState(() {
            _rewardedAd = null;
            EasyLoading.dismiss();
          });
          if (OfflineLibraryBox.userBox!.values.first.adsWatched < 10) {
            if (isLoggedIn == true) {
              int newPoints = userPoints + 1;
              await HomeController.to
                  .updatePoints(
                      LoginBox.userBox!.values.first.authToken, newPoints)
                  .then((pointsUpdated) async {
                var userdata = await HomeController.to
                    .getuserData(LoginBox.userBox!.values.first.authToken);
                print('Points updated in logged In mode');
                // Perform additional actions with userdata
              });
            } else {
              int newPoints = offlineUserPoints++;
              await OfflineLibraryBox.updatePoints(newPoints.toString());
              print('Points updated in logged off mode');
            }

            Get.snackbar(
                "Seems like the Ad failed to load but here's a token on us",
                'You have recieved a token');
          }
        },
      ),
    );
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: ((ad) {
        ad.dispose();
        createRewardedAd();
      }), onAdFailedToShowFullScreenContent: (((ad, error) {
        ad.dispose();
        createRewardedAd();
      })));

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) async {
          print("You earned a reward");

          // Your code to update points and user data

          if (isLoggedIn == true) {
            int newPoints = userPoints + 1;
            await HomeController.to
                .updatePoints(
                    LoginBox.userBox!.values.first.authToken, newPoints)
                .then((pointsUpdated) async {
              var userdata = await HomeController.to
                  .getuserData(LoginBox.userBox!.values.first.authToken);
              print('Points updated in logged In mode');
              // Perform additional actions with userdata
            });
          } else {
            int newPoints = offlineUserPoints++;
            await OfflineLibraryBox.updatePoints(newPoints.toString());
            print('Points updated in logged off mode');
          }
          Get.snackbar('You have recieved a token', "");
        },
      );
      _rewardedAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.action ??
                InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Image.asset(
                    'assets/images/menus.png',
                    height: 25,
                    color: MyColors.primaryColor,
                  ),
                ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                width: MediaQuery.of(context).size.width - 150,
                child: TextWidget(
                  text: widget.title,
                  color: MyColors.blackColor,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            CustomContainer(
                onpressed: () {
                  showAlertDialog(context, size);
                },
                height: size.height * 0.035,
                width: size.width * 0.145,
                color: MyColors.whiteColor,
                borderRadius: 40,
                borderColor: MyColors.primaryColor,
                borderWidth: 1.2,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo_2.png'),
                            maxRadius: 7.5,
                          ),
                          Container(
                            height: size.height * 0.025,
                            width: 1,
                            color: MyColors.primaryColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextWidget(
                        text: isLoggedIn
                            ? UserDataBox.userBox!.values.first.points
                            : OfflineLibraryBox.userBox!.values.first.points,
                        fontSize: 11,
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )),
          ],
        ),
        const Divider(
          thickness: 2,
        )
      ],
    );
  }

  Future<dynamic> showAlertDialog(BuildContext context, Size size) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyColors.whiteColor,
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Container(
          height: size.height * 0.5,
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
              color: MyColors.whiteColor,
              borderRadius: BorderRadius.circular(14)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextWidget(
                  text: 'Tokens',
                  fontSize: 24,
                  color: MyColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 12,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  height: size.height * 0.135,
                  width: size.width * 0.24,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/reward.png'))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: TextWidget(
                          text: isLoggedIn
                              ? UserDataBox.userBox!.values.first.points
                              : OfflineLibraryBox.userBox!.values.first.points,
                          color: MyColors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.016,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                CustomContainer(
                    onpressed: () {
                      if (OfflineLibraryBox.userBox!.values.first.adsWatched <
                          10) {
                        showRewardedAd();
                      } else {
                        Get.snackbar(
                            'You have reached the total Ads limit for today',
                            "");
                      }
                      // int newpoints = userPoints + 1;
                    },
                    height: size.height * 0.038,
                    width: size.width * 0.25,
                    color: MyColors.primaryColor,
                    borderRadius: 20,
                    borderColor: MyColors.transparent,
                    borderWidth: 0,
                    widget: const Center(
                      child: TextWidget(
                        text: 'Earn more',
                        fontSize: 12,
                      ),
                    )),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextWidget(
                  text: 'Welcome Missions',
                  fontSize: 18,
                  color: MyColors.blackColor,
                  fontWeight: FontWeight.w400,
                ),
                const Divider(
                  height: 12,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: Platform.isAndroid
                          ? 'Rate on Play Store'
                          : 'Rate on App Store',
                      fontSize: 14,
                      color: MyColors.primaryColor,
                    ),
                    CustomContainer(
                        onpressed: () {},
                        height: size.height * 0.035,
                        width: size.width * 0.15,
                        color: MyColors.whiteColor,
                        borderRadius: 40,
                        borderColor: MyColors.primaryColor,
                        borderWidth: 1.2,
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.circle_outlined,
                                    size: 18,
                                    color: MyColors.primaryColor,
                                  ),
                                  Container(
                                    height: size.height * 0.025,
                                    width: 1,
                                    color:
                                        MyColors.primaryColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextWidget(
                                text: '5',
                                fontSize: 12,
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: size.height * 0.055,
                ),
                CustomContainer(
                  onpressed: () {},
                  height: size.height * 0.04,
                  width: size.width * 0.4,
                  color: MyColors.primaryColor,
                  borderRadius: 40,
                  borderColor: MyColors.primaryColor,
                  borderWidth: 1.2,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RatingBarDialog();
                            },
                          );
                        },
                        child: TextWidget(
                          text: 'Rate Our App',
                          fontSize: 14,
                          color: MyColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingBarDialog extends StatefulWidget {
  @override
  _RatingBarDialogState createState() => _RatingBarDialogState();
}

class _RatingBarDialogState extends State<RatingBarDialog> {
  double rating = 0.0;
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    // Check if the user has already rated the app
    final double userRating =
        OfflineLibraryBox.userBox!.values.first.rating ?? 0.0;
    if (userRating > 0.0) {
      setState(() {
        rating = userRating;
        isSubmitted = true;
      });
    }
  }

  void submitRating(double rating) {
    // Save the rating, e.g., submit it to your server
    print("User has rated the app: $rating");

    // Update the user's rating in the OfflineLibraryBox
    OfflineLibraryBox.updateRating(rating);

    setState(() {
      isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rate This App"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              RatingBar.builder(
                unratedColor: Colors.grey,
                itemCount: 5,
                initialRating: rating, // Set initialRating
                allowHalfRating: true,
                glow: true,
                tapOnlyMode: true,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 255, 217, 0),
                ),
                onRatingUpdate: (val) {
                  setState(() {
                    rating = val;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              TextWidget(
                text: '$rating',
                fontSize: 16,
                color: MyColors.blackColor,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (!isSubmitted) // Display the "Submit" button if not submitted
            ElevatedButton(
              onPressed: () {
                // Call the function to submit the rating
                submitRating(rating);
              },
              child: const Text("Submit"),
            ),
          if (isSubmitted)
            TextWidget(
              text: "Thank you for rating our app!",
              fontSize: 16,
              color: MyColors.blackColor,
            ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  Function(String) onQueryChanged; // Callback function to pass the query

  CustomSearchDelegate(this.onQueryChanged);

  List<String> items = ['Alan Walker', 'Justin Bieber', 'Zayn', 'Drake'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: Icon(
            Icons.clear,
            color: MyColors.red,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(
          Icons.arrow_back,
          color: MyColors.blackColor,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var srch in items) {
      if (srch.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(srch);
      }
    }

    if (query.isNotEmpty) {
      onQueryChanged(query);
      close(context, null); // Pass the query to the SearchPage
    }

    return const SizedBox();
    // ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index];
    //     return ListTile(
    //       onTap: () {
    //         query = result;
    //       },
    //       title: TextWidget(
    //         text: result,
    //         color: MyColors.blackColor,
    //       ),
    //     );
    //   },
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var srch in items) {
      if (srch.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(srch);
      }
    }
    return const SizedBox();
    // ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index];
    //     return ListTile(
    //       onTap: () {
    //         query = result;
    //       },
    //       title: TextWidget(
    //         text: result,
    //         color: MyColors.blackColor,
    //       ),
    //     );
    //   },
    // );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomContainer(
            onpressed: () async {
              await LoginBox.setDefault();
              await UserDataBox.setDefault();
              await OfflineLibraryBox.setDefault();
              // HomeController.to.setEmail('');
              // HomeController.to.setUserName('');
              HomeController.to.index = 0;

              Get.offAll(() => const OnBoarding(
                    isLoggedIn: false,
                  ));
            },
            height: size.height * 0.035,
            width: size.width * 0.17,
            color: MyColors.primaryColor,
            borderRadius: 40,
            borderColor: MyColors.transparent,
            borderWidth: 0,
            boxShadow: [
              BoxShadow(
                  color: MyColors.blueColor.withOpacity(0.05),
                  spreadRadius: 7,
                  blurRadius: 8)
            ],
            widget: const TextWidget(
              text: 'Skip',
              fontSize: 12,
            )),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String passedVal;

  const FilterButton({super.key, required this.passedVal});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomContainer(
          onpressed: () {
            HomeController.to.selectedPage = passedVal;
            Scaffold.of(context).openEndDrawer();
          },
          height: size.height * 0.045,
          width: size.width * 0.27,
          color: MyColors.bottomColor,
          borderRadius: 40,
          borderColor: MyColors.transparent,
          borderWidth: 0,
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const TextWidget(text: 'Filter'),
              Icon(
                Icons.filter_alt_outlined,
                color: MyColors.whiteColor,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTextFormFeild extends StatelessWidget {
  const CustomTextFormFeild(
      {super.key,
      this.controller,
      this.focusNode,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      required this.obscureText,
      required this.validator,
      this.keyboardType,
      required this.autofocus,
      this.onFieldSubmitted,
      required this.error});
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?) validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool autofocus;
  final Function(String)? onFieldSubmitted;
  final bool error;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: error == true ? size.height * 0.1 : size.height * 0.08,
      width: size.width * 0.8,
      child: TextFormField(
        autofocus: autofocus,
        keyboardType: keyboardType,
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        style: TextStyle(
          fontFamily: 'Inter',
          color: MyColors.whiteColor,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          fontSize: 16,
        ),
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscureText,
        cursorColor: MyColors.whiteColor,
        decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 12),
            border: InputBorder.none,
            fillColor: MyColors.primaryColor,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              color: MyColors.lightGrey,
              fontWeight: FontWeight.w500,
              // letterSpacing: letterSpacing ?? 0.1,
              fontSize: 14,
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(40)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.primaryColor, width: 0),
                borderRadius: BorderRadius.circular(40)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(40)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: MyColors.primaryColor, width: 0)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon
            // prefixIconColor: MyColor.pinkColor,
            ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    this.onTap,
    required this.text,
    this.color,
    this.fontFamily,
    this.fontSize,
    this.letterSpacing,
    this.fontWeight,
    this.underline,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final TextDecoration? underline;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: fontFamily ?? 'Inter',
            color: color ?? MyColors.whiteColor,
            fontWeight: fontWeight ?? FontWeight.w400,
            letterSpacing: letterSpacing ?? 0.1,
            fontSize: fontSize ?? 16,
            overflow: overflow,
            decoration: underline ?? TextDecoration.none,
          ),
          maxLines: maxLines,
          softWrap: true, // Allow text to wrap within the available space
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.onpressed,
    required this.height,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.widget,
    this.boxShadow,
  });
  final Color? color;
  final Widget? widget;
  final double borderRadius;
  final VoidCallback onpressed;
  final double width;
  final double height;
  final double borderWidth;
  final Color borderColor;
  final List<BoxShadow>? boxShadow;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            boxShadow: boxShadow,
            border: Border.all(color: borderColor, width: borderWidth),
            color: color,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Center(child: widget),
      ),
    );
  }
}

class OtherSignIn extends StatelessWidget {
  const OtherSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.73,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomContainer(
                onpressed: () async {
                  final user =
                      await MyAuthenticationService.authenticateWithGoogle();
                  // String authToken =
                  //     await MyAuthenticationService().authenticateWithGoogle();
                  // if (authToken != null) {
                  //   // Authentication successful, you can add your logic here
                  // } else {
                  //   // Handle authentication failure
                  // }
                },
                height: size.height * 0.07,
                width: size.width * 0.4,
                color: MyColors.primaryColor,
                borderRadius: 40,
                borderColor: MyColors.transparent,
                borderWidth: 0,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 25,
                          ),
                          Container(
                            height: size.height * 0.03,
                            width: 1.5,
                            color: MyColors.lightGrey,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: TextWidget(
                        text: 'Google',
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )),
            // CustomContainer(
            //     onpressed: () {},
            //     height: size.height * 0.05,
            //     width: size.width * 0.35,
            //     color: MyColors.primaryColor,
            //     borderRadius: 40,
            //     borderColor: MyColors.transparent,
            //     borderWidth: 0,
            //     widget: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Expanded(
            //           flex: 2,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               Image.asset(
            //                 'assets/images/apple.png',
            //                 height: 20,
            //               ),
            //               Container(
            //                 height: size.height * 0.03,
            //                 width: 1.5,
            //                 color: MyColors.lightGrey,
            //               ),
            //             ],
            //           ),
            //         ),
            //         const Expanded(
            //           flex: 3,
            //           child: TextWidget(
            //             text: 'Apple',
            //             fontSize: 14,
            //             fontWeight: FontWeight.w400,
            //           ),
            //         )
            //       ],
            //     )),
          ],
        ),
        // SizedBox(
        //   height: size.height * 0.018,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     CustomContainer(
        //         onpressed: () {},
        //         height: size.height * 0.05,
        //         width: size.width * 0.35,
        //         color: MyColors.primaryColor,
        //         borderRadius: 40,
        //         borderColor: MyColors.transparent,
        //         borderWidth: 0,
        //         widget: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             Expanded(
        //               flex: 2,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 children: [
        //                   Image.asset(
        //                     'assets/images/twitter.png',
        //                     height: 20,
        //                   ),
        //                   Container(
        //                     height: size.height * 0.03,
        //                     width: 1.5,
        //                     color: MyColors.lightGrey,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             const Expanded(
        //               flex: 3,
        //               child: TextWidget(
        //                 text: 'Twitter',
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w400,
        //               ),
        //             )
        //           ],
        //         )),
        //     CustomContainer(
        //         onpressed: () {},
        //         height: size.height * 0.05,
        //         width: size.width * 0.35,
        //         color: MyColors.primaryColor,
        //         borderRadius: 40,
        //         borderColor: MyColors.transparent,
        //         borderWidth: 0,
        //         widget: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             Expanded(
        //               flex: 2,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 children: [
        //                   Image.asset(
        //                     'assets/images/facebook.png',
        //                     height: 20,
        //                   ),
        //                   Container(
        //                     height: size.height * 0.03,
        //                     width: 1.5,
        //                     color: MyColors.lightGrey,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             const Expanded(
        //               flex: 3,
        //               child: TextWidget(
        //                 text: 'Facebook',
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w400,
        //               ),
        //             )
        //           ],
        //         )),
        //   ],
        // )
      ]),
    );
  }
}

class BottomWidget extends StatelessWidget {
  const BottomWidget(
      {super.key,
      required this.onTap,
      required this.text,
      required this.color,
      required this.icon,
      required this.iconColor});
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30,
          ),
          TextWidget(
            text: text,
            color: iconColor,
            fontSize: 9,
          ),
          const SizedBox(
            height: 1,
          ),
          Container(
            height: 3,
            width: 25,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(40)),
          )
        ],
      ),
    );
  }
}

class RecentReleasedWidget extends StatelessWidget {
  const RecentReleasedWidget({super.key, required this.list});
  final ListItemModel list;

  String calculateRequiredTokens(int pages, bool isBook) {
    if (isBook) {
      double requiredTokens = 0;
      if (pages <= 75) {
        requiredTokens = pages * 0.5;
      } else if (pages >= 76 && pages <= 100) {
        requiredTokens = pages * 0.4;
      } else if (pages >= 101 && pages <= 300) {
        requiredTokens = pages * 0.25;
      }
      return '${requiredTokens.round()}'; // Round to the nearest integer
    } else {
      if (pages == 1) {
        return 'Watch to earn';
      } else if (pages >= 2 && pages <= 5) {
        return '${(pages * 3).round()}';
      } else {
        return '${(pages * 2).round()}';
      }
    }
  }

  String calculatePrice(String pages, String amazonPrice, bool isBook) {
    if (isBook) {
      double amazonPriceDouble = double.tryParse(amazonPrice) ?? 0.0;
      double bookPrice = amazonPriceDouble * 0.5;
      return '${bookPrice.round()}';
    } else {
      int pagesInt = int.tryParse(pages) ?? 0;
      double songPrice = pagesInt * 0.5;
      return '${songPrice.round()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bool isBook = list.detail.startsWith('BK');
    final isSongInLibrary = OfflineLibraryBox
        .userBox!.values.first.offlineLibrary
        .contains(list.detail);
    final String tokenText =
        calculateRequiredTokens(int.parse(list.pages), isBook);
    double tokenWidth = 45.w;
    double tokenTextSize = MediaQuery.of(context).size.width * 0.028;
    if (tokenText.length > 6) {
      tokenWidth = 130.w;
      tokenTextSize = MediaQuery.of(context).size.width * 0.028;
    }

    String price = calculatePrice(list.pages, list.amazonPrice, isBook);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: size.height * 0.35,
        width: 145.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: MyColors.darkBlue),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isBook
                    ? Image.network(
                        list.imageUrl,
                        fit: BoxFit.cover,
                        height: size.height * 0.29,
                      )
                    : Container(
                        height: size.height * 0.29,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/background.jpeg'),
                                fit: BoxFit.cover)),
                        child: Center(
                          child: CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: MyColors.whiteColor,
                            child: Center(
                              child: Image.asset(
                                'assets/images/new_logo.png',
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            Container(
              height: HomeController.to.index != 3
                  ? size.height * 0.11
                  : size.height * 0.07,
              width: 175.w,
              color: MyColors.darkBlue,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.0175,
                  vertical: size.height * 0.0055,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: list.title,
                      fontSize: MediaQuery.of(context).size.width * 0.032,
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Pages: ${list.pages}',
                          fontSize: MediaQuery.of(context).size.width * 0.026,
                          color: MyColors.grey,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.circle,
                          color: list.difficulty == 'Advanced'
                              ? MyColors.red
                              : list.difficulty == 'Intermediate'
                                  ? MyColors.yellowColor
                                  : list.difficulty == 'Beginner'
                                      ? MyColors.greenColor
                                      : MyColors.greyColor,
                          size: 14.h,
                        )
                      ],
                    ),
                    Visibility(
                        visible:
                            isSongInLibrary && HomeController.to.index != 3,
                        child: Column(
                          children: [
                            Divider(
                              thickness: 0.8,
                              color: MyColors.lightGrey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: TextWidget(
                                    text: 'Owned',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    Visibility(
                        visible:
                            HomeController.to.index != 3 && !isSongInLibrary,
                        child: Column(
                          children: [
                            Divider(
                              thickness: 0.8,
                              color: MyColors.lightGrey,
                            ),
                            !isBook && int.parse(list.pages) == 1
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomContainer(
                                        onpressed: () {},
                                        height: size.height * 0.026,
                                        width: tokenWidth,
                                        color: MyColors.whiteColor,
                                        borderRadius: 40,
                                        borderColor: MyColors.transparent,
                                        borderWidth: 0,
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/logo_2.png'),
                                              maxRadius: 7,
                                            ),
                                            TextWidget(
                                              fontSize: tokenTextSize,
                                              text: tokenText,
                                              color: MyColors.blackColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomContainer(
                                        onpressed: () {},
                                        height: size.height * 0.026,
                                        width: tokenWidth,
                                        color: MyColors.whiteColor,
                                        borderRadius: 40,
                                        borderColor: MyColors.transparent,
                                        borderWidth: 0,
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/logo_2.png'),
                                              maxRadius: 8,
                                            ),
                                            TextWidget(
                                              fontSize: tokenTextSize,
                                              text: tokenText,
                                              color: MyColors.blackColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomContainer(
                                          onpressed: () {},
                                          height: size.height * 0.026,
                                          width: size.width * 0.10,
                                          color: MyColors.whiteColor,
                                          borderRadius: 40,
                                          borderColor: MyColors.transparent,
                                          borderWidth: 0,
                                          widget: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextWidget(
                                                text: '\$ $price',
                                                color: MyColors.blackColor,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.028,
                                              )
                                            ],
                                          ))
                                    ],
                                  )
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewReleasesWidget extends StatelessWidget {
  const NewReleasesWidget({Key? key, required this.list}) : super(key: key);
  final ListItemModel list;

  String calculateRequiredTokens(int pages, bool isBook) {
    if (isBook) {
      double requiredTokens = 0;
      if (pages <= 75) {
        requiredTokens = pages * 0.5;
      } else if (pages >= 76 && pages <= 100) {
        requiredTokens = pages * 0.4;
      } else if (pages >= 101 && pages <= 300) {
        requiredTokens = pages * 0.25;
      }
      return '${requiredTokens.round()}'; // Round to the nearest integer
    } else {
      if (pages == 1) {
        return '1';
      } else if (pages >= 2 && pages <= 5) {
        return '${(pages * 3).round()}';
      } else {
        return '${(pages * 2).round()}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bool isBook = list.detail.startsWith('BK');
    final String tokenText =
        calculateRequiredTokens(int.parse(list.pages), isBook);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: SizedBox(
        child: Container(
          width: size.width * 0.92, // Set the fixed width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: MyColors.blueColor,
              width: 4, // Border color
            ),
            color: MyColors.whiteColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Container(
                      width: size.width * 0.32,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: isBook
                              ? NetworkImage(list.imageUrl)
                              : const AssetImage(
                                      'assets/images/background.jpeg')
                                  as ImageProvider,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.darkBlue,
                      ),
                    ),
                  ),
                ), // Add your content here

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: size.height * 0.28,
                        width: size.width * 0.37,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: list.title,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              color: MyColors.blackColor,
                            ),
                            SizedBox(
                              height: size.height * 0.0175,
                            ),
                            isBook
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomContainer(
                                        onpressed: () {},
                                        height: size.height * 0.032,
                                        width: size.width * 0.18,
                                        color: MyColors.primaryColor,
                                        borderRadius: 8,
                                        borderColor: MyColors.primaryColor,
                                        borderWidth: 1.5,
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  MyColors.transparent,
                                              backgroundImage: const AssetImage(
                                                  'assets/images/amazon.png'),
                                              maxRadius: 8,
                                            ),
                                            TextWidget(
                                              text: list.amazonPrice,
                                              color: MyColors.whiteColor,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomContainer(
                                        onpressed: () {},
                                        height: size.height * 0.032,
                                        width: size.width * 0.18,
                                        color: MyColors.whiteColor,
                                        borderRadius: 8,
                                        borderColor: MyColors.primaryColor,
                                        borderWidth: 1.5,
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  MyColors.transparent,
                                              backgroundImage: const AssetImage(
                                                  'assets/images/logo_2.png'),
                                              maxRadius: 8,
                                            ),
                                            TextWidget(
                                              text:
                                                  tokenText, // Convert pages to int
                                              color: MyColors.blueColor,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomContainer(
                                        onpressed: () {},
                                        height: size.height * 0.032,
                                        width: size.width * 0.18,
                                        color: MyColors.whiteColor,
                                        borderRadius: 8,
                                        borderColor: MyColors.primaryColor,
                                        borderWidth: 1.5,
                                        widget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  MyColors.transparent,
                                              backgroundImage: const AssetImage(
                                                  'assets/images/logo_2.png'),
                                              maxRadius: 8,
                                            ),
                                            TextWidget(
                                              text:
                                                  tokenText, // Convert pages to int
                                              color: MyColors.blueColor,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: size.height * 0.0175,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    text: 'Artist: ',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: MyColors.blackColor,
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    text: list.artist,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: MyColors.blackColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.009,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    text: 'Genre: ',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: MyColors.blackColor,
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    text: list.genre,
                                    fontSize: 12,
                                    color: MyColors.blackColor,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.009,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    text: 'Difficulty: ',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: MyColors.blackColor,
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    text: list.difficulty,
                                    fontSize: 12,
                                    color: MyColors.blackColor,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.009,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    text: 'Pages:',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: MyColors.blackColor,
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    text: list.pages,
                                    fontSize: 12,
                                    color: MyColors.blackColor,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookWidget extends StatelessWidget {
  BookWidget({super.key, required this.list});
  final ListItemModel list;
  final HomeController ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 250.h,
        width: 145.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: MyColors.darkBlue),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                list.imageUrl ==
                        'https://media.istockphoto.com/id/106533163/photo/plan.jpg?s=612x612&w=0&k=20&c=-XArhVuWKh1hqkBc7YWO-oCy785cuQuS3o2-oOpNBCQ='
                    ? Image.asset('assets/images/book_3.jpeg')
                    : Image.network(
                        list.imageUrl,
                        fit: BoxFit.cover,
                      ),
                // Text('${list.imageUrl}'),
              ],
            ),
            Container(
              height: 85.h,
              width: 175.w,
              color: MyColors.darkBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: list.title,
                      fontSize: 13.sp,
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: list.detail,
                          fontSize: 10.sp,
                          color: MyColors.lightGrey,
                        ),
                        Icon(
                          Icons.circle,
                          color: list.difficulty == 'Advanced'
                              ? MyColors.red
                              : list.difficulty == 'Intermediate'
                                  ? MyColors.yellowColor
                                  : list.difficulty == 'Beginner'
                                      ? MyColors.greenColor
                                      : MyColors.greyColor,
                          size: 14.h,
                        )
                      ],
                    ),
                    Divider(
                      thickness: 0.8,
                      color: MyColors.lightGrey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(
                            onpressed: () {},
                            height: 19.h,
                            width: 55.w,
                            color: MyColors.whiteColor,
                            borderRadius: 40,
                            borderColor: MyColors.transparent,
                            borderWidth: 0,
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextWidget(
                                  text: list.rating,
                                  color: MyColors.blackColor,
                                  fontSize: 12,
                                ),
                                Container(
                                  height: size.height * 0.02,
                                  width: 1.5,
                                  color: MyColors.greyColor,
                                ),
                                Icon(
                                  Icons.star,
                                  color: MyColors.yellowColor,
                                  size: 14,
                                )
                              ],
                            )),
                        CustomContainer(
                            onpressed: () {},
                            height: size.height * 0.028,
                            width: size.width * 0.18,
                            color: MyColors.whiteColor,
                            borderRadius: 40,
                            borderColor: MyColors.transparent,
                            borderWidth: 0,
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextWidget(
                                  text: ' \$ ${list.price}',
                                  color: MyColors.blackColor,
                                  fontSize: 12,
                                ),
                                Container(
                                  height: size.height * 0.02,
                                  width: 1.5,
                                  color: MyColors.greyColor,
                                ),
                                Image.asset(
                                  'assets/images/amazon.png',
                                  height: 12,
                                )
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookDetailScreen extends StatefulWidget {
  final ListItemModel book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool like = false;
  bool play = false;
  bool hide = true;
  double value = 0.0;
  double maxValue = 180.0;
  bool isOwned = false;
  bool earnToken = false;
  bool earnReward = false;
  final player = AudioPlayer();
  late Timer timer;
  RewardedInterstitialAd? _rewardedAd;
  int userPoints = int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;
  int offlineUserPoints =
      int.tryParse(OfflineLibraryBox.userBox!.values.first.points) ?? 0;
  bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8);
  }

  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (play) {
        player.getCurrentPosition().then((position) {
          setState(() {
            if (position != null) {
              value = position.inSeconds.toDouble();
            }
          });
        });
      }
    });
    getAudioDuration();
    checkOwnershipStatus();
    createRewardedAd();
  }

  void createRewardedAd() {
    if (EasyLoading.isShow) {
      return;
    }
    EasyLoading.show(status: 'loading...');
    EasyLoading.dismiss();
    RewardedInterstitialAd.load(
      adUnitId: AdMobService.rewardedInterstitialAdUnitId!,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          setState(() {
            _rewardedAd = ad;
            print(' ad is loading');
            EasyLoading.dismiss();
          });
          await OfflineLibraryBox.updateAdsWatched(
              OfflineLibraryBox.userBox!.values.first.adsWatched + 1);
        },
        onAdFailedToLoad: (error) async {
          setState(() {
            _rewardedAd = null;
            EasyLoading.dismiss();
          });
          if (OfflineLibraryBox.userBox!.values.first.adsWatched < 10) {
            if (isLoggedIn == true) {
              int newPoints = userPoints + 1;
              await HomeController.to
                  .updatePoints(
                      LoginBox.userBox!.values.first.authToken, newPoints)
                  .then((pointsUpdated) async {
                var userdata = await HomeController.to
                    .getuserData(LoginBox.userBox!.values.first.authToken);
                print('Points updated in logged In mode');
                // Perform additional actions with userdata
              });
            } else {
              int newPoints = offlineUserPoints++;
              await OfflineLibraryBox.updatePoints(newPoints.toString());
              print('Points updated in logged off mode');
            }

            Get.snackbar(
                "Seems like the Ad failed to load but here's a token on us",
                'You have recieved a token');
          }
        },
      ),
    );
  }

  Future<void> showRewardedAd() async {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: ((ad) {
        ad.dispose();
        createRewardedAd();
      }), onAdFailedToShowFullScreenContent: (((ad, error) {
        ad.dispose();
        createRewardedAd();
      })));

      await _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
        if (earnReward) {
          await OfflineLibraryBox.updateLibrary(widget.book.detail);
          print("You earned a reward");
        } else if (earnToken) {
          if (isLoggedIn == true) {
            int newPoints = userPoints + 1;
            await HomeController.to
                .updatePoints(
                    LoginBox.userBox!.values.first.authToken, newPoints)
                .then((pointsUpdated) async {
              var userdata = await HomeController.to
                  .getuserData(LoginBox.userBox!.values.first.authToken);
              print('Points updated in logged In mode');
              // Perform additional actions with userdata
            });
          } else {
            int newPoints = offlineUserPoints++;
            await OfflineLibraryBox.updatePoints(newPoints.toString());
            print('Points updated in logged off mode');
          }
          Get.snackbar('You have recieved a token', "");
        }
      });
      _rewardedAd = null;
    }
  }

  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
    getAudioDuration(); // Play audio from the provided URL
  }

  Future<void> getAudioDuration() async {
    final duration = await player.getDuration();
    if (duration != null) {
      setState(() {
        maxValue = duration.inSeconds.toDouble();
      });
    }
  }

  String calculateRequiredTokens(int pages) {
    double requiredTokens = 0;
    if (pages <= 75) {
      requiredTokens = pages * 0.5;
    } else if (pages >= 76 && pages <= 100) {
      requiredTokens = pages * 0.4;
    } else if (pages >= 101 && pages <= 300) {
      requiredTokens = pages * 0.25;
    }
    return '${requiredTokens.round()}'; // Round to the nearest integer
  }

  String calculateBookPrice(String amazonPrice) {
    double amazonPriceDouble = double.tryParse(amazonPrice) ?? 0.0;
    double bookPrice = amazonPriceDouble * 0.5;
    return '${bookPrice.round()}';
  }

  Future<void> AddtoLibrary(BuildContext context) async {
    final int requiredTokens =
        int.tryParse(calculateRequiredTokens(int.parse(widget.book.pages))) ??
            0;

    final isSongInLibrary = OfflineLibraryBox
        .userBox!.values.first.offlineLibrary
        .contains(widget.book.detail);

    if (isSongInLibrary) {
      // Show a snackbar saying "Already in the library"
      Get.snackbar("Already in the library", '');
    } else if (requiredTokens <= userPoints) {
      var _ = await OfflineLibraryBox.updateLibrary(widget.book.detail);
      var _data = HomeController.to
          .getuserData(LoginBox.userBox!.values.first.authToken);
      if (_) {
        Get.snackbar("${widget.book.title} is added to library", '');
      } else {
        Get.snackbar("Failed to update library", '');
      }
    } else {
      bool userWantsToWatchVideo = await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Not Enough Tokens'),
            content: const Text('Watch a video to earn a token?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(dialogContext)
                      .pop(false); // User declined to watch the video
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    earnToken = true;
                  });
                  Navigator.of(dialogContext)
                      .pop(true); // User wants to watch the video
                },
              ),
            ],
          );
        },
      );
      if (userWantsToWatchVideo) {
        if (OfflineLibraryBox.userBox!.values.first.adsWatched < 10) {
          showRewardedAd();
        } else {
          Get.snackbar('You have reached the total Ads limit for today', "");
        }
      }
    }

    var a = OfflineLibrary.encodeOfflineLibrary(
        OfflineLibraryBox.userBox!.values.first.offlineLibrary);
    print(a);
    if (OfflineLibraryBox.userBox!.values.first.isLoggedIn == true) {
      int newPoints = userPoints - requiredTokens;
      var submitted = HomeController.to
          .updateLibrary(LoginBox.userBox!.values.first.authToken, a);
      var pointsUpdated = HomeController.to
          .updatePoints(LoginBox.userBox!.values.first.authToken, newPoints);
      var userdata = await HomeController.to
          .getuserData(LoginBox.userBox!.values.first.authToken);
    }
  }

  void checkOwnershipStatus() {
    final userLibrary = UserDataBox.userBox!.values.first.userDataLibrary;
    final bookDetail = widget.book.detail;

    if (userLibrary.contains(bookDetail)) {
      setState(() {
        isOwned = true;
      });
    } else {
      setState(() {
        isOwned = false;
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isSongInLibrary = OfflineLibraryBox
        .userBox!.values.first.offlineLibrary
        .contains(widget.book.detail);
    bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;
    String bookPrice = calculateBookPrice(widget.book.amazonPrice);
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
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
                      title: widget.book.title),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: size.height * 0.29,
                                width: size.width * 0.36,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget.book.imageUrl),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColors.darkBlue),
                                child: Stack(
                                  children: [
                                    hide == true
                                        ? BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2, sigmaY: 2),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Center(
                                        child: InkWell(
                                      onTap: () async {
                                        player.pause();
                                        if (isSongInLibrary) {
                                          // If the song is in the library, open the PDF file from the local storage
                                          String localPdfPath =
                                              '/storage/emulated/0/PianoTab/${widget.book.title}.pdf';
                                          bool fileExists =
                                              await File(localPdfPath).exists();

                                          if (fileExists) {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext bc) {
                                                return PdfViewerScreen(
                                                  pdfPath: localPdfPath,
                                                  title: widget.book.title,
                                                  type: 'local',
                                                );
                                              },
                                            );
                                          } else {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (BuildContext bc) {
                                                  return PdfViewerScreen(
                                                    pdfPath: HomeController.to
                                                        .getOriginalbookPdfSource(
                                                            widget.book.detail),
                                                    title: widget.book.title,
                                                    type: 'network',
                                                  );
                                                });
                                          }
                                        } else {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext bc) {
                                                return PdfViewerScreen(
                                                  pdfPath: isSongInLibrary
                                                      ? HomeController.to
                                                          .getOriginalbookPdfSource(
                                                              widget
                                                                  .book.detail)
                                                      : HomeController.to
                                                          .getSamplePdfSource(
                                                              widget
                                                                  .book.detail),
                                                  title: widget.book.title,
                                                  type: 'network',
                                                );
                                              });
                                        }
                                      },
                                      child: Icon(
                                        CupertinoIcons.eye_fill,
                                        size: 40,
                                        color: MyColors.whiteColor,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: size.height * 0.29,
                                  width: size.width * 0.54,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      !isSongInLibrary
                                          ? Row(
                                              children: [
                                                CustomContainer(
                                                  onpressed: () {
                                                    AddtoLibrary(context);
                                                  },
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.2,
                                                  color: MyColors.whiteColor,
                                                  borderRadius: 8,
                                                  borderColor:
                                                      MyColors.primaryColor,
                                                  borderWidth: 1.5,
                                                  widget: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            MyColors
                                                                .transparent,
                                                        backgroundImage:
                                                            const AssetImage(
                                                                'assets/images/logo_2.png'),
                                                        maxRadius: 8,
                                                      ),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: size.width *
                                                              0.15, // Adjust based on your layout
                                                        ),
                                                        child: Text(
                                                          '${calculateRequiredTokens(int.parse(widget.book.pages))}',
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .blueColor,
                                                            fontSize: 14,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                CustomContainer(
                                                  onpressed: () async {
                                                    if (isLoggedIn) {
                                                      var _ =
                                                          await HomeController
                                                              .addToCart(
                                                                  widget.book);

                                                      setState(() {
                                                        HomeController
                                                                .to
                                                                .totalCartItemCount
                                                                .value =
                                                            HomeController
                                                                .to
                                                                .cartItems
                                                                .length;
                                                      });

                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return CartScreen();
                                                        },
                                                      );
                                                      if (_) {
                                                        Get.snackbar(
                                                            "Added to Cart",
                                                            "");
                                                      } else {
                                                        Get.snackbar(
                                                            "Already in Cart",
                                                            "");
                                                      }
                                                    } else {
                                                      Get.snackbar(
                                                          "You need to Sign In to Add item to cart",
                                                          "");
                                                    }
                                                  },
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.15,
                                                  color: MyColors.primaryColor,
                                                  borderRadius: 10,
                                                  borderColor:
                                                      MyColors.transparent,
                                                  borderWidth: 0,
                                                  widget: Center(
                                                    child: TextWidget(
                                                      text: '\$ $bookPrice',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    if (!isSongInLibrary) {
                                                      setState(() {
                                                        final favorites =
                                                            OfflineLibraryBox
                                                                .userBox!
                                                                .values
                                                                .first
                                                                .favourites;
                                                        if (favorites.contains(
                                                            widget
                                                                .book.detail)) {
                                                          // Remove from favorites
                                                          OfflineLibraryBox
                                                              .removeFromFavorites(
                                                                  widget.book
                                                                      .detail);
                                                          if (OfflineLibraryBox
                                                              .userBox!
                                                              .values
                                                              .first
                                                              .isLoggedIn) {
                                                            Get.snackbar(
                                                                "Removed from favorites",
                                                                "");
                                                          }
                                                        } else {
                                                          // Add to favorites
                                                          OfflineLibraryBox
                                                              .addToFavorites(
                                                                  widget.book
                                                                      .detail);
                                                          if (OfflineLibraryBox
                                                              .userBox!
                                                              .values
                                                              .first
                                                              .isLoggedIn) {
                                                            Get.snackbar(
                                                                "Added to Favorites",
                                                                "");
                                                          }
                                                        }
                                                      });
                                                    } else {
                                                      Get.snackbar(
                                                          'Already in the Library',
                                                          '');
                                                    }
                                                  },
                                                  child: Icon(
                                                    OfflineLibraryBox
                                                            .userBox!
                                                            .values
                                                            .first
                                                            .favourites
                                                            .contains(widget
                                                                .book.detail)
                                                        ? CupertinoIcons
                                                            .star_fill
                                                        : CupertinoIcons.star,
                                                    color: MyColors.yellowColor,
                                                  ),
                                                )

                                                // CustomContainer(
                                                //   onpressed: () {},
                                                //   height: size.height * 0.04,
                                                //   width: size.width * 0.2,
                                                //   color: MyColors.primaryColor,
                                                //   borderRadius: 10,
                                                //   borderColor: MyColors.transparent,
                                                //   borderWidth: 0,
                                                //   widget: const Center(
                                                //     child: TextWidget(
                                                //       text: 'Book',
                                                //       fontSize: 14,
                                                //     ),
                                                //   ),
                                                // ),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),
                                                // InkWell(
                                                //   onTap: () {
                                                //     setState(() {
                                                //       final favorites = OfflineLibraryBox
                                                //           .userBox!.values.first.favourites;
                                                //       if (favorites
                                                //           .contains(widget.song.detail)) {
                                                //         // Remove from favorites
                                                //         OfflineLibraryBox
                                                //             .removeFromFavorites(
                                                //                 widget.song.detail);
                                                //         if (OfflineLibraryBox.userBox!
                                                //             .values.first.isLoggedIn) {
                                                //           Get.snackbar(
                                                //               "Removed from favorites", "");
                                                //         }
                                                //       } else {
                                                //         // Add to favorites
                                                //         OfflineLibraryBox.addToFavorites(
                                                //             widget.song.detail);
                                                //         if (OfflineLibraryBox.userBox!
                                                //             .values.first.isLoggedIn) {
                                                //           Get.snackbar(
                                                //               "Added to favorites", "");
                                                //         }
                                                //       }
                                                //     });
                                                //   },
                                                //   child: Icon(
                                                //     OfflineLibraryBox.userBox!.values.first
                                                //             .favourites
                                                //             .contains(widget.song.detail)
                                                //         ? CupertinoIcons.heart_fill
                                                //         : CupertinoIcons.heart,
                                                //     color: MyColors.red,
                                                //   ),
                                                // )
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (!isSongInLibrary) {
                                                      setState(() {
                                                        final favorites =
                                                            OfflineLibraryBox
                                                                .userBox!
                                                                .values
                                                                .first
                                                                .favourites;
                                                        if (favorites.contains(
                                                            widget
                                                                .book.detail)) {
                                                          // Remove from favorites
                                                          OfflineLibraryBox
                                                              .removeFromFavorites(
                                                                  widget.book
                                                                      .detail);
                                                          if (OfflineLibraryBox
                                                              .userBox!
                                                              .values
                                                              .first
                                                              .isLoggedIn) {
                                                            Get.snackbar(
                                                                "Removed from favorites",
                                                                "");
                                                          }
                                                        } else {
                                                          // Add to favorites
                                                          OfflineLibraryBox
                                                              .addToFavorites(
                                                                  widget.book
                                                                      .detail);
                                                          if (OfflineLibraryBox
                                                              .userBox!
                                                              .values
                                                              .first
                                                              .isLoggedIn) {
                                                            Get.snackbar(
                                                                "Added to Favorites",
                                                                "");
                                                          }
                                                        }
                                                      });
                                                    } else {
                                                      Get.snackbar(
                                                          'Already in the Library',
                                                          '');
                                                    }
                                                  },
                                                  child: Icon(
                                                    OfflineLibraryBox
                                                            .userBox!
                                                            .values
                                                            .first
                                                            .favourites
                                                            .contains(widget
                                                                .book.detail)
                                                        ? CupertinoIcons
                                                            .star_fill
                                                        : CupertinoIcons.star,
                                                    color: MyColors.yellowColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.03,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextWidget(
                                                  text: 'Artist:',
                                                  fontSize: 15,
                                                  color: MyColors.blackColor,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextWidget(
                                                  text: widget.book.artist,
                                                  fontSize: 15,
                                                  color: MyColors.blackColor,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextWidget(
                                                  text: 'Genre',
                                                  fontSize: 15,
                                                  color: MyColors.blackColor,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextWidget(
                                                  text: widget.book.genre,
                                                  fontSize: 15,
                                                  color: MyColors.blackColor,
                                                  overflow: TextOverflow
                                                      .ellipsis, // Display ellipsis if the text overflows
                                                  maxLines:
                                                      1, // Limit text to a single line
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextWidget(
                                                  text: 'Difficulty:',
                                                  fontSize: 15,
                                                  color: MyColors.blackColor,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextWidget(
                                                  text: widget.book.difficulty,
                                                  fontSize: 14,
                                                  color: MyColors.blackColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextWidget(
                                                  text: 'Pages:',
                                                  fontSize: 15,
                                                  color: MyColors.blackColor,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextWidget(
                                                  text: widget.book.pages,
                                                  fontSize: 15,
                                                  color: MyColors.blackColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                        height: size.height * 0.076,
                                        width: size.width * 0.54,
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    play = !play;
                                                    print(HomeController.to
                                                        .getMp3Source(widget
                                                            .book.detail));
                                                  });

                                                  // Play or pause audio when the "Play" button is tapped
                                                  if (play) {
                                                    playAudioFromUrl(
                                                        HomeController.to
                                                            .getMp3Source(widget
                                                                .book.detail));
                                                  } else {
                                                    player.pause();
                                                  }
                                                },
                                                child: Icon(
                                                  play
                                                      ? Icons
                                                          .pause_circle_outline_outlined
                                                      : Icons
                                                          .play_circle_outline_outlined,
                                                  size: 28,
                                                  color: MyColors.blueColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: SliderTheme(
                                                data: const SliderThemeData(
                                                    trackHeight: 3,
                                                    trackShape:
                                                        RectangularSliderTrackShape(),
                                                    overlayShape:
                                                        RoundSliderOverlayShape(
                                                            overlayRadius: 8),
                                                    thumbShape:
                                                        RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                5)),
                                                child: Slider(
                                                  min: 0,
                                                  max: maxValue,
                                                  value: value,
                                                  inactiveColor:
                                                      MyColors.greyColor,
                                                  onChanged: (newValue) {
                                                    final position = Duration(
                                                        seconds:
                                                            newValue.toInt());
                                                    player.seek(position);
                                                    player.resume();
                                                    setState(() {
                                                      value = newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                    Row(
                                      children: [
                                        TextWidget(
                                          text: formatTime(value.toInt()),
                                          color: MyColors.blackColor,
                                          fontSize: 12,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.01,
                                        ),
                                        Container(
                                          height: size.height * 0.022,
                                          width: 1,
                                          color: MyColors.greyColor,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.01,
                                        ),
                                        TextWidget(
                                          text: formatTime(maxValue.toInt()),
                                          color: MyColors.blackColor,
                                          fontSize: 12,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Row(
                          children: [
                            CustomContainer(
                                onpressed: () async {
                                  final url = Uri.parse(widget.book.imageUrl);
                                  final response = await http.get(url);
                                  final bytes = response.bodyBytes;
                                  final temp = await getTemporaryDirectory();
                                  final path = '${temp.path}/image.jpg';
                                  File(path).writeAsBytesSync(bytes);
                                  final XFile xfile = XFile(path);
                                  await Share.shareXFiles([xfile],
                                      text: '${widget.book.title}');
                                },
                                height: size.height * 0.04,
                                width: size.width * 0.22,
                                color: MyColors.whiteColor,
                                borderRadius: 10,
                                borderColor: MyColors.primaryColor,
                                borderWidth: 1.5,
                                widget: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextWidget(
                                            text: 'Share',
                                            fontSize: 12,
                                            color: MyColors.primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          Container(
                                            height: size.height * 0.025,
                                            width: 1,
                                            color: MyColors.primaryColor
                                                .withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Icon(
                                        CupertinoIcons.share,
                                        size: 16,
                                        color: MyColors.primaryColor,
                                      ),
                                    )
                                  ],
                                )),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            CustomContainer(
                              onpressed: () async {
                                print(widget.book.amazonLink);
                                if (await canLaunchUrl(
                                    Uri.parse(widget.book.amazonLink))) {
                                  await launchUrl(
                                    Uri.parse(widget.book.amazonLink),
                                  );
                                } else {
                                  throw Exception(
                                      'Could not launch ${widget.book.amazonLink}');
                                }
                              },
                              height: size.height * 0.04,
                              width: size.width * 0.2,
                              color: MyColors.primaryColor,
                              borderRadius: 8,
                              borderColor: MyColors.primaryColor,
                              borderWidth: 1.5,
                              widget: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: MyColors.transparent,
                                    backgroundImage: const AssetImage(
                                        'assets/images/amazon.png'),
                                    maxRadius: 8,
                                  ),
                                  Flexible(
                                    child: TextWidget(
                                      text: '\$ ${widget.book.amazonPrice}',
                                      color: MyColors.whiteColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width: size.width * 0.02,
                            // ),
                            // Icon(
                            //   Icons.playlist_add,
                            //   size: 32,
                            //   color: MyColors.primaryColor,
                            // )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        TextWidget(
                          text: 'Description',
                          color: MyColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Text(widget.book.description,
                            style: TextStyle(
                                color: MyColors.blackColor.withOpacity(0.4),
                                fontSize: 16.sp)),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          height: size.height * 0.2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
              valueListenable: HomeController.to.totalCartItemCount,
              builder: (context, val, c) {
                return Visibility(
                    visible: val > 0,
                    child: Positioned(
                      bottom: 90,
                      right: 15,
                      child: Stack(
                        children: [
                          Material(
                            elevation: 6,
                            shape: CircleBorder(),
                            child: FloatingActionButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext bc) {
                                    return CartScreen();
                                  },
                                );
                              },
                              backgroundColor: MyColors.primaryColor,
                              child: Icon(
                                Icons.shopping_cart,
                                color: MyColors.whiteColor,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: MyColors.primaryColor,
                                  width: 2.0,
                                ),
                                color: MyColors.whiteColor,
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: val.toString(),
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              })
        ],
      ),
    );
  }

  // void _showPdfViewer(BuildContext context, String pdfPath) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext bc) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.95, // Occupies full screen height
  //         child: Container(
  //           child: Column(
  //             children: [
  //               AppBar(
  //                 title: TextWidget(text: widget.book.title),
  //                 centerTitle: true,
  //                 actions: [
  //                   IconButton(
  //                     icon: Icon(Icons.file_download),
  //                     onPressed: () {
  //                       showDialog(
  //                         context: context,
  //                         builder: (context) => DownloadingDialog(
  //                           pdfPath: pdfPath, // Pass the PDF path to the dialog
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                   IconButton(
  //                     icon: Icon(Icons.print),
  //                     onPressed: () {},
  //                   ),
  //                 ],
  //               ),
  //               Expanded(
  //                 child: SfPdfViewer.network(
  //                   pdfPath, // Use the passed PDF path here
  //                   controller: _pdfViewController,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String title;
  final String type;

  PdfViewerScreen(
      {required this.pdfPath, required this.title, required this.type});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewController;
  late DocumentFileSavePlus documentFileSavePlus;

  @override
  void initState() {
    super.initState();
    _pdfViewController = PdfViewerController();
    documentFileSavePlus = DocumentFileSavePlus();

    _preventSS();
  }

  @override
  void dispose() {
    // Remove the secure flag when the screen is disposed
    _allowSS();
    super.dispose();
  }

  Future<void> _preventSS() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void _allowSS() {
    // Remove the secure flag
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    // Apply the secure flag when building the screen
    _preventSS();

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.95,
        child: Container(
          child: Column(
            children: [
              AppBar(
                title: TextWidget(text: widget.title),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => DownloadingDialog(
                          pdfPath: widget.pdfPath,
                          title:
                              widget.title, // Pass the PDF path to the dialog
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () async {
                      var response = await http.get(Uri.parse(widget.pdfPath));
                      var pdfBytes = response.bodyBytes;
                      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
                    },
                  ),
                ],
              ),
              Expanded(
                child: widget.type == 'network'
                    ? SfPdfViewer.network(
                        widget.pdfPath,
                        controller: _pdfViewController,
                      )
                    : widget.type == 'local'
                        ? SfPdfViewer.file(
                            File(
                                '/storage/emulated/0/PianoTab/${widget.title}.pdf'),
                            controller: _pdfViewController,
                          )
                        : SfPdfViewer.asset(
                            widget.pdfPath,
                            controller: _pdfViewController,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadingDialog extends StatefulWidget {
  final String pdfPath;
  final String title;

  DownloadingDialog({
    required this.pdfPath,
    required this.title,
  });

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;
  late DocumentFileSavePlus documentFileSavePlus;

  Future getAndroidSdkVersion() async {
    try {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt > 30) {
        print('Executing code for Android version greater than 12');
      }
      if (androidInfo.version.sdkInt < 30) {
        print('Executing code for Android version greater than 12');
      }
      return androidInfo.version.sdkInt;
    } catch (e) {
      print('Error retrieving Android version: $e');
    }
  }

  void startDownloading() async {
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.storage,
    //   //add more permission to request here.
    // ].request();

    // String path = await _getFilePath(fileName);
    String path = '/storage/emulated/0/PianoTab/';
    final dir = Directory("storage/emulated/0/PianoTab");

    var androidversion = await getAndroidSdkVersion();

    if (androidversion >= 30) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      if (status.isGranted) {
        if ((await dir.exists())) {
          print("PianoTab directory exist");
        } else {
          print("PianoTab directory doesnot exist");
          dir.create();
        }
      }

      if (status.isGranted) {
        await FlutterDownloader.enqueue(
          url: widget.pdfPath,
          savedDir: path,
          fileName: '${widget.title}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );

        // FlutterDownloader.registerCallback((id, status, progress) {
        //   print(
        //       'Download task ($id) is in status ($status) and process ($progress)');
        //   // setState(() {
        //   //   downloadingprogress = progress;
        //   // });
        // });

        await dio.get(
          widget.pdfPath,
          onReceiveProgress: (recivedBytes, totalBytes) {
            setState(() {
              progress = recivedBytes / totalBytes;
            });

            print(progress);
          },
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }),
        ).then((_) {
          Navigator.pop(context);
          Get.snackbar(
              '${widget.title} has been downloaded to the Downloads', '');
        });
      } else {
        Navigator.pop(context);
        await Permission.manageExternalStorage.request();
      }
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if (status.isGranted) {
        if ((await dir.exists())) {
          print("PianoTab directory exist");
        } else {
          print("PianoTab directory doesnot exist");
          dir.create();
        }
      }

      if (status.isGranted) {
        await FlutterDownloader.enqueue(
          url: widget.pdfPath,
          savedDir: path,
          fileName: '${widget.title}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );

        // FlutterDownloader.registerCallback((id, status, progress) {
        //   print(
        //       'Download task ($id) is in status ($status) and process ($progress)');
        //   // setState(() {
        //   //   downloadingprogress = progress;
        //   // });
        // });

        await dio.get(
          widget.pdfPath,
          onReceiveProgress: (recivedBytes, totalBytes) {
            setState(() {
              progress = recivedBytes / totalBytes;
            });

            print(progress);
          },
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }),
        ).then((_) {
          Navigator.pop(context);
          Get.snackbar(
              '${widget.title} has been downloaded to the Downloads', '');
        });
      } else {
        Navigator.pop(context);
        await Permission.storage.request();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
    documentFileSavePlus = DocumentFileSavePlus();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class SongDetailScreen extends StatefulWidget {
  final ListItemModel song;
  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  bool like = false;
  bool play = false;
  bool hide = true;
  double value = 0.0;
  double maxValue = 180.0;
  final player = AudioPlayer();
  late Timer timer;
  bool isOwned = false;
  RewardedInterstitialAd? _rewardedAd;

  bool earnToken = false;
  bool earnReward = false;
  bool earnRewardOpenPDF = false;
  bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;
  int userPoints = int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;
  int offlineUserPoints =
      int.tryParse(OfflineLibraryBox.userBox!.values.first.points) ?? 0;
  late PdfViewerController _pdfViewController;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8);
  }

  String _calculateRequiredTokens(int pages) {
    if (pages == 1) {
      return 'Watch video and redeem';
    } else if (pages >= 2 && pages <= 5) {
      return '${(pages * 3).round()}';
    } else {
      return '${(pages * 2).round()}';
    }
  }

  String calculateSongPrice(String pages) {
    int pagesInt = int.tryParse(pages) ??
        0; // Convert pages to int, default to 0 if not a valid number
    double songPrice = pagesInt * 0.5;
    return '${songPrice.round()}';
  }

  @override
  void initState() {
    super.initState();
    createRewardedAd();
    _pdfViewController = PdfViewerController();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (play) {
        player.getCurrentPosition().then((position) {
          setState(() {
            if (position != null) {
              value = position.inSeconds.toDouble();
            }
          });
        });
      }
    });
    checkOwnershipStatus();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void createRewardedAd() {
    if (EasyLoading.isShow) {
      return;
    }
    EasyLoading.show(status: 'loading...');
    EasyLoading.dismiss();
    RewardedInterstitialAd.load(
      adUnitId: AdMobService.rewardedInterstitialAdUnitId!,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          setState(() {
            _rewardedAd = ad;
            print(' ad is loading');
            EasyLoading.dismiss();
          });
          await OfflineLibraryBox.updateAdsWatched(
              OfflineLibraryBox.userBox!.values.first.adsWatched + 1);
        },
        onAdFailedToLoad: (error) async {
          setState(() {
            _rewardedAd = null;
            EasyLoading.dismiss();
          });
          if (OfflineLibraryBox.userBox!.values.first.adsWatched < 10) {
            if (isLoggedIn == true) {
              int newPoints = userPoints + 1;
              await HomeController.to
                  .updatePoints(
                      LoginBox.userBox!.values.first.authToken, newPoints)
                  .then((pointsUpdated) async {
                var userdata = await HomeController.to
                    .getuserData(LoginBox.userBox!.values.first.authToken);
                print('Points updated in logged In mode');
                // Perform additional actions with userdata
              });
            } else {
              int newPoints = offlineUserPoints++;
              await OfflineLibraryBox.updatePoints(newPoints.toString());
              print('Points updated in logged off mode');
            }

            Get.snackbar(
                "Seems like the Ad failed to load but here's a token on us",
                'You have recieved a token');

            await OfflineLibraryBox.updateAdsWatched(
                OfflineLibraryBox.userBox!.values.first.adsWatched + 1);
          }
        },
      ),
    );
  }

  Future<void> showRewardedAd() async {
    final isSongInLibrary = OfflineLibraryBox
        .userBox!.values.first.offlineLibrary
        .contains(widget.song.detail);
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: ((ad) {
        ad.dispose();
        createRewardedAd();
      }), onAdFailedToShowFullScreenContent: (((ad, error) {
        ad.dispose();
        createRewardedAd();
      })));

      await _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
        if (earnReward) {
          await OfflineLibraryBox.updateLibrary(widget.song.detail);
          print("You earned a reward");
        } else if (earnRewardOpenPDF) {
          await OfflineLibraryBox.updateLibrary(widget.song.detail);
          if (isSongInLibrary) {
            // If the song is in the library, open the PDF file from the local storage
            String localPdfPath =
                '/storage/emulated/0/PianoTab/${widget.song.title}.pdf';
            bool fileExists = await File(localPdfPath).exists();

            if (fileExists) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext bc) {
                  return PdfViewerScreen(
                    pdfPath: localPdfPath,
                    title: widget.song.title,
                    type: 'local',
                  );
                },
              );
            } else {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext bc) {
                    return PdfViewerScreen(
                      pdfPath: HomeController.to
                          .getOriginalbookPdfSource(widget.song.detail),
                      title: widget.song.title,
                      type: 'network',
                    );
                  });
            }
          } else if (earnToken) {
            if (isLoggedIn == true) {
              int newPoints = userPoints + 1;
              await HomeController.to
                  .updatePoints(
                      LoginBox.userBox!.values.first.authToken, newPoints)
                  .then((pointsUpdated) async {
                var userdata = await HomeController.to
                    .getuserData(LoginBox.userBox!.values.first.authToken);
                print('Points updated in logged In mode');

                Get.snackbar(
                    "${widget.song.title} is added to the library", '');
                // Perform additional actions with userdata
              });
            } else {
              int newPoints = offlineUserPoints++;
              await OfflineLibraryBox.updatePoints(newPoints.toString());
              print('Points updated in logged off mode');
              Get.snackbar("${widget.song.title} is Redeemed for 24 hours", '');
            }
            Get.snackbar('You have recieved a token', "");
          }
        }
      });
      _rewardedAd = null;
    }
  }

  Future<void> getAudioDuration() async {
    final duration = await player.getDuration();
    if (duration != null) {
      setState(() {
        maxValue = duration.inSeconds.toDouble();
      });
    }
  }

  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
    getAudioDuration(); // Play audio from the provided URL
  }

  Future<void> AddtoLibrary(BuildContext context) async {
    final int requiredTokens =
        int.tryParse(_calculateRequiredTokens(int.parse(widget.song.pages))) ??
            0;
    final String tokenText =
        _calculateRequiredTokens(int.parse(widget.song.pages));

    // Check if the user is logged in
    final bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;

    // Check if the song is already in the library
    final isSongInLibrary = OfflineLibraryBox
        .userBox!.values.first.offlineLibrary
        .contains(widget.song.detail);

    if (isSongInLibrary) {
      // Show a snackbar saying "Already in the library"
      if (isLoggedIn) {
        Get.snackbar("Already in the library", '');
      }
    } else if (tokenText == 'Watch video and redeem') {
      bool userWantsToWatchVideo = await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Not Enough Tokens'),
            content: const Text('Watch a video to earn a token?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(dialogContext)
                      .pop(false); // User declined to watch the video
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    earnReward = true;
                    earnToken = false;
                  });
                  Navigator.of(dialogContext)
                      .pop(true); // User wants to watch the video
                },
              ),
            ],
          );
        },
      );
      if (userWantsToWatchVideo) {
        if (OfflineLibraryBox.userBox!.values.first.adsWatched < 10) {
          showRewardedAd();
        } else {
          Get.snackbar('You have reached the total Ads limit for today', "");
        }
      }
    } else if (requiredTokens <= userPoints) {
      var _ = await OfflineLibraryBox.updateLibrary(widget.song.detail);
      var _data = HomeController.to
          .getuserData(LoginBox.userBox!.values.first.authToken);
      if (isLoggedIn) {
        Get.snackbar("${widget.song.title} is added to the library", '');
      } else {
        // Prompt the user to create an account
        Get.snackbar("Create an account to add items to the library", '');
      }
    } else {
      bool userWantsToWatchVideo = await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Not Enough Tokens'),
            content: const Text('Watch a video to earn a reward?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(dialogContext)
                      .pop(false); // User declined to watch the video
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    earnToken = true;
                    earnReward = false;
                  });
                  Navigator.of(dialogContext)
                      .pop(true); // User wants to watch the video
                },
              ),
            ],
          );
        },
      );
      if (userWantsToWatchVideo) {
        if (OfflineLibraryBox.userBox!.values.first.adsWatched < 10) {
          showRewardedAd();
        } else {
          Get.snackbar('You have reached the total Ads limit for today', "");
        }
      }
    }

    var a = OfflineLibrary.encodeOfflineLibrary(
        OfflineLibraryBox.userBox!.values.first.offlineLibrary);
    print(a);
    if (OfflineLibraryBox.userBox!.values.first.isLoggedIn == true) {
      int newPoints = userPoints - requiredTokens;
      var submitted = HomeController.to
          .updateLibrary(LoginBox.userBox!.values.first.authToken, a);
      var pointsUpdated = HomeController.to
          .updatePoints(LoginBox.userBox!.values.first.authToken, newPoints);
      var userdata = await HomeController.to
          .getuserData(LoginBox.userBox!.values.first.authToken);
    }
  }

  void checkOwnershipStatus() {
    final userLibrary = UserDataBox.userBox!.values.first.userDataLibrary;
    final songDetail = widget.song.detail;

    if (userLibrary.contains(songDetail)) {
      setState(() {
        isOwned = true;
      });
    } else {
      setState(() {
        isOwned = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isSongInLibrary = OfflineLibraryBox
        .userBox!.values.first.offlineLibrary
        .contains(widget.song.detail);

    final tokenText = _calculateRequiredTokens(int.parse(widget.song.pages));
    double tokenHeight = size.height * 0.04;
    double tokenWidth = size.width * 0.2;
    double tokenTextSize = 14.0;
    if (tokenText.length > 6) {
      tokenHeight = size.height * 0.05;
      tokenWidth = size.width * 0.25;
      tokenTextSize = 8.5;
    }
    String songPrice = calculateSongPrice(widget.song.pages);

    return SafeArea(
        child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
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
                    title: widget.song.title),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                height: size.height * 0.29,
                                width: size.width * 0.36,
                                decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/background.jpeg'),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColors.darkBlue),
                                child: Stack(
                                  children: [
                                    hide == true
                                        ? BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2, sigmaY: 2),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          if (!isSongInLibrary &&
                                              int.parse(widget.song.pages) ==
                                                  1) {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext dialogContext) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Watch a Video'),
                                                  content: const Text(
                                                      'Watch a video to earn a reward?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(
                                                                dialogContext)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('Yes'),
                                                      onPressed: () {
                                                        earnRewardOpenPDF =
                                                            true;
                                                        if (OfflineLibraryBox
                                                                .userBox!
                                                                .values
                                                                .first
                                                                .adsWatched <
                                                            10) {
                                                          showRewardedAd();
                                                        } else {
                                                          Get.snackbar(
                                                              'You have reached the total Ads limit for today',
                                                              "");
                                                        }
                                                        Navigator.of(
                                                                dialogContext)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            player.pause();
                                            if (isSongInLibrary) {
                                              // If the song is in the library, open the PDF file from the local storage
                                              String localPdfPath =
                                                  '/storage/emulated/0/PianoTab/${widget.song.title}.pdf';
                                              bool fileExists =
                                                  await File(localPdfPath)
                                                      .exists();

                                              if (fileExists) {
                                                print(
                                                    'opening from local storage');
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (BuildContext bc) {
                                                    return PdfViewerScreen(
                                                      pdfPath: localPdfPath,
                                                      title: widget.song.title,
                                                      type: 'local',
                                                    );
                                                  },
                                                );
                                              } else {
                                                print('opening from network');
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (BuildContext bc) {
                                                      return PdfViewerScreen(
                                                        pdfPath: HomeController
                                                            .to
                                                            .getOriginalbookPdfSource(
                                                                widget.song
                                                                    .detail),
                                                        title:
                                                            widget.song.title,
                                                        type: 'network',
                                                      );
                                                    });
                                              }
                                            } else {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (BuildContext bc) {
                                                    return PdfViewerScreen(
                                                      pdfPath: isSongInLibrary
                                                          ? HomeController.to
                                                              .getOriginalbookPdfSource(
                                                                  widget.song
                                                                      .detail)
                                                          : HomeController.to
                                                              .getSamplePdfSource(
                                                                  widget.song
                                                                      .detail),
                                                      title: widget.song.title,
                                                      type: 'network',
                                                    );
                                                  });
                                            }
                                          }
                                        },
                                        child: Icon(
                                          CupertinoIcons.eye_fill,
                                          size: 40,
                                          color: MyColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                height: size.height * 0.29,
                                width: size.width * 0.54,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    !isSongInLibrary
                                        ? Row(
                                            children: [
                                              CustomContainer(
                                                onpressed: () {
                                                  AddtoLibrary(context);
                                                },
                                                height: tokenHeight,
                                                width: tokenWidth,
                                                color: MyColors.whiteColor,
                                                borderRadius: 8,
                                                borderColor:
                                                    MyColors.primaryColor,
                                                borderWidth: 1.5,
                                                widget: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          MyColors.transparent,
                                                      backgroundImage:
                                                          const AssetImage(
                                                              'assets/images/logo_2.png'),
                                                      maxRadius: 8,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: size.width *
                                                            0.15, // Adjust based on your layout
                                                      ),
                                                      child: Text(
                                                        tokenText,
                                                        style: TextStyle(
                                                          color: MyColors
                                                              .blueColor,
                                                          fontSize:
                                                              tokenTextSize,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              CustomContainer(
                                                onpressed: () async {
                                                  if (isLoggedIn) {
                                                    var _ = await HomeController
                                                        .addToCart(widget.song);

                                                    setState(() {
                                                      HomeController
                                                              .to
                                                              .totalCartItemCount
                                                              .value =
                                                          HomeController.to
                                                              .cartItems.length;
                                                    });

                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return CartScreen();
                                                      },
                                                    );
                                                    if (_) {
                                                      Get.snackbar(
                                                          "Added to Cart", "");
                                                    } else {
                                                      Get.snackbar(
                                                          "Already in Cart",
                                                          "");
                                                    }
                                                  } else {
                                                    Get.snackbar(
                                                        "You need to Sign In to Add item to cart",
                                                        "");
                                                  }
                                                },
                                                height: size.height * 0.04,
                                                width: size.width * 0.15,
                                                color: MyColors.primaryColor,
                                                borderRadius: 10,
                                                borderColor:
                                                    MyColors.transparent,
                                                borderWidth: 0,
                                                widget: Center(
                                                  child: TextWidget(
                                                    text: '\$ $songPrice',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  if (!isSongInLibrary) {
                                                    setState(() {
                                                      final favorites =
                                                          OfflineLibraryBox
                                                              .userBox!
                                                              .values
                                                              .first
                                                              .favourites;
                                                      if (favorites.contains(
                                                          widget.song.detail)) {
                                                        // Remove from favorites
                                                        OfflineLibraryBox
                                                            .removeFromFavorites(
                                                                widget.song
                                                                    .detail);
                                                        if (OfflineLibraryBox
                                                            .userBox!
                                                            .values
                                                            .first
                                                            .isLoggedIn) {
                                                          Get.snackbar(
                                                              "Removed from favorites",
                                                              "");
                                                        }
                                                      } else {
                                                        // Add to favorites
                                                        OfflineLibraryBox
                                                            .addToFavorites(
                                                                widget.song
                                                                    .detail);
                                                        if (OfflineLibraryBox
                                                            .userBox!
                                                            .values
                                                            .first
                                                            .isLoggedIn) {
                                                          Get.snackbar(
                                                              "Added to Favorites",
                                                              "");
                                                        }
                                                      }
                                                    });
                                                  } else {
                                                    Get.snackbar(
                                                        'Already in the Library',
                                                        '');
                                                  }
                                                },
                                                child: Icon(
                                                  OfflineLibraryBox
                                                          .userBox!
                                                          .values
                                                          .first
                                                          .favourites
                                                          .contains(widget
                                                              .song.detail)
                                                      ? CupertinoIcons.star_fill
                                                      : CupertinoIcons.star,
                                                  color: MyColors.yellowColor,
                                                ),
                                              ),
                                              // CustomContainer(
                                              //   onpressed: () {},
                                              //   height: size.height * 0.04,
                                              //   width: size.width * 0.2,
                                              //   color: MyColors.primaryColor,
                                              //   borderRadius: 10,
                                              //   borderColor:
                                              //       MyColors.transparent,
                                              //   borderWidth: 0,
                                              //   widget: const Center(
                                              //     child: TextWidget(
                                              //       text: 'Book',
                                              //       fontSize: 14,
                                              //     ),
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   width: 5,
                                              // ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     setState(() {
                                              //       final favorites =
                                              //           OfflineLibraryBox
                                              //               .userBox!
                                              //               .values
                                              //               .first
                                              //               .favourites;
                                              //       if (favorites.contains(
                                              //           widget.song.detail)) {
                                              //         // Remove from favorites
                                              //         OfflineLibraryBox
                                              //             .removeFromFavorites(
                                              //                 widget
                                              //                     .song.detail);
                                              //         if (OfflineLibraryBox
                                              //             .userBox!
                                              //             .values
                                              //             .first
                                              //             .isLoggedIn) {
                                              //           Get.snackbar(
                                              //               "Removed from favorites",
                                              //               "");
                                              //         }
                                              //       } else {
                                              //         // Add to favorites
                                              //         OfflineLibraryBox
                                              //             .addToFavorites(widget
                                              //                 .song.detail);
                                              //         if (OfflineLibraryBox
                                              //             .userBox!
                                              //             .values
                                              //             .first
                                              //             .isLoggedIn) {
                                              //           Get.snackbar(
                                              //               "Added to Favorites",
                                              //               "");
                                              //         }
                                              //       }
                                              //     });
                                              //   },
                                              //   child: Icon(
                                              //     OfflineLibraryBox
                                              //             .userBox!
                                              //             .values
                                              //             .first
                                              //             .favourites
                                              //             .contains(widget
                                              //                 .song.detail)
                                              //         ? CupertinoIcons
                                              //             .heart_fill
                                              //         : CupertinoIcons.heart,
                                              //     color: MyColors.red,
                                              //   ),
                                              // )
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (!isSongInLibrary) {
                                                    setState(() {
                                                      final favorites =
                                                          OfflineLibraryBox
                                                              .userBox!
                                                              .values
                                                              .first
                                                              .favourites;
                                                      if (favorites.contains(
                                                          widget.song.detail)) {
                                                        // Remove from favorites
                                                        OfflineLibraryBox
                                                            .removeFromFavorites(
                                                                widget.song
                                                                    .detail);
                                                        if (OfflineLibraryBox
                                                            .userBox!
                                                            .values
                                                            .first
                                                            .isLoggedIn) {
                                                          Get.snackbar(
                                                              "Removed from favorites",
                                                              "");
                                                        }
                                                      } else {
                                                        // Add to favorites
                                                        OfflineLibraryBox
                                                            .addToFavorites(
                                                                widget.song
                                                                    .detail);
                                                        if (OfflineLibraryBox
                                                            .userBox!
                                                            .values
                                                            .first
                                                            .isLoggedIn) {
                                                          Get.snackbar(
                                                              "Added to Favorites",
                                                              "");
                                                        }
                                                      }
                                                    });
                                                  } else {
                                                    Get.snackbar(
                                                        'Already in the Library',
                                                        '');
                                                  }
                                                },
                                                child: Icon(
                                                  OfflineLibraryBox
                                                          .userBox!
                                                          .values
                                                          .first
                                                          .favourites
                                                          .contains(widget
                                                              .song.detail)
                                                      ? CupertinoIcons.star_fill
                                                      : CupertinoIcons.star,
                                                  color: MyColors.yellowColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: size.height * 0.03,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextWidget(
                                                text: 'Artist:',
                                                fontSize: 15,
                                                color: MyColors.blackColor,
                                              ),
                                            ),
                                            Expanded(
                                              child: TextWidget(
                                                text: widget.song.artist,
                                                fontSize: 15,
                                                color: MyColors.blackColor,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextWidget(
                                                text: 'Genre',
                                                fontSize: 15,
                                                color: MyColors.blackColor,
                                              ),
                                            ),
                                            Expanded(
                                              child: TextWidget(
                                                text: widget.song.genre,
                                                fontSize: 15,
                                                color: MyColors.blackColor,
                                                overflow: TextOverflow
                                                    .ellipsis, // Display ellipsis if the text overflows
                                                maxLines:
                                                    1, // Limit text to a single line
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextWidget(
                                                text: 'Difficulty:',
                                                fontSize: 15,
                                                color: MyColors.blackColor,
                                              ),
                                            ),
                                            Expanded(
                                              child: TextWidget(
                                                text: widget.song.difficulty,
                                                fontSize: 14,
                                                color: MyColors.blackColor,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextWidget(
                                                text: 'Pages:',
                                                fontSize: 15,
                                                color: MyColors.blackColor,
                                              ),
                                            ),
                                            Expanded(
                                              child: TextWidget(
                                                text: widget.song.pages,
                                                fontSize: 15,
                                                color: MyColors.blackColor,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                      height: size.height * 0.076,
                                      width: size.width * 0.54,
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  play = !play;
                                                  print(HomeController.to
                                                      .getMp3Source(
                                                          widget.song.detail));
                                                });

                                                // Play or pause audio when the "Play" button is tapped
                                                if (play) {
                                                  playAudioFromUrl(
                                                      HomeController.to
                                                          .getMp3Source(widget
                                                              .song.detail));
                                                } else {
                                                  player.pause();
                                                }
                                              },
                                              child: Icon(
                                                play
                                                    ? Icons
                                                        .pause_circle_outline_outlined
                                                    : Icons
                                                        .play_circle_outline_outlined,
                                                size: 28,
                                                color: MyColors.blueColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: SliderTheme(
                                              data: const SliderThemeData(
                                                  trackHeight: 3,
                                                  trackShape:
                                                      RectangularSliderTrackShape(),
                                                  overlayShape:
                                                      RoundSliderOverlayShape(
                                                          overlayRadius: 8),
                                                  thumbShape:
                                                      RoundSliderThumbShape(
                                                          enabledThumbRadius:
                                                              5)),
                                              child: Slider(
                                                min: 0,
                                                max: maxValue,
                                                value: value,
                                                inactiveColor:
                                                    MyColors.greyColor,
                                                onChanged: (newValue) {
                                                  final position = Duration(
                                                      seconds:
                                                          newValue.toInt());
                                                  player.seek(position);
                                                  player.resume();
                                                  setState(() {
                                                    value = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  Row(
                                    children: [
                                      TextWidget(
                                        text: formatTime(value.toInt()),
                                        color: MyColors.blackColor,
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Container(
                                        height: size.height * 0.022,
                                        width: 1,
                                        color: MyColors.greyColor,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      TextWidget(
                                        text: formatTime(maxValue.toInt()),
                                        color: MyColors.blackColor,
                                        fontSize: 12,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Row(
                        children: [
                          CustomContainer(
                              onpressed: () async {
                                final url = Uri.parse(widget.song.imageUrl);
                                final response = await http.get(url);
                                final bytes = response.bodyBytes;
                                final temp = await getTemporaryDirectory();
                                final path = '${temp.path}/image.jpg';
                                File(path).writeAsBytesSync(bytes);
                                final XFile xfile = XFile(path);
                                await Share.shareXFiles([xfile],
                                    text:
                                        'Checkout ${widget.song.title} on Play Store');
                                // 'Checkout ${widget.song.title} on Play Store:https://play.google.com/store/apps/details?id=com.pianotab.app');
                                // : 'Checkout \'${widget.song.title}\' on App Store: https://apps.apple.com/pk/app/piano-tab/id1330123889');
                              },
                              height: size.height * 0.04,
                              width: size.width * 0.22,
                              color: MyColors.whiteColor,
                              borderRadius: 10,
                              borderColor: MyColors.primaryColor,
                              borderWidth: 1.5,
                              widget: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextWidget(
                                          text: 'Share',
                                          fontSize: 12,
                                          color: MyColors.primaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        Container(
                                          height: size.height * 0.025,
                                          width: 1,
                                          color: MyColors.primaryColor
                                              .withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Icon(
                                      CupertinoIcons.share,
                                      size: 16,
                                      color: MyColors.primaryColor,
                                    ),
                                  )
                                ],
                              )),
                          // SizedBox(
                          //   width: size.width * 0.02,
                          // ),
                          // Icon(
                          //   Icons.playlist_add,
                          //   size: 32,
                          //   color: MyColors.primaryColor,
                          // )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      TextWidget(
                        text: 'Description',
                        color: MyColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text(widget.song.description,
                          style: TextStyle(
                              color: MyColors.blackColor.withOpacity(0.4),
                              fontSize: 16.sp)),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
            valueListenable: HomeController.to.totalCartItemCount,
            builder: (context, val, c) {
              return Visibility(
                  visible: val > 0,
                  child: Positioned(
                    bottom: 90,
                    right: 15,
                    child: Stack(
                      children: [
                        Material(
                          elevation: 6,
                          shape: CircleBorder(),
                          child: FloatingActionButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext bc) {
                                  return CartScreen();
                                },
                              );
                            },
                            backgroundColor: MyColors.primaryColor,
                            child: Icon(
                              Icons.shopping_cart,
                              color: MyColors.whiteColor,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MyColors.primaryColor,
                                width: 2.0,
                              ),
                              color: MyColors.whiteColor,
                            ),
                            child: Center(
                              child: TextWidget(
                                text: val.toString(),
                                color: MyColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            })
      ],
    ));
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int userPoints = int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;
  @override
  void initState() {
    super.initState();
    calculateTotalAmount();
    calculateTotalTokens();
  }

  String calculatePrice(String pages, String amazonPrice, bool isBook) {
    if (isBook) {
      double amazonPriceDouble = double.tryParse(amazonPrice) ?? 0.0;
      double bookPrice = amazonPriceDouble * 0.5;
      return '${bookPrice.round()}';
    } else {
      int pagesInt = int.tryParse(pages) ?? 0;
      double songPrice = pagesInt * 0.5;
      return '${songPrice.round()}';
    }
  }

  void calculateTotalAmount() {
    HomeController.to.totalAmount.value = 0;

    for (var cartItem in HomeController.to.cartItems) {
      HomeController.to.totalAmount.value += int.parse(calculatePrice(
          cartItem.pages,
          cartItem.amazonPrice,
          cartItem.detail.startsWith('BK')));
    }
  }

  String calculateRequiredTokens(int pages, bool isBook) {
    if (isBook) {
      double requiredTokens = 0;
      if (pages <= 75) {
        requiredTokens = pages * 0.5;
      } else if (pages >= 76 && pages <= 100) {
        requiredTokens = pages * 0.4;
      } else if (pages >= 101 && pages <= 300) {
        requiredTokens = pages * 0.25;
      }
      return '${requiredTokens.round()}'; // Round to the nearest integer
    } else {
      if (pages == 1) {
        return '1';
      } else if (pages >= 2 && pages <= 5) {
        return '${(pages * 3).round()}';
      } else {
        return '${(pages * 2).round()}';
      }
    }
  }

  void calculateTotalTokens() {
    HomeController.to.totalTokensAwarded.value = 0;

    for (var cartItem in HomeController.to.cartItems) {
      HomeController.to.totalTokensAwarded.value += int.parse(
          calculateRequiredTokens(
              int.parse(cartItem.pages), cartItem.detail.startsWith('BK')));
    }
  }

  List<Map<String, dynamic>> getItemsDetails() {
    List<Map<String, dynamic>> itemsList = [];

    for (var cartItem in HomeController.to.cartItems) {
      String sku = cartItem.detail;
      String title = cartItem.title;
      String artist = cartItem.artist;
      String price = calculatePrice(cartItem.pages, cartItem.amazonPrice,
          cartItem.detail.startsWith('BK'));

      itemsList.add({
        "name": sku,
        "quantity": 1,
        "price": price,
        "currency": "USD",
      });
    }

    return itemsList;
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
    return Obx(() {
      return SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
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
                    title: 'Your Cart',
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: HomeController.to.cartItems.length,
                            itemBuilder: (context, index) {
                              ListItemModel cartItem =
                                  HomeController.to.cartItems[index];
                              return CartItem(
                                list: cartItem,
                                onRemove: () async {
                                  var _ = await HomeController.removeFromCart(
                                      cartItem);
                                  setState(() {
                                    HomeController.to.totalCartItemCount.value =
                                        HomeController.to.cartItems.length;
                                  });
                                  calculateTotalAmount();
                                  calculateTotalTokens();
                                  if (_) {
                                    Get.snackbar(
                                        "Item removed from the cart", '');
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 35),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
              valueListenable: HomeController.to.totalAmount,
              builder: (context, amount, c) {
                return ValueListenableBuilder(
                    valueListenable: HomeController.to.totalTokensAwarded,
                    builder: (context, token, c) {
                      return Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: InkWell(
                            onTap: () {
                              String transactionsJson = jsonEncode([
                                {
                                  "amount": {
                                    "total": amount.toString(),
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": amount.toString(),
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    },
                                    "description":
                                        "The payment transaction description.",
                                    "item_list": {
                                      "items": [
                                        {
                                          "name": "A demo product",
                                          "quantity": 1,
                                          "price": '10.12',
                                          "currency": "USD"
                                        }
                                      ],
                                    }
                                  },
                                }
                              ]);

                              print("Transactions JSON: $transactionsJson");
                              Get.to(UsePaypal(
                                sandboxMode: true,
                                clientId:
                                    "ATN1ojtdC_jqrMRvAll4ZplkSCuYse4s_o592nubbS-VjubMp2mBIlBgg1qXhSkxrxcFCqe2RxygL7_R",
                                secretKey:
                                    "EJH5ZtrISXwW3HkfiGJ8eI4PnR0vUPz7gPpaZtNMNKPGB1nkRygPa3H7A09IdpxhnrASDq1-LdIWFjBl",
                                returnURL: "https://samplesite.com/return",
                                cancelURL: "https://samplesite.com/cancel",
                                transactions: [
                                  {
                                    "amount": {
                                      "total": amount.toString(),
                                      "currency": "USD",
                                      "details": {
                                        "subtotal": amount.toString(),
                                        "shipping": '0',
                                        "shipping_discount": 0
                                      }
                                    },
                                    "description":
                                        "The payment transaction description.",
                                    // "payment_options": {
                                    //   "allowed_payment_method":
                                    //       "INSTANT_FUNDING_SOURCE"
                                    // },
                                    "item_list": {
                                      "items": getItemsDetails(),

                                      // shipping address is not required though
                                      // "shipping_address": {
                                      //   "recipient_name": "Jane Foster",
                                      //   "line1": "Travis County",
                                      //   "line2": "",
                                      //   "city": "Austin",
                                      //   "country_code": "US",
                                      //   "postal_code": "73301",
                                      //   "phone": "+00000000",
                                      //   "state": "Texas"
                                      // },
                                    }
                                  }
                                ],
                                note:
                                    "Contact us for any questions on your order.",
                                onSuccess: (Map params) async {
                                  if (mounted) {
                                    print("onSuccess: $params");
                                    for (var cartItem
                                        in HomeController.to.cartItems) {
                                      await OfflineLibraryBox.updateLibrary(
                                          cartItem.detail);
                                    }
                                    var a = OfflineLibrary.encodeOfflineLibrary(
                                        OfflineLibraryBox.userBox!.values.first
                                            .offlineLibrary);
                                    print(a);
                                    int newPoints = userPoints + token;
                                    var submitted = await HomeController.to
                                        .updateLibrary(
                                            LoginBox.userBox!.values.first
                                                .authToken,
                                            a);
                                    var pointsUpdated = await HomeController.to
                                        .updatePoints(
                                            LoginBox.userBox!.values.first
                                                .authToken,
                                            newPoints);
                                    var userdata = await HomeController.to
                                        .getuserData(LoginBox
                                            .userBox!.values.first.authToken);

                                    await HomeController.emptyCart();

                                    Get.snackbar(
                                        "You've been awarded $token tokens",
                                        '');

                                    setState(() {
                                      HomeController
                                              .to.totalCartItemCount.value =
                                          HomeController.to.cartItems.length;
                                    });
                                    calculateTotalAmount();
                                  } else {
                                    Get.snackbar(
                                        "Problem occured in making the payment",
                                        '');
                                  }
                                },
                                onError: (error) {
                                  print("onError: $error");
                                },
                                onCancel: (params) {
                                  print('cancelled: $params');
                                },
                              ));
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: MyColors.grey,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          text: 'Total Amount : ',
                                          color: MyColors
                                              .blackColor, // Set the text color
                                        ),
                                        Spacer(),
                                        TextWidget(
                                          text: " \$ $amount",
                                          color: MyColors
                                              .blackColor, // Set the text color
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: MyColors.bottomColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          text: 'Pay with ',
                                          color: MyColors
                                              .whiteColor, // Set the text color
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              'assets/images/paypal.png',
                                              height: 45),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    });
              })
        ],
      ));
    });
  }

  Widget notLoggedInView(Size size) {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
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
                    title: 'Your Cart'),
              ),
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

class CartItem extends StatefulWidget {
  final ListItemModel list;
  final VoidCallback onRemove;
  const CartItem({Key? key, required this.list, required this.onRemove})
      : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  String calculatePrice(String pages, String amazonPrice, bool isBook) {
    if (isBook) {
      double amazonPriceDouble = double.tryParse(amazonPrice) ?? 0.0;
      double bookPrice = amazonPriceDouble * 0.5;
      return '${bookPrice.round()}';
    } else {
      int pagesInt = int.tryParse(pages) ?? 0;
      double songPrice = pagesInt * 0.5;
      return '${songPrice.round()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bool isBook = widget.list.detail.startsWith('BK');
    String price =
        calculatePrice(widget.list.pages, widget.list.amazonPrice, isBook);

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Positioned(
            top: 0,
            right: 4,
            child: InkWell(
              onTap: () {
                widget.onRemove();
              },
              child: Icon(
                Icons.delete,
                color: MyColors.red,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: size.height * 0.18,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: isBook
                                ? NetworkImage(widget.list.imageUrl)
                                : const AssetImage(
                                        'assets/images/background.jpeg')
                                    as ImageProvider,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: MyColors.darkBlue,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: widget.list.title,
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: MyColors.blackColor,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.0175),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                TextWidget(
                                  text: 'SKU: ',
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: MyColors.blackColor,
                                ),
                                TextWidget(
                                  text: widget.list.detail,
                                  fontSize: size.width * 0.035,
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.009),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                TextWidget(
                                  text: 'Artist: ',
                                  fontSize: size.width * 0.033,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: MyColors.blackColor,
                                ),
                                TextWidget(
                                  text: widget.list.artist,
                                  fontSize: size.width * 0.033,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: MyColors.blackColor,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.009),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                TextWidget(
                                  text: 'Pages:',
                                  fontSize: size.width * 0.033,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: MyColors.blackColor,
                                ),
                                TextWidget(
                                  text: widget.list.pages,
                                  fontSize: size.width * 0.033,
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.009),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                TextWidget(
                                  text: 'Difficulty: ',
                                  fontSize: size.width * 0.033,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: MyColors.blackColor,
                                ),
                                TextWidget(
                                  text: widget.list.difficulty,
                                  fontSize: size.width * 0.033,
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.001),
              Center(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: CustomContainer(
                      onpressed: () {},
                      height: size.height * 0.04,
                      width: size.width,
                      color: MyColors.primaryColor,
                      borderRadius: 5,
                      borderColor: MyColors.primaryColor,
                      borderWidth: 1.2,
                      widget: TextWidget(
                        text: 'Price : \$ $price',
                        color: MyColors.whiteColor,
                        fontSize: size.width * 0.033,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )),
              ))
            ],
          ),
        ]));
  }
}
