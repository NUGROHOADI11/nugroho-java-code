import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/shared/widgets/custom_form.dart';

import '../../../../configs/routes/route.dart';
import '../../../../constants/cores/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../constants/sign_in_assets_constant.dart';
import '../../controllers/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final SignInController controller =
      Get.put(SignInController(), permanent: true);
  final assetsConstant = SignInAssetsConstant();
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      analytics.logScreenView(
        screenName: 'Sign In Screen',
        screenClass: 'Android',
      );
    } else if (Platform.isIOS) {
      analytics.logScreenView(
        screenName: 'Sign In Screen',
        screenClass: 'IOS',
      );
    } else if (Platform.isMacOS) {
      analytics.logScreenView(
        screenName: 'Sign In Screen',
        screenClass: 'MacOS',
      );
    }
    if (kIsWeb) {
      analytics.logScreenView(
        screenName: 'Sign In Screen',
        screenClass: 'Web',
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() {
            return DropdownButton(
              value: controller.selectedLanguage.value,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              underline: Container(
                height: 2,
              ),
              onChanged: (String? language) {
                controller.selectLanguage(language ?? "Indonesia");
              },
              items: controller.languageList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          })
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50.h),
                GestureDetector(
                  onDoubleTap: () => controller.flavorSeting(),
                  child: Image.asset(ImageConstant.logoApp),
                ),
                SizedBox(height: 50.h),
                Text(
                  "Masuk untuk melanjutkan!".tr,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16.h),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomForm(
                        controller: SignInController.to.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Alamat Email'.tr,
                        hintText: 'Masukkan Email anda'.tr,
                        required: true,
                        requiredText: "Email is required".tr,
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => CustomForm(
                          controller: SignInController.to.passwordCtrl,
                          labelText: 'Kata Sandi'.tr,
                          hintText: 'Masukkan kata sandi anda'.tr,
                          obscureText: SignInController.to.isPassword.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              SignInController.to.showPassword();
                            },
                            icon: Icon(
                              SignInController.to.isPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          required: true,
                          requiredText: "Password is required".tr,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.forgotPasswordRoute);
                      },
                      child: Text(
                        'Lupa Password?'.tr,
                        style: const TextStyle(
                          color: ColorStyle.dark,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.validateForm(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Masuk'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'atau'.tr,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.googleSignIn();
                    },
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
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.pdfViewerRoute);
                    },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
