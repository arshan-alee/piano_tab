import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/songs_model.dart';
import 'package:paino_tab/pages/song_page.dart';
import 'package:paino_tab/screens/home_screen.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListItemModel> albumList = [];
  List<ListItemModel> beginner = [];
  List<ListItemModel> twentyonepilot = [];
  List<ListItemModel> pop = [];
  List<ListItemModel> contemporary = [];
  List<ListItemModel> classical = [];
  List<ListItemModel> tvfilm = [];
  bool isLoggedIn = OfflineLibraryBox.userBox!.values.first.isLoggedIn;
  int selectedSongIndex = -1;
  bool bgnritem = false;
  bool twpitem = false;
  bool popitem = false;
  bool contempitem = false;
  bool classicalitem = false;
  bool tvfilmitem = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      albumList =
          HomeController.to.itemModellList(songs: HomeController.to.recentList);
      beginner = HomeController.to.itemModellList(songs: HomeController.to.ez);
      twentyonepilot =
          HomeController.to.itemModellList(songs: HomeController.to.twentyone);
      pop = HomeController.to.itemModellList(songs: HomeController.to.popsng);
      contemporary =
          HomeController.to.itemModellList(songs: HomeController.to.contemp);
      classical =
          HomeController.to.itemModellList(songs: HomeController.to.clsscal);
      tvfilm = HomeController.to.itemModellList(songs: HomeController.to.tvflm);
    });
  }

  Future<void> showDetailScreen(
      BuildContext context, int selectedSongIndex) async {
    bool isBook = false;

    dynamic selectedItem;

    if (bgnritem) {
      isBook = beginner[selectedSongIndex].detail.startsWith("BK");
      selectedItem = beginner[selectedSongIndex];
    } else if (twpitem) {
      isBook = twentyonepilot[selectedSongIndex].detail.startsWith("BK");
      selectedItem = twentyonepilot[selectedSongIndex];
    } else if (popitem) {
      isBook = pop[selectedSongIndex].detail.startsWith("BK");
      selectedItem = pop[selectedSongIndex];
    } else if (contempitem) {
      isBook = contemporary[selectedSongIndex].detail.startsWith("BK");
      selectedItem = contemporary[selectedSongIndex];
    } else if (classicalitem) {
      isBook = classical[selectedSongIndex].detail.startsWith("BK");
      selectedItem = classical[selectedSongIndex];
    } else if (tvfilmitem) {
      isBook = tvfilm[selectedSongIndex].detail.startsWith("BK");
      selectedItem = tvfilm[selectedSongIndex];
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        if (isBook) {
          return BookDetailScreen(book: selectedItem);
        } else {
          return SongDetailScreen(song: selectedItem);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.025,
                ),
                TextWidget(
                  text: 'New Releases',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 6,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 200.h,
                  width: size.width,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: albumList.length,
                    itemBuilder: (context, index) =>
                        NewReleasesWidget(list: albumList[index]),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextWidget(
                  text: 'Beginner Songs',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 6,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 250.h,
                  width: size.width,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      if (index == 8) {
                        return GestureDetector(
                            onTap: () {
                              Get.offAll(HomeScreen(
                                  isLoggedIn: isLoggedIn, initialIndex: 4));
                            },
                            child: Container(
                              width: 150, // Adjust the width as needed
                              height: 250.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColors.darkBlue),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: 'Browse',
                                    color: MyColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MyColors.whiteColor,
                                  ),
                                ],
                              ),
                            ));
                      } else {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedSongIndex = index;
                                bgnritem = true;
                                twpitem = false;
                                popitem = false;
                                contempitem = false;
                                classicalitem = false;
                                tvfilmitem = false;
                              });
                              showDetailScreen(context, selectedSongIndex);
                            },
                            child: RecentReleasedWidget(list: beginner[index]));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextWidget(
                  text: 'Twenty One Pilots',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 6,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 250.h,
                  width: size.width,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      if (index == 8) {
                        return GestureDetector(
                            onTap: () {
                              Get.offAll(HomeScreen(
                                  isLoggedIn: isLoggedIn, initialIndex: 4));
                            },
                            child: Container(
                              width: 150, // Adjust the width as needed
                              height: 250.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColors.darkBlue),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: 'Browse',
                                    color: MyColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MyColors.whiteColor,
                                  ),
                                ],
                              ),
                            ));
                      } else {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedSongIndex = index;
                                twpitem = true;
                                bgnritem = false;
                                popitem = false;
                                contempitem = false;
                                classicalitem = false;
                                tvfilmitem = false;
                              });
                              showDetailScreen(context, selectedSongIndex);
                            },
                            child: RecentReleasedWidget(
                                list: twentyonepilot[index]));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextWidget(
                  text: 'Pop Songs',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 6,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 250.h,
                  width: size.width,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: pop.length < 9 ? pop.length : 9,
                    itemBuilder: (context, index) {
                      if (index == 8) {
                        return GestureDetector(
                            onTap: () {
                              Get.offAll(HomeScreen(
                                  isLoggedIn: isLoggedIn, initialIndex: 4));
                            },
                            child: Container(
                              width: 150, // Adjust the width as needed
                              height: 250.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColors.darkBlue),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: 'Browse',
                                    color: MyColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MyColors.whiteColor,
                                  ),
                                ],
                              ),
                            ));
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedSongIndex = index;
                                popitem = true;
                                twpitem = false;
                                bgnritem = false;
                                contempitem = false;
                                classicalitem = false;
                                tvfilmitem = false;
                              });
                              showDetailScreen(context, selectedSongIndex);
                            },
                            child: RecentReleasedWidget(list: pop[index]));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextWidget(
                  text: 'Contemporary Songs',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 6,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 250.h,
                  width: size.width,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      if (index == 8) {
                        // This is the last item, display the "Browse" button
                        return GestureDetector(
                            onTap: () {
                              Get.offAll(HomeScreen(
                                  isLoggedIn: isLoggedIn, initialIndex: 4));
                            },
                            child: Container(
                              width: 150, // Adjust the width as needed
                              height: 250.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColors.darkBlue),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: 'Browse',
                                    color: MyColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MyColors.whiteColor,
                                  ),
                                ],
                              ),
                            ));
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedSongIndex = index;
                                popitem = false;
                                twpitem = false;
                                bgnritem = false;
                                contempitem = true;
                                classicalitem = false;
                                tvfilmitem = false;
                              });
                              showDetailScreen(context, selectedSongIndex);
                            },
                            child: RecentReleasedWidget(
                                list: contemporary[index]));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextWidget(
                  text: 'Classical Songs',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 6,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 250.h,
                  width: size.width,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      if (index == 8) {
                        // This is the last item, display the "Browse" button
                        return GestureDetector(
                            onTap: () {
                              Get.offAll(HomeScreen(
                                  isLoggedIn: isLoggedIn, initialIndex: 4));
                            },
                            child: Container(
                              width: 150, // Adjust the width as needed
                              height: 250.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColors.darkBlue),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: 'Browse',
                                    color: MyColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MyColors.whiteColor,
                                  ),
                                ],
                              ),
                            ));
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedSongIndex = index;
                                popitem = false;
                                twpitem = false;
                                bgnritem = false;
                                contempitem = false;
                                classicalitem = true;
                                tvfilmitem = false;
                              });
                              showDetailScreen(context, selectedSongIndex);
                            },
                            child:
                                RecentReleasedWidget(list: classical[index]));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextWidget(
                  text: 'TV / Film',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                const Divider(
                  height: 6,
                  thickness: 1.5,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 250.h,
                  width: size.width,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      if (index == 8) {
                        // This is the last item, display the "Browse" button
                        return GestureDetector(
                            onTap: () {
                              Get.offAll(HomeScreen(
                                  isLoggedIn: isLoggedIn, initialIndex: 4));
                            },
                            child: Container(
                              width: 150, // Adjust the width as needed
                              height: 250.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColors.darkBlue),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: 'Browse',
                                    color: MyColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MyColors.whiteColor,
                                  ),
                                ],
                              ),
                            ));
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedSongIndex = index;
                                tvfilmitem = true;
                                popitem = false;
                                twpitem = false;
                                bgnritem = false;
                                contempitem = false;
                                classicalitem = false;
                              });
                              showDetailScreen(context, selectedSongIndex);
                            },
                            child: RecentReleasedWidget(list: tvfilm[index]));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
