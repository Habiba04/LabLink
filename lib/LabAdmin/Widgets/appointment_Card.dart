import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/Prescription_Viewer.dart';

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
    final List tests = appointment['tests'] ?? [];
    final String prescriptions = appointment['prescription'] ?? '';
    final String date = appointment['date'] ?? 'N/A';
    final String time = appointment['time'] ?? 'N/A';
    final String branch = appointment['branch'] ?? 'N/A';
    final String collection = appointment['collectionType'] ?? 'N/A';

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
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        color: Colors.blueGrey,
                        size: 20,
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

          _buildTestSection(context, tests, prescriptions),

          const SizedBox(height: 16),

          _infoRow(Icons.calendar_today_outlined, date),
          const SizedBox(height: 8),
          _infoRow(Icons.access_time_outlined, time),
          const SizedBox(height: 8),
          _infoRow(Icons.location_on_outlined, branch),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 10),

          _buildCollectionType(collection),

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

          if (appointment['status'].toLowerCase() == 'completed')
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final link = appointment['results'];

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

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PrescriptionViewer(url: link, isPdf: true),
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
        Icon(icon, size: 20, color: Color(0xFF00BBA7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionType(String collectionType) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x2200BBA7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xAA00BBA7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                collectionType.toLowerCase().contains('home')
                    ? Icons.home_outlined
                    : Icons.directions_walk_outlined,
                size: 14,
                color: const Color(0xFF00BBA7),
              ),
              const SizedBox(width: 4),
              Text(
                collectionType,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF00BBA7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildTestSection(
    BuildContext context,
    List tests,
    String prescription,
  ) => Container(
    decoration: BoxDecoration(
      color: const Color(0x1100BBA7),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tests", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        ...tests.map((t) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Color(0xFF00BBA7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t['name'] ?? '',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        if (prescription.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.description, size: 18),
              label: const Text(
                "View Uploaded Prescription",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrescriptionViewer(url: prescription),
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
      case 'scheduled':
        return const Color(0xFF0A84FF);
      case 'awaiting results':
        return const Color(0xFFFF9500);
      case 'completed':
        return const Color(0xFF34C759);
      case 'cancelled':
        return const Color(0xFFFF3B30);
      case 'no show':
        return const Color(0xFF8E8E93);
      default:
        return Colors.blueGrey;
    }
  }
}
