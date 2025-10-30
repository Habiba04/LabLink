import 'package:lablink/Models/LabTests.dart';

class LabLocation {
  final String id;
  final String name;
  final String address;
  final String openAt;
  final String closeAt;
  final List<LabTest> tests;

  LabLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.openAt,
    required this.closeAt,
    this.tests = const [],
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'openAt': openAt,
      'closeAt': closeAt,
      'tests': tests.map((tests) => tests.toMap()).toList(),
    };
  }

  factory LabLocation.fromMap(
    String id,
    Map<String, dynamic> map, {
    List<LabTest> tests = const [],
  }) {
    return LabLocation(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      openAt: map['openAt'] ?? '',
      closeAt: map['closeAt'] ?? '',
      tests: tests,
    );
  }
}
