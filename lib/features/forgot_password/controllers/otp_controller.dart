import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';

import '../../../configs/routes/route.dart';

class OtpController extends GetxController {
  static OtpController get to => Get.find();
  final RxString email = "".obs;
  late TextEditingController otpTextController;

  @override
  void onInit() {
    otpTextController = TextEditingController();
    email.value = Get.arguments as String;
    super.onInit();
  }

  @override
  void onClose() {
    otpTextController.dispose();
    super.onClose();
  }

  void onOtpComplete(String value) {
    if (value == "1234") {
      Get.snackbar("Sukses".tr, "Kode Otp Valid".tr,
          duration: const Duration(seconds: 2),
          backgroundColor: ColorStyle.success);
      Get.offAllNamed(Routes.signInRoute);
    }
  }
}
