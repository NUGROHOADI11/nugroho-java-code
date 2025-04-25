import 'package:flutter/material.dart';

import '../../../../shared/styles/color_style.dart';

Widget buildDetailTile(
    IconData icon,
    String title,
    String value, {
    bool showArrow = false,
    bool isPrice = false,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: ColorStyle.primary, size: 20),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          onTap: onTap,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isPrice ? ColorStyle.primary : Colors.black,
                ),
              ),
              if (showArrow)
                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }