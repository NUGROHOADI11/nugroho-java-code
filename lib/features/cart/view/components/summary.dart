import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/cart_controller.dart';
import 'checkout_button.dart';

Widget buildOrderSummary(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildSummaryDetails(),
      buildCheckoutButton(context),
    ],
  );
}

Widget _buildSummaryDetails() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F6F6),
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, -1),
        ),
      ],
    ),
    child: Column(
      children: [
        _buildSummaryRow(
          "Subtotal Pesanan (${CartController.to.totalQuantity} item)".tr,
          CartController.to.subTotalPrice.formatCurrency(),
          isBold: true,
        ),
        const Divider(height: 1),
        if (CartController.to.selectedVoucherId.value == -1) ...[
          _buildSummaryRow(
            "Diskon".tr,
            CartController.to.calculateDiscount().formatCurrency(),
            icon: Icons.discount,
            valueColor: Colors.red,
            isTappable: true,
            onTap: () {
              _showDiscountModal();
            },
          ),
          const Divider(height: 1),
        ],
        _buildSummaryRow(
          "Voucher".tr,
          CartController.to.selectedVoucherId.value != -1
              ? CartController.to.selectedVoucherValue.toInt().formatCurrency()
              : "Pilih Voucher".tr,
          icon: Icons.card_giftcard,
          isTappable: true,
          onTap: () {
            Get.toNamed(Routes.voucherRoute);
          },
        ),
        const Divider(height: 1),
        _buildSummaryRow(
          "Pembayaran".tr,
          "Pay Later".tr,
          icon: Icons.payments,
          isTappable: true,
        ),
      ],
    ),
  );
}

void _showDiscountModal() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Info Diskon".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ...CartController.to.discounts.map<Widget>((discounts) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Text(
                      discounts['nama'],
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    const Spacer(),
                    Text(
                      '${discounts['diskon'].toString()} %',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Oke".tr,
                  style: const TextStyle(
                    color: ColorStyle.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSummaryRow(
  String title,
  String value, {
  IconData? icon,
  Color? valueColor,
  bool isTappable = false,
  bool isBold = false,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20.w, color: ColorStyle.primary),
            SizedBox(width: 12.w),
          ],
          Text(
            title.tr,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          Text(
            value.tr,
            style: TextStyle(
              color: valueColor ?? Colors.grey,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.sp,
            ),
          ),
          if (isTappable)
            Icon(Icons.chevron_right, size: 20.w, color: Colors.grey),
        ],
      ),
    ),
  );
}
