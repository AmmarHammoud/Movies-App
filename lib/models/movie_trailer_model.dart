class MovieTrailerModel{
  late String id;
  MovieTrailerModel.fromJson(Map<String, dynamic> json){
    id = json['videoId'];
  }
}