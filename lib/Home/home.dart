import 'package:flutter/material.dart';
import 'package:lablink/Patient/Pages/MainScreen.dart';
import 'package:lablink/Patient/Pages/ServiceType.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> mockLabData = {
      'name': 'Central Lab',
      'id': 'lab1',
    };

    final Map<String, dynamic> mockLocationData = {
    final labData = {'name': 'Central Lab', 'id': 'lab1'};
    final locationData = {
      'id': 'location1',
      "name": "Nasr City Branch",
      'address': 'Nasr City, Cairo',
      'openAt': '08:00',
      'closeAt': '17:00',
      'workingDays': ['Mon', 'Tue', 'Wed', 'Thu', 'Sun'],
    };

    final List<Map<String, dynamic>> mockSelectedTests = [
      {'name': 'Blood Test', 'price': 500},
      {'name': 'Glucose Test', 'price': 250},
    ];

    const String mockSelectedService = 'Visit Lab';
    return MaterialApp(
      title: 'Lablink',
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
      home: MainScreen(
        mockLabData: mockLabData,
        mockLocationData: mockLocationData,
        mockSelectedTests: mockSelectedTests,
        mockSelectedService: mockSelectedService,
      home: ServiceTypeScreen(
        labData: labData,
        locationData: locationData,
        selectedTests: selectedTests,
      ),
    );
  }
}
