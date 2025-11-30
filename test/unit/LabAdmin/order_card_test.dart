
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';






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

void main() {
  group('Order Status Color Mapping Unit Tests', () {
    test('Pending/New status maps to correct colors', () {
      expect(_statusBg('pending'), const Color(0xFFFFE8D6));
      expect(_statusTextColor('New'), const Color(0xFFFF7B00));
    });

    test('Completed status maps to correct colors', () {
      expect(_statusBg('Completed'), const Color(0xFFD4F9E6));
      expect(_statusTextColor('completed'), const Color(0xFF00BBA7));
    });

    test('Upcoming/Scheduled status maps to correct colors', () {
      expect(_statusBg('upcoming'), const Color(0xFFDBF0FF));
      expect(_statusTextColor('Scheduled'), const Color(0xFF0A84FF));
    });

    test('Cancelled status maps to correct colors', () {
      expect(_statusBg('Cancelled'), const Color(0xFFFFEAEA));
      expect(_statusTextColor('cancelled'), const Color(0xFFE53935));
    });

    test('Unknown status maps to default colors', () {
      expect(_statusBg('Awaiting Results'), const Color(0xFFEAEAEA));
      expect(_statusTextColor('Unknown'), Colors.black87);
    });
  });
}