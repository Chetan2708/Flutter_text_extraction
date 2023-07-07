import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_keys.dart';
import 'UserPage.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(" Text Extracted Sucessfully ")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  maxLines: MediaQuery.of(context).size.height.toInt(),
                  controller: controller,
                  decoration:
                      const InputDecoration(hintText: "Text goes here..."),
                ), // here's the snippet for the raw text field
              ));
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
        final List<dynamic> entities = data['entities'];
        List<String> organizationEntities = [];
        List<String> personEntities = [];
        String course = '';
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
      } else {
        print('No entities found in the response.');
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. ${response.body}');
    }
  }
  // Firebase: Collections and Documents
  // col/doc/col/doc
  // col/ doc1, doc2, doc3....

  // to send data as text blocks

  Future<void> _addDataToFirebase(blocks) async {
    CollectionReference textsCollectionRef =
        FirebaseFirestore.instance.collection('texts');
    await textsCollectionRef.add({'blocks': FieldValue.arrayUnion(blocks)});
  }

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
