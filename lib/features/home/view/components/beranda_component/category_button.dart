import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/styles/color_style.dart';

Widget buildCategoryButtons(controller) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        const SizedBox(width: 12),
        buildCategoryButton(
          controller: controller,
          icon: Icons.menu,
          label: "Semua Menu".tr,
          category: "semua",
        ),
        const SizedBox(width: 8),
        buildCategoryButton(
          controller: controller,
          icon: Icons.fastfood,
          label: "Makanan".tr,
          category: "makanan",
        ),
        const SizedBox(width: 8),
        buildCategoryButton(
          controller: controller,
          icon: Icons.local_cafe,
          label: "Minuman".tr,
          category: "minuman",
        ),
        const SizedBox(width: 8),
        buildCategoryButton(
          controller: controller,
          icon: Icons.lunch_dining,
          label: "Snack".tr,
          category: "snack",
        ),
        const SizedBox(width: 12),
      ],
    ),
  );
}

Widget buildCategoryButton({
  required IconData icon,
  required String label,
  required String category,
  required controller
}) {
  return Obx(() {
    final isSelected =
        controller.selectedCategory.value == category.toLowerCase();
    return ElevatedButton.icon(
      onPressed: () => controller.changeCategory(category),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? ColorStyle.primary : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  });
}
