import 'package:flutter/material.dart';

Widget buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.grey[500],
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.grey[500],
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }