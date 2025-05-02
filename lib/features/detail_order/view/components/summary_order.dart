import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';
import '../../controllers/detail_order_controller.dart';
import '../../models/order_detail_model.dart';

Widget buildOrderSummary(BuildContext context, id) {
  return Obx(() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSummaryDetails(),
        _builtStatusOrder(),
      ],
    );
  });
}

Widget _buildSummaryDetails() {
  final order = DetailOrderController.to.orderDetail.value;
  final totalItem = (order?.detail ?? [])
      .cast<OrderItem>()
      .fold<int>(0, (sum, item) => sum + item.jumlah);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
          "Total Pesanan ($totalItem item)",
          order!.order.totalBayar.formatCurrency(),
          isBold: true,
        ),
        const Divider(height: 1),
        _buildSummaryRow(
          "Diskon".tr,
          order.order.diskon!.formatCurrency(),
          icon: Icons.discount,
          valueColor: Colors.red,
        ),
        const Divider(height: 1),
        _buildSummaryRow(
          "Voucher".tr,
          order.order.namaVoucher.toString(),
          icon: Icons.card_giftcard,
        ),
        const Divider(height: 1),
        _buildSummaryRow(
          "Pembayaran".tr,
          "Pay Later".tr,
          icon: Icons.payments,
        ),
        const Divider(height: 1),
        _buildSummaryRow(
          "Total Pembayaran".tr,
          order.order.totalBayar.formatCurrency(),
          isBold: true,
        ),
      ],
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

Widget _builtStatusOrder() {
  final order = DetailOrderController.to.orderDetail.value;
  int currentStep = order?.order.status ?? 1;

  final steps = [
    {'label': 'Order accepted'.tr},
    {'label': 'Please take your order'.tr},
    {'label': 'Order completed'.tr},
  ];

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    color: const Color(0xFFF6F6F6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          steps[currentStep]['label'] ?? '',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                return const Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 2.5,
                  ),
                );
              } else {
                int stepIndex = index ~/ 2;
                bool isCurrent = stepIndex == currentStep;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent ? ColorStyle.primary : null,
                  ),
                  child: Center(
                    child: Icon(
                      isCurrent ? Icons.check : Icons.circle,
                      size: isCurrent ? 14.w : 10.w,
                      color: isCurrent ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }
            }),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.map((e) {
            return SizedBox(
              width: 60.w,
              child: Text(
                e['label']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
      ],
    ),
  );
}
