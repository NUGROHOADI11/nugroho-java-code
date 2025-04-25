import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../configs/routes/route.dart';


class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get to => Get.find();

  final TextEditingController emailCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var emailValue = "".obs;

  void validateForm(context) async {

    var isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      EasyLoading.show(
        status: 'Sedang Diproses...'.tr,
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );

      formKey.currentState!.save();
      if (emailCtrl.text.isNotEmpty) {
        EasyLoading.dismiss();
        Get.toNamed(Routes.otpRoute, arguments: emailCtrl.text);
      } else {
        EasyLoading.dismiss();
        PanaraInfoDialog.show(
          context,
          title: "Warning".tr,
          message: "Email Tidak Boleh Kosong".tr,
          buttonText: "Coba lagi".tr,
          onTapDismiss: () {
            Get.back();
          },
          panaraDialogType: PanaraDialogType.warning,
          barrierDismissible: false,
        );
      }
    } 
  }
}