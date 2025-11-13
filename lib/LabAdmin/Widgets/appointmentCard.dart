import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/prescription_viewer.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentCard({required this.appointment, super.key});

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
          // Top Row: Name + Status
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
                      const Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: Colors.blueGrey,
                      ),
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

          // Test list
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

          _infoRow(Icons.calendar_today_outlined, appointment['date']),
          const SizedBox(height: 8),
          _infoRow(Icons.access_time, appointment['time']),
          const SizedBox(height: 8),
          _infoRow(Icons.location_on_outlined, appointment['branch']),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 10),

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
