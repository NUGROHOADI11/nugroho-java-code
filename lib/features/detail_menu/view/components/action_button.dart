import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../../cart/models/cart_model.dart';
import '../../controllers/detail_menu_controller.dart';
import '../../models/detail_menu_model.dart';

Widget buildActionButton(
    DetailMenuController controller,
    CartController cartController,
    int menuId,
    int qtyArg,
    dynamic menu,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final qty = controller.quantity.value;

          if (qty == 0) {
            Get.snackbar(
              'Peringatan',
              'Silahkan pilih jumlah pesanan',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final selectedLevelDetail = controller.menuDetail.value!.level
              .firstWhere((level) => level.id == controller.selectedLevel.value,
                  orElse: () => DetailItem(id: 0, keterangan: '', harga: 0));

          final selectedToppingDetails =
              controller.selectedTopping.map((toppingId) {
            return controller.menuDetail.value!.topping.firstWhere(
                (topping) => topping.id == toppingId,
                orElse: () => DetailItem(id: 0, keterangan: '', harga: 0));
          }).toList();

          final totalToppingPrice = selectedToppingDetails
              .map((topping) => topping.harga)
              .fold(0, (previousValue, element) => previousValue + element);

          final totalPrice =
              menu.menu.harga + selectedLevelDetail.harga + totalToppingPrice;

          if (qtyArg > 0) {
            final existingIndex =
                cartController.cartItems.indexWhere((e) => e.menuId == menuId);
            if (existingIndex != -1) {
              final updatedItem =
                  cartController.cartItems[existingIndex].copyWith(
                jumlah: qty,
                level: controller.selectedLevel.value,
                topping: controller.selectedTopping,
                notes: controller.note.value,
                hargaLevel: selectedLevelDetail.harga,
                hargaTopping: totalToppingPrice,
              );
              cartController.updateItem(existingIndex, updatedItem);
            }
            Get.back();
            Get.snackbar("Sukses".tr, "Pesanan diperbarui".tr,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3));
          } else {
            cartController.addItem(CartItemModel(
              menuId: menuId,
              productName: menu.menu.nama,
              harga: totalPrice,
              jumlah: qty,
              imageUrl: menu.menu.foto,
              level: controller.selectedLevel.value,
              hargaLevel: selectedLevelDetail.harga,
              topping: controller.selectedTopping,
              hargaTopping: totalToppingPrice,
              notes: controller.note.value,
            ));
            Get.back();
            Get.snackbar("Sukses".tr, "Pesanan ditambahkan".tr,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorStyle.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          qtyArg > 0 ? 'Update Pesanan'.tr : 'Tambahkan Ke Pesanan'.tr,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }