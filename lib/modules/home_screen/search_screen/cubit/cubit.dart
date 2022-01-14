import 'package:bloc/bloc.dart';
import 'package:flutter_app2/models/movie_search_model.dart';
import 'package:flutter_app2/modules/home_screen/search_screen/cubit/states.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchForMovieCubit extends Cubit<SearchForMovieStates> {
  SearchForMovieCubit() : super(SearchForMovieInitialState());

  static SearchForMovieCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  List<dynamic> res = [];
  void searchForMovie(String movie) {
    emit(SearchForMovieLoadingState());
    DioHelper.searchForMovie(movie)
        .then((value) {
          model = SearchModel.fromJson(value.data);
          emit(SearchForMovieSuccessState());
    })
        .catchError((error) {
          print(error.toString());
          emit(SearchForMovieErrorState());});
  }
}
