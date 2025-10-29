import 'package:flutter/material.dart';
import '../utils/BookingHelpers.dart';

class BookingPaymentCard extends StatelessWidget {
  const BookingPaymentCard({super.key});

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00BBA7), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00BBA7)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF00BBA7)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(Icons.payment, "Payment Method"),
          const SizedBox(height: 12),
          _buildPaymentOption(
            title: "Pay at Lab/Home",
            subtitle: "Pay upon arrival or collection",
            icon: Icons.home_work,
          ),
        ],
      ),
    );
  }
}