import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/utils/widget.dart';

import '../controllers/home_controller.dart';
import '../screens/setting_screen.dart';
import 'colors.dart';

class CustomDrawer extends StatefulWidget {
  final int initialIndex;
  const CustomDrawer({super.key, required this.initialIndex});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String email = '';
  String username = '';
  int index = 0;
  Color color = MyColors.darkGrey;
  bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;

  @override
  void initState() {
    index = widget.initialIndex;
    var userBox = LoginBox.userBox!.values.first;
    email = userBox.email;

    // HomeController.to.getUserName().then((value) {
    //   if (value != null) {
    //     setState(() {
    //       username = value;
    //     });
    //   }
    // });
    // HomeController.to.getEmail().then((value) {
    //   if (value != null) {
    //     setState(() {
    //       email = value;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        height: size.height,
        width: size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: size.height * 0.89,
              width: size.width * 0.7,
              decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  border: Border.all(color: MyColors.greyColor, width: 1.5),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: size.height * 0.155,
                        width: size.width * 0.6,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/background.jpeg'))),
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/images/new_logo.png'),
                            maxRadius: 40,
                            backgroundColor: MyColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 0;
                                                });
                                                Get.offAll(HomeScreen(
                                                    isLoggedIn: isLoggedIn,
                                                    initialIndex: 0));
                                              },
                                              child: Container(
                                                height: size.height * 0.063,
                                                width: size.width * 0.5,
                                                decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  border: Border.all(
                                                      color: MyColors.greyColor,
                                                      width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.home_rounded,
                                                        color: index == 0
                                                            ? MyColors.blueColor
                                                            : color,
                                                        size: 30,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextWidget(
                                                        text: 'Home',
                                                        color: index == 0
                                                            ? MyColors.blueColor
                                                            : color,
                                                        fontSize: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 1;
                                                });
                                                Get.offAll(HomeScreen(
                                                    isLoggedIn: isLoggedIn,
                                                    initialIndex: 1));
                                              },
                                              child: Container(
                                                height: size.height * 0.063,
                                                width: size.width * 0.53,
                                                decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  border: Border.all(
                                                      color: MyColors.greyColor,
                                                      width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.book,
                                                        color: index == 1
                                                            ? MyColors.blueColor
                                                            : color,
                                                        size: 30,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextWidget(
                                                        text: 'Books',
                                                        color: index == 1
                                                            ? MyColors.blueColor
                                                            : color,
                                                        fontSize: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.asset(
                                          'assets/images/piano.png',
                                        )
                                      ],
                                    ),
                                    Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 2;
                                                });
                                                Get.offAll(HomeScreen(
                                                    isLoggedIn: isLoggedIn,
                                                    initialIndex: 4));
                                              },
                                              child: Container(
                                                height: size.height * 0.063,
                                                width: size.width * 0.53,
                                                decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  border: Border.all(
                                                      color: MyColors.greyColor,
                                                      width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .music_note_rounded,
                                                        color: index == 2
                                                            ? MyColors.blueColor
                                                            : color,
                                                        size: 30,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextWidget(
                                                        text: 'Song',
                                                        color: index == 2
                                                            ? MyColors.blueColor
                                                            : color,
                                                        fontSize: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 3;
                                                });
                                                Get.offAll(HomeScreen(
                                                    isLoggedIn: isLoggedIn,
                                                    initialIndex: 3));
                                              },
                                              child: Container(
                                                height: size.height * 0.063,
                                                width: size.width * 0.53,
                                                decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  border: Border.all(
                                                      color: MyColors.greyColor,
                                                      width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.local_library,
                                                        color: index == 3
                                                            ? MyColors.blueColor
                                                            : color,
                                                        size: 30,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextWidget(
                                                        text: 'Library',
                                                        color: index == 3
                                                            ? MyColors.blueColor
                                                            : color,
                                                        fontSize: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 1.4),
                                          child: Image.asset(
                                              'assets/images/piano.png'),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Image.asset('assets/images/piano.png')
                              ],
                            ),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 4;
                                                });
                                              },
                                              child: Container(
                                                height: size.height * 0.063,
                                                width: size.width * 0.5,
                                                decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  border: Border.all(
                                                      color: MyColors.greyColor,
                                                      width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/amazon.png',
                                                        color: index == 4
                                                            ? MyColors.blueColor
                                                            : color,
                                                        height: 25,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextWidget(
                                                        text: 'Amazon',
                                                        color: index == 4
                                                            ? MyColors.blueColor
                                                            : color,
                                                        fontSize: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 5;
                                                });
                                              },
                                              child: Container(
                                                height: size.height * 0.063,
                                                width: size.width * 0.5,
                                                decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  border: Border.all(
                                                      color: MyColors.greyColor,
                                                      width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.info,
                                                        color: index == 5
                                                            ? MyColors.blueColor
                                                            : color,
                                                        size: 30,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextWidget(
                                                        text: 'Guide',
                                                        color: index == 5
                                                            ? MyColors.blueColor
                                                            : color,
                                                        fontSize: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.asset('assets/images/piano.png')
                                      ],
                                    ),
                                    Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 6;
                                                });
                                              },
                                              child: Container(
                                                height: size.height * 0.063,
                                                width: size.width * 0.5,
                                                decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  border: Border.all(
                                                      color: MyColors.greyColor,
                                                      width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Transform.flip(
                                                        flipX: true,
                                                        child: Image.asset(
                                                          'assets/images/student.png',
                                                          color: index == 6
                                                              ? MyColors
                                                                  .blueColor
                                                              : color,
                                                          height: 35,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextWidget(
                                                        text: 'Intro',
                                                        color: index == 6
                                                            ? MyColors.blueColor
                                                            : color,
                                                        fontSize: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: size.height * 0.063,
                                              width: size.width * 0.5,
                                              decoration: BoxDecoration(
                                                  color: MyColors.whiteColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .play_circle_outline_outlined,
                                                      color:
                                                          MyColors.yellowColor,
                                                      size: 30,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    TextWidget(
                                                      text: 'Watch AD',
                                                      color:
                                                          MyColors.blackColor,
                                                      fontSize: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Image.asset('assets/images/piano.png')
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'Follow us on',
                            color: MyColors.blackColor,
                            fontSize: 16,
                          ),
                          Divider(
                            height: 12,
                            color: color,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/instagram.png',
                                height: 18,
                                color: MyColors.blueColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/facebook_1.png',
                                height: 18,
                                color: MyColors.blueColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/twitter_1.png',
                                height: 18,
                                color: MyColors.blueColor,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).closeDrawer();
                                  Get.to(() => SettingScreen(email: email));
                                },
                                child: Image.asset(
                                  'assets/images/settings.png',
                                  height: 28,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({super.key});

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
  bool beethoven = false;
  bool aerosmith = false;
  bool greatBigWorld = false;
  bool alanWalker = false;

  bool american = false;
  bool banjo = false;
  bool artist = false;
  bool pages = false;
  bool genre = false;
  bool difficulty = false;

  List<String> selectedArtists = [];
  List<String> selectedPages = [];
  List<String> selectedGenres = [];
  List<String> selectedDifficulty = [];
  List<String> artistNames = [];
  List<String> genreNames = [];
  List<String> maxpages = [];
  List<String> difficultylevel = [];

  @override
  void initState() {
    super.initState();
    // Initialize the unique artist and genre names from your songs list.
    artistNames = HomeController.to.getAllArtistNames(HomeController.to.songs!);
    genreNames = HomeController.to.getAllGenreNames(HomeController.to.songs!);
    maxpages = ['10', '20', '30', '40', '50'];
    difficultylevel = ['Beginner', 'Intermediate', 'Advanced', 'Various'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: size.height * 0.89,
            width: size.width * 0.7,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: MyColors.whiteColor,
                border: Border.all(color: MyColors.greyColor, width: 1.5),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Filter',
                        fontSize: 18,
                        color: MyColors.blackColor,
                      ),
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).closeEndDrawer();
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Divider(color: MyColors.greyColor),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height:
                        artist == true ? size.height * 0.3 : size.height * 0.05,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    artist = !artist;
                                  });
                                },
                                child: SizedBox(
                                  height: size.height * 0.05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: 'Artist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.blackColor,
                                      ),
                                      Icon(
                                        artist == true
                                            ? Icons.remove
                                            : Icons.add,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          artist == true
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: artistNames.length,
                                  itemBuilder: (context, index) {
                                    final artistName = artistNames[index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          // Toggle the selection state of the artist
                                          if (selectedArtists
                                              .contains(artistName)) {
                                            selectedArtists.remove(artistName);
                                          } else {
                                            selectedArtists.add(artistName);
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: artistName,
                                            fontSize: 14,
                                            color: selectedArtists
                                                    .contains(artistName)
                                                ? MyColors.blueColor
                                                : MyColors.blackColor,
                                          ),
                                          selectedArtists.contains(artistName)
                                              ? Icon(
                                                  Icons.circle,
                                                  color: MyColors.blueColor,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.circle_outlined,
                                                  size: 16,
                                                )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Divider(
                            color: MyColors.greyColor,
                          ),
                          // Display selected artists with checkboxes below artist section
                          Column(
                            children: selectedArtists.map((artistName) {
                              return CheckboxListTile(
                                title: TextWidget(
                                  text: artistName,
                                  fontSize: 9,
                                ),
                                value: selectedArtists.contains(artistName),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      selectedArtists.add(artistName);
                                    } else {
                                      selectedArtists.remove(artistName);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Divider(
                    color: MyColors.greyColor,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height:
                        artist == true ? size.height * 0.3 : size.height * 0.05,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    artist = !artist;
                                  });
                                },
                                child: SizedBox(
                                  height: size.height * 0.05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: 'Pages',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.blackColor,
                                      ),
                                      Icon(
                                        pages == true
                                            ? Icons.remove
                                            : Icons.add,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pages == true
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: maxpages.length,
                                  itemBuilder: (context, index) {
                                    final pageno = maxpages[index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          // Toggle the selection state of the artist
                                          // if (selectedArtists
                                          //     .contains(artistName)) {
                                          //   selectedArtists.remove(artistName);
                                          // } else {
                                          //   selectedArtists.add(artistName);
                                          // }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: pageno,
                                            fontSize: 14,
                                            color:
                                                selectedPages.contains(pageno)
                                                    ? MyColors.blueColor
                                                    : MyColors.blackColor,
                                          ),
                                          selectedPages.contains(pageno)
                                              ? Icon(
                                                  Icons.circle,
                                                  color: MyColors.blueColor,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.circle_outlined,
                                                  size: 16,
                                                )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Divider(
                            color: MyColors.greyColor,
                          ),
                          // Display selected artists with checkboxes below artist section
                          Column(
                            children: selectedPages.map((maxpage) {
                              return CheckboxListTile(
                                title: Text(maxpage),
                                value: selectedPages.contains(maxpage),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      selectedArtists.add(maxpage);
                                    } else {
                                      selectedArtists.remove(maxpage);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          // Display genre section...
                          // ... (similar logic as artists)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Divider(
                    color: MyColors.greyColor,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height:
                        pages == true ? size.height * 0.2 : size.height * 0.05,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    pages = !pages;
                                  });
                                },
                                child: SizedBox(
                                  height: size.height * 0.05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: 'Genre',
                                        fontSize: 16,
                                        color: MyColors.blackColor,
                                      ),
                                      Icon(
                                        pages == true
                                            ? Icons.remove
                                            : Icons.add,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          genre == true
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedGenres.length,
                                  itemBuilder: (context, index) {
                                    final genr = selectedGenres[index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          // Toggle the selection state of the artist
                                          if (selectedGenres.contains(genr)) {
                                            selectedArtists.remove(genr);
                                          } else {
                                            selectedArtists.add(genr);
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: genr,
                                            fontSize: 14,
                                            color: selectedGenres.contains(genr)
                                                ? MyColors.blueColor
                                                : MyColors.blackColor,
                                          ),
                                          selectedGenres.contains(genr)
                                              ? Icon(
                                                  Icons.circle,
                                                  color: MyColors.blueColor,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.circle_outlined,
                                                  size: 16,
                                                )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Divider(
                            color: MyColors.greyColor,
                          ),
                          // ... Continue with your existing code for other sections
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Divider(
                    color: MyColors.greyColor,
                    height: 5,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height:
                        pages == true ? size.height * 0.2 : size.height * 0.05,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    pages = !pages;
                                  });
                                },
                                child: SizedBox(
                                  height: size.height * 0.05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: 'Genre',
                                        fontSize: 16,
                                        color: MyColors.blackColor,
                                      ),
                                      Icon(
                                        pages == true
                                            ? Icons.remove
                                            : Icons.add,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          difficulty == true
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedDifficulty.length,
                                  itemBuilder: (context, index) {
                                    final diff = difficultylevel[index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          // Toggle the selection state of the artist
                                          if (selectedGenres.contains(diff)) {
                                            selectedDifficulty.remove(diff);
                                          } else {
                                            selectedDifficulty.add(diff);
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: diff,
                                            fontSize: 14,
                                            color: selectedGenres.contains(diff)
                                                ? MyColors.blueColor
                                                : MyColors.blackColor,
                                          ),
                                          selectedGenres.contains(diff)
                                              ? Icon(
                                                  Icons.circle,
                                                  color: MyColors.blueColor,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.circle_outlined,
                                                  size: 16,
                                                )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Divider(
                            color: MyColors.greyColor,
                          ),
                          // ... Continue with your existing code for other sections
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
