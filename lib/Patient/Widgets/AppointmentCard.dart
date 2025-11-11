import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lablink/LabAdmin/Pages/PrescriptionViewer.dart';
import 'package:lablink/Models/Appointment.dart';
import 'package:lablink/Patient/services/BookingService.dart';

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;
  final BookingService bookingService;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.bookingService,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.appointment.status;
  }

  Color statusColor() {
    switch (currentStatus.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFF3A82F7);
      case 'completed':
        return const Color(0xFF00BBA7);
      case 'awaiting results':
        return const Color(0xFFFFA726);
      case 'pending':
        return const Color(0xFF9C27B0);
      case 'cancelled':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon() {
    switch (currentStatus.toLowerCase()) {
      case 'scheduled':
        return Icons.schedule_rounded;
      case 'completed':
        return Icons.check_circle_outline;
      case 'awaiting results':
        return Icons.hourglass_empty_rounded;
      case 'pending':
        return Icons.pending_actions_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Future<void> cancelBooking() async {
    try {
      await widget.bookingService.cancelAppointment(
        labId: widget.appointment.labId,
        locationId: widget.appointment.locationId,
        appointmentDocId: widget.appointment.docId,
        date: widget.appointment.date,
        time: widget.appointment.time,
      );

      if (mounted) {
        setState(() {
          currentStatus = 'Cancelled';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to cancel booking: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.appointment.bookingId,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon(), size: 16, color: statusColor()),
                      const SizedBox(width: 4),
                      Text(
                        currentStatus,
                        style: TextStyle(
                          color: statusColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            _buildInfoRow(
              Icons.calendar_today_rounded,
              DateFormat('MMM d, yyyy').format(widget.appointment.date),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.apartment_rounded, widget.appointment.labName),
            const SizedBox(height: 10),

            const Divider(height: 28, thickness: 0.8, color: Color(0xFFEAEAEA)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  'EGP ${widget.appointment.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (currentStatus.toLowerCase() == 'completed')
              OutlinedButton.icon(
                onPressed: () {
                  if (widget.appointment.resultUrl != null &&
                      widget.appointment.resultUrl!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrescriptionViewer(
                          url: widget.appointment.resultUrl!,
                          title: 'Appointment Result',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No result available.')),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00BBA7),
                  side: const BorderSide(color: Color(0xFF00BBA7), width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  minimumSize: const Size.fromHeight(42),
                ),
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text(
                  'View Result',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              )
            else if (currentStatus.toLowerCase() == 'scheduled')
              OutlinedButton.icon(
                onPressed: cancelBooking,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53935),
                  side: const BorderSide(color: Color(0xFFE53935), width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  minimumSize: const Size.fromHeight(42),
                ),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text(
                  'Cancel Booking',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 19, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
