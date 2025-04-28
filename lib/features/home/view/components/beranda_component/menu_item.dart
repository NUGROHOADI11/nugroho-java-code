import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';

import '../../../../../configs/routes/route.dart';
import '../../../../../shared/styles/color_style.dart';
import '../../../../cart/models/cart_model.dart';
import '../../../../detail_menu/view/components/qty_button.dart';

Widget buildMenuItem({
  required int id,
  required String name,
  required int price,
  required String image,
  required bool stock,
  required int index,
  required cartController,
}) {
  final detailCartItem = cartController.getItem(id);

  return Obx(() {
    final quantity = cartController.getQuantity(id);
    return Opacity(
      opacity: stock ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: () => stock
            ? Get.toNamed(
                Routes.detailMenuRoute,
                arguments: {'menuId': id, 'quantity': quantity},
              )
            : null,
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: stock
                ? BorderSide.none
                : BorderSide(color: Colors.blue.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildProductImage(image),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: stock ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price.formatCurrency(),
                        style: TextStyle(
                          fontSize: 14,
                          color: stock ? ColorStyle.primary : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      (detailCartItem != null &&
                              detailCartItem.notes != null &&
                              detailCartItem.notes!.isNotEmpty)
                          ? Text(detailCartItem.notes!.toString())
                          : Text(
                              "Tambahkan Catatan".tr,
                              style: const TextStyle(
                                  fontSize: 12, color: ColorStyle.secondary),
                            ),
                    ],
                  ),
                ),
                _buildQuantityControls(
                    id, name, price, quantity, image, stock, cartController),
              ],
            ),
          ),
        ),
      ),
    );
  });
}

Widget _buildProductImage(String image) {
  return image.isNotEmpty
      ? Image.network(
          image,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        )
      : _buildPlaceholderImage();
}

Widget _buildPlaceholderImage() {
  return Container(
    width: 50,
    height: 50,
    color: Colors.grey[200],
    child: Icon(Icons.fastfood, color: Colors.grey[400]),
  );
}

Widget _buildQuantityControls(int id, String name, int price, int quantity,
    String image, bool stock, cartController) {
  if (!stock) return const SizedBox();

  return Row(
    children: [
      if (quantity > 0) ...[
        buildQtyButton(
          Icons.remove,
          () => _handleDecreaseQuantity(id, quantity, cartController),
        ),
        const SizedBox(width: 8),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
      ],
      buildQtyButton(
        Icons.add,
        () => _handleIncreaseQuantity(id, name, price, image, cartController),
      ),
    ],
  );
}

void _handleDecreaseQuantity(
    int productId, int currentQuantity, cartController) {
  final index = cartController.cartItems.indexWhere((i) => i.menuId == productId);
  if (index == -1) return;

  if (currentQuantity > 1) {
    final item = cartController.cartItems[index];
    final updatedItem = item.copyWith(
            jumlah: item.jumlah - 1,
          );
    cartController.updateItem(index, updatedItem);
  } else {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              'Konfirmasi'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus item ini dari keranjang?'.tr,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyle.primary,
            ),
            onPressed: () {
              cartController.removeItem(index);
              Get.back();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

void _handleIncreaseQuantity(
    int productId, String name, int price, String image, cartController) {
  final index = cartController.cartItems.indexWhere((i) => i.menuId == productId);

  if (index != -1) {
    final item = cartController.items[index];
    final updatedItem = item.copyWith(
            jumlah: item.jumlah + 1,
          );
    cartController.updateItem(index, updatedItem);
  } else {
    cartController.addItem(CartItemModel(
      menuId: productId,
      productName: name,
      harga: price,
      jumlah: 1,
      imageUrl: image,
    )
    );
  }
}
