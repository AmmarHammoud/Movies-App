class SearchModel{
  List<dynamic> results = [];
  SearchModel.fromJson(Map<String, dynamic> json){
    for(int i = 0; i < json['results'].length; i++)
      {
        results.add(SearchResults.formJson(json['results'][i]));
      }
  }
}

class SearchResults{
  late String title;
  late String image;
  SearchResults.formJson(Map<String, dynamic> json){
    title = json['title'];
    image = json['image'];
  }
}