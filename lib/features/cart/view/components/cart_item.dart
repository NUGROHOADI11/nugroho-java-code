import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';

import '../../../../configs/routes/route.dart';
import '../../../../constants/cores/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';

Widget buildCartItemsList() {
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.all(14.r),
      itemCount: CartController.to.items.length,
      itemBuilder: (context, index) {
        final item = CartController.to.items[index];
        return _buildCartItem(item, index);
      },
    ),
  );
}

Widget _buildCartItem(CartItemModel item, int index) {
  return InkWell(
    onTap: () {
      Get.toNamed(
        Routes.detailMenuRoute,
        arguments: {'menuId': item.menuId, 'quantity': item.jumlah},
      );
    },
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Row(
          children: [
            _buildItemImage(item),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItemName(item),
                  SizedBox(height: 4.h),
                  _buildItemPrice(item),
                  SizedBox(height: 4.h),
                  _buildItemNotes(item),
                ],
              ),
            ),
            _buildQuantityControls(item, index),
          ],
        ),
      ),
    ),
  );
}

Widget _buildItemImage(CartItemModel item) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        item.imageUrl ?? ImageConstant.foodChickenSlam,
        width: 45.w,
        height: 45.w,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image_not_supported_outlined,
          size: 45.w,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

Widget _buildItemName(CartItemModel item) {
  final menuDetail = CartController.to.menuDetails[item.menuId];

  String levelText = '';
  if (item.level != null && menuDetail != null) {
    final levelItem =
        menuDetail.level.firstWhereOrNull((level) => level.id == item.level);
    if (levelItem != null) {
      levelText = 'lvl. ${levelItem.keterangan}';
    }
  }

  String toppingsText = '';
  if (item.topping != null && item.topping!.isNotEmpty && menuDetail != null) {
    final toppingNames = item.topping!.map((id) {
      final found = menuDetail.topping.firstWhereOrNull((e) => e.id == id);
      return found?.keterangan ?? id;
    }).toList();
    toppingsText = toppingNames.join(' + ');
  }

  String modifierText = '';
  if (levelText.isNotEmpty || toppingsText.isNotEmpty) {
    List<String> parts = [];
    if (levelText.isNotEmpty) parts.add(levelText);
    if (toppingsText.isNotEmpty) parts.add(toppingsText);
    modifierText = ' (${parts.join(', ')})';
  }

  return Text(
    '${item.productName}$modifierText',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.sp,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

Widget _buildItemPrice(CartItemModel item) {
  final levelPrice = item.hargaLevel ?? 0;
  final toppingPrice = item.hargaTopping ?? 0;

  String detail = '';
  if (levelPrice > 0 || toppingPrice > 0) {
    List<String> parts = [];
    if (levelPrice > 0) parts.add(levelPrice.formatCurrency());
    if (toppingPrice > 0) parts.add(toppingPrice.formatCurrency());
    detail = ' (${parts.join(' , ')})';
  }

  return Text(
    '${item.harga.formatCurrency()}$detail',
    style: TextStyle(
      color: ColorStyle.primary,
      fontWeight: FontWeight.w600,
      fontSize: 13.sp,
    ),
  );
}

Widget _buildItemNotes(CartItemModel item) {
  return item.notes != null && item.notes!.isNotEmpty
      ? Row(
          children: [
            Icon(Icons.notes, size: 14.w, color: ColorStyle.primary),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                item.notes!,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
      : Row(
          children: [
            Icon(Icons.notes, size: 14.w, color: ColorStyle.primary),
            SizedBox(width: 4.w),
            Text(
              "Tambahkan Catatan".tr,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        );
}

Widget _buildQuantityControls(CartItemModel item, int index) {
  return Row(
    children: [
      InkWell(
        onTap: () {
          if (item.jumlah > 1) {
            final updatedItem = item.copyWith(
              jumlah: item.jumlah - 1,
            );
            CartController.to.updateItem(index, updatedItem);
          } else {
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Konfirmasi'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Text(
                  'Apakah kamu yakin ingin menghapus item ini dari keranjang?'
                      .tr,
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
                      CartController.to.removeItem(index);
                      Get.back();
                    },
                    child: const Text('Hapus',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Icon(Icons.remove, size: 16.w),
        ),
      ),
      SizedBox(width: 8.w),
      Text(
        item.jumlah.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
      ),
      SizedBox(width: 8.w),
      InkWell(
        onTap: () {
          final updatedItem = item.copyWith(
            jumlah: item.jumlah + 1,
          );
          CartController.to.updateItem(index, updatedItem);
        },
        child: Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: ColorStyle.primary),
          ),
          child: Icon(Icons.add, size: 16.w, color: ColorStyle.primary),
        ),
      ),
    ],
  );
}
