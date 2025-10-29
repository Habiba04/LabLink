import 'package:flutter/material.dart';
import '../utils/BookingHelpers.dart';

class NonWorkingDayMessage extends StatelessWidget {
  const NonWorkingDayMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: getBoxDecoration(),
      child: const Text(
        "The lab is closed on this day. Please select a working day.",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      ),
    );
  }
}