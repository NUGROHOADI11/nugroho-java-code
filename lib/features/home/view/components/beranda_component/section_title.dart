import 'package:flutter/material.dart';

import '../../../../../shared/styles/color_style.dart';

Widget buildSectionTitle(String title, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: ColorStyle.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorStyle.primary,
          ),
        ),
      ],
    ),
  );
}
