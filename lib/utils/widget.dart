import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paino_tab/models/localdbmodels/Boxes.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';
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
                        text: '23',
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
                  onpressed: () {},
                  height: size.height * 0.035,
                  width: size.width * 0.2,
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
                    text: 'Follow us on instagram',
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: MyColors.primaryColor,
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
                              text: '23',
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
                height: size.height * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Follow us on Facebook',
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
                              text: '23',
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
                height: size.height * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Follow us on Twitter',
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
                              text: '23',
                              fontSize: 12,
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
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
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap: () {
            query = result;
          },
          title: TextWidget(
            text: result,
            color: MyColors.blackColor,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var srch in items) {
      if (srch.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(srch);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap: () {
            query = result;
          },
          title: TextWidget(
            text: result,
            color: MyColors.blackColor,
          ),
        );
      },
    );
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
            onpressed: ()async {
              await Boxes.getUserBox().clear();
              // HomeController.to.setEmail('');
              // HomeController.to.setUserName('');
              HomeController.to.index = 0;

              Get.offAll(() => const HomeScreen(
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
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomContainer(
            onpressed: () {
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
            )),
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
  const TextWidget(
      {super.key,
      this.onTap,
      required this.text,
      this.color,
      this.fontFamily,
      this.fontSize,
      this.letterSpacing,
      this.fontWeight,
      this.underline,
      this.overflow});
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final TextDecoration? underline;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: fontFamily ?? 'Inter',
            color: color ?? MyColors.whiteColor,
            fontWeight: fontWeight ?? FontWeight.w400,
            letterSpacing: letterSpacing ?? 0.1,
            fontSize: fontSize ?? 16,
            overflow: overflow,
            decoration: underline ?? TextDecoration.none),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
                onpressed: () async {
                  String authToken =
                      await MyAuthenticationService().authenticateWithGoogle();
                  if (authToken != null) {
                    // Authentication successful, you can add your logic here
                  } else {
                    // Handle authentication failure
                  }
                },
                height: size.height * 0.05,
                width: size.width * 0.35,
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
                            height: 20,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )),
            CustomContainer(
                onpressed: () {},
                height: size.height * 0.05,
                width: size.width * 0.35,
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
                            'assets/images/apple.png',
                            height: 20,
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
                        text: 'Apple',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )),
          ],
        ),
        SizedBox(
          height: size.height * 0.018,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
                onpressed: () {},
                height: size.height * 0.05,
                width: size.width * 0.35,
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
                            'assets/images/twitter.png',
                            height: 20,
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
                        text: 'Twitter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )),
            CustomContainer(
                onpressed: () {},
                height: size.height * 0.05,
                width: size.width * 0.35,
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
                            'assets/images/facebook.png',
                            height: 20,
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
                        text: 'Facebook',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )),
          ],
        )
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
  final SongModel list;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                Container(
                  height: 165.h,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpeg'),
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
              width: 145.w,
              color: MyColors.darkBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: list.title,
                      fontSize: 14.sp,
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
                          color: list.color == 'red'
                              ? MyColors.red
                              : list.color == 'yellow'
                                  ? MyColors.yellowColor
                                  : MyColors.transparent,
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
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: MyColors.yellowColor,
                              size: 20,
                            ),
                            TextWidget(
                              text: list.rating,
                              fontSize: 14.sp,
                            )
                          ],
                        ),
                        TextWidget(
                          text: 'Pages: ${list.pages}',
                          fontSize: 12.sp,
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

class JazzWidget extends StatelessWidget {
  const JazzWidget({super.key, required this.list});
  final SongModel list;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 200.h,
        width: 120.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: MyColors.darkBlue),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 132.h,
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
            Container(
              height: 68.h,
              width: 145.w,
              color: MyColors.darkBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: list.title,
                      fontSize: 12.sp,
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: list.detail,
                          fontSize: 8.sp,
                          color: MyColors.lightGrey,
                        ),
                        Icon(
                          Icons.circle,
                          color: list.color == 'red'
                              ? MyColors.red
                              : list.color == 'yellow'
                                  ? MyColors.yellowColor
                                  : MyColors.transparent,
                          size: 12.h,
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
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: MyColors.yellowColor,
                              size: 12.h,
                            ),
                            TextWidget(
                              text: list.rating,
                              fontSize: 10.sp,
                            )
                          ],
                        ),
                        TextWidget(
                          text: 'Pages: ${list.pages}',
                          fontSize: 10.sp,
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

class BookWidget extends StatelessWidget {
  BookWidget({super.key, required this.list});
  final BookModel list;
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
                          color: list.color == 'red'
                              ? MyColors.red
                              : list.color == 'yellow'
                                  ? MyColors.yellowColor
                                  : MyColors.greenColor,
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
  const BookDetailScreen({super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool like = false;
  bool play = false;
  bool hide = true;
  double value = 0.0;
  double maxValue = 180.0;
  bool isOwned = true;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8);
  }

  void openPdfViewer(BuildContext context, bool isOwned) {
    if (isOwned) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PdfViewScreen(
              pdfPath:
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          image: AssetImage('assets/images/image1.jpg'),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.darkBlue),
                    child: Stack(
                      children: [
                        hide == true
                            ? BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              )
                            : const SizedBox(),
                        Center(
                            child: InkWell(
                          onTap: () {
                            openPdfViewer(context, isOwned);
                          },
                          child: Icon(
                            isOwned
                                ? CupertinoIcons.eye_fill
                                : CupertinoIcons.eye_slash_fill,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      backgroundColor: MyColors.transparent,
                                      backgroundImage: const AssetImage(
                                          'assets/images/amazon.png'),
                                      maxRadius: 8,
                                    ),
                                    TextWidget(
                                      text: '\$ 39.5',
                                      color: MyColors.whiteColor,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                              CustomContainer(
                                onpressed: () {},
                                height: size.height * 0.04,
                                width: size.width * 0.2,
                                color: MyColors.whiteColor,
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
                                          'assets/images/logo_2.png'),
                                      maxRadius: 8,
                                    ),
                                    TextWidget(
                                      text: '100',
                                      color: MyColors.blueColor,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    like = !like;
                                  });
                                },
                                child: Icon(
                                  like
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
                                  fontSize: 14,
                                  color: MyColors.blackColor,
                                ),
                              ),
                              Expanded(
                                child: TextWidget(
                                  text: 'Multiple',
                                  fontSize: 14,
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
                                  text: 'Genre:',
                                  fontSize: 14,
                                  color: MyColors.blackColor,
                                ),
                              ),
                              Expanded(
                                child: TextWidget(
                                  text: 'Pop',
                                  fontSize: 14,
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
                                  text: 'Difficulty:',
                                  fontSize: 14,
                                  color: MyColors.blackColor,
                                ),
                              ),
                              Expanded(
                                child: TextWidget(
                                  text: 'Various',
                                  fontSize: 14,
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
                                  text: 'Pages:',
                                  fontSize: 14,
                                  color: MyColors.blackColor,
                                ),
                              ),
                              Expanded(
                                child: TextWidget(
                                  text: '288',
                                  fontSize: 14,
                                  color: MyColors.blackColor,
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
                                    });
                                  },
                                  child: Icon(
                                    play
                                        ? Icons.pause_circle_outline_outlined
                                        : Icons.play_circle_outline_outlined,
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
                                      trackShape: RectangularSliderTrackShape(),
                                      overlayShape: RoundSliderOverlayShape(
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
                    onpressed: () {},
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                color: MyColors.primaryColor.withOpacity(0.5),
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
                Icon(
                  Icons.playlist_add,
                  size: 32,
                  color: MyColors.primaryColor,
                )
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
            TextWidget(
                color: MyColors.blackColor.withOpacity(0.4),
                fontSize: 16.sp,
                text:
                    '    This book contains 5 popular Philip Glass songs in piano tablature; a color coded, easy interpretation of piano music that requires little training. The piano tabs display right and left-hand fingering numbers with red and blue note letters,'),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              height: size.height * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}

class PdfViewScreen extends StatefulWidget {
  final String pdfPath;

  PdfViewScreen({
    required this.pdfPath,
  });

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  late PdfViewerController _pdfViewController;

  @override
  void initState() {
    _pdfViewController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => DownloadingDialog(
                        pdfPath: widget.pdfPath,
                      ));
            },
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {},
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfPath,
        controller: _pdfViewController,
      ),
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
  const SongDetailScreen({super.key});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  bool like = false;
  bool play = false;
  bool hide = true;
  double value = 0.0;
  double maxValue = 180.0;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          image: AssetImage('assets/images/background.jpeg'),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.darkBlue),
                    child: Stack(
                      children: [
                        hide == true
                            ? BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              )
                            : const SizedBox(),
                        Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                hide = !hide;
                              });
                            },
                            child: Icon(
                              hide == true
                                  ? CupertinoIcons.eye_fill
                                  : CupertinoIcons.eye_slash_fill,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomContainer(
                                onpressed: () {},
                                height: size.height * 0.04,
                                width: size.width * 0.2,
                                color: MyColors.whiteColor,
                                borderRadius: 10,
                                borderColor: MyColors.primaryColor,
                                borderWidth: 1.5,
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
                                        fontSize: 14,
                                        text: '100',
                                        color: MyColors.blueColor),
                                  ],
                                ),
                              ),
                              CustomContainer(
                                  onpressed: () {},
                                  height: size.height * 0.04,
                                  width: size.width * 0.2,
                                  color: MyColors.primaryColor,
                                  borderRadius: 10,
                                  borderColor: MyColors.transparent,
                                  borderWidth: 0,
                                  widget: const Center(
                                    child: TextWidget(
                                      text: 'Book',
                                      fontSize: 14,
                                    ),
                                  )),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    like = !like;
                                  });
                                },
                                child: Icon(
                                  like
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
                                height: size.height * 0.05,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextWidget(
                                      text: 'Artist:',
                                      fontSize: 14,
                                      color: MyColors.blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextWidget(
                                      text: 'In Un\'Altra Vita',
                                      fontSize: 14,
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
                                      text: 'Genre:',
                                      fontSize: 14,
                                      color: MyColors.blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextWidget(
                                      text: 'Contemporary',
                                      fontSize: 14,
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
                                      text: 'Dificulty:',
                                      fontSize: 14,
                                      color: MyColors.blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextWidget(
                                      text: 'Intermediate',
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
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
                                      text: 'Pages:',
                                      fontSize: 14,
                                      color: MyColors.blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextWidget(
                                      text: '37',
                                      fontSize: 14,
                                      color: MyColors.blackColor,
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
                                    });
                                  },
                                  child: Icon(
                                    play
                                        ? Icons.pause_circle_outline_outlined
                                        : Icons.play_circle_outline_outlined,
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
                                      trackShape: RectangularSliderTrackShape(),
                                      overlayShape: RoundSliderOverlayShape(
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
                    onpressed: () {},
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                color: MyColors.primaryColor.withOpacity(0.5),
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
                Icon(
                  Icons.playlist_add,
                  size: 32,
                  color: MyColors.primaryColor,
                )
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
            TextWidget(
                fontSize: 14.sp,
                color: MyColors.blackColor.withOpacity(0.4),
                text:
                    "Learn to play in UriAt1a Vita- Italian pianist Ludovico with Piano lab: a easy interlayoon ot I-vano muss: that requires little This beautiful was released from studio album or the intermediate Piano pia,, of A Vince with 172 music atity il Out getty cuic.xrv. you're a Visual learner, irirn.dated with the coriOhyites o standard wart an tool un In tyy Einaudi, this txx Leam to play n Ungua Vita- Oy Ludovico E-inaucS with Tao: a cavy inter;yetation Ot vianc muss; that loquite hrl. this beautifut was released in 2001 from tr.2 studio album l Gorrin Perfect intermediate tt. key o A Minu with 172 witn very ittle musu figure il out CtettV auicAV. a visual With standard wart to Vita by L Einaudi, this Ice to in unAt1a Ludovico Einaud with lab, a easy inter;yelayon ot musc that lit!le this Ceased Studio album l Gunt."),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
