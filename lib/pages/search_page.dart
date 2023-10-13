import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paino_tab/utils/model.dart';

import '../utils/colors.dart';
import '../utils/widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            CustomContainer(
                onpressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                height: size.height * 0.07,
                width: size.width,
                color: MyColors.grey,
                borderRadius: 10,
                borderColor: MyColors.transparent,
                borderWidth: 0,
                widget: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        size: 28,
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BookWidget(/*index: 1,*/ list: bookList[0]),
                  RecentReleasedWidget(
                    list: albumList[1],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
