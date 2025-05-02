 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../controllers/sign_in_controller.dart';

Widget buildSocialLoginButtons() {
    return Column(
      children: [
        _buildGoogleLoginButton(),
        SizedBox(height: 12.h),
        _buildAppleLoginButton(),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => SignInController.to.googleSignIn(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          elevation: 2,
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        icon: Image.asset(
          "assets/images/logo-google.png".tr,
          height: 24.h,
        ),
        label: Text(
          'Masuk menggunakan Google'.tr,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAppleLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Get.toNamed(Routes.pdfViewerRoute),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        icon: Icon(Icons.apple, color: Colors.white, size: 24.h),
        label: Text(
          'Masuk menggunakan Apple'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }