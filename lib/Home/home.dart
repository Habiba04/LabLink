import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lablink/Patient/Pages/splashScreen.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LabLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00BBA7)),
        useMaterial3: true,
      ),

      home: Splash(),
    );
  }
}
