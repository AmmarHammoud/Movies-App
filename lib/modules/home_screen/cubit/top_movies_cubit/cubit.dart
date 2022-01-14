import 'package:bloc/bloc.dart';
import 'package:flutter_app2/models/movies_model.dart';
import 'package:flutter_app2/modules/home_screen/cubit/top_movies_cubit/states.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopMoviesCubit extends Cubit<TopMoviesStates>{
  TopMoviesCubit() : super(TopMoviesInitialState());
  static TopMoviesCubit get(context) => BlocProvider.of(context);
  MoviesModel? top250;
  getTopMovies() {
    emit(GetTopMoviesLoadingState());
    DioHelper.getTopMovies().then((value) {
      top250 = MoviesModel.fromJson(value.data);
      emit(GetTopMoviesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetTopMoviesErrorState());
    });
  }
}