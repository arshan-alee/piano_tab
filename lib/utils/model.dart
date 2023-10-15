class SongModel {
  final String title;
  final String detail;
  final String color;
  final String rating;
  final String pages;

  SongModel(
    this.title,
    this.detail,
    this.color,
    this.rating,
    this.pages,
  );
}

List<SongModel> albumList = [
  SongModel('85mm', 'Ludovico Einaudi', 'red', '100', '35'),
  SongModel('85mm', 'Ludovico Einaudi', 'yellow', '100', '35'),
  SongModel('85mm', 'Ludovico Einaudi', 'red', '100', '35'),
  SongModel('85mm', 'Ludovico Einaudi', 'yellow', '100', '35'),
  SongModel('85mm', 'Ludovico Einaudi', 'red', '100', '35'),
  SongModel('85mm', 'Ludovico Einaudi', 'yellow', '100', '35'),
  SongModel('85mm', 'Ludovico Einaudi', 'red', '100', '35'),
  SongModel('85mm', 'Ludovico Einaudi', 'yellow', '100', '35'),
];

class BookModel {
  final String imageUrl;
  final String title;
  final String detail;
  final String color;
  final String rating;
  final String price;
  final String artist;
  final String genre;
  final String pages;
  final String difficulty;
  final String description;

  BookModel(
      this.imageUrl,
      this.title,
      this.detail,
      this.color,
      this.rating,
      this.price,
      this.artist,
      this.genre,
      this.pages,
      this.difficulty,
      this.description);

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'detail': detail,
      'color': color,
      'rating': rating,
      'price': price,
      'artist': artist,
      'genre': genre,
      'pages': pages,
      'difficulty': difficulty,
      'description': description
    };
  }
}

List<BookModel> bookList = [
  BookModel(
      'assets/images/book_1.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'red',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
  BookModel(
      'assets/images/book_2.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'yellow',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
  BookModel(
      'assets/images/book_3.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'green',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
  BookModel(
      'assets/images/book_4.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'red',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
  BookModel(
      'assets/images/book_1.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'yellow',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
  BookModel(
      'assets/images/book_2.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'green',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
  BookModel(
      'assets/images/book_3.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'red',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
  BookModel(
      'assets/images/book_4.jpeg',
      'Play Piano by Letters',
      'Joseph Caliguri',
      'yellow',
      '100',
      '39.5',
      'John Legend',
      'Pop',
      '201',
      'Intermediate',
      'Looking for a fun and easy way to learn how to play some of...'),
];
