import 'package:flutter/material.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../home/models/promo_model.dart';

 Widget buildPromoDetails(Promo promo, controller) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailSection(
                title: 'Nama Promo',
                content: promo.name,
                isPrimary: true,
              ),
              const Divider(height: 1, color: Color(0xFFE2E2E2)),
              _buildDetailSection(
                title: 'Syarat dan Ketentuan',
                content: controller.stripHtmlTags(promo.terms),
                isPrimary: false,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }



Widget _buildDetailSection({
  required String title,
  required String content,
  required bool isPrimary,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        content,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: isPrimary ? ColorStyle.primary : Colors.black,
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
