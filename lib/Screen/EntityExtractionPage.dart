import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test/UserTextField.dart';
import 'package:test/colors.dart';

class EditableUserPage extends StatefulWidget {
  final String name, org, txt 
  // course
  ;

  const EditableUserPage({
    Key? key,
    required this.name,
    required this.org,
    required this.txt,
    // required this.course, 
  }) : super(key: key);

  @override
  _EditableUserPageState createState() => _EditableUserPageState();
}

class _EditableUserPageState extends State<EditableUserPage> {
  bool showText = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 12), () {
      setState(() {
        showText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Pallete.blackColor,
        child: Column(
          children: [
            Image.asset("assets/bg.png"),
            const SizedBox(height: 2),
            const Text(
              "Details",
              style: TextStyle(
                color: Pallete.whiteColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            UserTextField(label: "Name", showText: widget.name), // for username
            const SizedBox(height: 10),
            UserTextField(label: "Organization", showText: widget.org), // for user org
            const SizedBox(height: 10),
            // UserTextField(label: "Course", showText: widget.course), // for user course
            // const SizedBox(height: 10),
            if (showText)
              Text(
                widget.txt,
                style: const TextStyle(
                  color: Pallete.whiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
