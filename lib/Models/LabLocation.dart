import 'package:lablink/Models/LabTests.dart';

class LabLocation {
  String id;
  final String name;
  final String address;
  final String openAt;
  final String closeAt;
  final List<LabTest> tests;
  final String phone;
  final List<String> workingDays;

  LabLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.openAt,
    required this.closeAt,
    this.tests = const [],
    this.phone = '',
    this.workingDays = const [],
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'openAt': openAt,
      'closeAt': closeAt,
      'tests': tests.map((tests) => tests.toMap()).toList(),
      'phone': phone,
      'workingDays': workingDays,
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
      phone: map['phone'] ?? '',
      workingDays: List<String>.from(map['workingDays'] ?? []),
    );
  }
}
