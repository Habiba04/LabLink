import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Models/Appointment.dart';
import '../services/BookingService.dart';
import '../widgets/AppointmentCard.dart';

class BookingHistoryScreen extends StatefulWidget {
  // Removed all mock data parameters as they are irrelevant for history
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late Future<List<Appointment>> _appointmentsFuture;
  late final BookingService _bookingService;

  @override
  void initState() {
    super.initState();

    // Initialize BookingService with dummy or empty values
    // since it's only being used for fetchPatientAppointments() here.
    // In a production app, the service should be accessed via Provider/Riverpod.
    _bookingService = BookingService(
      labData: {},
      locationData: {},
      selectedTests: [],
      selectedService: '',
    );

    // Initial fetch - No user ID parameter needed!
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      // no user signed in — produce a failed Future so UI shows the error branch
      _appointmentsFuture = Future<List<Appointment>>.error(
        FirebaseAuthException(code: 'user-not-signed-in'),
      );
    } else {
      // pass uid because your real method expects it
      _appointmentsFuture = _bookingService.fetchPatientAppointments(uid);
    }
  }

  Future<void> _refreshAppointments() async {
    // Refresh function now returns a Future for use with RefreshIndicator
    setState(() {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        // no user signed in — produce a failed Future so UI shows the error branch
        _appointmentsFuture = Future<List<Appointment>>.error(
          FirebaseAuthException(code: 'user-not-signed-in'),
        );
      } else {
        // pass uid because your real method expects it
        _appointmentsFuture = _bookingService.fetchPatientAppointments(uid);
      }
    });
    // Wait for the new Future to complete before resolving the indicator
    await _appointmentsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Booking History",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Check for the specific authentication error
            final errorMessage =
                snapshot.error.toString().contains('user-not-signed-in')
                ? 'Please sign in to view your history.'
                : 'Error loading history.';

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _refreshAppointments,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final appointments = snapshot.data ?? []; // Use null-safe access

          if (appointments.isEmpty) {
            return const Center(child: Text("You have no booking history."));
          }

          return RefreshIndicator(
            // Added Pull-to-Refresh
            onRefresh: _refreshAppointments,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return AppointmentCard(
                  appointment: appointments[index],
                  bookingService: _bookingService,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
