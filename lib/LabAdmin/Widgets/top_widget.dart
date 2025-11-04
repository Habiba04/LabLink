import 'package:flutter/material.dart';

Widget top_screen({ required BuildContext context,required  String title,   String ? subtitle}) {
  return Container(
    height: 127,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF00BBA7), Color(0xFF155DFC)],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius:2,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        Row(
           children: [
             Padding(
            padding: const EdgeInsets.only(left: 24, top: 10, right: 16, bottom: 8),
            child: Text(
              subtitle??'',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
           ],
        ),
      ],
    ),
  );
}
