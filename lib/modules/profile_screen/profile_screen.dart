import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/profile_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/profile_screen/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  UserModel model;

  ProfileScreen(this.model);

  @override
  Widget build(BuildContext context) {
    var userNameController = TextEditingController(text: model.userName);
    var emailController = TextEditingController(text: model.email);
    var oldPasswordController = TextEditingController(text: model.password);
    String userName = model.userName!;
    String email = model.email;
    String password = model.password;
    String newPassword = '';
    String rewritePassword = '';
    return BlocProvider(
      create: (context) => EditingProfileCubit(),
      child: BlocConsumer<EditingProfileCubit, EditingProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          print(model.userName);
          print(model.email);
          print(model.password);
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit profile'),
            ),
            body: SingleChildScrollView(child: Column(
              children: [
                TextFormField(
                  controller: userNameController,
                  onChanged: (String value) {
                    userName = value;
                  },
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    hintText: 'user name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  onChanged: (String value) {
                    email = value;
                  },
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    hintText: 'email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: oldPasswordController,
                  onChanged: (String value) {
                    password = value;
                  },
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    hintText: 'old password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                TextFormField(
                  onChanged: (String value) {
                    newPassword = value;
                  },
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    hintText: 'new password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                TextFormField(
                  onChanged: (String value) {
                    rewritePassword = value;
                  },
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    hintText: 're-write password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                ConditionalBuilder(
                    condition: state is! EditingProfileLoadingState,
                    builder: (context) =>
                        MaterialButton(
                          child: Text('Save changes'),
                          onPressed: () {
                            EditingProfileCubit.get(context).editUserInfo(
                                model: model,
                                newUserName: userName,
                                newEmail: email,
                                newPassword: newPassword,
                                rewritePassword: rewritePassword);
                          },
                          color: Colors.blue,
                        ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator(),)),
              ],
            ),),);
        },
      ),
    );
  }
}
