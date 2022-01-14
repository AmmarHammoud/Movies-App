class SingleMovieModel{
  late String description;
  List<dynamic> actors = [];
  SingleMovieModel.fromJson(Map<String, dynamic> json){
    description = json['plot'];
    for(int i = 0; i < json['actorList'].length; i++)
      {
        actors.add(Actors.fromJson(json['actorList'][i]));
      }
  }
}

class Actors{
  late String name;
  late String image;
  late String asWho;
  Actors.fromJson(Map<String, dynamic> json){
    name = json['name'];
    image = json['image'];
    asWho = json['asCharacter'];
  }
}