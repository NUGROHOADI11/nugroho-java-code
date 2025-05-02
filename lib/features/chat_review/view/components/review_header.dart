import 'package:flutter/material.dart';

import '../../../../shared/styles/color_style.dart';

Widget buildReviewHeader(review) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              Icons.star,
              size: 20,
              color: i < review.rating ? Colors.amber : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Tooltip(
            message: review.category,
            child: Text(
              review.category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorStyle.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
