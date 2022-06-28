import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/profile_screen/cubit/states.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditingProfileCubit extends Cubit<EditingProfileStates> {
  EditingProfileCubit() : super(EditingProfileInitialState());

  static EditingProfileCubit get(context) => BlocProvider.of(context);
  bool oldPasswordIsShown = true;
  bool newPasswordIsShown = true;
  changeOldPasswordVisibility() {
    if (oldPasswordIsShown) {
      oldPasswordIsShown = false;
      emit(NotShownOldPassword());
    } else {
      oldPasswordIsShown = true;
      emit(ShownOldPassword());
    }
  }

  changeNewPasswordVisibility(){
    if(newPasswordIsShown){
      newPasswordIsShown = false;
      emit(NotShownNewPassword());
    }
    else{
      newPasswordIsShown = true;
      emit(ShownNewPassword());
    }
  }
  void editUserInfo(
      {required context,
      required UserModel model,
      required String newUserName,
      required String newEmail,
      required String newPassword,
      required String rewritePassword}) {
    editUserName(model: model, newUserName: newUserName);
    editUserEmail(model: model, newEmail: newEmail);
    editUserPassword(
        context: context,
        model: model,
        newPassword: newPassword,
        rewritePassword: rewritePassword);
  }

  void editUserName(
      {required UserModel model, required String newUserName}) async {
    emit(EditingProfileLoadingState());
    if (model.userName != newUserName) {
      model.userName = newUserName;
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(model.userName)
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(model.uId)
            .set(model.toMap())
            .then((value) {
          emit(EditingProfileSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(EditingProfileErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        emit(EditingProfileErrorState());
      });
    }
  }

  void editUserEmail(
      {required UserModel model, required String newEmail}) async {
    emit(EditingProfileLoadingState());
    if (model.email != newEmail) {
      model.email = newEmail;
      await FirebaseAuth.instance.currentUser!
          .updateEmail(model.email)
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(model.uId)
            .set(model.toMap())
            .then((value) {
          emit(EditingProfileSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(EditingProfileErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        emit(EditingProfileErrorState());
      });
    }
  }

  void editUserPassword(
      {required context,
      required UserModel model,
      required String newPassword,
      required String rewritePassword}) async {
    emit(EditingProfileLoadingState());
    if (model.password != newPassword &&
        newPassword == rewritePassword &&
        newPassword != '' &&
        newPassword.length >= 6) {
      model.password = newPassword;
      await FirebaseAuth.instance.currentUser!
          .updatePassword(newPassword)
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(model.uId)
            .set(model.toMap())
            .then((value) {
          emit(EditingProfileSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(EditingProfileErrorState());
        });
      }).catchError((error) {
        showToast(context: context, text: error.toString(), color: Colors.red);
        print(error.toString());
        emit(EditingProfileErrorState());
      });
    }
  }
}
