// To parse this JSON data, do
//
//     final songs = songsFromJson(jsonString);

import 'dart:convert';

List<Songs> songsFromJson(String str) =>
    List<Songs>.from(json.decode(str).map((x) => Songs.fromJson(x)));

String songsToJson(List<Songs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Songs> fromJsonList(String jsonStr) {
  final List<dynamic> parsedList = json.decode(jsonStr);
  return parsedList.map((json) => Songs.fromJson(json)).toList();
}

class Songs {
  String? songSku;
  String? songName;
  String? bkSku;
  String? bkName;
  String? amazonLink;
  String? amazonPrice;
  String? artist;
  String? sectionOfSong;
  String? genre;
  String? difficulty;
  String? pages;
  String? price;
  String? description;
  String? image;
  DateTime? date;

  Songs({
    this.songSku,
    this.songName,
    this.bkSku,
    this.bkName,
    this.amazonLink,
    this.amazonPrice,
    this.artist,
    this.sectionOfSong,
    this.genre,
    this.difficulty,
    this.pages,
    this.price,
    this.description,
    this.image,
    this.date,
  });

  Songs copyWith({
    String? songSku,
    String? songName,
    String? bkSku,
    String? bkName,
    String? amazonLink,
    String? amazonPrice,
    String? artist,
    String? sectionOfSong,
    String? genre,
    String? difficulty,
    String? pages,
    String? price,
    String? description,
    String? image,
    DateTime? date,
  }) =>
      Songs(
        songSku: songSku ?? this.songSku,
        songName: songName ?? this.songName,
        bkSku: bkSku ?? this.bkSku,
        bkName: bkName ?? this.bkName,
        amazonLink: amazonLink ?? this.amazonLink,
        amazonPrice: amazonPrice ?? this.amazonPrice,
        artist: artist ?? this.artist,
        sectionOfSong: sectionOfSong ?? this.sectionOfSong,
        genre: genre ?? this.genre,
        difficulty: difficulty ?? this.difficulty,
        pages: pages ?? this.pages,
        price: price ?? this.price,
        description: description ?? this.description,
        image: image ?? this.image,
        date: date ?? this.date,
      );

  factory Songs.fromJson(Map<String, dynamic> json) => Songs(
        songSku: json["Song SKU"],
        songName: json["Song Name"],
        bkSku: json["BK SKU"],
        bkName: json["BK Name"],
        amazonLink: json["Amazon Link"],
        amazonPrice: json["Amazon Price"],
        artist: json["Artist"],
        sectionOfSong: json["Section Of Song"],
        genre: json["Genre"],
        difficulty: json["Difficulty"],
        pages: json["Pages"],
        price: json["Price"],
        description: json["Description"],
        image: json["Image"],
        date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
      );

  Map<String, dynamic> toJson() => {
        "Song SKU": songSku,
        "Song Name": songName,
        "BK SKU": bkSku,
        "BK Name": bkName,
        "Amazon Link": amazonLink,
        "Amazon Price": amazonPrice,
        "Artist": artist,
        "Section Of Song": sectionOfSong,
        "Genre": genre,
        "Difficulty": difficulty,
        "Pages": pages,
        "Price": price,
        "Description": description,
        "Image": image,
        "Date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
