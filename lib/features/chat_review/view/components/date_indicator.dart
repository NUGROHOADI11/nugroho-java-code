  import 'package:flutter/material.dart';

Widget buildDateIndicator(review, controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${review.createdAt.day} ${controller.getMonthName(review.createdAt.month)} ${review.createdAt.year}',
        style: TextStyle(fontSize: 12, color: Colors.teal[700]),
      ),
    );
  }