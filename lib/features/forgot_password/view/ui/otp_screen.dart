import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../constants/cores/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/styles/google_text_style.dart';
import '../../controllers/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      analytics.logScreenView(
        screenName: 'OTP Screen',
        screenClass: 'Android',
      );
    } else if (Platform.isIOS) {
      analytics.logScreenView(
        screenName: 'OTP Screen',
        screenClass: 'IOS',
      );
    } else if (Platform.isMacOS) {
      analytics.logScreenView(
        screenName: 'OTP Screen',
        screenClass: 'MacOS',
      );
    }

    if (kIsWeb) {
      analytics.logScreenView(
        screenName: 'OTP Screen',
        screenClass: 'Web',
      );
    }
    
    return Scaffold(
      backgroundColor: ColorStyle.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 121.h),
            Image.asset(
              ImageConstant.logoApp,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 121.h),
            Obx(
              () => Text(
                'Masukkan kode otp yang telah dikirimkan ke email ${OtpController.to.email.value}'.tr,
                style: GoogleTextStyle.fw600.copyWith(
                  fontSize: 22.sp,
                  color: ColorStyle.dark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40.h),
            Pinput(
              controller: OtpController.to.otpTextController,
              length: 4,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != "1234") {
                  return "Kode OTP salah";
                }
                return null;
              },
              onCompleted: OtpController.to.onOtpComplete,
            ),
          ],
        ),
      ),
    );
  }
}