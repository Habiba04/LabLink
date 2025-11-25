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
    return _firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .snapshots()
        .map((shots) {
          return shots.docs.map((doc) {
            return LabLocation.fromMap(doc.id, doc.data());
          }).toList();
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

    // لو المدى عادي (السبت → الثلاثاء)
    if (startIndex <= endIndex) {
      return week.sublist(startIndex, endIndex + 1);
    }

    // لو المدى عدى على نهاية الأسبوع (الخميس → الاثنين)
    return [...week.sublist(startIndex), ...week.sublist(0, endIndex + 1)];
  }
}
