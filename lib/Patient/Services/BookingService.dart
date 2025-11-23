import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Models/Appointment.dart';

class BookingService {
  final Map<String, dynamic> labData;
  final Map<String, dynamic> locationData;
  final List<Map<String, dynamic>> selectedTests;
  final String selectedService;
  final double homeCollectionCharge = 50;

  BookingService({
    required this.labData,
    required this.locationData,
    required this.selectedTests,
    required this.selectedService,
  });

  double calculateTotal() {
    double total = selectedTests.fold<double>(
      0.0,
      (sum, test) => sum + (test['price'] ?? 0),
    );
    if (selectedService == "Home Collection") {
      total += homeCollectionCharge;
    }
    return total;
  }

  Future<Map<String, dynamic>> fetchLocationDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('labs')
        .doc(labData['id'])
        .collection('locations')
        .doc(locationData['id'])
        .get();

    return doc.data() ?? {};
  }

  Future<Set<String>> fetchDisabledSlots(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final locationId = locationData['id'];

    final snapshot = await FirebaseFirestore.instance
        .collection('labs')
        .doc(labData['id'])
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots')
        .where('date', isEqualTo: formattedDate)
        .get();

    return snapshot.docs
        .map((doc) => doc.data()['time'] as String?)
        .where((time) => time != null)
        .cast<String>()
        .toSet();
  }

  Future<List<Appointment>> fetchPatientAppointments(String userId) async {
    if (userId.isEmpty || userId == 'mock_user_id_12345') {
      return _getMockAppointments(
        labData['id'] as String? ?? 'lab1',
        locationData['id'] as String? ?? 'location1',
      );
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collectionGroup('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Appointment.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  List<Appointment> _getMockAppointments(
    String mockLabId,
    String mockLocationId,
  ) {
    return [
      Appointment(
        docId: 'APPT_001',
        bookingId: '#LB2025001',
        date: DateTime(2025, 10, 15),
        labName: 'Central Diagnostics',
        totalAmount: 450.00,
        status: 'Completed',
        labId: mockLabId,
        locationId: mockLocationId,
        time: '8:00 AM',
      ),
      Appointment(
        docId: 'APPT_002',
        bookingId: '#LB2025002',
        date: DateTime(2025, 10, 28),
        labName: 'Central Diagnostics (Upcoming)',
        totalAmount: 650.00,
        status: 'Scheduled',
        labId: mockLabId,
        locationId: mockLocationId,
        time: '08:30 AM',
      ),
      Appointment(
        docId: 'APPT_003',
        bookingId: '#LB2025003',
        date: DateTime(2025, 9, 28),
        labName: 'MediLab Pro',
        totalAmount: 200.00,
        status: 'Pending',
        labId: mockLabId,
        locationId: mockLocationId,
        time: '1:00 PM',
      ),
    ];
  }

  Future<void> cancelAppointment({
    required String labId,
    required String locationId,
    required String appointmentDocId,
    required DateTime date,
    required String time,
  }) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final appointmentRef = FirebaseFirestore.instance
        .collection('labs')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('appointments')
        .doc(appointmentDocId);

    final disabledSlotDocId = "${formattedDate}_$time";
    final disabledSlotRef = FirebaseFirestore.instance
        .collection('labs')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots')
        .doc(disabledSlotDocId);

    await appointmentRef.update({'status': 'Cancelled'});
    await disabledSlotRef.delete();
  }

  Future<Map<String, dynamic>> confirmBooking({
    required DateTime date,
    required String time,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    const userId = "mock_user_id_12345";

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final labId = labData['id'];
    final locationId = locationData['id'];

    final appointment = {
      'userId': userId,
      'date': formattedDate,
      'time': time,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'serviceType': selectedService,
      'tests': selectedTests,
      'labData': labData,
      'locationData': locationData,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    final appointmentsRef = FirebaseFirestore.instance
        .collection('labs')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('appointments');

    final ref = await appointmentsRef.add(appointment);
    final docId = ref.id;

    DateFormat('yyyyMM').format(date);
    final displayBookingId = '${docId.substring(0, 8).toUpperCase()}';

    await ref.update({'displayBookingId': displayBookingId});

    final disabledSlotRef = FirebaseFirestore.instance
        .collection('labs')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots');

    await disabledSlotRef.doc("${formattedDate}_$time").set({
      'date': formattedDate,
      'time': time,
      'bookedByAppointmentId': ref.id,
      'bookedAt': FieldValue.serverTimestamp(),
    });

    return {'refId': docId, 'displayBookingId': displayBookingId};
  }
}
