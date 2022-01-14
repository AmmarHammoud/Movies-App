import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/home_screen/home_screen.dart';
import 'package:flutter_app2/shared/dio_helper.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  runApp(
    MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

