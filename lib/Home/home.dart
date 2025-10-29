import 'package:flutter/material.dart';
import 'package:lablink/Patient/Pages/MainScreen.dart';
import 'package:lablink/Patient/Pages/ServiceType.dart';


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



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LabLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00BBA7)),
        useMaterial3: true,
      ),
      
      // home: MainScreen(
      //   mockLabData: labData,
      //   mockLocationData: locationData,
      //   mockSelectedTests: selectedTests,
      //   mockSelectedService: selectedService,
      // ),

      home: ServiceTypeScreen(
        labData: labData,
        locationData: locationData,
        selectedTests: selectedTests,
        // selectedService: selectedService, // Add if ServiceTypeScreen needs this
      ),
    );
  }
}
