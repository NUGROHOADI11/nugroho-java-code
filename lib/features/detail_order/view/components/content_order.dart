import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';

import '../../../../constants/cores/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/detail_order_controller.dart';
import '../../models/order_detail_model.dart';

Widget buildCartItemsList(int id) {
  return Obx(() {
    final controller = DetailOrderController.to;

    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.isNotEmpty) {
      return Center(child: Text(controller.errorMessage.value));
    }

    final items = controller.orderDetail.value?.detail ?? [];

    if (items.isEmpty) {
      return const Center(child: Text("Tidak ada item pesanan"));
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(16.r),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildOrderItem(item, index);
        },
      ),
    );
  });
}

Widget _buildOrderItem(OrderItem item, int index) {
  return Card(
    color: const Color(0xFFF6F6F6),
    margin: EdgeInsets.symmetric(vertical: 6.h),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Padding(
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          _buildItemImage(item.foto),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item.harga.formatCurrency(),
                  style: TextStyle(
                    color: ColorStyle.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.notes, size: 14.w, color: ColorStyle.primary),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        (item.catatan.isNotEmpty)
                            ? item.catatan
                            : "Tidak ada catatan".tr,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildItemImage(String? imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.r),
    child: Image.network(
      imageUrl ?? ImageConstant.foodChickenSlam,
      width: 45.w,
      height: 45.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.image_not_supported_outlined,
        size: 45.w,
        color: Colors.grey,
      ),
    ),
  );
}
