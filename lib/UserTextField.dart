import 'package:flutter/material.dart';
import 'colors.dart';

class UserTextField extends StatelessWidget {
  final String label, showText;

  const UserTextField({super.key, required this.label, required this.showText});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: TextFormField(
          key:Key(showText.toString()),
          maxLines: 5,
          minLines: 1,
          initialValue: showText,
          style: const TextStyle(
            color: Pallete.whiteColor,
            fontSize: 20,

          ),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            label: Text(
              label,
              style: const TextStyle(
                color: Pallete.whiteColor,
                fontSize: 20,
              ),
            ),
            contentPadding: const EdgeInsets.all(27),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallete.borderColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallete.gradient2,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
