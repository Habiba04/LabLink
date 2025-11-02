import 'package:flutter/material.dart';

Widget top_screen({ required BuildContext context,required  String title,   String ? subtitle}) {
  return Container(
    height: 127,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF00BBA7), Color(0xFF155DFC)],
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36.0, left: 26.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 78.0, top: 8),
            child: Text(
              subtitle??'',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
