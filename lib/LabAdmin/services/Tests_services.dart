import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lablink/Models/LabTests.dart';

class TestsServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNewTest(
    LabTest labtest,
    String labId,
    String locationId,
  ) async {
    try {
      final testsCollectionRef = firestore
          .collection('lab')
          .doc(labId)
          .collection('locations')
          .doc(locationId)
          .collection('tests');

          final newDocRef = testsCollectionRef.doc();
          final newTestId = newDocRef.id;
          labtest.id = newTestId;

      await newDocRef.set(labtest.toMap());
      print('Test added successfully!');
    } catch (e) {
      print('Error adding test: $e');
    }
  }

  Stream<List<LabTest>> getTests(String labId, String locationId) {
    return FirebaseFirestore.instance
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('tests')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            var data = doc.data();
            data['id'] = doc.id;
            return LabTest.fromMap(data);
          }).toList(),
        );
  }

  Future<int> getTestsCount(String labId, String locationId) {
    return firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('tests')
        .snapshots()
        .map((snapshot) => snapshot.docs.length)
        .first;
  }

  Future<void> updatetest(
    LabTest labtest,
    String labId,
    String locationId,
    String testId,
  ) async {
    await firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('tests')
        .doc(testId)
        .update(labtest.toMap());
  }

  Future<void> delettest(String testId, String labId, String locationId) async {
    await firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('tests')
        .doc(testId)
        .delete();
  }

  Stream<List<LabTest>> searchTests(
    String labId,
    String locationId,
    String keyword,
  ) {
    return FirebaseFirestore.instance
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('tests')
        .where("testName", isGreaterThanOrEqualTo: keyword)
        .where("testName", isLessThanOrEqualTo: "$keyword\uf8ff")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            var data = doc.data();
            data['id'] = doc.id;
            return LabTest.fromMap(data);
          }).toList(),
        );
  }
}
