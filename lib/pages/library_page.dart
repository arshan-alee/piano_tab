import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/songs_model.dart';
import 'package:paino_tab/utils/model.dart';

import '../utils/colors.dart';
import '../utils/widget.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<String> offlineLibrary =
      OfflineLibraryBox.userBox!.values.first.offlineLibrary;
  List<ListItemModel> songModels = [];
  List<ListItemModel> bookModels = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Get the userLibrary once and store it.
    final userLibrary = HomeController.to.getLibraryData(offlineLibrary);

    setState(() {
      songModels = getSongModels(userLibrary);
      bookModels = getBookModels(userLibrary);
    });
  }

  List<ListItemModel> getSongModels(List<Songs> userLibrary) {
    List<Songs> songs = HomeController.filterSongs(userLibrary, type: 'song');
    return HomeController.to.songModelList(songs: songs);
  }

  List<ListItemModel> getBookModels(List<Songs> userLibrary) {
    List<Songs> books = HomeController.filterSongs(userLibrary, type: 'book');
    return HomeController.to.bookModelList(songs: books);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.015,
          ),
          Container(
            height: size.height * 0.4,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: MyColors.gradient),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const TextWidget(
                text: 'Favorites',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              Divider(
                height: 12,
                color: MyColors.blackColor.withOpacity(0.4),
                thickness: 0.5,
              ),
              Expanded(
                  child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 20,
                    mainAxisExtent: 250.h,
                    childAspectRatio: 1.h),
                itemCount: albumList.length,
                itemBuilder: (context, index) =>
                    RecentReleasedWidget(list: albumList[index]),
              ))
            ]),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextWidget(
              text: 'Owned',
              fontSize: 24,
              color: MyColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: size.height * 0.015,
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
                  childAspectRatio: 1.h),
              itemCount: albumList.length,
              itemBuilder: (context, index) =>
                  RecentReleasedWidget(list: albumList[index]),
            ),
          ),
          SizedBox(
            height: size.height * 0.12,
          ),
        ],
      ),
    );
  }
}
