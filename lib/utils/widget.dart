import 'dart:async';
import 'dart:io';
import 'dart:ui';
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
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/services/ad_mob_service.dart';
import 'package:paino_tab/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
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
  RewardedAd? _rewardedAd;
  final int userPoints =
      int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;
  @override
  void initState() {
    super.initState();
    createRewardedAd();
  }

  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _rewardedAd = null;
          });
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
        onUserEarnedReward: (ad, reward) {
          print("You earned a reward");

          // Your code to update points and user data
          int newPoints = userPoints + 1;

          HomeController.to
              .updatePoints(LoginBox.userBox!.values.first.authToken, newPoints)
              .then((pointsUpdated) async {
            var userdata = await HomeController.to
                .getuserData(LoginBox.userBox!.values.first.authToken);
            // Perform additional actions with userdata
          });
        },
      );
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
              child: TextWidget(
                text: widget.title,
                color: MyColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            CustomContainer(
                onpressed: () {
                  showAlertDialog(context, size);
                },
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
                        text: UserDataBox.userBox!.values.first.points,
                        fontSize: 12,
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ))
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
                  text: 'Rewards',
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
                          text: '23',
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
                      showRewardedAd;
                      int newpoints = userPoints + 1;
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
      title: Text("Rate This App"),
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
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 255, 217, 0),
                ),
                onRatingUpdate: (val) {
                  setState(() {
                    rating = val;
                  });
                },
              ),
              SizedBox(width: 8.0),
              TextWidget(
                text: '$rating',
                fontSize: 16,
                color: MyColors.blackColor,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          if (!isSubmitted) // Display the "Submit" button if not submitted
            ElevatedButton(
              onPressed: () {
                // Call the function to submit the rating
                submitRating(rating);
              },
              child: Text("Submit"),
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

    return SizedBox();
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
    return SizedBox();
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

              Get.offAll(() => const HomeScreen(
                    isLoggedIn: false,
                    initialIndex: 0,
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
      if (pages >= 24 && pages <= 75) {
        requiredTokens = pages * 0.5;
      } else if (pages >= 76 && pages <= 100) {
        requiredTokens = pages * 0.4;
      } else if (pages >= 101 && pages <= 300) {
        requiredTokens = pages * 0.025;
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 250.h,
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
                      )
                    : Container(
                        height: 165.h,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/background.jpeg'),
                                fit: BoxFit.fill)),
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
                        Spacer(),
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
                          width: 45.w,
                          color: MyColors.whiteColor,
                          borderRadius: 40,
                          borderColor: MyColors.transparent,
                          borderWidth: 0,
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/logo_2.png'),
                                maxRadius: 8,
                              ),
                              TextWidget(
                                fontSize: 12.sp,
                                text: tokenText,
                                color: MyColors.blackColor,
                              ),
                            ],
                          ),
                        ),
                        isBook
                            ? CustomContainer(
                                onpressed: () {},
                                height: size.height * 0.028,
                                width: size.width * 0.20,
                                color: MyColors.whiteColor,
                                borderRadius: 40,
                                borderColor: MyColors.transparent,
                                borderWidth: 0,
                                widget: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextWidget(
                                      text: ' \$ ${list.amazonPrice}',
                                      color: MyColors.blackColor,
                                      fontSize: 12.sp,
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
                                ))
                            : TextWidget(
                                text: 'Pages: ${list.pages}',
                                fontSize: 11.sp,
                              )
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

