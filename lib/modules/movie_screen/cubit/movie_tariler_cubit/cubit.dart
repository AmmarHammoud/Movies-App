import 'package:bloc/bloc.dart';
import 'package:flutter_app2/models/movie_trailer_model.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/movie_tariler_cubit/states.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieTrailerCubit extends Cubit<MovieTrailerStates> {
  MovieTrailerCubit() : super(MovieTrailerInitialState());

  static MovieTrailerCubit get(context) => BlocProvider.of(context);

  MovieTrailerModel? model;

  getMovieTrailer(String movie) {
    emit(MovieTrailerLoadingState());
    DioHelper.getMovieTrailer(movie)
        .then((value) {
          model = MovieTrailerModel.fromJson(value.data);
          emit(MovieTrailerSuccessState());
    })
        .catchError((error) {
          print(error.toString());
          emit(MovieTrailerErrorState());
    });
  }
}
