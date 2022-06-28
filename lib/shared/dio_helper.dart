import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static String old = 'k_q6aztflp';
  static String nw = 'k_aslht6w6';

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://imdb-api.com/en/API/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getMostPopularMovies() async {
    return await dio.get('MostPopularMovies/$old');
  }

  static Future<Response> getTopMovies() async {
    return await dio.get('Top250Movies/$old');
  }

  static Future<Response> getComingSoon() async {
    return await dio.get('ComingSoon/$old');
  }

  static Future<Response> getMovieDetails(String id) async {
    return await dio.get('Title/$nw/' + id);
  }

  static Future<Response> searchForMovie(String movie) async {
    return await dio.get('Search/$nw/' + movie);
  }

  static Future<Response> getMovieTrailer(String movie) async {
    return await dio.get('YouTubeTrailer/$nw/' + movie);
  }
}
