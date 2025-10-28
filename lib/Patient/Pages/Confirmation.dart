import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Models/DetailVariant.dart';
import 'package:lottie/lottie.dart';
import '../widgets/ConfirmationDetailRow.dart';

class ConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final String date;
  final String time;
  final Map<String, dynamic> locationData;
  final Map<String, dynamic> labData;
  final double total;

  const ConfirmationScreen({
    super.key,
    required this.bookingId,
    required this.date,
    required this.time,
    required this.locationData,
    required this.labData,
    required this.total,
  });

  String get _formattedLocation {
    final labName = labData['name'] ?? 'Unknown Lab';
    final branchName = locationData['name'] ?? 'Unknown Branch';
    final address = locationData['address'] ?? 'No Address Provided';
    return "$labName - $branchName\n$address";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Lottie.asset(
                  "assets/images/Success.json",
                  width: 120,
                  height: 120,
                  repeat: false,
                ),
                const SizedBox(height: 25),
                const Text(
                  "Booking Confirmed!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your appointment has been scheduled successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      ConfirmationDetailRow(
                        title: "Date",
                        value: DateFormat('MMMM d, yyyy').format(DateTime.parse(date)),
                        icon: Icons.calendar_today_rounded,
                        variant: DetailVariant.date,
                      ),
                      const SizedBox(height: 16),
                      ConfirmationDetailRow(
                        title: "Time",
                        value: time,
                        icon: Icons.access_time_rounded,
                        variant: DetailVariant.time,
                      ),
                      const SizedBox(height: 16),
                      ConfirmationDetailRow(
                        title: "Location",
                        value: _formattedLocation,
                        icon: Icons.location_on_rounded,
                        variant: DetailVariant.location,
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        height: 30,
                        thickness: 1.2,
                        color: Color(0xFFF5F5F5),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Booking ID",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "#${bookingId.substring(0, 8).toUpperCase()}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "EGP ${NumberFormat('#,###.00').format(total)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Add reminder logic
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF00BBA7),
                        width: 1.5,
                      ),
                    ),
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF00BBA7),
                    ),
                    label: const Text(
                      "Add Reminder",
                      style: TextStyle(
                        color: Color(0xFF00BBA7),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (r) => r.isFirst),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF00BBA7)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}