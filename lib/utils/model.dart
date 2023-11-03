class ListItemModel {
  final String title;
  final String detail;
  final String color;
  final String rating;
  final String pages;
  final String price;
  final String amazonPrice;
  final String amazonLink;
  final String artist;
  final String genre;
  final String difficulty;
  final String description;
  final String imageUrl;

  ListItemModel(
    this.title,
    this.detail,
    this.color,
    this.rating,
    this.pages,
    this.price,
    this.amazonPrice,
    this.amazonLink,
    this.artist,
    this.genre,
    this.difficulty,
    this.description,
    this.imageUrl,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'detail': detail,
      'color': color,
      'rating': rating,
      'pages': pages,
      'price': price,
      'amazonPrice': amazonPrice,
      'amazonLink': amazonLink,
      'artist': artist,
      'genre': genre,
      'difficulty': difficulty,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
