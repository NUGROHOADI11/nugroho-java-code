import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_item.dart';
import 'section_title.dart';

Widget buildAllCategoriesView(controller, cartController) {
  return Obx(() {
    final categories = controller.getAvailableCategories();

    if (categories.isEmpty) {
      return Center(child: Text('Tidak ada menu tersedia'.tr));
    }

    return Column(
      children: categories.map<Widget>((category) {
        final items = controller.getItemsByCategory(category, limit: 3);
        if (items.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSectionTitle(
              category == 'makanan'
                  ? 'Makanan'.tr
                  : category == 'minuman'
                      ? 'Minuman'.tr
                      : category == 'snack'
                          ? 'Snack'.tr
                          : 'Lainnya'.tr,
              category == 'makanan'
                  ? Icons.fastfood
                  : category == 'minuman'
                      ? Icons.local_cafe
                      : Icons.lunch_dining,
            ),
            Column(
              children: items
                  .map<Widget>((item) => buildMenuItem(
                      id: item.id,
                      name: item.name,
                      price: item.price,
                      image: item.image,
                      stock: item.stock,
                      index: controller.filteredItems.indexOf(item),
                      cartController: cartController,))
                  .toList(),
            ),
          ],
        );
      }).toList(),
    );
  });
}

Widget buildSingleCategoryView(controller, cartController) {
  return Obx(() {
    if (controller.filteredItems.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada ${controller.selectedCategory.value} tersedia',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Column(
      children: controller.filteredItems
          .map<Widget>((item) => buildMenuItem(
              id: item.id,
              name: item.name,
              price: item.price,
              image: item.image,
              stock: item.stock,
              index: controller.filteredItems.indexOf(item),
              cartController: cartController))
          .toList(),
    );
  });
}
