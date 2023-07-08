// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_keys.dart';
// import 'UserPage.dart';
import 'EditableUserPage.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool comp =
      false; // this variable will track ki api has completed it's work or not?
  bool _isLoad = true;

  TextEditingController controller = TextEditingController();
  List<dynamic> entities = [];
  List<String> organizationEntities = [];
  List<String> personEntities = [];
  String course = '';
  String userName = '';
  String userOrg = '';
  String userCourse = '';
  String txt2 = '';

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text(" Text Extracted Sucessfully ")),
        body: _isLoad
            ? const Center(child: CircularProgressIndicator())
            : EditableUserPage(name: userName, org: userOrg, txt: txt2));
  }

  Future<void> analyzeEntitiesAPI(String rawData) async {
    const String ibmKey = NATURAL_LANGUAGE_UNDERSTANDING_APIKEY;
    const String url = NATURAL_LANGUAGE_UNDERSTANDING_URL;

    print(rawData);
    final String text = 'www.ibm.com';

    final Map<String, dynamic> body = {
      'text': rawData,
      'features': {
        'entities': {'limit': 5, 'mentions': true, 'model': 'en-news'}
      },
    };
    final http.Response response = await http.post(
      Uri.parse(url + '/v1/analyze?version=2022-04-07'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic " + base64Encode(utf8.encode("apikey:$ibmKey")),
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Extracting entities of type 'Person'

      if (data.containsKey('entities')) {
        entities = data['entities'];
        for (var entity in entities) {
          if (entity.containsKey('type') && entity.containsKey('text')) {
            if (entity['type'] == 'Person') {
              personEntities.add(entity['text']);
            } else if (entity['type'] == 'Organization') {
              organizationEntities.add(entity['text']);
            } else if (entity['type'] == 'JobTitle') {
              course = entity['text'];
            }
          }
        }

        print('Person Entities: $personEntities');
        print('Organization Entities: $organizationEntities');
        print('Course: $course');
        comp = true;

        // final int startIndex = rawData.indexOf("has successfully completed");

        // if (startIndex != -1) {
        //   // Find the index of "by" or "from" after the startIndex
        //   final int endIndexBy = rawData.indexOf("by", startIndex);
        //   final int endIndexFrom = rawData.indexOf("from", startIndex);

        //   // Find the index of the first occurrence of "by" or "from" after the startIndex
        //   final int endIndex = (endIndexBy != -1 && endIndexBy > startIndex)
        //       ? endIndexBy
        //       : (endIndexFrom != -1 && endIndexFrom > startIndex)
        //           ? endIndexFrom
        //           : -1;

        //   if (endIndex != -1) {
        //     // Extract the text between startIndex and endIndex
        //     final String extractedText =
        //         rawData.substring(startIndex, endIndex);
        //         print('This is the extracted text' + extractedText.trim());
        //     // Update the userCourse variable
        //     setState(() {
        //       userCourse = extractedText.trim();
        //     });
        //   }
        // }
        if (personEntities.isEmpty && organizationEntities.isEmpty) {
          setState(() {
            userName = '';
            userOrg = '';
            txt2 = "Sorry , wasn't able to understand the image!";
          });
        } else if (personEntities.isEmpty) {
          setState(() {
            userName = '';
            txt2 =
                "Sorry , wasn't able to understand name try filling it yourself.";
          });
        }
        if (organizationEntities.isEmpty) {
          setState(() {
            userOrg = '';
            txt2 =
                "Sorry , wasn't able to understand organisation try filling it yourself.";
          });
        }
        // retrieving the original string that is needed
        // String org = organizationEntities[0];
        // String organization = org.substring(0, org.indexOf(" "));
        // reDirectUserTo(personEntities[0], organization,course); // isko idher pe name, org and course pass krna hoga as arguments

        // making some changes->
        setState(() {
          _isLoad = false;
          userName = personEntities[0];
          userOrg = organizationEntities[0];
        });
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. ${response.body}');
    }
  }

  // to send data as text blocks

  // Future<void> _addDataToFirebase(blocks) async {
  //   CollectionReference textsCollectionRef =
  //       FirebaseFirestore.instance.collection('texts');
  //   await textsCollectionRef.add({'blocks': FieldValue.arrayUnion(blocks)});
  // }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer();
    final RecognizedText recognisedText =
        await textRecognizer.processImage(image);

    List<TextBlock> recognizedBlocks = recognisedText.blocks;

    String blocksText = "";

    List<String> blocks = []; //Appending data into array "block"

    for (TextBlock block in recognizedBlocks) {
      blocks.add(block.text);
      blocksText += block.text + ("    ");
    }

    controller.text = blocks.join("\n");
    await analyzeEntitiesAPI(blocksText);
    // await _addDataToFirebase(blocks);
  }

// To send Data as text---string

  // Future<void> _addDataToFirebase(String text) async {
  //   CollectionReference textsCollectionRef =
  //       FirebaseFirestore.instance.collection('texts');
  //   await textsCollectionRef.add({'text': text});
  // }

  // void processImage(InputImage image) async {
  //   final textRecognizer = TextRecognizer();
  //   final RecognizedText recognisedText =
  //       await textRecognizer.processImage(image);

  //   List<TextBlock> recognizedBlocks = recognisedText.blocks;

  //   String blocksText = "";

  //   for (TextBlock block in recognizedBlocks) {
  //     blocksText += block.text + ("           ");
  //   }

  //   controller.text = blocksText;
  // await _addDataToFirebase(blocksText);
  // }
}
