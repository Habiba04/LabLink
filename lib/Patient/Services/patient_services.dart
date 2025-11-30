import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lablink/Models/Patient.dart';

class PatientServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Patient?> getCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('patient')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final patient = Patient.fromDocumentSnapshot(doc);

        return patient;
      } else {
        print("User data not found");
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  Future<void> updateUserData({
    required String name,
    required String phone,
    required String address,
    required String email,
    required String age,
    required String ssn,
    required String? gender,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ No user logged in");
        return;
      }

      await _firestore.collection('patient').doc(user.uid).update({
        'name': name.trim(),
        'phone': phone.trim(),
        'address': address.trim(),
        'email': email.trim(),
        'age': age.trim(),
        'ssn': ssn.trim(),
        'gender': gender,
      });

      print("✅ User data updated successfully");
    } catch (e) {
      print("❌ Error updating user data: $e");
    }
  }
}
