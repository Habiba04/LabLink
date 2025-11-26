import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Utils/date_utils.dart';
import 'package:lablink/Models/SimpleOrder.dart';

class OrderCard extends StatelessWidget {
  final SimpleOrder order;
  const OrderCard({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final displayStatus = order.status.toLowerCase() == 'pending'
        ? 'New'
        : order.status;
    final bg = _statusBg(displayStatus);
    final txt = _statusTextColor(displayStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.patientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    displayStatus,
                    style: TextStyle(
                      color: txt,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.prescriptionPath != null)
                  Text(
                    "Prescription Attached",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.testsList
                  .map(
                    (test) => Text(
                      test,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  timeAgo(order.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusBg(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
    case 'new':
      return const Color(0xFFFFE8D6);
    case 'completed':
      return const Color(0xFFD4F9E6);
    case 'scheduled':
    case 'upcoming':
      return const Color(0xFFDBF0FF);
    case 'cancelled':
      return const Color(0xFFFFEAEA);
    default:
      return const Color(0xFFEAEAEA);
  }
}

Color _statusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
    case 'new':
      return const Color(0xFFFF7B00);
    case 'completed':
      return const Color(0xFF00BBA7);
    case 'scheduled':
    case 'upcoming':
      return const Color(0xFF0A84FF);
    case 'cancelled':
      return const Color(0xFFE53935);
    default:
      return Colors.black87;
  }
}
