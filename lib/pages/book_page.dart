import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paino_tab/utils/model.dart';

import '../utils/colors.dart';
import '../utils/widget.dart';

class BookPage extends StatefulWidget {
  const BookPage({
    super.key,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool bookScreen = false;
  @override
  Widget build(BuildContext context) {
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
          ? const BookDetailScreen()
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
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       BookWidget(list: bookList[0]),
                    //       BookWidget(list: bookList[1]),
                    //     ]),
                    // SizedBox(
                    //   height: size.height * 0.02,
                    // ),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       BookWidget(list: bookList[2]),
                    //       BookWidget(list: bookList[3]),
                    //     ]),
                    // SizedBox(
                    //   height: size.height * 0.02,
                    // ),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       BookWidget(list: bookList[4]),
                    //       BookWidget(list: bookList[5]),
                    //     ]),
                    // SizedBox(
                    //   height: size.height * 0.02,
                    // ),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       BookWidget(list: bookList[6]),
                    //       BookWidget(list: bookList[7]),
                    //     ]),

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
                      itemCount: bookList.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          if (index == 0) {
                            setState(() {
                              bookScreen = true;
                            });
                          }
                        },
                        child: BookWidget(
                          list: bookList[index],
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
