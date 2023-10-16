// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/screens/signin.dart';
import 'package:to_do/service/Auth_Service.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({super.key});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  // ignore: unused_field
  late Stream<QuerySnapshot> _stream;
  AuthClass authClass = AuthClass();
  // User? currentUSer = FirebaseAuth.instance.currentUser;
  final ImagePicker picker = ImagePicker();
  XFile? image;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    // Load the user's profile image URL when the screen initializes
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    if (user != null) {
      // Retrieve the user's document from Firestore
      DocumentSnapshot userDoc =
          await firestore.collection("users").doc(user!.uid).get();
      if (userDoc.exists) {
        // Get the profileImage URL from the user's document
        String storedImageUrl = userDoc.get('profileImage') ?? "";

        // Use the URL from Firestore
        setState(() {
          imageUrl = storedImageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                backgroundImage: getImage(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.of(context).size.width - 99,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 40,
                      width: 99,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          image = (await picker.pickImage(
                              source: ImageSource.gallery))!;
                          setState(() {
                            image = image;
                          });
                        },
                        icon: Icon(Icons.add_a_photo, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference folderName = referenceRoot.child("images");
                          String uniqueName =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          Reference imageToupload =
                              folderName.child(uniqueName);
                          try {
                            await imageToupload.putFile(File(image!.path));
                            String imageUrl =
                                await imageToupload.getDownloadURL();
                            await firestore
                                .collection("users")
                                .doc(user.uid)
                                .set({'profileImage': imageUrl});
                            // print(imageUrl);
                            setState(() {
                              imageUrl = imageUrl;
                            });
                          } catch (e) {
                            // nothing;
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 99,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Upload",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    // SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.of(context).size.width - 40,
                // color: Colors.cyanAccent,
                child: Text(
                  "Hello, ${user?.email}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 80),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm SignOut"),
                        content: Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Dismiss the dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              // Sign out and navigate to the sign-up page
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ScreenSignin()),
                              );
                            },
                            child: Text('Sign Out'),
                          ),
                        ],
                      );
                    },
                  );
                },
                // child: Text(
                //   'Sign Out',
                //   style: TextStyle(
                //     color: Colors.red, // Customize the button's text color
                //   ),
                // ),
                child: Container(
                  height: 60,
                  width: 130,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Sign Out",
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
    );
  }

  ImageProvider getImage() {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else if (image != null) {
      return FileImage(File(image!.path));
    }
    return const AssetImage("lib/images/123.gif");
  }
}
