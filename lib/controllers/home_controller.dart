import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paino_tab/api/api.dart';
import 'package:paino_tab/models/localdbmodels/OfflineLibraryBox.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/songs_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxInt status = 2.obs;
  String selectedPage = "song";

  List<Songs>? songs;
  List<Songs> book = [];
  List<Songs> song = [];

  RxList<ListItemModel> cartItems = <ListItemModel>[].obs;
  var totalCartItemCount = ValueNotifier(0);
  RxInt adsWatched = 0.obs;
  var totalAmount = ValueNotifier(0);
  var totalTokensAwarded = ValueNotifier(0);
  var totalPoints = ValueNotifier('');

  RxList<ListItemModel> filteredBk = <ListItemModel>[].obs;
  RxList<ListItemModel> filteredSng = <ListItemModel>[].obs;

  List<String> authorBookFilter = [];
  List<String> pageBookFilter = [];
  List<String> genreBookFilter = [];
  List<String> difficultyBookFilter = [];

  List<String> authorSongFilter = [];
  List<String> pageSongFilter = [];
  List<String> genreSongFilter = [];
  List<String> difficultySongFilter = [];
  List<String> sectionOfSongsSongFilter = [];

  List<Songs> recentList = [];
  List<Songs> ez = [];
  List<Songs> twentyone = [];
  List<Songs> contemp = [];
  List<Songs> popsng = [];
  List<Songs> clsscal = [];
  List<Songs> tvflm = [];

  String selectedArtists = "All";
  String selectedPages = "All";
  String selectedGenres = "All";
  String selectedDifficulty = "All";
  String selectedSectionOfSongs = "All";

  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setTimestamp(String timestamp) async {
    await _prefs.setString('timestamp', timestamp);
  }

  String getTimestamp() {
    return _prefs.getString('timestamp') ?? '';
  }

  Future<void> setAdsWatched(int adswatched) async {
    await _prefs.setInt('adswatched', adswatched);
  }

  int getAdsWatched() {
    return _prefs.getInt('adswatched') ?? 0;
  }

  Future<int> getSongs() async {
    try {
      var response = await http
          .get(Uri.parse('https://ktswebhub.com/ppbl/api.php?catalog'));
      if (response.statusCode == 200) {
        songs = songsFromJson(response.body);
        status.value = 0;
        createFilters();

        book = filterSongs(songs!, type: 'book');
        song = filterSongs(songs!, type: 'song');
        filteredBk.value = itemModellList(songs: book);
        filteredSng.value = itemModellList(songs: song);
        update();
        return status.value;
      } else {
        status.value = 1;
        update();
        return status.value;
      }
    } catch (e) {
      status.value = 1;
      update();
      // ignore: avoid_print
      print('Exception : ${e.toString()}');
      return status.value;
    }
  }

  String getSamplePdfSource(String Sku) {
    return 'https://www.ktswebhub.com/ppbl/resources/samples/$Sku.pdf';
  }

  String getOriginalbookPdfSource(String Sku) {
    return 'https://www.ktswebhub.com/ppbl/resources/tablatures/books/$Sku.pdf';
  }

  String getOriginalsongPdfSource(String Sku) {
    return 'https://www.ktswebhub.com/ppbl/resources/tablatures/$Sku.pdf';
  }

  String getMp3Source(String Sku) {
    return 'https://www.ktswebhub.com/ppbl/resources/mp3s/$Sku.mp3';
  }

  void createFilters() {
    int recentCount = 0;
    int difficultyCount = 0;
    int twentyonepilotCount = 0;
    int popCount = 0;
    int contempCount = 0;
    int classicCount = 0;
    int tvfilmCount = 0;
    for (var song in songs!) {
      if (recentCount < 11) {
        recentList.add(song);
        recentCount++;
      }
      if (difficultyCount < 10 && song.difficulty == "Beginner") {
        ez.add(song);
        difficultyCount++;
      }
      if (twentyonepilotCount < 10 && song.artist == "Twenty One Pilots") {
        twentyone.add(song);
        twentyonepilotCount++;
      }
      // if (popCount < 10 && song.difficulty == "Beginner") {
      //   ez.add(song);
      //   popCount++;
      // }
      if (contempCount < 10 && song.genre == "Contemporary") {
        contemp.add(song);
        contempCount++;
      }
      if (popCount < 10 && song.genre == "Pop") {
        popsng.add(song);
        popCount++;
      }
      if (classicCount < 10 && song.genre == "Classical") {
        clsscal.add(song);
        classicCount++;
      }
      if (tvfilmCount < 10 && song.genre == "TV / Film") {
        tvflm.add(song);
        tvfilmCount++;
      }
      if (song.songSku!.startsWith("BK")) {
        if (!authorBookFilter.contains(song.artist)) {
          authorBookFilter.add(song.artist!);
        }
        if (!difficultyBookFilter.contains(song.difficulty)) {
          difficultyBookFilter.add(song.difficulty!);
        }
        if (!genreBookFilter.contains(song.genre)) {
          genreBookFilter.add(song.genre!);
        }
        if (!pageBookFilter.contains(song.pages)) {
          pageBookFilter.add(song.pages!);
        }
      } else {
        if (!authorSongFilter.contains(song.artist)) {
          authorSongFilter.add(song.artist!);
        }
        if (!difficultySongFilter.contains(song.difficulty)) {
          difficultySongFilter.add(song.difficulty!);
        }
        if (!genreSongFilter.contains(song.genre)) {
          genreSongFilter.add(song.genre!);
        }
        if (!pageSongFilter.contains(song.pages)) {
          pageSongFilter.add(song.pages!);
        }
        if (!sectionOfSongsSongFilter.contains(song.sectionOfSong)) {
          sectionOfSongsSongFilter.add(song.sectionOfSong!);
        }
      }
    }
    authorSongFilter.sort();
    difficultySongFilter.sort();
    genreSongFilter.sort();
    pageSongFilter.sort((a, b) {
      final int aValue = int.tryParse(a) ?? 0;
      final int bValue = int.tryParse(b) ?? 0;

      return aValue - bValue;
    });
    sectionOfSongsSongFilter.sort();

    authorBookFilter.sort();
    difficultyBookFilter.sort();
    genreBookFilter.sort();
    pageBookFilter.sort((a, b) {
      final int aValue = int.tryParse(a) ?? 0;
      final int bValue = int.tryParse(b) ?? 0;

      return aValue - bValue;
    });

    authorSongFilter.insert(0, "All");
    difficultySongFilter.insert(0, "All");
    genreSongFilter.insert(0, "All");
    pageSongFilter.insert(0, "All");
    sectionOfSongsSongFilter.insert(0, "All");

    authorBookFilter.insert(0, "All");
    difficultyBookFilter.insert(0, "All");
    genreBookFilter.insert(0, "All");
    pageBookFilter.insert(0, "All");
  }

  List<Songs> getLibraryData(List<String> libraryItems) {
    List<Songs> userlibrary =
        songs!.where((song) => libraryItems.contains(song.songSku)).toList();

    return userlibrary;
  }

  static List<Songs> filterSongs(List<Songs> songs,
      {double? maxPrice,
      int? pages,
      String? artist,
      String? difficulty,
      String? type, // Use 'book' or 'song' as values
      String? genre,
      String? sectionOfSong}) {
    return songs.where((song) {
      // Price filter
      if (maxPrice != null && double.parse(song.price!) > maxPrice) {
        return false;
      }
      // Pages filter
      if (pages != null && int.parse(song.pages!) != pages) return false;
      // Artist filter
      if (artist != null && song.artist != artist) return false;
      // Type filter
      if (type == 'both') return true;
      if (type == 'book' && !song.songSku!.startsWith('BK')) return false;
      if (type == 'song' && song.songSku!.startsWith('BK')) return false;
      // Genre filter
      if (genre != null && song.genre != genre) return false;
      if (sectionOfSong != null && song.sectionOfSong != sectionOfSong)
        return false;
      if (difficulty != null) {
        if (difficulty == 'Beginner' && song.difficulty != difficulty) {
          return false;
        }
        if (difficulty == 'Intermediate' && song.difficulty != difficulty) {
          return false;
        }
        if (difficulty == 'Advanced' && song.difficulty != difficulty) {
          return false;
        }
        if (difficulty == 'Various' && song.difficulty != difficulty) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<ListItemModel> itemModellList({required List<Songs> songs}) {
    List<ListItemModel> lst = [];
    Set<String> addedSongSkus = Set();

    songs.forEach((e) {
      if (!addedSongSkus.contains(e.songSku!)) {
        if (e.songSku != null && e.songSku!.startsWith('BK')) {
          // This is a book
          ListItemModel bookModel = ListItemModel(
            e.bkName == null ? '' : e.bkName!,
            e.songSku == null ? '' : e.songSku!,
            'yellow',
            int.parse(e.pages!) <= 5
                ? "${int.parse(e.pages!) * 1}"
                : int.parse(e.pages!) > 5 && int.parse(e.pages!) <= 10
                    ? "${int.parse(e.pages!) * 0.5}"
                    : "${int.parse(e.pages!) * 0.25}",
            e.pages == null ? '' : e.pages!,
            e.price == null ? '' : e.price!,
            e.amazonPrice == null ? '' : e.amazonPrice!,
            e.amazonLink == null ? '' : e.amazonLink!,
            e.artist == null ? '' : e.artist!,
            e.genre == null ? '' : e.genre!,
            e.difficulty == null ? '' : e.difficulty!,
            e.description == null ? '' : e.description!,
            e.image == null
                ? "https://media.istockphoto.com/id/106533163/photo/plan.jpg?s=612x612&w=0&k=20&c=-XArhVuWKh1hqkBc7YWO-oCy785cuQuS3o2-oOpNBCQ="
                : "https://www.ktswebhub.com/ppbl/resources/images2/${e.songSku}b.jpg",
          );
          lst.add(bookModel);
          addedSongSkus.add(e.songSku!);
        } else {
          // This is a song
          ListItemModel songModel = ListItemModel(
            e.songName == null ? '' : e.songName!,
            e.songSku == null ? '' : e.songSku!,
            e.difficulty == "Intermediate"
                ? "yellow"
                : e.difficulty == "Advanced"
                    ? 'red'
                    : 'green',
            int.parse(e.pages!) <= 5
                ? "${int.parse(e.pages!) * 1}"
                : int.parse(e.pages!) > 5 && int.parse(e.pages!) <= 10
                    ? "${int.parse(e.pages!) * 0.5}"
                    : "${int.parse(e.pages!) * 0.25}",
            e.pages == null ? '' : e.pages!,
            e.price == null ? '' : e.price!,
            e.amazonPrice == null ? '' : e.amazonPrice!,
            e.amazonLink == null ? '' : e.amazonLink!,
            e.artist == null ? '' : e.artist!,
            e.genre == null ? '' : e.genre!,
            e.difficulty == null ? '' : e.difficulty!,
            e.description == null ? '' : e.description!,
            e.image == null ? '' : e.image!,
          );
          lst.add(songModel);
          addedSongSkus.add(e.songSku!);
        }
      }
    });

    return lst;
  }

  /*Future<bool?> getSpData() async {
    final prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool('isLoggedIn');
    return isLoggedIn;
  }*/

  /*Future<bool?> loginSpData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    return null;
  }
  */

  Future<bool?> logoutSpData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    return null;
  }

  /*

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('UserName');
    return userName;
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('Email');
    return email;
  }
  */

  Future<dynamic> login(String email, String password) async {
    var _ = await ApiService.login(email, password);
    return _;
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    var _ = await ApiService.signUp(email, password);
    return _;
  }

  Future<bool> getuserData(String auth) async {
    var _ = await ApiService.getUserData(auth);
    return _;
  }

  Future<bool> updateLibrary(String auth, String Sku) async {
    var _ = await ApiService.updateLibrary(auth, Sku);
    return _;
  }

  Future<bool> updatePoints(String auth, int newpoints) async {
    var _ = await ApiService.updatePoints(auth, newpoints);
    return _;
  }

  /*Future<String?> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('UserName', userName);
    return null;
  }
  */

  /*Future<String?> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Email', email);
    return null;
  }
  */
  // String emailAddress = '';
  // String userName = '';

  PageController homePageController = PageController(initialPage: 0);
  int index = 0;

  Future emptyFuture() async {
    Future.delayed(Duration(seconds: 1));
    return;
  }

  static Future<bool> addToCart(ListItemModel cartItem) async {
    if (!HomeController.to.cartItems.contains(cartItem)) {
      HomeController.to.cartItems.add(cartItem);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeFromCart(ListItemModel cartItem) async {
    if (HomeController.to.cartItems.contains(cartItem)) {
      HomeController.to.cartItems.remove(cartItem);
      return true;
    } else {
      return false;
    }
  }

  static Future<void> emptyCart() async {
    HomeController.to.cartItems.clear();
  }
}
