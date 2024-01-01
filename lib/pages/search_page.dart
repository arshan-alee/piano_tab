import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/songs_model.dart';
import 'package:paino_tab/utils/model.dart';

import '../utils/colors.dart';
import '../utils/widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Songs> searchitem = [];
  List<ListItemModel> searchResults = [];
  String query = '';
  int selectedSongIndex = -1;

  List<Songs> searchItems(List<Songs> songs, String searchTerm) {
    searchTerm = searchTerm.toLowerCase();
    return songs.where((song) {
      final bkName = song.bkName?.toLowerCase() ?? '';
      final songName = song.songName?.toLowerCase() ?? '';
      return bkName.contains(searchTerm) || songName.contains(searchTerm);
    }).toList();
  }

  void updateQuery(String newQuery) {
    setState(() {
      query = newQuery;
      searchitem = searchItems(HomeController.to.songs!, newQuery);
      searchResults = HomeController.to.itemModellList(songs: searchitem);
    });
    print('query in searchpage $newQuery');
  }

  Future<void> showDetailScreen(BuildContext context, dynamic item) async {
    bool isBook = item.detail.startsWith("BK");

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext bc) {
        if (isBook) {
          return BookDetailScreen(book: item);
        } else {
          return SongDetailScreen(song: item);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            CustomContainer(
              height: size.height * 0.07,
              width: size.width,
              color: MyColors.grey,
              borderRadius: 10,
              borderColor: MyColors.transparent,
              borderWidth: 0,
              widget: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      size: 28,
                    ),
                    Expanded(
                      child: TextField(
                        onSubmitted: updateQuery,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onpressed: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: searchResults.isEmpty
                      ? Center(
                          child: TextWidget(
                            text: "No Book/Song Found...",
                            fontSize: 18,
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            mainAxisExtent: 250.h,
                            childAspectRatio: 1.h,
                          ),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedSongIndex = index;
                              });
                              showDetailScreen(
                                  context, searchResults[selectedSongIndex]);
                            },
                            child: RecentReleasedWidget(
                              list: searchResults[index],
                            ),
                          ),
                        ),
                ),
              ),
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
