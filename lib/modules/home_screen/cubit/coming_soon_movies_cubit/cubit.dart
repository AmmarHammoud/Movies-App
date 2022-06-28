import 'package:bloc/bloc.dart';
import 'package:flutter_app2/models/movies_model.dart';
import 'package:flutter_app2/modules/home_screen/cubit/coming_soon_movies_cubit/states.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComingSoonCubit extends Cubit<ComingSoonStates>{
  ComingSoonCubit() : super(ComingSoonInitialState());
  static ComingSoonCubit get(context) => BlocProvider.of(context);
  /// ComingSoon [cs]
  MoviesModel? cs;
  getComingSoon(){
    emit(GetComingSoonLoadingState());
    DioHelper.getComingSoon().then((value){
      cs = MoviesModel.fromJson(value.data);
      emit(GetComingSoonSuccessState());
    }).catchError((error){emit(GetComingSoonErrorState());});
  }
}