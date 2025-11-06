import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Models/LabLocation.dart';
import 'package:lablink/Models/LabTests.dart';
import 'package:lablink/Models/Patient.dart';
import 'package:lablink/Models/Review.dart';

class FirebaseDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Lab?> getLabDetails(String labId) async {
    try {
      // Get main lab document
      final labDoc = await _firestore.collection('lab').doc(labId).get();
      if (!labDoc.exists) return null;

      final labData = labDoc.data()!;

      // Get all locations (branches)
      final locationsSnapshot = await _firestore
          .collection('lab')
          .doc(labId)
          .collection('locations')
          .get();

      final locations = <LabLocation>[];

      for (var locationDoc in locationsSnapshot.docs) {
        final locData = locationDoc.data();

        // Get all tests in this location
        final testsSnapshot = await _firestore
            .collection('lab')
            .doc(labId)
            .collection('locations')
            .doc(locationDoc.id)
            .collection('tests')
            .get();

        final tests = testsSnapshot.docs.map((t) {
          return LabTest.fromMap(t.id, t.data());
        }).toList();

        locations.add(
          LabLocation.fromMap(locationDoc.id, locData, tests: tests),
        );
      }

      // Return full Lab object
      return Lab.fromMap(labData, locations: locations);
    } catch (e) {
      print(' Error fetching lab details: $e');
      return null;
    }
  }

  Future<List<Review>> getLabReviews(String labId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('labs')
          .doc(labId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      return reviewsSnapshot.docs
          .map((doc) => Review.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  Future<void> addReview({
    required String labId,
    required Review review,
  }) async {
    try {
      await _firestore
          .collection('labs')
          .doc(labId)
          .collection('reviews')
          .add(review.toMap());
    } catch (e) {
      print('Error adding review: $e');
    }
  }

  Future<void> updateLabRating(String labId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('labs')
          .doc(labId)
          .collection('reviews')
          .get();

      if (reviewsSnapshot.docs.isEmpty) {
        await _firestore.collection('labs').doc(labId).update({
          'labRating': 0.0,
        });
        return;
      }

      double total = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        final data = doc.data();
        total += (data['rating'] ?? 0).toDouble();
      }
      final avgRating = total / reviewsSnapshot.docs.length;

      await _firestore.collection('labs').doc(labId).update({
        'labRating': double.parse(avgRating.toStringAsFixed(1)),
      });
    } catch (e) {
      print('❌ Error updating lab rating: $e');
    }
  }

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
      });

      print("✅ User data updated successfully");
    } catch (e) {
      print("❌ Error updating user data: $e");
    }
  }
}
