import 'package:flutter/material.dart';
import '../utils/BookingHelpers.dart';

class BookingTestsCard extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedTests;
  final String selectedService;

  const BookingTestsCard({
    super.key,
    required this.selectedTests,
    required this.selectedService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(Icons.medical_services, "Selected Tests"),
          const SizedBox(height: 12),
          if (selectedTests == null || selectedTests!.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Prescription Uploaded",
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  "Tests prices will be determined by the lab.",
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            )
          else
            ...selectedTests!.map(
              (test) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      test['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "EGP ${test['price'] ?? 0}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          if (selectedService == "Home Collection")
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Home Collection Charge",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Text("EGP 50", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
