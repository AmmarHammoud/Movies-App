import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/login_screen/login_screen.dart';
import 'package:flutter_app2/modules/signin_screen/cubit/states.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit() : super(SignInInitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  void signIn(
      {required context,
      required userName,
      required String email,
      required String password}) {
    emit(SignInLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
          context: context,
          uId: value.user!.uid,
          userName: userName,
          email: email,
          password: password);
    }).catchError((error) {
      print(error.toString());
      emit(SignInErrorState());
    });
  }

  void createUser(
      {required context,
      required String uId,
      required String userName,
      required String email,
      required String password}) {
    UserModel model =
        UserModel(uId: uId, email: email, userName: userName, password: password);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SignInSuccessState());
      navigateTo(context, LoginScreen(model: model,));
    }).catchError((error) {});
  }
}
