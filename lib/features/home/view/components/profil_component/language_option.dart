import 'package:flutter/material.dart';

import '../../../../../shared/styles/color_style.dart';

Widget languageOption(String label, String emoji, {bool isSelected = false}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: isSelected ? Colors.teal : Colors.grey),
      borderRadius: BorderRadius.circular(12),
      color: isSelected ? ColorStyle.primary : Colors.transparent,
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(label,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
        if (isSelected) const Icon(Icons.check, color: Colors.white),
      ],
    ),
  );
}
