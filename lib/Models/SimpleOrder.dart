class SimpleOrder {
  final String id;
  final String patientName;
  final DateTime? createdAt;
  final String status;
  final List<String> testsList;
  final String? prescriptionPath;

  SimpleOrder({
    required this.id,
    required this.patientName,
    required this.createdAt,
    required this.status,
    required this.testsList,
    this.prescriptionPath,
  });
}
