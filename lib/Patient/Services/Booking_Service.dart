import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Models/Appointment.dart';

class BookingService {
  final FirebaseAuth _auth;

  final Map<String, dynamic> labData;
  final Map<String, dynamic> locationData;
  final List<Map<String, dynamic>>? selectedTests;
  final String selectedService;
  final String? prescriptionPath;
  final double homeCollectionCharge = 50.0;

  BookingService({
    FirebaseAuth? auth,
    required this.labData,
    required this.locationData,
    this.selectedTests,
    required this.selectedService,
    this.prescriptionPath,
  }) : _auth = auth ?? FirebaseAuth.instance;

  String getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'A user must be signed in to perform this action.',
      );
    }
    return user.uid;
  }

  double calculateTotal() {
    double total = selectedTests!.fold<double>(
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
        .collection('lab')
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
        .collection('lab')
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

  Future<Map<String, dynamic>> confirmBooking({
    required DateTime date,
    required String time,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final userId = getCurrentUserId();
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final labId = labData['id'];
    final locationId = locationData['id'];

    final appointmentData = {
      'patientId': userId,
      'date': formattedDate,
      'time': time,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'serviceType': selectedService,
      'tests': selectedTests,
      'prescription': prescriptionPath,
      'labData': labData,
      'locationData': locationData,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    final appointmentsCollectionRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('appointments');

    final ref = appointmentsCollectionRef.doc();
    final docId = ref.id;

    final displayBookingId = docId.substring(0, 8).toUpperCase();
    final finalAppointmentData = {
      ...appointmentData,
      'displayBookingId': displayBookingId,
    };

    final patientAppointmentRef = firestore
        .collection('patient')
        .doc(userId)
        .collection('appointments')
        .doc(docId);

    final disabledSlotRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots')
        .doc("${formattedDate}_$time");

    batch.set(ref, finalAppointmentData);
    batch.set(patientAppointmentRef, finalAppointmentData);
    batch.set(disabledSlotRef, {
      'date': formattedDate,
      'time': time,
      'bookedByAppointmentId': ref.id,
      'bookedAt': FieldValue.serverTimestamp(),
    });

    try {
      await batch.commit();
      print('✅ Booking confirmed successfully via Batch Write.');
      return {'refId': docId, 'displayBookingId': displayBookingId};
    } catch (e) {
      print('❌ Error confirming booking: $e');
      rethrow;
    }
  }

  Future<void> cancelAppointment({
    required String labId,
    required String locationId,
    required String appointmentDocId,
    required DateTime date,
    required String time,
  }) async {
    final userId = getCurrentUserId();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final appointmentRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('appointments')
        .doc(appointmentDocId);

    final patientAppointmentRef = firestore
        .collection('patient')
        .doc(userId)
        .collection('appointments')
        .doc(appointmentDocId);

    final disabledSlotRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots')
        .doc("${formattedDate}_$time");

    batch.update(appointmentRef, {'status': 'Cancelled'});
    batch.update(patientAppointmentRef, {'status': 'Cancelled'});
    batch.delete(disabledSlotRef);

    try {
      await batch.commit();
      print('✅ Appointment cancelled successfully via Batch Write.');
    } catch (e) {
      print('❌ Error during batch cancellation: $e');
      rethrow;
    }
  }
}
