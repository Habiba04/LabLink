import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Models/Appointment.dart';
// Note: Assuming 'Appointment' model is defined and has fromFirestore()

class BookingService {
  final FirebaseAuth _auth;

  final Map<String, dynamic> labData;
  final Map<String, dynamic> locationData;
  final List<Map<String, dynamic>>? selectedTests;
  final String selectedService;
  final String? prescriptionPath;
  final double homeCollectionCharge = 50.0;

  BookingService({
    // Only required when creating a new booking, not when viewing history
    FirebaseAuth? auth,
    required this.labData,
    required this.locationData,
    this.selectedTests,
    required this.selectedService,
    this.prescriptionPath,
  }) : _auth = auth ?? FirebaseAuth.instance;
  // --- Utility Function ---
  String getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      // Throw a specific error if no user is signed in
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'A user must be signed in to perform this action.',
      );
    }
    return user.uid;
  }

  // --- Calculation Function ---
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

  // --- Data Fetching Functions ---

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

  // --- Booking Confirmation (Dual Write + Atomicity Recommended) ---

  Future<Map<String, dynamic>> confirmBooking({
    required DateTime date,
    required String time,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final userId = getCurrentUserId();
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch(); // Use a Batch for atomicity

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

    // 1. Primary Ref (Lab/Location)
    final appointmentsCollectionRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('appointments');

    // Create a new document reference with an auto-generated ID
    final ref = appointmentsCollectionRef.doc();
    final docId = ref.id;

    // Generate Display ID
    final displayBookingId = docId.substring(0, 8).toUpperCase();
    final finalAppointmentData = {
      ...appointmentData,
      'displayBookingId': displayBookingId,
    };

    // 2. Secondary Ref (Patient's table)
    final patientAppointmentRef = firestore
        .collection('patient')
        .doc(userId)
        .collection('appointments')
        .doc(docId); // Use the same document ID

    // 3. Disabled Slot Ref
    final disabledSlotRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots')
        .doc("${formattedDate}_$time");

    // Queue all writes in the batch
    batch.set(ref, finalAppointmentData); // A. Primary write
    batch.set(
      patientAppointmentRef,
      finalAppointmentData,
    ); // B. Secondary (Patient) write
    batch.set(disabledSlotRef, {
      // C. Disable slot
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

  // --- Appointment Cancellation (Batch Write) ---

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

    // 1. Primary Appointment Ref (Lab/appointments)
    final appointmentRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('appointments')
        .doc(appointmentDocId);

    // 2. Secondary Appointment Ref (Patient's table)
    final patientAppointmentRef = firestore
        .collection('patient')
        .doc(userId)
        .collection('appointments')
        .doc(appointmentDocId);

    // 3. Disabled Slot Ref
    final disabledSlotRef = firestore
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots')
        .doc("${formattedDate}_$time");

    // Queue the updates and delete
    batch.update(appointmentRef, {'status': 'Cancelled'});
    batch.update(patientAppointmentRef, {'status': 'Cancelled'});
    batch.delete(disabledSlotRef);

    // Commit the batch
    try {
      await batch.commit();
      print('✅ Appointment cancelled successfully via Batch Write.');
    } catch (e) {
      print('❌ Error during batch cancellation: $e');
      rethrow;
    }
  }
}
