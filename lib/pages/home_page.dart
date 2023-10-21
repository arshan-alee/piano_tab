import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/songs_model.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListItemModel> beginner = [];
  List<ListItemModel> twentyonepilot = [];
  List<ListItemModel> pop = [];
  List<ListItemModel> contemporary = [];
  List<ListItemModel> classical = [];
  List<ListItemModel> tvfilm = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<Songs> ez = HomeController.filterSongs(HomeController.to.songs!,
        difficulty: 'Beginner');
    List<Songs> twentyone = HomeController.filterSongs(HomeController.to.songs!,
        artist: 'Twenty One Pilots');
    List<Songs> contemp = HomeController.filterSongs(HomeController.to.songs!,
        genre: 'Contemporary');
    List<Songs> popsng =
        HomeController.filterSongs(HomeController.to.songs!, genre: 'Pop');
    List<Songs> clsscal = HomeController.filterSongs(HomeController.to.songs!,
        genre: 'Classical');
    List<Songs> tvflm = HomeController.filterSongs(HomeController.to.songs!,
        genre: 'TV / Film');

    setState(() {
      beginner = HomeController.to.itemModellList(songs: ez);
      twentyonepilot = HomeController.to.itemModellList(songs: twentyone);
      pop = HomeController.to.itemModellList(songs: popsng);
      contemporary = HomeController.to.itemModellList(songs: contemp);
      classical = HomeController.to.itemModellList(songs: clsscal);
      tvfilm = HomeController.to.itemModellList(songs: tvflm);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.025,
                ),
                TextWidget(
                  text: 'Recent released',
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
                    itemCount: albumList.length,
                    itemBuilder: (context, index) =>
                        RecentReleasedWidget(list: albumList[index]),
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
                          onTap: () {},
                          child: Container(
                            width: 150, // Adjust the width as needed
                            height: 250.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(179, 226, 223, 223)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Browse',
                                  color: MyColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: MyColors.blackColor,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return RecentReleasedWidget(list: beginner[index]);
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
                          onTap: () {},
                          child: Container(
                            width: 150, // Adjust the width as needed
                            height: 250.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(179, 226, 223, 223)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Browse',
                                  color: MyColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: MyColors.blackColor,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return RecentReleasedWidget(
                            list: twentyonepilot[index]);
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
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      if (index == 8) {
                        // This is the last item, display the "Browse" button
                        return GestureDetector(
                          onTap: () {
                            // Handle the "Browse" button click
                            // You can navigate to another screen or perform an action here.
                          },
                          child: Container(
                            width: 150, // Adjust the width as needed
                            height: 250.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(179, 226, 223, 223)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Browse',
                                  color: MyColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: MyColors.blackColor,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return RecentReleasedWidget(list: pop[index]);
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
                            // Handle the "Browse" button click
                            // You can navigate to another screen or perform an action here.
                          },
                          child: Container(
                            width: 150, // Adjust the width as needed
                            height: 250.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(179, 226, 223, 223)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Browse',
                                  color: MyColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: MyColors.blackColor,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return RecentReleasedWidget(list: contemporary[index]);
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
                            // Handle the "Browse" button click
                            // You can navigate to another screen or perform an action here.
                          },
                          child: Container(
                            width: 150, // Adjust the width as needed
                            height: 250.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(179, 226, 223, 223)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Browse',
                                  color: MyColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: MyColors.blackColor,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return RecentReleasedWidget(list: classical[index]);
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
                            // Handle the "Browse" button click
                            // You can navigate to another screen or perform an action here.
                          },
                          child: Container(
                            width: 150, // Adjust the width as needed
                            height: 250.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(179, 226, 223, 223)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Browse',
                                  color: MyColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: MyColors.blackColor,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Display your regular items from the 'tvfilm' list
                        return RecentReleasedWidget(list: tvfilm[index]);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
