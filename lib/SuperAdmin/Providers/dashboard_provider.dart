import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  int totalLabs = 0;
  int activeUsers = 0;
  int testsToday = 0;
  double revenueMonth = 0;

  List<Map<String, dynamic>> topLabs = [];

  bool isLoading = true; // new loading flag

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void listenDashboard() async {
    isLoading = true;
    notifyListeners();

    // Listen to labs collection
    firestore.collection('lab').snapshots().listen((labSnapshot) async {
      totalLabs = labSnapshot.docs.length;

      // Active users real-time
      firestore.collection('patient').snapshots().listen((userSnapshot) {
        activeUsers = userSnapshot.docs.length;
        notifyListeners();
      });

      // Reset counters
      testsToday = 0;
      revenueMonth = 0;
      topLabs = [];

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (var labDoc in labSnapshot.docs) {
        final labData = labDoc.data();

        // Listen to appointments for each lab
        firestore
            .collection('lab')
            .doc(labDoc.id)
            .collection('appointments')
            .snapshots()
            .listen((appointmentsSnapshot) {
          int labTestsToday = 0;
          double labRevenueMonth = 0;

          for (var apptDoc in appointmentsSnapshot.docs) {
            final apptData = apptDoc.data();
            final apptDate = DateTime.parse(apptData['date']); // string to DateTime

            if (apptDate.year == today.year &&
                apptDate.month == today.month &&
                apptDate.day == today.day) {
              labTestsToday++;
            }

            if (apptDate.year == now.year && apptDate.month == now.month) {
              labRevenueMonth += (apptData['totalAmount'] as num).toDouble();
            }
          }

          // Update overall stats
          testsToday = labSnapshot.docs
              .map((doc) => doc.id == labDoc.id ? labTestsToday : 0)
              .fold(0, (sum, val) => sum + val);
          revenueMonth = labSnapshot.docs
              .map((doc) => doc.id == labDoc.id ? labRevenueMonth : 0)
              .fold(0, (sum, val) => sum + val);

          // Update top labs
          topLabs.removeWhere((e) => e['name'] == labData['name']);
          topLabs.add({
            'name': labData['name'],
            'rating': (labData['labRating'] as num).toDouble(),
            'tests': appointmentsSnapshot.docs.length,
            'revenue': appointmentsSnapshot.docs
                .fold<double>(
                    0,
                    (sum, a) =>
                        sum + (a.data()['totalAmount'] as num).toDouble()),
          });

          // Sort top labs by rating descending and take top 4
          topLabs.sort((a, b) => b['rating'].compareTo(a['rating']));
          if (topLabs.length > 4) topLabs = topLabs.sublist(0, 4);

          isLoading = false;
          notifyListeners();
        });
      }
    });
  }
}
