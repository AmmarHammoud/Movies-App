import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/profile_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/profile_screen/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../shared/components.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel model;
  final FToast fToast = FToast();

  ProfileScreen(this.model);

  @override
  Widget build(BuildContext context) {
    var userNameController = TextEditingController(text: model.userName);
    var emailController = TextEditingController(text: model.email);
    var oldPasswordController = TextEditingController(text: '');
    String userName = model.userName!;
    String email = model.email;
    String? newPassword;
    String? rewritePassword;
    return BlocProvider(
      create: (context) => EditingProfileCubit(),
      child: BlocConsumer<EditingProfileCubit, EditingProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          bool oldPasswordIsShown = EditingProfileCubit.get(context).oldPasswordIsShown;
          bool newPasswordIsShown = EditingProfileCubit.get(context).newPasswordIsShown;
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
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
                    SizedBox(
                      height: 10,
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
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: oldPasswordIsShown,
                      controller: oldPasswordController,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              EditingProfileCubit.get(context)
                                  .changeOldPasswordVisibility();
                            },
                            icon: oldPasswordIsShown
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        hintText: 'old password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: newPasswordIsShown,
                      onChanged: (String value) {
                        newPassword = value;
                      },
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              EditingProfileCubit.get(context)
                                  .changeNewPasswordVisibility();
                            },
                            icon: newPasswordIsShown
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        hintText: 'new password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                        builder: (context) => MaterialButton(
                              child: Text('Save changes'),
                              onPressed: () {
                                if (model.password ==
                                    oldPasswordController.text)
                                  EditingProfileCubit.get(context).editUserInfo(
                                      context: context,
                                      model: model,
                                      newUserName: userName,
                                      newEmail: email,
                                      newPassword: newPassword!,
                                      rewritePassword: rewritePassword!);
                                else
                                  showToast(
                                      context: context,
                                      text: 'wrong password!',
                                      color: Colors.red);
                                if (state is EditingProfileSuccessState)
                                  showToast(
                                      context: context,
                                      text:
                                          'Your info has been edited successfully',
                                      color: Colors.green);
                              },
                              color: Colors.blue,
                            ),
                        fallback: (context) => Center(
                              child: CircularProgressIndicator(),
                            )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
