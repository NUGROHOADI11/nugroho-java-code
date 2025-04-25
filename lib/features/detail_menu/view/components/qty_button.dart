import 'package:flutter/material.dart';

import '../../../../shared/styles/color_style.dart';

Widget buildQtyButton(IconData icon, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      color: icon == Icons.remove ? Colors.transparent : ColorStyle.primary,
      border: icon == Icons.remove
          ? Border.all(color: ColorStyle.primary, width: 1)
          : null,
      borderRadius: BorderRadius.circular(4),
    ),
    width: 28,
    height: 28,
    child: IconButton(
      icon: Icon(
        icon,
        size: 14,
        color: icon == Icons.remove ? ColorStyle.primary : Colors.white,
      ),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
    ),
  );
}
