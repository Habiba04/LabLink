import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Patient/Pages/Confirmation.dart';
import '../services/BookingService.dart';

class ConfirmButton extends StatelessWidget {
  final BookingService bookingService;
  final double totalAmount;
  final bool isTimeDisabled;
  final String? selectedTime;
  final DateTime selectedDate;
  final Map<String, dynamic> locationData;
  final Map<String, dynamic> labData;
  final String selectedPaymentMethod;

  const ConfirmButton({
    super.key,
    required this.bookingService,
    required this.totalAmount,
    required this.isTimeDisabled,
    required this.selectedTime,
    required this.selectedDate,
    required this.locationData,
    required this.labData,
    required this.selectedPaymentMethod,
  });

  Future<void> _confirmBooking(BuildContext context) async {
    if (selectedTime == null) return;

    final bookingInfo = await bookingService.confirmBooking(
      date: selectedDate,
      time: selectedTime!,
      totalAmount: totalAmount,
      paymentMethod: selectedPaymentMethod,
    );

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          bookingId: bookingInfo['displayBookingId'] as String,
          date: DateFormat('yyyy-MM-dd').format(selectedDate),
          time: selectedTime!,
          locationData: locationData,
          labData: labData,
          total: totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = selectedTime == null || isTimeDisabled;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : () => _confirmBooking(context),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isDisabled
                ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                : const LinearGradient(
                    colors: [Color(0xFF00B4DB), Color(0xFF00BBA7)],
                  ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              "Confirm Booking",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

extension on DocumentReference<Object?> {
  void operator [](String other) {}
}
