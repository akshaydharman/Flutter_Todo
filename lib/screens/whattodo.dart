// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_if_null_operators
// import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/screens/home.dart';
import 'package:to_do/screens/profile.dart';
import 'package:to_do/screens/viewData.dart';
import 'package:to_do/service/Auth_Service.dart';
import 'package:to_do/services/cardItem.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class screenWhattoDo extends StatefulWidget {
  const screenWhattoDo({
    super.key,
  });

  String? get id => null;

  @override
  State<screenWhattoDo> createState() => _screenWhattoDoState();
}

class _screenWhattoDoState extends State<screenWhattoDo> {
  late Stream<QuerySnapshot> _stream;
  AuthClass authClass = AuthClass();
  User? currentUSer = FirebaseAuth.instance.currentUser;

  List<Select> selected = [];
  final ImagePicker picker = ImagePicker();
  XFile? image;
  User? user = FirebaseAuth.instance.currentUser;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("todos")
        .snapshots();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "What To Do Today",
            style: TextStyle(
                color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(
              width: 25,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(38),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Monday",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: IconButton(
                  onPressed: () async {
                    var instance = FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection("todos");

                    // Create a list of document IDs to delete
                    List<String> documentIdsToDelete = selected
                        .where((select) =>
                            select.checkValue) // Filter selected items
                        .map((select) => select.id) // Get the document IDs
                        .toList();

                    // Iterate through the selected items and delete them
                    for (String documentId in documentIdsToDelete) {
                      var documentReference = instance.doc(documentId);
                      await documentReference.delete();
                    }
                    // Clear the selected list after deletion
                    selected.clear();
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 32,
                    color: Colors.deepOrange,
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => ScreenHome()),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: const [
                          Color.fromARGB(255, 0, 0, 0),
                          Color.fromARGB(255, 42, 41, 42),
                          Color.fromARGB(255, 0, 0, 0)
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ScreenProfile()));
                    // showModalBottomSheet(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return setting(context);
                    //   },
                    // );
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
                label: ''),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                IconData iconData;
                Color iconColor;
                Map<String, dynamic> document =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                switch (document["category"]) {
                  case "Work":
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.cyan;
                    break;
                  case "Personal":
                    iconData = Icons.person;
                    iconColor = Colors.cyan;
                    break;
                  case "Workout":
                    iconData = Icons.alarm;
                    iconColor = Colors.cyan;
                    break;
                  case "food":
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.cyan;
                    break;
                  case "Travel":
                    iconData = Icons.travel_explore;
                    iconColor = Colors.cyan;
                    break;
                  default:
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.cyan;
                }
                selected.add(
                  Select(id: snapshot.data!.docs[index].id, checkValue: false),
                );
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ScreenViewData(
                            document: document,
                            id: snapshot.data!.docs[index].id),
                      ),
                    );
                  },
                  child: itemCard(
                    title: document["title"] == null
                        ? "Hey there"
                        : document["title"],
                    check: selected[index].checkValue,
                    iconBgColor: Colors.black,
                    iconData: iconData,
                    iconColor: iconColor,
                    time: '12pm',
                    onChange: onChanged,
                    index: index,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void onChanged(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }

  Future<void> getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in.
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        setState(() {
          imageUrl = userSnapshot.data()?['profileImage'] ?? '';
        });
      } catch (e) {
        // nothin;
      }
    } else {
      // No user is signed in.
    }
  }
}

class Select {
  late String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
