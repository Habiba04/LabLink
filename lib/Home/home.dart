import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
   import 'package:lablink/LabAdmin/Pages/Lab_Locations.dart';
  
 
const Map<String, dynamic> labData = {
  'name': 'Central Lab (Mock)',
  'id': 'lab1',
};

const Map<String, dynamic> locationData = {
  'id': 'location1',
  "name": "Nasr City Branch (Mock)",
  'address': 'Nasr City, Cairo, Egypt',
  'openAt': '08:00',
  'closeAt': '17:00',
  'workingDays': ['Mon', 'Tue', 'Wed', 'Thu', 'Sun'],
};

const List<Map<String, dynamic>> selectedTests = [
  {'name': 'Blood Test', 'price': 500},
  {'name': 'Glucose Test', 'price': 250},
  {'name': 'Lipid Panel', 'price': 450},
];

const String selectedService = 'Visit Lab';

// ignore: must_be_immutable
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
     // home: Splash(),
   home:  LabLocations_screen(),
    );
  }
}
