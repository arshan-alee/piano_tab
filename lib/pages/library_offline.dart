import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paino_tab/controllers/home_controller.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/models/songs_model.dart';
import 'package:paino_tab/screens/login_screen.dart';
import 'package:paino_tab/utils/colors.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:paino_tab/utils/widget.dart';

class LibraryOffline extends StatefulWidget {
  LibraryOffline({Key? key}) : super(key: key);

  @override
  _LibraryOfflineState createState() => _LibraryOfflineState();
}

class _LibraryOfflineState extends State<LibraryOffline> {
  final List<String> offlineLibrary =
      OfflineLibraryBox.userBox!.values.first.offlineLibrary;
  List<SongModel> songModels = [];
  List<BookModel> bookModels = [];

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

  List<SongModel> getSongModels(List<Songs> userLibrary) {
    List<Songs> songs = HomeController.filterSongs(userLibrary, type: 'song');
    return HomeController.to.songModelList(songs: songs);
  }

  List<BookModel> getBookModels(List<Songs> userLibrary) {
    List<Songs> books = HomeController.filterSongs(userLibrary, type: 'book');
    return HomeController.to.bookModelList(songs: books);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.06,
            ),
            TextWidget(
              text: 'You have to login\n           first!',
              fontSize: 26,
              color: MyColors.blackColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: "Don't have an account? ",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: MyColors.greyColor,
                ),
                TextWidget(
                  onTap: () {
                    Get.offAll(() => const LoginScreen());
                  },
                  text: 'Login',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: MyColors.primaryColor,
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Image.asset('assets/images/library.png'),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextWidget(
                text: 'Your Songs',
                fontSize: 24,
                color: MyColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            // Check if songModels is empty
            if (songModels.isEmpty || songModels == [])
              TextWidget(
                text: 'No songs in library',
                fontSize: 16,
                color: MyColors.blackColor,
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 250,
                  childAspectRatio: 1,
                ),
                itemCount: songModels.length,
                itemBuilder: (context, index) =>
                    RecentReleasedWidget(list: songModels[index]),
              ),
            SizedBox(
              height: size.height * 0.12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextWidget(
                text: 'Your Books',
                fontSize: 24,
                color: MyColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            // Check if bookModels is empty
            if (bookModels.isEmpty)
              TextWidget(
                text: 'No books in library',
                fontSize: 16,
                color: MyColors.blackColor,
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 250,
                  childAspectRatio: 1,
                ),
                itemCount: bookModels.length,
                itemBuilder: (context, index) =>
                    BookWidget(list: bookModels[index]),
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
