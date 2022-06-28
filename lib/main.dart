import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/home_screen/home_screen.dart';
import 'package:flutter_app2/modules/login_screen/login_screen.dart';
import 'package:flutter_app2/shared/dio_helper.dart';
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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SafeArea(
          child:
              MyApp(uId == null ? false : true, login == null ? false : login)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool loginVisited;
  final bool uId;

  MyApp(this.uId, this.loginVisited);

  @override
  Widget build(BuildContext context) {
    ///if [uId] is not null, then there is an active user.
    ///[uId] is true AND [loginVisited] is false, this means that the user has just sign up.
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
