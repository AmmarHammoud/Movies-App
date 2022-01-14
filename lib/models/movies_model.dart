
class MoviesModel{
  late String message;
  List<dynamic> items = [];
  MoviesModel.fromJson(Map<String, dynamic> json){
    message = json['errorMessage'];
    for(int i = 0; i < json['items'].length; i++)
      {
        items.add(ItemModel.fromJson(json['items'][i]));
      }
  }
}

class ItemModel{
  late String id;
  late String title;
  late String year;
  late String image;
  late String rating;
  ItemModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    year = json['year'];
    image = json['image'];
    rating = json['imDbRating'];
  }
}