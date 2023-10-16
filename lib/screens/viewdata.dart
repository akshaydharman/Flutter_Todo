// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenViewData extends StatefulWidget {
  const ScreenViewData({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;

  @override
  State<ScreenViewData> createState() => _ScreenViewDataState();
}

class _ScreenViewDataState extends State<ScreenViewData> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String type;
  late String category;
  bool edit = false;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document["title"]);
    _descriptionController =
        TextEditingController(text: widget.document["description"]);
    type = widget.document["task"];
    category = widget.document["category"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 42, 41, 42),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("todos")
                              .doc(widget.id)
                              // .collection("users")
                              // .doc(widget.id)
                              .delete()
                              .then(
                            (value) {
                              Navigator.pop(context);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: edit ? Colors.orangeAccent : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? "Editing" : "View",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          letterSpacing: 4),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "What ToDo",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          letterSpacing: 2),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Title"),
                    SizedBox(
                      height: 25,
                    ),
                    title(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Type"),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        taskSelect(
                          "Important",
                          0xDD000000,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        taskSelect(
                          "Planned",
                          0xDD000000,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Description"),
                    SizedBox(
                      height: 25,
                    ),
                    description(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Category"),
                    SizedBox(
                      height: 25,
                    ),
                    Wrap(
                      runSpacing: 25,
                      children: [
                        categorySelect(
                          "Food",
                          0xDD000000,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        categorySelect(
                          "Travel",
                          0xDD000000,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        categorySelect(
                          "Work",
                          0xDD000000,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        categorySelect(
                          "Workout",
                          0xDD000000,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        categorySelect(
                          "Personal",
                          0xDD000000,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    edit ? button() : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        // User? user = FirebaseAuth.instance.currentUser;
        // ignore: avoid_single_cascade_in_expression_statements
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("todos")
            .doc(widget.id)
            .update(
          {
            "title": _titleController.text,
            "task": type,
            "description": _descriptionController.text,
            "category": category
          },
        );
        Navigator.pop(context);
      },
      child: Center(
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
            child: Text(
              "Update ToDo",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.black26,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enabled: edit,
        style: TextStyle(color: Colors.white, fontSize: 16),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Description",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: type == label ? Colors.black38 : Color(color),
        label: Text(
          label,
          style: TextStyle(
              color: type == label ? Colors.black : Colors.white, fontSize: 15),
        ),
        labelPadding: EdgeInsets.symmetric(
          vertical: 3.8,
          horizontal: 17,
        ),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: category == label ? Colors.black38 : Color(color),
        label: Text(
          label,
          style: TextStyle(
              color: category == label ? Colors.black : Colors.white,
              fontSize: 15),
        ),
        labelPadding: EdgeInsets.symmetric(
          vertical: 3.8,
          horizontal: 17,
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.black26,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        enabled: edit,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2),
    );
  }
}
