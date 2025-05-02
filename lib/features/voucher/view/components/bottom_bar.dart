import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../cart/controllers/cart_controller.dart';

Widget buildBottomBar(BuildContext context, controller) {
  return Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: ColorStyle.primary,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penggunaan voucher tidak dapat digabung dengan".tr,
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        "discount employee reward program".tr,
                        style: const TextStyle(
                            fontSize: 15, color: ColorStyle.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.selectedVoucherId.value != -1
                    ? () {
                        final selected = controller.vouchers.firstWhere(
                          (v) =>
                              v['id_promo'] ==
                              controller.selectedVoucherId.value,
                        );
                        CartController.to.applyVoucher(
                          selected['id_promo'],
                          selected['nominal'],
                        );
                        Get.back();
                      }
                    : () {
                        CartController.to.selectedVoucherId.value == -1;
                        Get.back();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  'Oke'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
}
