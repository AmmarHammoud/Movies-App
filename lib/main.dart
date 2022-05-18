import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/home_screen/home_screen.dart';
import 'package:flutter_app2/modules/login_screen/login_screen.dart';
import 'package:flutter_app2/modules/signin_screen/signin_screen.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app2/shared/chach_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CachHelper.init();
  final uId = CachHelper.getString(key: 'uId');
  final login = CachHelper.getBoolean(key: 'login');
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SafeArea(child: MyApp(uId == null ? false : true, login == null ? false : login)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool loginVisited;
  final bool uId;
  MyApp(this.uId, this.loginVisited);

  @override
  Widget build(BuildContext context) {
    return loginVisited && uId
        ? HomeScreen(
            model: UserModel(
                uId: CachHelper.getString(key: 'uId')!,
                userName: CachHelper.getString(key: 'userName')!,
                email: CachHelper.getString(key: 'email')!,
                password: CachHelper.getString(key: 'password')!),
          )
        : LoginScreen();
  }
}
