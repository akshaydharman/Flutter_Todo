// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/main.dart';
import 'package:to_do/screens/phone.dart';
import 'package:to_do/screens/signin.dart';
import 'package:to_do/screens/whattodo.dart';
import 'package:to_do/service/Auth_Service.dart';

class ScreenSignup extends StatefulWidget {
  const ScreenSignup({super.key});

  @override
  State<ScreenSignup> createState() => _ScreenSignupState();
}

class _ScreenSignupState extends State<ScreenSignup> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black26,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                buttonItem("lib/images/google.svg", "Continue with Google", 25,
                    () async {
                  await authClass.googleSignIn(context);
                }),
                const SizedBox(
                  height: 10,
                ),
                buttonItem("lib/images/phone.svg", "Continue with Mobile", 25,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => const ScreenOtp()),
                  );
                }),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  "or",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(
                  height: 18,
                ),
                textItem("Email:abcd@gmail.com", _emailController, false),
                const SizedBox(
                  height: 15,
                ),
                textItem("Password:******", _pwdController, true),
                const SizedBox(height: 35),
                colorButton(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "If you have already an account? ",
                    //   style: TextStyle(color: Colors.white, fontSize: 18),
                    // ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ScreenSignin()),
                            (route) => false);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonItem(String imagepath, String buttonName, double size,
      void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: 50,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String labelText, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 17, color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 17, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: _emailController.text, password: _pwdController.text);
          // print(userCredential.user?.email);

          setState(() {
            circular = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => screenWhattoDo()),
              (route) => false);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool(SAVE_KEY, true);
          // print(SAVE_KEY);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 42, 41, 42),
              Color.fromARGB(255, 0, 0, 0)
            ],
          ),
        ),
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
