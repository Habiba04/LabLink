import 'package:flutter/material.dart';
import '../Pages/prescription_viewer.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onViewDetails;
  final VoidCallback? onAccept; // kept for interface
  final VoidCallback? onReject; // kept for interface

  const OrderCard({
    required this.order,
    required this.onViewDetails,
    required this.onAccept,
    required this.onReject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String name = order['name'] ?? '';
    final String age = order['age'] != null ? "${order['age']} yrs" : '';
    final String date = order['date'] ?? '-';
    final String time = order['time'] ?? '-';
    final String service = order['collection'] ?? '-';
    final List tests = order['tests'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info
            Row(
              children: [
                _avatar(name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 2),
                      if (age.isNotEmpty)
                        Text(
                          age,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _infoRow(Icons.calendar_today_outlined, "$date at $time"),
            const SizedBox(height: 16),
            _infoRow(Icons.article_outlined, service),

            const SizedBox(height: 16),
            // Tests list
            if (tests.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(21, 0, 179, 219),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.article_outlined,
                          color: Color(0xFF00BBA7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tests.any((t) => t['prescription'] != null)
                              ? "Prescriptions"
                              : "Tests",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(tests.length, (index) {
                      final test = tests[index];
                      final testName = test['name'] ?? '';
                      final prescriptionUrl = test['prescription'];

                      return Padding(
                        padding: const EdgeInsets.only(left: 32, bottom: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                testName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            if (prescriptionUrl != null)
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  color: Color(0xFF00BBA7),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PrescriptionViewer(
                                        url: prescriptionUrl,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            Row(
              children: [
                // Accept Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept, // null disables button
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onAccept != null
                          ? Colors.teal
                          : Colors.teal.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Accept",
                      style: TextStyle(
                        color: onAccept != null ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Reject Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject, // null disables button
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  print("View Details clicked");
                  onViewDetails();
                },
                child: const Text(
                  "View Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String name) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        color: Color.fromARGB(105, 0, 187, 168),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person_2_outlined, color: Colors.white, size: 30),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.blueGrey.shade600),
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
}
