// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_keys.dart';
import 'UserPage.dart';
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
  String date = '';
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
            : EditableUserPage(name: userName, org: userOrg, txt: txt2 , Date:date ));
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

        if (personEntities.isEmpty && organizationEntities.isEmpty) {
          setState(() {
            userName = '';
            userOrg = '';
            txt2 = "Sorry, wasn't able to understand the image!";
          });
        } else if (personEntities.isEmpty) {
          setState(() {
            userName = '';
            txt2 =
                "Sorry, wasn't able to understand the name. Please fill it yourself.";
          });
        } else if (organizationEntities.isEmpty) {
          setState(() {
            userOrg = '';
            txt2 =
                "Sorry, wasn't able to understand the organization. Please fill it yourself.";
          });
        }

        String? extractedDate = fetchDate(rawData);

        if (extractedDate != null) {
          setState(() {
            date = extractedDate;
          });
          // Do something with the extracted date
        } else {
          setState(() {
            date = 'NIL';
          });
        }

        setState(() {
          _isLoad = false;
          userName = personEntities[0];
          userOrg = organizationEntities[0];
        });
        for (String organization in predefinedOrg) {
          if (rawData.toLowerCase().contains(organization.toLowerCase())) {
            setState(() {
              userOrg = organization;
            });
          }
        }
        for (String prename in Names) {
          if (rawData.toLowerCase().contains(prename.toLowerCase())) {
            setState(() {
              userName = prename;
            });
          }
        }
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. ${response.body}');
    }
  }

  String? fetchDate(String rawData) {
    RegExp exp1 = RegExp(r'(\d{4}-\d{2}-\d{2})'); // yyyy-mm-dd
    RegExp exp2 = RegExp(r'(\d{4}/\d{2}/\d{2})'); // yyyy/mm/dd
    RegExp exp3 = RegExp(r'(\d{2}-\d{2}-\d{4})'); // dd-mm-yyyy
    RegExp exp4 = RegExp(r'(\d{2}/\d{2}/\d{4})'); // dd/mm/yyyy
    RegExp exp5 = RegExp(
        r'([A-Za-z]+,\s[A-Za-z]+\s\d{1,2},\s\d{4})'); // Monday, September 29, 2014
    List<RegExp> patterns = [
      exp1,exp2,exp3,exp4,exp5, RegExp(r'[A-Za-z]+,\s[A-Za-z]+\s\d{1,2},\s\d{4}'), // Tuesday, September 06, 2022
      RegExp(r'[A-Za-z]+,\s[A-Za-z]+\s\d{1,2},\s\d{2}'), // Tuesday, September 06, 22
      RegExp(r'[A-Za-z]+\s\d{1,2},\s\d{4}'), // September 06, 2022
      RegExp(r'[A-Za-z]+\s\d{1,2},\s\d{2}'), // September 06, 22
      RegExp(r'\d{1,2}\s[A-Za-z]+\,\s\d{4}'), // 06 September, 2022
      RegExp(r'\d{1,2}\s[A-Za-z]+\,\s\d{2}'), // 06 September, 22
      RegExp(r'\d{1,2}\s[A-Za-z]+\s\d{4}'), // 06 September 2022
      RegExp(r'\d{1,2}\s[A-Za-z]+\s\d{2}'), // 06 September 22
      RegExp(r'\d{1,2}/\d{1,2}/\d{4}'), // 06/12/2022
      RegExp(r'\d{1,2}-\d{1,2}-\d{4}'), // 06-12-2022
      RegExp(r'\d{4}/\d{1,2}/\d{1,2}'), // 2022/12/06
      RegExp(r'\d{4}-\d{1,2}-\d{1,2}'), // 2022-12-06
    ];

    String? extractedDate;
    for (RegExp pattern in patterns) {
      RegExpMatch? match = pattern.firstMatch(rawData);
      if (match != null) {
        extractedDate = match.group(0);
        break;
      }
    }

    return extractedDate;
  }
  // Firebase: Collections and Documents
  // col/doc/col/doc
  // col/ doc1, doc2, doc3....

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
