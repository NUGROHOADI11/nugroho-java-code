import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../constants/cores/assets/image_constant.dart';
import '../../constants/sign_in_assets_constant.dart';
import '../../controllers/sign_in_controller.dart';
import '../components/divider.dart';
import '../components/login_button.dart';
import '../components/login_form.dart';
import '../components/social_login.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final SignInController controller =
      Get.put(SignInController(), permanent: true);
  final assetsConstant = SignInAssetsConstant();

  @override
  Widget build(BuildContext context) {
    _logScreenView();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                buildLoginForm(),
                SizedBox(height: 30.h),
                buildLoginButton(),
                SizedBox(height: 50.h),
                buildDivider(),
                SizedBox(height: 16.h),
                buildSocialLoginButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _logScreenView() {
    if (Platform.isAndroid) {
      analytics.logScreenView(
          screenName: 'Sign In Screen', screenClass: 'Android');
    } else if (Platform.isIOS) {
      analytics.logScreenView(screenName: 'Sign In Screen', screenClass: 'IOS');
    } else if (Platform.isMacOS) {
      analytics.logScreenView(
          screenName: 'Sign In Screen', screenClass: 'MacOS');
    }
    if (kIsWeb) {
      analytics.logScreenView(screenName: 'Sign In Screen', screenClass: 'Web');
    }
  }
}
