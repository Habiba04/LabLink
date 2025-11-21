import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/ResultsViewerScreen.dart'; // REQUIRED for viewing results
import 'package:lablink/LabAdmin/Pages/prescription_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final Function(Map<String, dynamic> order, String status) onStatusChange;
  final bool isActionableToday;

  const AppointmentCard({
    required this.appointment,
    required this.onStatusChange,
    required this.isActionableToday,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top Row: Name + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Colors.blueGrey,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        appointment['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        appointment['phone'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    appointment['status'],
                  ).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  appointment['status'],
                  style: TextStyle(
                    color: _getStatusColor(appointment['status']),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 Test list
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(21, 0, 179, 219),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.article_outlined, color: Color(0xFF00BBA7)),
                      SizedBox(width: 8),
                      Text(
                        "Tests",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...List.generate((appointment['tests'] as List).length, (
                    index,
                  ) {
                    final test =
                        appointment['tests'][index] as Map<String, dynamic>;
                    final hasPrescription = test['prescription'] != null;

                    return Padding(
                      padding: const EdgeInsets.only(left: 32, bottom: 4),
                      child: GestureDetector(
                        onTap: hasPrescription
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PrescriptionViewer(
                                      url: test['prescription'],
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                test['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: hasPrescription
                                      ? Colors.blue
                                      : Colors.black54,
                                  decoration: hasPrescription
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                            ),
                            if (hasPrescription)
                              const Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Appointment Info
          _infoRow(Icons.calendar_today_outlined, appointment['date']),
          const SizedBox(height: 8),
          _infoRow(Icons.access_time, appointment['time']),
          const SizedBox(height: 8),
          _infoRow(Icons.location_on_outlined, appointment['branch']),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 10),

          // 🔹 Collection Type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              appointment['collectionType'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),

          // 🔹 Action buttons for appointments scheduled today
          if (isActionableToday)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        onStatusChange(appointment, 'Awaiting Results'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Appointment Completed',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => onStatusChange(appointment, 'No Show'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Mark No Show',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

          // 🔹 View Results button (only for completed appointments)
          if (appointment['status'].toLowerCase() == 'completed')
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final link = appointment['results'];

                    // 1. Initial Link/Empty Check
                    if (link == null || link.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Results link not available yet.'),
                          ),
                        );
                      });
                      return;
                    }

                    // 2. Navigate to the in-app PDF Viewer Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultsViewerScreen(pdfUrl: link),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BBA7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  label: const Text(
                    'View Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF00BBA7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming': // lab view
      case 'scheduled': // patient view
        return const Color(0xFF0A84FF); // blue
      case 'awaiting results':
        return const Color(0xFFFF9500); // orange
      case 'completed':
        return const Color(0xFF34C759); // green
      case 'cancelled':
        return const Color(0xFFFF3B30); // red
      case 'no show':
        return const Color(0xFF8E8E93); // gray
      default:
        return Colors.blueGrey;
    }
  }
}
