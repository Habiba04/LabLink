import 'dart:ui';

class Order {
  final String name;
  final String test;
  final String time;
  final String status;
  final Color statusColor;
  final Color textColor;

  Order({
    required this.name,
    required this.test,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.textColor,
  });
}
