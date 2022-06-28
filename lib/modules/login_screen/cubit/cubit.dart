import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/login_screen/cubit/states.dart';
import 'package:flutter_app2/shared/chach_helper.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home_screen/home_screen.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  bool passwordIsShown = true;
  changePasswordVisibility(){
    if(passwordIsShown){
      passwordIsShown = false;
      emit(NotShownPassword());
    }
    else{
      passwordIsShown = true;
      emit(ShownPassword());
    }
  }

  void login(
      {required context,
      required String email,
      required String password}) {
    emit(LoginLoadingState());
    String? userName;
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      CachHelper.putString(key: 'uId', value: value.user!.uid);
      CachHelper.putString(key: 'email', value: email);
      CachHelper.putString(key: 'password', value: password);
      CachHelper.putBoolean(key: 'login', value: true);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .get()
          .then((value) {
            userName = value.data()!['userName'];
            CachHelper.putString(key: 'userName', value: userName);
      })
          .catchError((error) {});
      UserModel model = UserModel(
          uId: value.user!.uid,
          email: email,
          password: password,
          userName: userName);
      emit(LoginSuccessState());
      navigateTo(
          context,
          HomeScreen(
            model: model,
          ));
    }).catchError((error) {
      print(error.toString());
      showToast(context: context, text: error.toString(), color: Colors.red);
      emit(LoginErrorState(error.toString()));
    });
  }
}
