import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test/UserTextField.dart';
import 'package:test/colors.dart';

class EditableUserPage extends StatefulWidget {
  final String name, org, txt, Date;

  const EditableUserPage({
    Key? key,
    required this.name,
    required this.org,
    required this.txt,
    required this.Date,
  }) : super(key: key);

  @override
  _EditableUserPageState createState() => _EditableUserPageState();
}

class _EditableUserPageState extends State<EditableUserPage> {
  bool showText = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 7), () {
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
            const SizedBox(height: 50),
            Image.asset("assets/logo.jpg"),
            const SizedBox(height: 50),
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
            UserTextField(
                label: "Organization", showText: widget.org), // for user org
            const SizedBox(height: 10),
            UserTextField(
                label: "Completion Date",
                showText: widget.Date), // for user course
            const SizedBox(height: 10),
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
