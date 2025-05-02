import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_form.dart';
import '../../controllers/sign_in_controller.dart';

Widget buildLoginForm() {
  return Form(
    key: SignInController.to.formKey,
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
        _buildPasswordField(),
        SizedBox(height: 5.h),
        _buildForgotPasswordButton(),
      ],
    ),
  );
}

Widget _buildPasswordField() {
  return Obx(
    () => CustomForm(
      controller: SignInController.to.passwordCtrl,
      labelText: 'Kata Sandi'.tr,
      hintText: 'Masukkan kata sandi anda'.tr,
      obscureText: SignInController.to.isPassword.value,
      suffixIcon: IconButton(
        onPressed: () => SignInController.to.showPassword(),
        icon: Icon(
          SignInController.to.isPassword.value
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
      required: true,
      requiredText: "Password is required".tr,
    ),
  );
}

Widget _buildForgotPasswordButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () => Get.toNamed(Routes.forgotPasswordRoute),
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
  );
}
