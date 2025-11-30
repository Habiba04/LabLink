import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Models/LabLocation.dart';
import 'package:lablink/Models/LabTests.dart';

class LabServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Lab>> getAllLabs() async {
    try {
      final labsSnapshot = await _firestore.collection('lab').get();
      List<Lab> labs = [];

      for (var labDoc in labsSnapshot.docs) {
        final labData = labDoc.data();

        final appointmentsSnapshot = await FirebaseFirestore.instance
            .collection('lab')
            .doc(labDoc.id)
            .collection('appointments')
            .orderBy('date', descending: false)
            .get();

        double totalRevenue = 0;

        for (var appointment in appointmentsSnapshot.docs) {
          totalRevenue += (appointment['totalAmount'] ?? 0).toDouble();
        }

        final usersCount = await getUniqueUsersCount(labDoc.id);
        // Get locations
        final locationsSnapshot = await _firestore
            .collection('lab')
            .doc(labDoc.id)
            .collection('locations')
            .get();

        List<LabLocation> locations = [];
        int testsNum = 0;
        for (var locationDoc in locationsSnapshot.docs) {
          final locData = locationDoc.data();

          // Get tests for this location
          final testsSnapshot = await _firestore
              .collection('lab')
              .doc(labDoc.id)
              .collection('locations')
              .doc(locationDoc.id)
              .collection('tests')
              .get();

          final tests = testsSnapshot.docs.map((t) {
            return LabTest.fromMap(t.data());
          }).toList();
          testsNum += tests.length;

          locations.add(
            LabLocation.fromMap(locationDoc.id, locData, tests: tests),
          );
        }

        labs.add(
          Lab.fromMap(
            labData,
            id: labDoc.id,
            locations: locations,
            testsCount: testsNum,
            usersCount: usersCount ?? 0,
            lastMonthRevenue: totalRevenue,
          ),
        );
      }

      return labs;
    } catch (e) {
      print("❌ Error fetching labs: $e");
      return [];
    }
  }

  Future<int> getUniqueUsersCount(String labId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('lab')
          .doc(labId)
          .collection('appointments')
          .get();

      // Set to store unique patient IDs
      final Set<String> uniquePatients = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final patientId = data['patientId'];
        if (patientId != null) {
          uniquePatients.add(patientId);
        }
      }

      return uniquePatients.length;
    } catch (e) {
      print("Error getting unique users: $e");
      return 0;
    }
  }

  Future<void> deleteLab(String labId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final appointments = await firestore
          .collection('lab')
          .doc(labId)
          .collection('appointments')
          .get();

      for (var doc in appointments.docs) {
        await doc.reference.delete();
      }

      final reviews = await firestore
          .collection('lab')
          .doc(labId)
          .collection('reviews')
          .get();

      for (var doc in reviews.docs) {
        await doc.reference.delete();
      }

      final locations = await firestore
          .collection('lab')
          .doc(labId)
          .collection('locations')
          .get();

      for (var loc in locations.docs) {
        final tests = await loc.reference.collection('tests').get();
        for (var t in tests.docs) {
          await t.reference.delete();
        }

        await loc.reference.delete();
      }

      await firestore.collection('lab').doc(labId).delete();

      print("✅ Lab deleted successfully");
    } catch (e) {
      print("❌ Error deleting lab: $e");
    }
  }

  Future<void> addNewLab(Lab lab, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: lab.email, password: password);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("lab").doc(uid).set({
        ...lab.toMap(),
        "uid": uid,
      });

      print("Lab created + Auth account created successfully!");
    } catch (e) {
      print("Error adding lab: $e");
    }
  }
}
