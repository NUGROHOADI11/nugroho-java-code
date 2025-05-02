import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/features/sign_in/controllers/sign_in_controller.dart';

import '../../../../shared/styles/color_style.dart';

Widget buildLoginButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => SignInController.to.validateForm(Get.context!),
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
  );
}
