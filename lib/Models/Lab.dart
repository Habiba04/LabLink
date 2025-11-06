import 'package:lablink/Models/LabLocation.dart';

class Lab {
  final String id;
  final String name;
  final String email;
  final String phone;
  final double labRating;
  final List<LabLocation> locations;

  Lab({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.labRating,
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
      labRating: (map['labRating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'locations': locations.map((location) => location.toMap()).toList(),
      'labRating': labRating,
    };
  }
}
