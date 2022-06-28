import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/login_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/login_screen/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/shared/components.dart';
import '../../models/user_model.dart';
import '../signup_screen/signin_screen.dart';

class LoginScreen extends StatelessWidget {
  final UserModel? model;

  LoginScreen({this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          String? email;
          String? password;
          bool passwordIsShown = LoginCubit.get(context).passwordIsShown;
          return ConditionalBuilder(
              condition: state is! LoginLoadingState,
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('login'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: passwordIsShown,
                          onChanged: (String value) {
                            password = value;
                          },
                          style: TextStyle(fontSize: 20.0),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  LoginCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                icon: passwordIsShown
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                            hintText: 'password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        MaterialButton(
                            child: Text('login'),
                            onPressed: () {
                              if (email != null && password != null) {
                                String userName = 'userName';
                                if (model?.uId != null) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(model!.uId)
                                      .get()
                                      .then((value) {
                                    userName = value.data()!['userName'];
                                  }).catchError((error) {
                                    showToast(
                                        context: context,
                                        text: error.toString(),
                                        color: Colors.red);
                                  });
                                }
                                LoginCubit.get(context).login(
                                    context: context,
                                    email: email!,
                                    password: password!);
                              } else
                                {

                              showToast(
                                  context: context,
                                  text: 'Wrong email or password!',
                                  color: Colors.red);
                            }}),
                        TextButton(
                            onPressed: () {
                              navigateTo(context, SignUpScreen());
                            },
                            child: Text('sign up')),
//                        if (state is LoginErrorState)
//                          Container(
//                            child: Text(state.error),
//                          ),
                      ],
                    ),
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
