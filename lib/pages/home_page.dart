import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:paino_tab/utils/widget.dart';

import '../utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  height: size.height * 0.02,
                ),
                TextWidget(
                  text: 'Jazz',
                  color: MyColors.blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: 200.h,
                  width: size.width,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(
                      width: size.width * 0.035,
                    ),
                    itemCount: albumList.length,
                    itemBuilder: (context, index) =>
                        JazzWidget(list: albumList[index]),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
