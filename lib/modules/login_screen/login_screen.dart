import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/login_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/login_screen/cubit/states.dart';
import 'package:flutter_app2/modules/signin_screen/signin_screen.dart';
import 'package:flutter_app2/shared/chach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/shared/components.dart';

import '../../models/user_model.dart';

class LoginScreen extends StatelessWidget {
  UserModel? model;

  LoginScreen({this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          String email = 'null';
          String password = 'null';
          return ConditionalBuilder(
              condition: state is! LoginLoadingState,
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('login'),
                  ),
                  body: Column(
                    children: [
                      TextFormField(
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
                        onChanged: (String value) {
                          password = value;
                        },
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                          hintText: 'password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      MaterialButton(
                          child: Text('login'),
                          onPressed: () {
                            if (email != 'null' && password != 'null') {
                              String userName = 'userName';
                              if (model?.uId != null) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(model!.uId)
                                    .get()
                                    .then((value) {
                                  print('here in if ----');
                                  print(value.data());
                                  userName = value.data()!['userName'];
                                }).catchError((error) {});
                              }
                              LoginCubit.get(context).login(
                                  context: context,
                                  email: email,
                                  password: password);
                            } else
                              print('Error Logging In');
                          }),
                      TextButton(
                          onPressed: () {
                            navigateTo(context, SignInScreen());
                          },
                          child: Text('sign up')),
                      if (state is LoginErrorState)
                        Container(
                          child: Text(state.error),
                        )
                    ],
                  ),
                );
              },
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
