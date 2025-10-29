import 'package:cloud_firestore/cloud_firestore.dart';

class PatientData {
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future<void>savepatinetdata({
     required String uid,
    required String email,
    required String phone,
    required String age,
    required String gender,
    required String ssn,
  })async{
    try{
      await firestore.collection('patient').doc(uid).set({
        'email':email,
        'phone':phone,
        'age':age,
        'gender':gender,
        'ssn':ssn  ,
          'createdAt': FieldValue.serverTimestamp(),
      });
        print('✅ User data saved successfully!');
    }catch(e){
        print('❌ Error saving user data: $e');
       
    }
  }
}