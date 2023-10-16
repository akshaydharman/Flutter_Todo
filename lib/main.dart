// ignore_for_file: constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do/screens/splash.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:to_do/screens/home.dart';
// import 'package:to_do/screens/profile.dart';
// import 'package:to_do/screens/signup.dart';
// import 'package:to_do/screens/whattodo.dart';
// import 'package:shared_preferences/shared_preferences.dart';

const String SAVE_KEY = 'IsLoggedIn';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const ToDo());
}

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ScreenSplash(),
    );
  }
}
