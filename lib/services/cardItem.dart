// ignore_for_file: sort_child_properties_last, file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';

class itemCard extends StatelessWidget {
  const itemCard(
      {super.key,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.time,
      required this.check,
      required this.iconBgColor,
      required this.onChange,
      required this.index});
  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBgColor;
  final Function onChange;
  final int index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                activeColor: Colors.deepOrange,
                checkColor: Colors.black,
                value: check,
                onChanged: (bool? check) {
                  onChange(index);
                },
              ),
            ),
            data: ThemeData(
                primarySwatch: Colors.grey, unselectedWidgetColor: Colors.grey),
          ),
          Expanded(
            child: Container(
              height: 75,
              color: Colors.black,
              child: Card(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: iconBgColor,
                      ),
                      child: Icon(
                        iconData,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
