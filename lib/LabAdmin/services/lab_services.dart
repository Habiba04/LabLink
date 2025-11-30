import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Models/Appointment.dart';
import 'package:lablink/Models/Review.dart';

class LabsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateLabData({
    required String name,
    required String phone,
    required String closingTime,
    required String email,
  }) async {
    try {
      final lab = FirebaseAuth.instance.currentUser;
      if (lab == null) {
        print("❌ No lab logged in");
        return;
      }

      await _firestore.collection('lab').doc(lab.uid).update({
        'name': name.trim(),
        'phone': phone.trim(),
        'closingTime': closingTime.trim(),
        'email': email.trim(),
      });

      print("✅ Lab data updated successfully");
    } catch (e) {
      print("❌ Error updating lab data: $e");
    }
  }
}
