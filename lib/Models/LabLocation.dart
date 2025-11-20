import 'package:lablink/Models/LabTests.dart';

class LabLocation {
  String? id;
  String phone;
  final String name;
  final String address;
  final String startday;
  final String endday;
  final String openAt;
  final String closeAt;
  final String openinghours;
  final String closinghours;

  final List<LabTest> tests;

  LabLocation({
    required this.openinghours,
    required this.closinghours,
    required this.startday,
    required this.endday,
    required this.phone,
    this.id,
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
      'tests': tests.map((t) => t.toMap()).toList(),
      'phone': phone,
      'openinghours': openinghours,
      'closinghours': closinghours,
      'startday': startday,
      'endday': endday,
    };
  }

  factory LabLocation.fromMap(String id, Map<String, dynamic> map) {
    return LabLocation(
      id: id,
      phone: map['phone'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      openAt: map['openAt'] ?? '',
      closeAt: map['closeAt'] ?? '',
      openinghours: map['openinghours'] ?? '',
      closinghours: map['closinghours'] ?? '',
      startday: map['startday'] ?? '',
      endday: map['endday'] ?? '',
      tests: (map['tests'] as List? ?? [])
          .map((e) => LabTest.fromMap(e))
          .toList(),
    );
  }
}
