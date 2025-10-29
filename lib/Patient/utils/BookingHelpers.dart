import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


BoxDecoration getBoxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

Widget buildSectionTitle(IconData icon, String title) {
  return Row(
    children: [
      Icon(icon, color: const Color(0xFF00B4DB)),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    ],
  );
}

List<String> generateAvailableTimes(
    String openAt, String closeAt, DateTime selectedDate) {
  final openHour = int.parse(openAt.split(':')[0]);
  final closeHour = int.parse(closeAt.split(':')[0]);

  DateTime startTime = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day, openHour);
  DateTime endTime = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day, closeHour);

  final List<String> times = [];
  final timeFormat = DateFormat('h:mm a');

  while (startTime.isBefore(endTime)) {
    final timeSlot = timeFormat.format(startTime);
    times.add(timeSlot);
    startTime = startTime.add(const Duration(minutes: 30));
  }

  return times;
}

bool checkIsWorkingDay(DateTime date, List<String> workingDays) {
  final dayName = DateFormat('E').format(date).substring(0, 3).toLowerCase();
  return workingDays.contains(dayName);
}