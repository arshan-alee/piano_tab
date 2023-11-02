import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/services/ad_mob_service.dart';
import 'package:paino_tab/utils/widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controllers/home_controller.dart';
import '../models/songs_model.dart';
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
  late PdfViewerController _pdfViewController;
  RewardedAd? _rewardedAd;
  int userPoints = int.tryParse(UserDataBox.userBox!.values.first.points) ?? 0;
  int offlineUserPoints =
      int.tryParse(OfflineLibraryBox.userBox!.values.first.points) ?? 0;

  @override
  void initState() {
    index = widget.initialIndex;
    var userBox = LoginBox.userBox!.values.first;
    email = userBox.email;

    _pdfViewController = PdfViewerController();

    createRewardedAd();
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
            int newPoints = offlineUserPoints + 1;
            await OfflineLibraryBox.updatePoints(newPoints.toString());
            print('Points updated in logged off mode');
          }
        },
      );
    }
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
                                                HomeController
                                                    .to.selectedArtists = "All";
                                                HomeController
                                                    .to.selectedPages = "All";
                                                HomeController
                                                    .to.selectedGenres = "All";
                                                HomeController.to
                                                    .selectedDifficulty = "All";
                                                setState(() {
                                                  index = 1;
                                                });
                                                Get.offAll(HomeScreen(
                                                    isLoggedIn: isLoggedIn,
                                                    initialIndex: 1));
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
                                                        text: 'Songs',
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
                                                HomeController
                                                    .to.selectedArtists = "All";
                                                HomeController
                                                    .to.selectedPages = "All";
                                                HomeController
                                                    .to.selectedGenres = "All";
                                                HomeController.to
                                                    .selectedDifficulty = "All";
                                                setState(() {
                                                  index = 3;
                                                });
                                                Get.offAll(HomeScreen(
                                                    isLoggedIn: isLoggedIn,
                                                    initialIndex: 3));
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
                                                        onTap: () {
                                                          _showPdfViewer(
                                                              context);
                                                        },
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
                                                      onTap: () {
                                                        showRewardedAd();
                                                      },
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

  void _showPdfViewer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return FractionallySizedBox(
          heightFactor: 1, // Occupies full screen height
          child: Container(
            child: Column(
              children: [
                AppBar(
                  title: TextWidget(text: 'Guide'),
                  centerTitle: true,
                ),
                Expanded(
                  child: SfPdfViewer.network(
                    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', // Use the passed PDF path here
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

class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({super.key});

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
  bool artist = false;
  bool pages = false;
  bool genre = false;
  bool difficulty = false;

  List<String> artistNames = [];
  List<String> genreNames = [];
  List<String> maxpages = [];
  List<String> difficultylevel = [];

  late String passedVal;

  @override
  void initState() {
    super.initState();
    if (HomeController.to.selectedPage == "song") {
      artistNames = HomeController.to.authorSongFilter;
      genreNames = HomeController.to.genreSongFilter;
      maxpages = HomeController.to.pageSongFilter;
      difficultylevel = HomeController.to.difficultySongFilter;
    } else {
      artistNames = HomeController.to.authorBookFilter;
      genreNames = HomeController.to.genreBookFilter;
      maxpages = HomeController.to.pageBookFilter;
      difficultylevel = HomeController.to.difficultyBookFilter;
    }
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: artist == true
                              ? size.height * 0.3
                              : size.height * 0.05,
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
                                                HomeController
                                                        .to.selectedArtists =
                                                    artistName;
                                                filterList();
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  text: artistName,
                                                  fontSize: 14,
                                                  color: HomeController.to
                                                              .selectedArtists ==
                                                          artistName
                                                      ? MyColors.blueColor
                                                      : MyColors.blackColor,
                                                ),
                                                HomeController.to
                                                            .selectedArtists ==
                                                        artistName
                                                    ? Icon(
                                                        Icons.circle,
                                                        color:
                                                            MyColors.blueColor,
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
                        HomeController.to.index == 4
                            ? Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: pages == true
                                        ? size.height * 0.3
                                        : size.height * 0.05,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextWidget(
                                                        text: 'Pages',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            MyColors.blackColor,
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
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: maxpages.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final pageno =
                                                        maxpages[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          HomeController.to
                                                                  .selectedPages =
                                                              pageno;
                                                          filterList();
                                                        });
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextWidget(
                                                            text: pageno,
                                                            fontSize: 14,
                                                            color: HomeController
                                                                        .to
                                                                        .selectedPages ==
                                                                    pageno
                                                                ? MyColors
                                                                    .blueColor
                                                                : MyColors
                                                                    .blackColor,
                                                          ),
                                                          HomeController.to
                                                                      .selectedPages ==
                                                                  pageno
                                                              ? Icon(
                                                                  Icons.circle,
                                                                  color: MyColors
                                                                      .blueColor,
                                                                  size: 16,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .circle_outlined,
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
                                ],
                              )
                            : SizedBox(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: genre == true
                              ? size.height * 0.2
                              : size.height * 0.05,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          genre = !genre;
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
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.blackColor,
                                            ),
                                            Icon(
                                              genre == true
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
                                        itemCount: genreNames.length,
                                        itemBuilder: (context, index) {
                                          final genre = genreNames[index];
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                HomeController
                                                    .to.selectedGenres = genre;
                                                filterList();
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  text: genre,
                                                  fontSize: 14,
                                                  color: HomeController.to
                                                              .selectedGenres ==
                                                          genre
                                                      ? MyColors.blueColor
                                                      : MyColors.blackColor,
                                                ),
                                                HomeController.to
                                                            .selectedGenres ==
                                                        genre
                                                    ? Icon(
                                                        Icons.circle,
                                                        color:
                                                            MyColors.blueColor,
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
                          height: difficulty == true
                              ? size.height * 0.2
                              : size.height * 0.05,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          difficulty = !difficulty;
                                        });
                                      },
                                      child: SizedBox(
                                        height: size.height * 0.05,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              text: 'Difficulty',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.blackColor,
                                            ),
                                            Icon(
                                              difficulty == true
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
                                        itemCount: difficultylevel.length,
                                        itemBuilder: (context, index) {
                                          final difficulty =
                                              difficultylevel[index];
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                HomeController
                                                        .to.selectedDifficulty =
                                                    difficulty;
                                                filterList();
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  text: difficulty,
                                                  fontSize: 14,
                                                  color: HomeController.to
                                                              .selectedDifficulty ==
                                                          difficulty
                                                      ? MyColors.blueColor
                                                      : MyColors.blackColor,
                                                ),
                                                HomeController.to
                                                            .selectedDifficulty ==
                                                        difficulty
                                                    ? Icon(
                                                        Icons.circle,
                                                        color:
                                                            MyColors.blueColor,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void filterList() {
    if (HomeController.to.selectedPage == "song") {
      print(HomeController.to.selectedPages);
      List<Songs> sng = HomeController.filterSongs(
        HomeController.to.song,
        type: 'song',
        artist: HomeController.to.selectedArtists != "All"
            ? HomeController.to.selectedArtists
            : null,
        genre: HomeController.to.selectedGenres != "All"
            ? HomeController.to.selectedGenres
            : null,
        difficulty: HomeController.to.selectedDifficulty != "All"
            ? HomeController.to.selectedDifficulty
            : null,
        pages: HomeController.to.selectedPages != "All"
            ? int.parse(HomeController.to.selectedPages)
            : null,
      );
      HomeController.to.filteredSng.value =
          HomeController.to.itemModellList(songs: sng);
    } else if (HomeController.to.selectedPage == "book") {
      List<Songs> bk = HomeController.filterSongs(
        HomeController.to.book,
        type: 'book',
        artist: HomeController.to.selectedArtists != "All"
            ? HomeController.to.selectedArtists
            : null,
        genre: HomeController.to.selectedGenres != "All"
            ? HomeController.to.selectedGenres
            : null,
        difficulty: HomeController.to.selectedDifficulty != "All"
            ? HomeController.to.selectedDifficulty
            : null,
        pages: HomeController.to.selectedPages != "All"
            ? int.parse(HomeController.to.selectedPages)
            : null,
      );

      HomeController.to.filteredBk.value =
          HomeController.to.itemModellList(songs: bk);
    }
  }
}
