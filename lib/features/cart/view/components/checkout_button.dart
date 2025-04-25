import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';

import '../../../../constants/cores/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/cart_controller.dart';

Widget buildCheckoutButton(BuildContext context) {
  return Container(
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
    child: Row(
      children: [
        Icon(Icons.shopping_basket, color: ColorStyle.primary, size: 30.w),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Pembayaran".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorStyle.primary,
                fontSize: 14.sp,
              ),
            ),
            Text(
              CartController.to.totalPrice.formatCurrency(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => _showVerificationModal(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyle.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            elevation: 2,
          ),
          child: Text(
            "Pesan Sekarang".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showVerificationModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Verifikasi Pesanan".tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Finger Print".tr,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            Icon(Icons.fingerprint, size: 100.w, color: ColorStyle.primary),
            SizedBox(height: 16.h),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    "atau".tr,
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showPinVerificationDialog(context);
              },
              child: Text(
                "Verifikasi Menggunakan PIN".tr,
                style: TextStyle(
                  color: ColorStyle.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showPinVerificationDialog(BuildContext context) {
  bool obscure = true;
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Verifikasi Pesanan".tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Masukan kode PIN".tr,
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                      length: 6,
                      obscureText: obscure,
                      controller: pinController,
                      focusNode: focusNode,
                      defaultPinTheme: PinTheme(
                        width: 34.w,
                        height: 34.w,
                        textStyle: TextStyle(fontSize: 20.sp),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onCompleted: (pin) {
                        if (pin == "111111") {
                          Navigator.pop(context);
                          _showOrderSuccessDialog(context);
                        } else {
                          Get.snackbar(
                            "Error".tr,
                            "PIN salah, coba lagi.".tr,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        size: 24.w,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

void _showOrderSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageConstant.bgOrder,
              width: 120.w,
            ),
            SizedBox(height: 24.h),
            Text(
              "Pesanan Sedang Disiapkan".tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Kamu dapat melacak pesananmu di fitur Pesanan".tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyle.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: Text(
                  "Oke".tr,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
