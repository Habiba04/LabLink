import 'package:flutter/material.dart';
import 'package:lablink/Patient/Pages/ServiceType.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final labData = {'name': 'Central Lab', 'id': 'lab1'};
    final locationData = {
      'id': 'location1',
      "name": "Nasr City Branch",
      'address': 'Nasr City, Cairo',
      'openAt': '08:00',
      'closeAt': '17:00',
      'workingDays': ['Mon', 'Tue', 'Wed', 'Thu', 'Sun'],
    };
    final selectedTests = [
      {'name': 'Blood Test', 'price': 500},
      {'name': 'Glucose Test', 'price': 250},
    ];
    return MaterialApp(
      title: 'LabLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00BBA7)),
      ),
      home: ServiceTypeScreen(
        labData: labData,
        locationData: locationData,
        selectedTests: selectedTests,
      ),
    );
  }
}
