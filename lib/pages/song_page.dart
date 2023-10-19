import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/songs_model.dart';
import 'package:paino_tab/utils/model.dart';

import '../utils/colors.dart';
import '../utils/widget.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  bool songDetail = false;
  int selectedSongIndex = -1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Songs> sng =
        HomeController.filterSongs(HomeController.to.songs!, type: 'song');
    List<ListItemModel> songs = HomeController.to.songModelList(songs: sng);

    return WillPopScope(
      onWillPop: () async {
        if (songDetail == false) {
          SystemNavigator.pop();
        } else {
          setState(() {
            songDetail = false;
          });
        }

        return false;
      },
      child: songDetail == true
          ? SongDetailScreen(song: songs[selectedSongIndex])
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  TextWidget(
                    text: 'Choose from a list of 590 Piano Tabs.',
                    color: MyColors.blackColor,
                    fontSize: 18,
                  ),
                  TextWidget(
                    text:
                        'A Fast, Fun and Visual Way To Learn Your Favorite Songs',
                    color: MyColors.greyColor,
                    fontSize: 10,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const FilterButton(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          mainAxisExtent: 250.h,
                          childAspectRatio: 1.h,
                        ),
                        itemCount: songs.length,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                songDetail = true;
                                selectedSongIndex = index;
                              });
                            },
                            child: RecentReleasedWidget(list: songs[index]))),
                  ),
                  SizedBox(
                    height: size.height * 0.12,
                  ),
                ],
              ),
            ),
    );
  }
}
