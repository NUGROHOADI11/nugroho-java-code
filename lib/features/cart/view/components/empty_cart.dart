import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';

Widget buildEmptyCart() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey[400]),
        SizedBox(height: 16.h),
        Text(
          "Keranjang kosong".tr,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        ElevatedButton(
          onPressed: () => Get.offAllNamed(Routes.homeRoute),
          child: Text(
            "Belanja Sekarang".tr,
            style: const TextStyle(color: ColorStyle.primary),
          ),
        ),
      ],
    ),
  );
}
