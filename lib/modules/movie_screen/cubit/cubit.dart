import 'package:flutter_app2/models/single_movie_model.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/states.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMovieDetailsCubit extends Cubit<GetMovieDetailsStates> {
  GetMovieDetailsCubit() : super(GetMovieDetailsInitialState());
  static GetMovieDetailsCubit get(context) => BlocProvider.of(context);
  SingleMovieModel? smm;
  getMovieDetails(String id) {
    emit(GetMovieDetailsLoadingState());
    DioHelper.getMovieDetails(id)
        .then((value) {
          smm = SingleMovieModel.fromJson(value.data);
          //print(smm?.description.toString());
          emit(GetMovieDetailsSuccessState());
    })
        .catchError((error) {emit(GetMovieDetailsErrorState());});
  }

}
