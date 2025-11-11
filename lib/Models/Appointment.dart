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
  final String? resultUrl;

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
    this.resultUrl,
  });

  factory Appointment.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final labData = data['labData'] as Map<String, dynamic>? ?? {}; 
    final locationData = data['locationData'] as Map<String, dynamic>? ?? {};

    final dateString = data['date'] as String? ?? DateTime.now().toIso8601String();
    
    return Appointment(
      docId: doc.id,
      bookingId: data['displayBookingId'] as String? ?? doc.id.substring(0, 8).toUpperCase(), 
      patientId: data['patientId'] as String? ?? '',
      date: DateTime.parse(dateString),
      labName: labData['name'] ?? 'Central Diagnostics',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'Scheduled',
      labId: labData['id'] as String? ?? '', 
      locationId: locationData['id'] as String? ?? '', 
      time: data['time'] as String? ?? '', 
    );
  }
}
