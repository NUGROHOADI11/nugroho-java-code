import 'package:flutter/material.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../home/models/promo_model.dart';

Widget buildPromoHeader(BuildContext context, Promo promo, controller) {
  return Container(
    width: 350,
    height: 200,
    decoration: BoxDecoration(
      color: ColorStyle.primary,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[200]!,
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          promo.type!.toLowerCase() == 'diskon'
              ? _buildDiscountTypeHeader(context, promo)
              : _buildRegularTypeHeader(context, promo),
          const SizedBox(height: 8),
          Text(
            controller.stripHtmlTags(promo.terms),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

Widget _buildDiscountTypeHeader(BuildContext context, Promo promo) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "${promo.type![0].toUpperCase()}${promo.type?.substring(1)}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
          letterSpacing: 1.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(width: 8),
      _buildPromoValueText(context, promo.displayValue),
    ],
  );
}

Widget _buildRegularTypeHeader(BuildContext context, Promo promo) {
  return Column(
    children: [
      Text(
        "${promo.type![0].toUpperCase()}${promo.type?.substring(1)}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
          letterSpacing: 1.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      _buildPromoValueText(context, promo.displayValue),
    ],
  );
}

Widget _buildPromoValueText(BuildContext context, String value) {
  return Stack(
    children: [
      Text(
        value,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.white,
            ),
      ),
      Text(
        value,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorStyle.primary,
            ),
      ),
    ],
  );
}
