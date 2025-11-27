import 'package:flutter/material.dart';

class ProfileListtile extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  Color iconColor;
  String title;
  double height;
  double width;
  BorderRadius? borderRadiusWidget;

  ProfileListtile({
    super.key,
    required this.bgColor,
    required this.iconColor,
    required this.height,
    required this.width,
    required this.icon,
    required this.title,
    this.borderRadiusWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFF3F4F6), width: 1.26),
        borderRadius: borderRadiusWidget,
      ),
      // height: height,
      // width: width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              width: width,
              height: height,

              child: Icon(icon, color: iconColor),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
