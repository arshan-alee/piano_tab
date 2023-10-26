import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paino_tab/api/api.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/songs_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxInt status = 2.obs;

  List<Songs>? songs;

    //this is setting book filters. just pull data from this dont create it seperately thats not logical .
   List<String> authorBookFilter = List<String>();
   List<int> pageBookFilter = List<int>();
   List<String> genreBookFilter = List<String>();
   List<String> difficultyBookFilter = List<String>();
    //this is setting song filters. just pull data from this dont create it seperately thats not logical .
   List<String> authorSongFilter = List<String>();
   List<int> pageSongFilter = List<int>();
   List<String> genreSongFilter = List<String>();
   List<String> difficultySongFilter = List<String>();

  Future<int> getSongs() async {
    try {
      var response = await http
          .get(Uri.parse('https://ktswebhub.com/ppbl/api.php?catalog'));
      if (response.statusCode == 200) {
        songs = songsFromJson(response.body);
        createFilters();
        status.value = 0;
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

  String getOriginalPdfSource(String Sku) {
    return 'https://www.ktswebhub.com/ppbl/resources/tablatures/books/$Sku.pdf';
  }

  String getMp3Source(String Sku) {
    return 'https://www.ktswebhub.com/ppbl/resources/mp3s/$Sku.mp3';
  }

  List<String> getAllArtistNames(List<Songs> songs) {
    // Use a Set to store unique artist names.
    Set<String> artistNamesSet = Set<String>();

    // Iterate through the songs and add artist names to the set.
    for (var song in songs) {
      if (song.artist != null) {
        artistNamesSet.add(song.artist!);
      }
    }

    // Convert the set to a list to maintain the order.
    List<String> artistNames = artistNamesSet.toList();

    // Sort the list in alphabetical order.
    artistNames.sort();

    return artistNames;
  }

  function createFilters(){
    
       authorBookFilter.add("All");
       difficultyBookFilter.add("All");
       genreBookFilter.add("All");   
       pageBookFilter.add("All");
       authorSongFilter.add("All");
       difficultySongFilter.add("All");
       genreSongFilter.add("All");
       pageSongFilter.add("All");
     
    for (var song in songs) {
      if (song.songSKU.startsWith("BK")) {
         if(!authorBookFilter.contains(song.artist)){
           authorBookFilter.add(song.artist);
         }
        if(!difficultyBookFilter.contains(song.difficulty)){
           difficultyBookFilter.add(song.difficulty);
         } 
        if(!genreBookFilter.contains(song.genre)){
           genreBookFilter.add(song.genre);
         }
        if(!pageBookFilter.contains(song.pages)){
           pageBookFilter.add(song.pages);
         }    
      }else{
         if(!authorSongFilter.contains(song.artist)){
           authorSongFilter.add(song.artist);
         }
        if(!difficultySongFilter.contains(song.difficulty)){
           difficultySongFilter.add(song.difficulty);
         } 
        if(!genreSongFilter.contains(song.genre)){
           genreSongFilter.add(song.genre);
         }
        if(!pageSongFilter.contains(song.pages)){
           pageSongFilter.add(song.pages);
         }        
    }
      
    authorBookFilter.sort();
    difficultyBookFilter.sort();
    genreBookFilter.sort();
    pageBookFilter.sort();
    authorSongFilter.sort();
    difficultySongFilter.sort();
    genreSongFilter.sort();
    pageSongFilter.sort();
  }
    
/*
  List<String> getAllGenreNames(List<Songs> songs) {
    // Use a Set to store unique genre names.
    Set<String> genreNamesSet = Set<String>();

    // Iterate through the songs and add genre names to the set.
    for (var song in songs) {
      if (song.genre != null) {
        genreNamesSet.add(song.genre!);
      }
    }

    // Convert the set to a list to maintain the order.
    List<String> genreNames = genreNamesSet.toList();

    // Sort the list in alphabetical order.
    genreNames.sort();

    return genreNames;
  }*/

  List<Songs> getLibraryData(List<String> libraryItems) {
    List<Songs> userlibrary = songs!
        .where((song) =>
            libraryItems.contains(song.songSku) ||
            libraryItems.contains(song.bkSku))
        .toList();
    print(userlibrary);

    return userlibrary;
  }

  static List<Songs> filterSongs(
    List<Songs> songs, {
    double? maxPrice, 
    int? maxPages, 
    String? artist,
    String? difficulty,
    String? type, // Use 'book' or 'song' as values
    String? genre,
  }) {
    return songs.where((song) {
      // Price filter
      if (maxPrice != null && double.parse(song.price!) > maxPrice) {
        return false;
      } 
      // Pages filter
      if (maxPages != null && int.parse(song.pages!) > maxPages) return false; 
      // Artist filter
      if (artist != null && song.artist != artist) return false;
      // Type filter
      if (type == 'both') return true;
      if (type == 'book' && !song.songSku!.startsWith('BK')) return false;
      if (type == 'song' && song.songSku!.startsWith('BK')) return false;
      // Genre filter
      if (genre != null && song.genre != genre) return false;
      if (difficulty == 'Beginner' && song.difficulty != difficulty)
        return false;
      if (difficulty == 'Intermediate' && song.difficulty != difficulty)
        return false;
      if (difficulty == 'Advanced' && song.difficulty != difficulty)
        return false;
      if (difficulty == 'Various' && song.difficulty != difficulty)
        return false;
      return true;
    }).toList();
  }

  List<ListItemModel> itemModellList({required List<Songs> songs}) {
    List<ListItemModel> lst = [];

    songs.forEach((e) {
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
          e.artist == null ? '' : e.artist!,
          e.genre == null ? '' : e.genre!,
          e.difficulty == null ? '' : e.difficulty!,
          e.description == null ? '' : e.description!,
          e.image == null
              ? "https://media.istockphoto.com/id/106533163/photo/plan.jpg?s=612x612&w=0&k=20&c=-XArhVuWKh1hqkBc7YWO-oCy785cuQuS3o2-oOpNBCQ="
              : "https://www.ktswebhub.com/ppbl/resources/images2/${e.songSku}b.jpg",
        );
        lst.add(bookModel);
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
          e.artist == null ? '' : e.artist!,
          e.genre == null ? '' : e.genre!,
          e.difficulty == null ? '' : e.difficulty!,
          e.description == null ? '' : e.description!,
          e.image == null ? '' : e.image!,
        );
        lst.add(songModel);
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
}