class NewReleasesWidget extends StatelessWidget {
  const NewReleasesWidget({super.key, required this.list});
  final ListItemModel list;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 120.h,
        width: 200.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: MyColors.darkBlue, // Border color
            ),
            color: MyColors.whiteColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 110.h,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpeg'),
                      fit: BoxFit.fill)),
              child: Center(
                child: CircleAvatar(
                  maxRadius: 35,
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
  final player = AudioPlayer();
  late Timer timer;
  late PdfViewerController _pdfViewController;
  final int userPoints =
      int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8);
  }

  void initState() {
    super.initState();
    _pdfViewController = PdfViewerController();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    if (pages >= 24 && pages <= 75) {
      requiredTokens = pages * 0.5;
    } else if (pages >= 76 && pages <= 100) {
      requiredTokens = pages * 0.4;
    } else if (pages >= 101 && pages <= 300) {
      requiredTokens = pages * 0.25;
    }
    return '${requiredTokens.round()}'; // Round to the nearest integer
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
      Get.snackbar("Not enough tokens", '');
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
    return SafeArea(
      child: Padding(
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
                  title: 'Book'),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Center(
                      child: TextWidget(
                        text: widget.book.title,
                        fontSize: 15,
                        color: MyColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      )
                                    : const SizedBox(),
                                Center(
                                    child: InkWell(
                                  onTap: () {
                                    _showPdfViewer(
                                        context,
                                        isOwned
                                            ? HomeController.to
                                                .getOriginalPdfSource(
                                                    widget.book.detail)
                                            : HomeController.to
                                                .getSamplePdfSource(
                                                    widget.book.detail));
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
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomContainer(
                                        onpressed: () {},
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
                                              backgroundColor:
                                                  MyColors.transparent,
                                              backgroundImage: const AssetImage(
                                                  'assets/images/amazon.png'),
                                              maxRadius: 8,
                                            ),
                                            TextWidget(
                                              text: widget.book.amazonPrice,
                                              color: MyColors.whiteColor,
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                      !isSongInLibrary
                                          ? CustomContainer(
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
                                                        MyColors.transparent,
                                                    backgroundImage:
                                                        const AssetImage(
                                                            'assets/images/logo_2.png'),
                                                    maxRadius: 8,
                                                  ),
                                                  TextWidget(
                                                    text:
                                                        '${calculateRequiredTokens(int.parse(widget.book.pages))}', // Convert pages to int
                                                    color: MyColors.blueColor,
                                                    fontSize: 14,
                                                  )
                                                ],
                                              ),
                                            )
                                          : (isLoggedIn
                                              ? SizedBox()
                                              : TextWidget(
                                                  text: 'Redeemed',
                                                  color: MyColors.blackColor)),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            final favorites = OfflineLibraryBox
                                                .userBox!
                                                .values
                                                .first
                                                .favourites;
                                            if (favorites
                                                .contains(widget.book.detail)) {
                                              // Remove from favorites
                                              OfflineLibraryBox
                                                  .removeFromFavorites(
                                                      widget.book.detail);
                                              if (OfflineLibraryBox.userBox!
                                                  .values.first.isLoggedIn) {
                                                Get.snackbar(
                                                    "Removed from favorites",
                                                    "");
                                              }
                                            } else {
                                              // Add to favorites
                                              OfflineLibraryBox.addToFavorites(
                                                  widget.book.detail);
                                              if (OfflineLibraryBox.userBox!
                                                  .values.first.isLoggedIn) {
                                                Get.snackbar(
                                                    "Added to favorites", "");
                                              }
                                            }
                                          });
                                        },
                                        child: Icon(
                                          OfflineLibraryBox.userBox!.values
                                                  .first.favourites
                                                  .contains(widget.book.detail)
                                              ? CupertinoIcons.heart_fill
                                              : CupertinoIcons.heart,
                                          color: MyColors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.05,
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
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: size.height * 0.076,
                                  width: size.width * 0.54,
                                  padding: const EdgeInsets.only(
                                    left: 10,
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
                                                      widget.book.detail));
                                            });

                                            // Play or pause audio when the "Play" button is tapped
                                            if (play) {
                                              playAudioFromUrl(HomeController.to
                                                  .getMp3Source(
                                                      widget.book.detail));
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
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 5)),
                                          child: Slider(
                                            min: 0,
                                            max: maxValue,
                                            value: value,
                                            inactiveColor: MyColors.greyColor,
                                            onChanged: (newValue) {
                                              setState(() {
                                                value = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }

  void _showPdfViewer(BuildContext context, String pdfPath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return FractionallySizedBox(
          heightFactor: 0.95, // Occupies full screen height
          child: Container(
            child: Column(
              children: [
                AppBar(
                  title: TextWidget(text: widget.book.title),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DownloadingDialog(
                            pdfPath: pdfPath, // Pass the PDF path to the dialog
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.print),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
                Expanded(
                  child: SfPdfViewer.network(
                    pdfPath, // Use the passed PDF path here
                    controller: _pdfViewController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DownloadingDialog extends StatefulWidget {
  final String pdfPath;

  DownloadingDialog({
    required this.pdfPath,
  });

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;

  void startDownloading() async {
    const String fileName = "PDF";

    String path = await _getFilePath(fileName);

    await dio.download(
      widget.pdfPath,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });

        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    print("${dir.path}/$filename");
    return "${dir.path}/$filename";
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
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
  RewardedAd? _rewardedAd;
  late PdfViewerController _pdfViewController;
  bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;
  final int userPoints =
      int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;

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

  @override
  void initState() {
    super.initState();
    createRewardedAd();
    _pdfViewController = PdfViewerController();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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

  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _rewardedAd = null;
          });
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

      await _rewardedAd!.show(
          onUserEarnedReward: ((ad, reward) => {print("You earned a reward")}));
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
      await OfflineLibraryBox.updateLibrary(widget.song.detail);
      showRewardedAd();
      if (isLoggedIn) {
        Get.snackbar("Create an account to add items to the library", '');
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
      if (isLoggedIn) {
        Get.snackbar("Not enough tokens", '');
      } else {
        // Prompt the user to create an account
        Get.snackbar("Create an account to add items to the library", '');
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
    final bookDetail = widget.song.detail;

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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isSongInLibrary = OfflineLibraryBox
        .userBox!.values.first.offlineLibrary
        .contains(widget.song.detail);
    return Padding(
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
                title: 'Song'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Center(
                    child: TextWidget(
                      text: widget.song.title,
                      fontSize: 15,
                      color: MyColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                                image:
                                    AssetImage('assets/images/background.jpeg'),
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
                                        color: Colors.black.withOpacity(0.1),
                                      ),
                                    )
                                  : const SizedBox(),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    _showPdfViewer(
                                        context,
                                        isOwned
                                            ? HomeController.to
                                                .getOriginalPdfSource(
                                                    widget.song.detail)
                                            : HomeController.to
                                                .getSamplePdfSource(
                                                    widget.song.detail));
                                  },
                                  child: Icon(
                                    CupertinoIcons.eye_fill,
                                    size: 40,
                                    color: MyColors.whiteColor,
                                  ),
                                ),
                              ),
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
                                Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final tokenText =
                                            _calculateRequiredTokens(
                                                int.parse(widget.song.pages));
                                        double tokenWidth = size.width * 0.2;
                                        double tokenTextSize = 14.0;

                                        // Check the length of tokenText and adjust width and text size accordingly
                                        if (tokenText.length > 6) {
                                          tokenWidth = constraints.maxWidth *
                                              1; // Adjusted width
                                          tokenTextSize =
                                              10.75; // Adjusted text size
                                        }

                                        return !isSongInLibrary
                                            ? CustomContainer(
                                                onpressed: () {
                                                  AddtoLibrary(context);
                                                },
                                                height: size.height * 0.04,
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
                                                    TextWidget(
                                                      text:
                                                          tokenText, // Convert pages to int
                                                      color: MyColors.blueColor,
                                                      fontSize: tokenTextSize,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : (isLoggedIn
                                                ? SizedBox()
                                                : TextWidget(
                                                    text: 'Redeemed',
                                                    color:
                                                        MyColors.blackColor));
                                      },
                                    ),
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          final favorites = OfflineLibraryBox
                                              .userBox!.values.first.favourites;
                                          if (favorites
                                              .contains(widget.song.detail)) {
                                            // Remove from favorites
                                            OfflineLibraryBox
                                                .removeFromFavorites(
                                                    widget.song.detail);
                                            if (OfflineLibraryBox.userBox!
                                                .values.first.isLoggedIn) {
                                              Get.snackbar(
                                                  "Removed from favorites", "");
                                            }
                                          } else {
                                            // Add to favorites
                                            OfflineLibraryBox.addToFavorites(
                                                widget.song.detail);
                                            if (OfflineLibraryBox.userBox!
                                                .values.first.isLoggedIn) {
                                              Get.snackbar(
                                                  "Added to favorites", "");
                                            }
                                          }
                                        });
                                      },
                                      child: Icon(
                                        OfflineLibraryBox.userBox!.values.first
                                                .favourites
                                                .contains(widget.song.detail)
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart,
                                        color: MyColors.red,
                                      ),
                                    )
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
                                              playAudioFromUrl(HomeController.to
                                                  .getMp3Source(
                                                      widget.song.detail));
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
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 5)),
                                          child: Slider(
                                            min: 0,
                                            max: maxValue,
                                            value: value,
                                            inactiveColor: MyColors.greyColor,
                                            onChanged: (newValue) {
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
                                text: '${widget.song.title}');
                          },
                          height: size.height * 0.04,
                          width: size.width * 0.22,
                          color: MyColors.whiteColor,
                          borderRadius: 10,
                          borderColor: MyColors.primaryColor,
                          borderWidth: 1.5,
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }

  void _showPdfViewer(BuildContext context, String pdfPath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return FractionallySizedBox(
          heightFactor: 0.95, // Occupies full screen height
          child: Container(
            child: Column(
              children: [
                AppBar(
                  title: TextWidget(text: widget.song.title),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DownloadingDialog(
                            pdfPath: pdfPath, // Pass the PDF path to the dialog
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.print),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
                Expanded(
                  child: SfPdfViewer.network(
                    pdfPath, // Use the passed PDF path here
                    controller: _pdfViewController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
