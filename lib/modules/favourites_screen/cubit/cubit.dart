import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/favourites_screen/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

class GetFavouriteMoviesCubit extends Cubit<GetFavouriteMoviesStates> {
  GetFavouriteMoviesCubit() : super(GetFavouriteMoviesInitialState());

  static GetFavouriteMoviesCubit get(context) => BlocProvider.of(context);
  var favMovies = [];

  Future<void> getFavouriteMovies(UserModel model) async {
    emit(GetFavouriteMoviesLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .get()
        .then((value) {
      favMovies.clear();
      for (int i = 0; i < value.data()!['favMovies'].length; i++) {
        favMovies.add(value.data()!['favMovies'][i]);
      }
      emit(GetFavouriteMoviesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetFavouriteMoviesErrorState());
    });
  }
}
