import 'package:flutter/material.dart';
import 'package:lablink/Patient/providers/appointment_provider.dart';
import 'package:provider/provider.dart';
import '../services/BookingService.dart';
import '../widgets/AppointmentCard.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

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
      body: Consumer<AppointmentNotifier>(
        builder: (context, notifier, child) {
          final appointments = notifier.appointments;

          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifier.error != null) {
            // Check for the specific authentication error
            final isAuthError = notifier.error!.contains('user-not-signed-in');
            final errorMessage = isAuthError
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
                      onPressed: notifier.refreshAppointments,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (appointments.isEmpty) {
            return const Center(child: Text("You have no booking history."));
          }

          return RefreshIndicator(
            // Added Pull-to-Refresh
            onRefresh: notifier.refreshAppointments,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return AppointmentCard(
                  appointment: appointments[index],
                  bookingService: BookingService(labData: {}, locationData: {}, selectedService: '' ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
