import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Models/Appointment.dart';

class AnalysisServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>> getMonthlyLabAnalytics(String labId) async {
    try {
      final snapshot = await _firestore
          .collection('lab')
          .doc(labId)
          .collection('appointments')
          .where('status', isEqualTo: 'Completed')
          .get();

      Map<String, Map<String, dynamic>> monthlyData = {};
      double labVisitsRevenue = 0;
      double homeVisitsRevenue = 0;

      for (var doc in snapshot.docs) {
        final appointment = Appointment.fromFirestore(doc);
        if (appointment.serviceType == "Visit Lab") {
          labVisitsRevenue += appointment.totalAmount;
        } else if (appointment.serviceType == "Home Collection") {
          homeVisitsRevenue += appointment.totalAmount;
        }

        final monthKey = DateFormat('MMM yyyy').format(appointment.date);

        monthlyData.putIfAbsent(monthKey, () {
          print("month is not found");
          return {'patients': <String>{}, 'tests': 0, 'revenue': 0.0};
        });

        monthlyData[monthKey]!['patients'].add(appointment.patientId);
        monthlyData[monthKey]!['tests'] += appointment.tests?.length ?? 0;
        monthlyData[monthKey]!['revenue'] += appointment.totalAmount ?? 0.0;
      }

      Map<String, dynamic> monthlyResults = {};
      monthlyData.forEach((month, data) {
        monthlyResults[month] = {
          'patients': (data['patients'] as Set).length,
          'tests': data['tests'],
          'revenue': data['revenue'],
        };
      });

      return {
        'monthlyData': monthlyResults,
        'labVisitsRevenue': labVisitsRevenue,
        'homeVisitsRevenue': homeVisitsRevenue,
      };
    } catch (e) {
      print('❌ Error fetching monthly analytics: $e');
      return {};
    }
  }
}
