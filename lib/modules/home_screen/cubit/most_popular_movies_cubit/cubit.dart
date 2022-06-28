import 'package:bloc/bloc.dart';
import 'package:flutter_app2/models/movies_model.dart';
import 'package:flutter_app2/modules/home_screen/cubit/most_popular_movies_cubit/states.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MostPopularMoviesCubit extends Cubit<MostPopularMoviesStates>{
  MostPopularMoviesCubit() : super(MostPopularMoviesInitialState());

  static MostPopularMoviesCubit get(context) => BlocProvider.of(context);
  ///MostPopularMovie [mpm]
  MoviesModel? mpm;

  getMostPopularMovies() {
    emit(GetMostPopularMoviesLoadingState());
    DioHelper.getMostPopularMovies().then((value) {
      mpm = MoviesModel.fromJson(value.data);
      emit(GetMostPopularMoviesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetMostPopularMoviesErrorState());
    });
  }
}