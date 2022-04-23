import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/signin_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/signin_screen/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocConsumer<SignInCubit, SignInStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: state is! SignInLoadingState,
              builder: (context) {
                String userName = 'null';
                String email = 'null';
                String password = 'null';
                return Scaffold(
                  appBar: AppBar(
                    title: Text('SignIn'),
                  ),
                  body: Column(
                    children: [
                      TextFormField(
                        onChanged: (String value) {userName = value;},
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                          hintText: 'user name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
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
                        child: Text('button'),
                        onPressed: () {
                          if(email != 'null' && password != 'null')
                          {
                            SignInCubit.get(context)
                                .signIn(context: context, userName: userName, email: email, password: password);
                          }
                          else print('Error SigningIn!');
                        },
                        color: Colors.blue,
                      )
                    ],
                  ),
                );
              },
              fallback: (context) => CircularProgressIndicator());
        },
      ),
    );
  }
}
