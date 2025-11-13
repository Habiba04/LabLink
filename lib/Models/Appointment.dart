import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String docId;
  final String bookingId;
  final DateTime date;
  final String patientId;
  final String labName;
  final double totalAmount;
  final String status;
  final String labId;
  final String locationId;
  final String time;
  final String serviceType;
  final String? resultUrl;
  final String? prescription;
  final List<Map<String, dynamic>>? tests;
  Appointment({
    required this.docId,
    required this.bookingId,
    required this.date,
    required this.labName,
    required this.totalAmount,
    required this.status,
    required this.labId,
    required this.locationId,
    required this.time,
    required this.patientId,
    required this.serviceType,
    this.resultUrl,
    this.prescription,
    this.tests,
  });
  factory Appointment.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final labData = data['labData'] as Map<String, dynamic>? ?? {};
    final locationData = data['locationData'] as Map<String, dynamic>? ?? {};
    final dateString =
        data['date'] as String? ?? DateTime.now().toIso8601String();
    return Appointment(
      docId: doc.id,
      bookingId:
          data['displayBookingId'] as String? ??
          doc.id.substring(0, 8).toUpperCase(),
      patientId: data['patientId'] as String? ?? '',
      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      labName: labData['name'] ?? 'Central Diagnostics',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'Scheduled',
      labId: labData['id'] as String? ?? '',
      locationId: locationData['id'] as String? ?? '',
      serviceType: data['serviceType'] ?? '',
      time: data['time'] as String? ?? '',
      prescription: data['prescription'] ?? '',
      tests:
          (data['tests'] as List<dynamic>?)
              ?.map((test) => Map<String, dynamic>.from(test))
              .toList() ??
          [],
    );
  }
}

/*
class Appointment {
  final String id;
  final String branchId;
  final String patientId;
  final DateTime date;
  final String time;
  final String serviceType;
  final String status;
  final double totalAmount;
  final String paymentMethod;
  final String? prescription;
  final List<Map<String, dynamic>>? tests;

  Appointment({
    required this.id,
    required this.branchId,
    required this.patientId,
    required this.date,
    required this.time,
    required this.serviceType,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    this.tests,
    this.prescription,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Appointment(
      id: doc.id,
      branchId: data['branchId'] ?? '',
      patientId: data['patientId'] ?? '',
      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      time: data['time'] ?? '',
      serviceType: data['serviceType'] ?? '',
      status: data['status'] ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: data['paymentMethod'] ?? '',
      prescription: data['prescription'] ?? '',
      tests:
          (data['tests'] as List<dynamic>?)
              ?.map((test) => Map<String, dynamic>.from(test))
              .toList() ??
          [],
    );
  }
}
*/
