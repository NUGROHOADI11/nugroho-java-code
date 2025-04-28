import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pinput/pinput.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';

import '../../../../constants/cores/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/cart_controller.dart';

Widget buildCheckoutButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
          onPressed: () => _authenticateUser(context),
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

Future<void> _authenticateUser(context) async {
  final logger = Logger();
  final localAuth = LocalAuthentication();

  try {
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final isDeviceSupported = await localAuth.isDeviceSupported();

    if (!isDeviceSupported || !canCheckBiometrics) {
      _showVerificationModal(context);
      return;
    }

    final didAuthenticate = await localAuth.authenticate(
      localizedReason: 'Authenticate to complete your order',
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );

    if (didAuthenticate) {
      final preparedData = await CartController.to.prepareOrderData();
      logger.d("Data prepare $preparedData");

      final orderResponse = await CartController.to.createOrder();
      if (orderResponse != null) {
        _showOrderSuccessDialog(context);
      }
    } else {
      Get.snackbar(
        "Authentication Failed".tr,
        "Please try again or use PIN".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      _showVerificationModal(context);
    }
  } catch (e) {
    logger.e("Authentication error: $e");
    Get.snackbar(
      "Error".tr,
      "Biometric authentication unavailable. Using PIN instead.".tr,
      snackPosition: SnackPosition.BOTTOM,
    );
    _showVerificationModal(context);
  }
}

void _showVerificationModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Verifikasi Pesanan".tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              "Finger Print".tr,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _authenticateUser(context);
              },
              child: Icon(Icons.fingerprint,
                  size: 100.w, color: ColorStyle.primary),
            ),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Verifikasi Pesanan".tr,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
                            border: Border.all(color: ColorStyle.primary),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onCompleted: (pin) async {
                          if (pin == "111111") {
                            Navigator.pop(context);
                            final orderResponse =
                                await CartController.to.createOrder();
                            if (orderResponse != null) {
                              if (context.mounted) {
                                _showOrderSuccessDialog(context);
                              }
                            }
                          } else {
                            if (context.mounted) {
                              Get.snackbar(
                                "Error".tr,
                                "PIN salah, coba lagi.".tr,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
                        }),
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
