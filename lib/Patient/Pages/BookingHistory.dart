import 'package:flutter/material.dart';
import 'package:lablink/Models/Appointment.dart';
import '../services/BookingService.dart';
import '../widgets/AppointmentCard.dart';

class BookingHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> mockLabData;
  final Map<String, dynamic> mockLocationData;
  final List<Map<String, dynamic>> mockSelectedTests;
  final String mockSelectedService;

  const BookingHistoryScreen({
    super.key,
    required this.mockLabData,
    required this.mockLocationData,
    required this.mockSelectedTests,
    required this.mockSelectedService,
  });

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late Future<List<Appointment>> _appointmentsFuture;
  late final BookingService _bookingService;
  
  final String _currentUserId = 'mock_user_id_12345'; 

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService(
      labData: widget.mockLabData,
      locationData: widget.mockLocationData,
      selectedTests: widget.mockSelectedTests,
      selectedService: widget.mockSelectedService,
    );
    _appointmentsFuture = _bookingService.fetchPatientAppointments(_currentUserId);
  }

  void _refreshAppointments() {
    setState(() {
      _appointmentsFuture = _bookingService.fetchPatientAppointments(_currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Text(
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
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 50),
                    const SizedBox(height: 16),
                    const Text(
                      'Error loading history.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Details: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
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
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("You have no booking history."));
          }

          final appointments = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return AppointmentCard(
                appointment: appointments[index],
                bookingService: _bookingService,
              );
            },
          );
        },
      ),
    );
  }
}
