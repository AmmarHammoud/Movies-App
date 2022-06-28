import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/signup_screen/cubit/cubit.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/states.dart';
class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: state is! SignInLoadingState,
              builder: (context) {
                String? userName;
                String? email;
                String? password;
                return Scaffold(
                  appBar: AppBar(
                    title: Text('SignUp'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
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
                        SizedBox(height: 10,),
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
                        SizedBox(height: 10,),
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
                        SizedBox(height: 10,),
                        MaterialButton(
                          child: Text('SignUp'),
                          onPressed: () {
                            if(email != null && password != null)
                            {
                              SignUpCubit.get(context)
                                  .signIn(context: context, userName: userName, email: email!, password: password!);
                            }
                            else showToast(context: context, text: 'Error Signing in', color: Colors.red);
                          },
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                );
              },
              fallback: (context) => Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
