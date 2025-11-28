import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lablink/Models/LabLocation.dart';

class LocationServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLocation(LabLocation location, String labId) async {
    String newLocationId = _firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc()
        .id;

    location.id = newLocationId;

    await _firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(location.id)
        .set(location.toMap());
  }

  Future<void> deletLocation(String locationId, String labId) async {
    await _firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .delete();
  }

  Stream<List<LabLocation>> getLocations(String labId) {
    final labRef = _firestore.collection('lab').doc(labId);
    final locationsRef = labRef.collection('locations');

    return locationsRef.snapshots().asyncMap((shots) async {
      List<LabLocation> locationsWithCount = [];

      for (var doc in shots.docs) {
        final data = doc.data();
        final locationId = doc.id;

        final testCountSnapshot = await locationsRef
            .doc(locationId)
            .collection('tests')
            .count()
            .get();

        final int testCount = testCountSnapshot.count ?? 0;
        final List<dynamic> testsPlaceholder = List.generate(
          testCount,
          (_) => null,
        );

        locationsWithCount.add(
          LabLocation.fromMap(doc.id, data, tests: testsPlaceholder.cast()),
        );
      }
      return locationsWithCount;
    });
  }

  List<String> generateWorkingDays(String startDay, String endDay) {
    const List<String> week = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    int startIndex = week.indexOf(startDay);
    int endIndex = week.indexOf(endDay);

    if (startIndex == -1 || endIndex == -1) return [];

    if (startIndex <= endIndex) {
      return week.sublist(startIndex, endIndex + 1);
    }

    return [...week.sublist(startIndex), ...week.sublist(0, endIndex + 1)];
  }
}
