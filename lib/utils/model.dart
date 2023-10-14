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

  BookModel(this.imageUrl, this.title, this.detail, this.color, this.rating,
      this.price);

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'detail': detail,
      'color': color,
      'rating': rating,
      'price': price,
    };
  }
}

List<BookModel> bookList = [
  BookModel('assets/images/book_1.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'red', '100', '39.5'),
  BookModel('assets/images/book_2.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'yellow', '100', '39.5'),
  BookModel('assets/images/book_3.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'green', '100', '39.5'),
  BookModel('assets/images/book_4.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'red', '100', '39.5'),
  BookModel('assets/images/book_1.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'yellow', '100', '39.5'),
  BookModel('assets/images/book_2.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'green', '100', '39.5'),
  BookModel('assets/images/book_3.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'red', '100', '39.5'),
  BookModel('assets/images/book_4.jpeg', 'Play Piano by Letters',
      'Joseph Caliguri', 'yellow', '100', '39.5'),
];
