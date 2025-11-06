import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Models/LabLocation.dart';
import 'package:lablink/Models/LabTests.dart';

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
}
