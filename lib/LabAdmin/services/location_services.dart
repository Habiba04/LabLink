import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lablink/Models/LabLocation.dart';

class LocationServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLocation(Lablocation location, String labId) async {
         String newLocationId = _firestore
        .collection('labs')
        .doc(labId)
        .collection('locations')
        .doc()
        .id;     
    location.locationId = newLocationId;
    await  _firestore
        .collection('labs')
        .doc(labId)
        .collection('locations')
        .doc(location.locationId)
        .set(location.toMap());
       
  }
  Stream<List<Lablocation>> getLocations(String labId)  {
    var snapshots =   _firestore
    .collection('labs')
    .doc(labId)
    .collection('locations')
    . snapshots();
    return snapshots.map((shots)=>shots.docs.map((doc) => Lablocation.fromMap(doc.data())).toList());
    
   }
  //  String getlocationid(String labId){
  //   String locationId = _firestore
  //       .collection('labs')
  //       .doc(labId)
  //       .collection('locations')
  //       .doc()
  //       .id;     
  //   return locationId;
  //  }
 

}
