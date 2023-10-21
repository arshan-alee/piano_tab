import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/songs_model.dart';
import 'package:paino_tab/utils/colors.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:paino_tab/utils/widget.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool bookScreen = false;
  int selectedBookIndex = -1; // Track selected book index

  @override
  Widget build(BuildContext context) {
    List<Songs> sng =
        HomeController.filterSongs(HomeController.to.songs!, type: 'book');
    List<ListItemModel> books = HomeController.to.itemModellList(songs: sng);
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (bookScreen == false) {
          SystemNavigator.pop();
        } else {
          setState(() {
            bookScreen = false;
          });
        }

        return false;
      },
      child: bookScreen == true
          ? BookDetailScreen(book: books[selectedBookIndex])
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    TextWidget(
                      text: '108 books to choose from',
                      color: MyColors.blackColor,
                      fontSize: 20,
                    ),
                    TextWidget(
                      text: 'Digital PDFs are ready to download & print',
                      color: MyColors.greyColor,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    const FilterButton(),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15.w,
                        mainAxisExtent: 260.h,
                        childAspectRatio: 0.55.h,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          setState(() {
                            bookScreen = true;
                            selectedBookIndex = index; // Store selected index
                          });
                        },
                        child: RecentReleasedWidget(
                          list: books[index],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.12,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
