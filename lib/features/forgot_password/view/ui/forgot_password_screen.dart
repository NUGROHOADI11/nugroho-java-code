import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../constants/cores/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_form.dart';
import '../../constants/forgot_password_assets_constant.dart';
import '../../controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());
  final assetsConstant = ForgotPasswordAssetsConstant();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Container(
                  padding: const EdgeInsets.all(22),
                  child: Image.asset(ImageConstant.logoApp),
                ),
                SizedBox(height: 50.h),
                Text(
                  "Masukkan alamat email untuk mengubah password anda".tr,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Form(
                  key: controller.formKey,
                  child: CustomForm(
                    controller: ForgotPasswordController.to.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Alamat Email'.tr,
                    hintText: 'Masukkan Email anda'.tr,
                    required: true,
                    requiredText: "Email is required".tr,
                  ),
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
                      'Ubah Password'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
