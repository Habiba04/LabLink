import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Home/splach.dart';
import 'package:lablink/firebase_options.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(My_App());
}
