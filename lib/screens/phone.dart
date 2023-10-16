// ignore_for_file: prefer_const_constructors, unused_local_variable, sized_box_for_whitespace

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:to_do/service/Auth_Service.dart';

class ScreenOtp extends StatefulWidget {
  const ScreenOtp({super.key});

  @override
  State<ScreenOtp> createState() => _ScreenOtpState();
}

class _ScreenOtpState extends State<ScreenOtp> {
  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  bool circular = false;
  TextEditingController phoneController = TextEditingController();
  // FirebaseAuth _auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";

  // String get verificationId => null;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          // shadowColor: const Color.fromRGBO(249, 27, 194, 1),
        ),
        body: Container(
          // color: const Color(0xFF42275a),
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                CircleAvatar(
                    // backgroundColor: Color.fromRGBO(249, 1, 224, 0.199),
                    backgroundColor: Colors.black12,
                    radius: 50,
                    child: SvgPicture.asset("lib/images/phone.svg")),
                const SizedBox(
                  height: 40,
                ),
                textField(),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          // color: Color.fromRGBO(249, 27, 194, 1),
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      const Text(
                        "Enetr 6 Digit OTP",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          // color: Color.fromRGBO(249,27, 194, 1),
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                otpField(context),
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Send OTP Again ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      TextSpan(
                        text: "00:$start ",
                        style: TextStyle(
                          fontSize: 16,
                          // color: Color.fromRGBO(249, 27, 194, 1),
                          color: Colors.amber,
                        ),
                      ),
                      TextSpan(
                        text: "Sec",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 90,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey)
                      // gradient: const LinearGradient(
                      //   colors: [
                      //     Color.fromRGBO(249, 27, 194, 1),
                      //     Color(0xFF734B6D),
                      //     Color.fromRGBO(249, 27, 194, 1),
                      //   ],
                      // ),
                      ),
                  child: InkWell(
                    onTap: () {
                      authClass.signInwithPhoneNumber(
                          verificationIdFinal, smsCode, context);
                    },
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Confirm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(
      onsec,
      (timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
            wait = false;
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  Widget textField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
        // color: const Color(0xFF734B6D),
        color: Colors.black,
        border: Border.all(
            // color: const Color.fromRGBO(249, 27, 194, 1),
            color: Colors.grey,
            width: 0.5,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            // color: Color.fromRGBO(249, 27, 194, 1),
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: TextFormField(
        controller: phoneController,
        style: TextStyle(color: Colors.white, fontSize: 17),
        keyboardType: TextInputType.phone,
        // maxLength: 10,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Your Phone Number",
          hintStyle: TextStyle(color: Colors.white30, fontSize: 15),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 9,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            child: Text(
              " (+91) ",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait
                ? null
                : () async {
                    // startTimer();
                    setState(
                      () {
                        start = 30;
                        wait = true;
                        buttonName = "Resend";
                      },
                    );
                    await authClass.verifyPhoneNumber(
                        "+91 ${phoneController.text}", context, setData);
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Text(
                buttonName,
                style: TextStyle(
                    color: wait ? Colors.grey : Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget otpField(BuildContext context) {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 30,
      fieldWidth: 50,
      otpFieldStyle: OtpFieldStyle(
          // backgroundColor: Color(0xFF734B6D),
          backgroundColor: Colors.black,
          // borderColor: Color.fromRGBO(249, 27, 194, 1),
          enabledBorderColor: Colors.grey,
          focusBorderColor: Colors.amber),
      style: TextStyle(fontSize: 17, color: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceEvenly,
      fieldStyle: FieldStyle.box,
      onCompleted: (pin) {
        // print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}
