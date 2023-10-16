// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/main.dart';
import 'package:to_do/screens/signup.dart';
import 'package:to_do/screens/whattodo.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    navigate();
    super.initState();
  }

  Future<void> navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final _isloggedin = prefs.getBool(SAVE_KEY);
    await Future.delayed(const Duration(seconds: 5));

    if (_isloggedin == true) {
      // The user is already signed in, navigate to the main screen (screenWhattoDo)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (builder) => const screenWhattoDo()));
    } else {
      // The user is not signed in, navigate to the sign-up screen
      Navigator.push(context,
          MaterialPageRoute(builder: (builder) => const ScreenSignup()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: AlignmentDirectional.center,
              height: 100,
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width - 99,
              width: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30)),
              child: Image.asset(
                "lib/images/123.gif",
                alignment: AlignmentDirectional.center,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Powered by Whattodo",
            style: TextStyle(
                color: Colors.white30,
                fontSize: 10,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

Future<void> gotoLogin(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 3));
  // ignore: use_build_context_synchronously
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: ((context) => const ScreenSignup())));
}
// if (_isloggedin == null || _isloggedin == false) {
    //   // ignore: use_build_context_synchronously
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (builder) => const ScreenSignup()));
    // } else {
    //   // The user is not signed in, navigate to the sign-up screen
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (builder) => screenWhattoDo()));
    // }