import 'package:flutter/material.dart';

class EditProfileTextField extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String labelText;
  final String hintText;
  final Icon prefixIcon;
  EditProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? hintText : null,
    );
  }
}
