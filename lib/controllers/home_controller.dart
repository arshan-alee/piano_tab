import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paino_tab/utils/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/songs_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxInt status = 2.obs;

  List<Songs>? songs;

  Future<int> getSongs() async {
    try {
      var response =
          await http.get(Uri.parse('https://ktswebhub.com/dev/api/'));
      if (response.statusCode == 200) {
        songs = songsFromJson(response.body);
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

  String getSamplePdfSource() {
    return ''; //sample/$songSKU.pdf
  }

  String getOriginalPdfSource() {
    return ''; //resources/$songSKU.pdf
  }

  String getMp3Source() {
    return ''; //mp3/$songSKU.mp3
  }

  static List<Songs> filterSongs(
    List<Songs> songs, {
    double? maxPrice,
    double? minPrice,
    int? maxPages,
    int? minPages,
    String? artist,
    String? type, // Use 'book' or 'song' as values
    String? genre,
  }) {
    return songs.where((song) {
      // Price filter
      if (maxPrice != null && song.price != null) {
        if (double.parse(song.price!) > maxPrice) return false;
      }
      if (minPrice != null && song.price != null) {
        if (double.parse(song.price!) < minPrice) return false;
      }

      // Pages filter

      if (maxPrice != null && song.pages != null) {
        if (double.parse(song.pages!) > maxPrice) return false;
      }
      if (minPrice != null && song.pages != null) {
        if (double.parse(song.pages!) < minPrice) return false;
      }

      // Artist filter
      if (artist != null && song.artist != artist) return false;

      // Type filter
      if (type != null && type == "book" && song.songSku != null) {
        if (song.songSku!.startsWith('BK')) return false;
      }
      if (type != null && type == "song" && song.songSku != null) {
        if (song.songSku!.startsWith('BK')) return false;
      }

      // Genre filter
      if (genre != null && song.genre != null) {
        if (song.genre != genre) return false;
      }

      return true; // If none of the criteria is violated, include the song
    }).toList();
  }

  List<BookModel> bookModelList({required List<Songs> songs}) {
    List<BookModel> lst = [];
    songs.forEach((e) {
      print(
          'imgs : https://www.ktswebhub.com/ppbl/resources/images2/${e.bkSku}b.jpg');
      BookModel bookModel = BookModel(
        e.bkSku == null
            ? "https://media.istockphoto.com/id/106533163/photo/plan.jpg?s=612x612&w=0&k=20&c=-XArhVuWKh1hqkBc7YWO-oCy785cuQuS3o2-oOpNBCQ="
            : "https://www.ktswebhub.com/ppbl/resources/images2/${e.bkSku}b.jpg",
        // "https: //www.ktswebhub.com/ppbl/resources/images2/BK059178.jpg/",
        e.bkName == null ? '' : e.bkName!,
        e.bkSku == null ? '' : e.bkSku!,
        'yellow',
        int.parse(e.pages!) <= 5
            ? "${int.parse(e.pages!) * 1}"
            : int.parse(e.pages!) > 5 && int.parse(e.pages!) <= 10
                ? "${int.parse(e.pages!) * 0.5}"
                : "${int.parse(e.pages!) * 0.25}",
        e.price == null ? '' : e.price!,
      );
      lst.add(bookModel);
    });
    return lst;
  }

  List<SongModel> songModelList({required List<Songs> songs}) {
    List<SongModel> songList = [];
    songs.forEach((e) {
      SongModel songModel = SongModel(
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
      );
      songList.add(songModel);
    });
    return songList;
  }

  Future<bool?> getSpData() async {
    final prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool('isLoggedIn');
    return isLoggedIn;
  }

  Future<bool?> loginSpData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    return null;
  }

  Future<bool?> logoutSpData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    return null;
  }

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

  Future<String?> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('UserName', userName);
    return null;
  }

  Future<String?> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Email', email);
    return null;
  }

  String emailAddress = '';
  String userName = '';

  PageController homePageController = PageController(initialPage: 0);
  int index = 0;

  Future emptyFuture() async {
    Future.delayed(Duration(seconds: 1));
    return;
  }
}
