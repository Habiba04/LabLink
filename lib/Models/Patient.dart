import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String address;
  final String age;

  Patient({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.address,
    required this.age,
  });

  // من Map (Firestore document data)
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      age: map['age'] ?? '',
    );
  }

  factory Patient.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      return Patient(
        uid: doc.id,
        name: '',
        email: '',
        phone: '',
        gender: '',
        address: '',
        age: '',
      );
    }
    return Patient(
      uid: data['uid'] ?? doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      address: data['address'] ?? '',
      age: data['age'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'address': address,
      'age': age,
    };
  }
}
