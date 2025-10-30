import 'package:lablink/Models/LabLocation.dart';

class Lab {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<LabLocation> locations;

  Lab({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.locations = const [],
  });

  factory Lab.fromMap(
    Map<String, dynamic> map, {
    List<LabLocation> locations = const [],
  }) {
    return Lab(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      locations: locations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'locations': locations.map((location) => location.toMap()).toList(),
    };
  }
}
