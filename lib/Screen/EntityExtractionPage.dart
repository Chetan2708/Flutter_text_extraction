// Here's a valid Dart code block for a new screen with two text areas for name and organization:

import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final _nameController = TextEditingController();
  final _orgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name'),
            TextField(
              controller: _nameController,
            ),
            SizedBox(height: 16.0),
            Text('Organization'),
            TextField(
              controller: _orgController,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    super.dispose();
  }
}

// This code creates a new screen with an app bar and a body containing two text areas for name and organization. The text areas are implemented with TextField widgets and their values can be accessed through the _nameController and _orgController objects. The dispose() method is used to clean up the controllers when the widget is removed from the tree.