import 'package:flutter/material.dart';

class BookingTimeCard extends StatelessWidget {
  final List<String> availableTimes;
  final Set<String> disabledTimes;
  final String? selectedTime;
  final void Function(String time) onTimeSelected;
  final Widget Function(IconData icon, String title) sectionTitleBuilder;
  final BoxDecoration Function() boxDecorationBuilder;

  const BookingTimeCard({
    super.key,
    required this.availableTimes,
    required this.disabledTimes,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.sectionTitleBuilder,
    required this.boxDecorationBuilder,
  });

  Widget _buildTimeButton(String time) {
    final isSelected = time == selectedTime;
    final isDisabled = disabledTimes.contains(time);

    return GestureDetector(
      onTap: isDisabled ? null : () => onTimeSelected(time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade200
              : isSelected
              ? const Color(0xFF00BBA7)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.shade400
                : isSelected
                ? Colors.transparent
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isDisabled
                ? Colors.grey.shade500
                : isSelected
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w500,
            decoration: isDisabled ? TextDecoration.lineThrough : null,
            decorationColor: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationBuilder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitleBuilder(Icons.access_time, "Select Time"),
          const SizedBox(height: 12),
          if (availableTimes.isEmpty)
            const Text(
              "No available times",
              style: TextStyle(color: Colors.grey),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: availableTimes.map((t) => _buildTimeButton(t)).toList(),
            ),
        ],
      ),
    );
  }
}
