import 'dart:developer';

import 'package:image_picker/image_picker.dart';

Future<String> pickImage({ImageSource? source}) async {
  //constructor
  final picker = ImagePicker();

  String path = '';

  try {
    final getImage = await picker.pickImage(
        source:
            source!); //didnot passed Image source directly , because we have to se camera as well as gallery

    if (getImage != null) {
      path = getImage.path; //if user chooses image give path .path
    } else {
      path = ''; //else : empty
    }
  } catch (e) {
    log(e.toString());
  }

  return path;
}
