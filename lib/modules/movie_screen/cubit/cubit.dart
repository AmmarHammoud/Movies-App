import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app2/models/movies_model.dart';
import 'package:flutter_app2/models/single_movie_model.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/states.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMovieDetailsCubit extends Cubit<GetMovieDetailsStates> {
  GetMovieDetailsCubit() : super(GetMovieDetailsInitialState());

  static GetMovieDetailsCubit get(context) => BlocProvider.of(context);
  SingleMovieModel? smm;
  bool isFav = false;

  getMovieDetails(String id, String uId) {
    emit(GetMovieDetailsLoadingState());
    DioHelper.getMovieDetails(id).then((value) {
      smm = SingleMovieModel.fromJson(value.data);
      checkIsFav(uId, id);
    }).catchError((error) {
      emit(GetMovieDetailsErrorState());
    });
  }

  Future<void> checkIsFav(String uId, String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      for (int i = 0; i < value.data()!['favMovies'].length; i++) {
        if (value.data()!['favMovies'][i]['title'][1] == id) {
          print('checkIsFav: ${value.data()!['favMovies'][i]['title'][1]}');
          isFav = true;
          emit(GetMovieDetailsSuccessState());
          return;
        }
      }
      isFav = false;
      emit(GetMovieDetailsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetMovieDetailsErrorState());
    });
    //emit(CheckIsFavouriteSuccessState());
  }

  Future<void> updateFavourites(
      UserModel model, SingleMovieModel itemModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .get()
        .then((value) {
      model.favMovies = [];
      model.favMovies = model.fromJson(value.data()!['favMovies']);
      if (!isFav) {
        isFav = true;
        emit(FavouriteMovie());
        model.favMovies = sortList(model.favMovies, itemModel);
      } else {
        isFav = false;
        emit(NotFavouriteMovie());
        if(model.favMovies[0]['title'][0] == itemModel.title)
          model.favMovies.remove(model.favMovies[0]);
        else if(model.favMovies[model.favMovies.length-1]['title'][0] == itemModel.title)
          model.favMovies.remove(model.favMovies[model.favMovies.length-1]);
        else model.favMovies = binarySearchRemoving(
            model.favMovies, 0, model.favMovies.length, itemModel.title);
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(model.uId)
          .set(model.toMap())
          .then((value) {
        print('DONE ====');
        checkIsFav(model.uId, itemModel.id);
      }).catchError((error) {
        print(error.toString());
      });
    }).catchError((error) {});
  }
}
