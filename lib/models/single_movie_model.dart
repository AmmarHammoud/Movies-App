class SingleMovieModel {
  late String id;
  late String title;
  late String year;
  late String image;
  late String rating;
  late String description;
  List<dynamic>? actors = [];

  SingleMovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.image,
    required this.rating,
    required this.description,
    required this.actors
  });

  SingleMovieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    image = json['image'];
    rating = json['imDbRating'];
    description = json['plot'];
    for (int i = 0; i < json['actorList'].length; i++) {
      actors?.add(Actors.fromJson(json['actorList'][i]));
    }
  }
}

class Actors {
  late String id;
  late String name;
  late String image;
  late String asWho;

  Actors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    asWho = json['asCharacter'];
  }
}
