import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';
import 'package:paino_tab/pages/book_page.dart';
import 'package:paino_tab/pages/home_page.dart';
import 'package:paino_tab/pages/library_offline.dart';
import 'package:paino_tab/pages/library_page.dart';
import 'package:paino_tab/pages/search_page.dart';
import 'package:paino_tab/pages/song_page.dart';
import 'package:paino_tab/utils/colors.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.isLoggedIn, required this.initialIndex});
  final bool isLoggedIn;
  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    HomeController.to.index = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    setState(() {
      HomeController.to.cartItems =
          OfflineLibraryBox.userBox!.values.first.cartItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      drawer: CustomDrawer(initialIndex: widget.initialIndex),
      drawerEnableOpenDragGesture: false,
      endDrawer: const CustomEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(children: [
                  Expanded(
                      child: CustomAppBar(
                    title: HomeController.to.index == 0
                        ? 'Home'
                        : HomeController.to.index == 1
                            ? 'Books'
                            : HomeController.to.index == 2
                                ? 'Piano Tab'
                                : HomeController.to.index == 3
                                    ? 'Library'
                                    : 'Songs',
                  )),
                  Expanded(
                      flex: 10,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (value) {
                          setState(() {
                            HomeController.to.index = value;
                          });
                        },
                        children: [
                          const HomePage(),
                          const BookPage(),
                          const SearchPage(),
                          OfflineLibraryBox.userBox!.values.first.isLoggedIn ==
                                  true
                              ? LibraryPage()
                              : LibraryOffline(),
                          const SongPage()
                        ],
                      ))
                ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: CustomContainer(
                    onpressed: () {},
                    height: size.height * 0.09,
                    width: size.width,
                    color: MyColors.bottomColor,
                    borderRadius: 40,
                    borderColor: MyColors.transparent,
                    boxShadow: [
                      BoxShadow(
                          color: MyColors.whiteColor.withOpacity(0.95),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 10))
                    ],
                    borderWidth: 0,
                    widget: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: BottomWidget(
                                  onTap: () {
                                    print(LoginBox.userBox!.values.first
                                        .toJson());
                                    print(UserDataBox.userBox!.values.first
                                        .toJson());
                                    print(OfflineLibraryBox
                                        .userBox!.values.first
                                        .toJson());
                                    print(UserDataBox
                                        .userBox!.values.first.userDataLibrary);
                                    _pageController.animateToPage(0,
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.fastLinearToSlowEaseIn);
                                  },
                                  icon: Icons.home_rounded,
                                  text: 'Home',
                                  color: HomeController.to.index == 0
                                      ? MyColors.whiteColor
                                      : MyColors.transparent,
                                  iconColor: HomeController.to.index == 0
                                      ? MyColors.whiteColor
                                      : MyColors.lightGrey),
                            ),
                            Expanded(
                              child: BottomWidget(
                                  icon: Icons.book,
                                  onTap: () {
                                    _pageController.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.fastLinearToSlowEaseIn);
                                  },
                                  text: 'Books',
                                  iconColor: HomeController.to.index == 1
                                      ? MyColors.whiteColor
                                      : MyColors.lightGrey,
                                  color: HomeController.to.index == 1
                                      ? MyColors.whiteColor
                                      : MyColors.transparent),
                            ),
                            Expanded(
                              child: BottomWidget(
                                  icon: Icons.search,
                                  onTap: () {
                                    _pageController.animateToPage(2,
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.fastLinearToSlowEaseIn);
                                  },
                                  text: 'Search',
                                  color: HomeController.to.index == 2
                                      ? MyColors.whiteColor
                                      : MyColors.transparent,
                                  iconColor: HomeController.to.index == 2
                                      ? MyColors.whiteColor
                                      : MyColors.lightGrey),
                            ),
                            Expanded(
                              child: BottomWidget(
                                  icon: Icons.local_library,
                                  onTap: () {
                                    _pageController.animateToPage(3,
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.fastLinearToSlowEaseIn);
                                  },
                                  text: 'Library',
                                  color: HomeController.to.index == 3
                                      ? MyColors.whiteColor
                                      : MyColors.transparent,
                                  iconColor: HomeController.to.index == 3
                                      ? MyColors.whiteColor
                                      : MyColors.lightGrey),
                            ),
                            Expanded(
                              child: BottomWidget(
                                  icon: Icons.music_note_rounded,
                                  onTap: () {
                                    _pageController.animateToPage(4,
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.fastLinearToSlowEaseIn);
                                  },
                                  text: 'Songs',
                                  color: HomeController.to.index == 4
                                      ? MyColors.whiteColor
                                      : MyColors.transparent,
                                  iconColor: HomeController.to.index == 4
                                      ? MyColors.whiteColor
                                      : MyColors.lightGrey),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              HomeController.to.cartItems.isNotEmpty
                  ? Positioned(
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
                                  text: HomeController.to.cartItems.length
                                      .toString(),
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Positioned(
                      bottom: 90,
                      right: 15,
                      child: Material(
                        elevation: 6,
                        shape: CircleBorder(),
                        child: FloatingActionButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext bc) {
                                  return CartScreen();
                                });
                          },
                          backgroundColor: MyColors.primaryColor,
                          child: Icon(
                            Icons.shopping_cart,
                            color: MyColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
