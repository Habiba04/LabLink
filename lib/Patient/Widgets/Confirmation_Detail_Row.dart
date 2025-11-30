import 'package:flutter/material.dart';
import 'package:lablink/Models/DetailVariant.dart';
import '../utils/Confirmation_Style_Utils.dart';

class ConfirmationDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final DetailVariant variant;

  const ConfirmationDetailRow({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final bgIconColor = getBgColorForVariant(variant);
    final iconColor = getIconColorForVariant(variant);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgIconColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Icon(icon, color: iconColor, size: 24)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(color: Colors.black87, fontSize: 17),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
