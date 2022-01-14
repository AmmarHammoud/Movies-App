import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  String old = 'k_q6aztflp';
  String nw = 'k_aslht6w6';

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://imdb-api.com/en/API/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getMostPopularMovies() async {
    return await dio.get('MostPopularMovies/k_q6aztflp');
  }

  static Future<Response> getTopMovies() async {
    return await dio.get('Top250Movies/k_q6aztflp');
  }

  static Future<Response> getComingSoon()async{
    return await dio.get('ComingSoon/k_q6aztflp');
  }

  static Future<Response> getMovieDetails(String id)async{
    return await dio.get('Title/k_q6aztflp/' + id);
  }

  static Future<Response> searchForMovie(String movie)async{
    return await dio.get('Search/k_q6aztflp/' + movie);
  }

  static Future<Response> getMovieTrailer(String movie)async{
    return await dio.get('YouTubeTrailer/k_q6aztflp/' + movie);
  }
}
