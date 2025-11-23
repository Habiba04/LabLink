import 'package:flutter/material.dart';

Widget buildLabel(String text, Icon icon) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Icon(icon.icon, color: Color(0xFF364153)),
      ),
      SizedBox(width: 12),
      Text(
        text,
        style: TextStyle(
          color: Color(0xFF364153),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
