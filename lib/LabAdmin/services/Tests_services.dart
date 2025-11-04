import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:lablink/Models/LabTests.dart';

class TestsServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addNewTest(Labtest labtest) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String locationId = "svcdxbxN6pePsTcOTZTo";
    String labId = 'sJAWUw2DnhZDibT5EeUqf2D5qXr2';
  //  String locationId = "svcdxbxN6pePsTcOTZTo";
    try{
      firestore
        .collection('labs')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('tests')
        .doc()
        .set({
          'name': labtest.name,
          'category': labtest.category,
          'price': labtest.price,
          'duration': labtest.duration,
          'sampleType': labtest.sampleType,
          'description': labtest.description,
          'preparation': labtest.preparation,
        });
    }catch(e){
      print('Error adding test: $e');
    }
  }
}
