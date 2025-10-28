import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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


  Future<DocumentReference> confirmBooking({
    required DateTime date,
    required String time,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    // 1. Mock User ID - REPLACE WITH ACTUAL AUTH LOGIC
    // final userId = FirebaseAuth.instance.currentUser!.uid;
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

    return ref;
  }
}