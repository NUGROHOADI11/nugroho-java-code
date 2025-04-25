import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';
import 'package:nugroho_javacode/utils/services/hive_service.dart';

import '../../../configs/routes/route.dart';
import '../../../constants/cores/api/api_constant.dart';
import '../../../shared/controllers/global_controllers/global_controller.dart';
import '../../../shared/styles/google_text_style.dart';
import '../../../utils/services/dio_service.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    Get.putAsync(() async {
      final service = LocalStorageService();
      return await service.init();
    });
  }

  var isLoading = false.obs;
  var user = {}.obs;
  var token = "".obs;

  var formKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();
  var emailValue = "".obs;
  var passwordCtrl = TextEditingController();
  var passwordValue = "".obs;
  var isPassword = true.obs;
  var isRememberMe = false.obs;

  googleSignIn() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void showPassword() {
    if (isPassword.value == true) {
      isPassword.value = false;
    } else {
      isPassword.value = true;
    }
  }

  var languageList = ["English", "Indonesia"];
  var selectedLanguage = "English".obs;

  void selectLanguage(String language) {
    selectedLanguage.value = language;

    if (language == "Indonesia") {
      Get.updateLocale(const Locale("id", "ID"));
      return;
    }

    if (language == "English") {
      Get.updateLocale(const Locale("en", "US"));
      return;
    }
  }

  Future<void> validateForm(context) async {
    await GlobalController.to.checkConnection();
    bool isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (!isValid || GlobalController.to.isConnected.value == false) {
      if (GlobalController.to.isConnected.value == false) {
        Get.toNamed(Routes.noConnectionRoute);
      }
      return;
    }

    EasyLoading.show(
      status: 'Sedang Diproses...'.tr,
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );

    formKey.currentState!.save();

    try {
      if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
        _showErrorDialog(context, "Email atau Password tidak boleh kosong".tr);
        return;
      }

      EasyLoading.dismiss();

      final loginResponse = await DioService.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      if (loginResponse["status_code"] == 200) {
        var user = loginResponse["data"]["user"];
        String token = loginResponse["data"]["token"];

        await LocalStorageService.setAuth(
          idUser: user['id_user'],
          email: user['email'],
          nama: user['nama'],
          foto: user['foto'],
          roles: user['roles'],
          akses: user['akses'],
          token: token,
        );

        log("Login Success: $token".tr);
        Get.offAllNamed(Routes.homeRoute);
      } else {
        _showErrorDialog(
            context, loginResponse['message'] ?? "Login gagal.".tr);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _showErrorDialog(context, "Terjadi kesalahan: ${e.toString()}");
    }
  }

  void _showErrorDialog(context, String message) {
    PanaraInfoDialog.show(
      context,
      title: "Error".tr,
      message: message,
      buttonText: "Coba lagi".tr,
      onTapDismiss: () {
        Get.back();
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
    );
  }

  void flavorSeting() async {
    Get.bottomSheet(
      Obx(
        () => Wrap(
          children: [
            Container(
              width: double.infinity.w,
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: ColorStyle.light,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      GlobalController.to.isStaging.value = false;
                      GlobalController.to.baseUrl = ApiConstant.production;
                    },
                    title: Text(
                      "Production".tr,
                      style: GoogleTextStyle.fw400.copyWith(
                        color: GlobalController.to.isStaging.value == true
                            ? ColorStyle.dark
                            : ColorStyle.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: GlobalController.to.isStaging.value == true
                        ? null
                        : Icon(
                            Icons.check,
                            color: ColorStyle.primary,
                            size: 14.sp,
                          ),
                  ),
                  Divider(
                    height: 1.h,
                  ),
                  ListTile(
                    onTap: () {
                      GlobalController.to.isStaging.value = true;
                      GlobalController.to.baseUrl = ApiConstant.staging;
                    },
                    title: Text(
                      "Staging".tr,
                      style: GoogleTextStyle.fw400.copyWith(
                        color: GlobalController.to.isStaging.value == true
                            ? ColorStyle.primary
                            : ColorStyle.dark,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: GlobalController.to.isStaging.value == true
                        ? Icon(
                            Icons.check,
                            color: ColorStyle.primary,
                            size: 14.sp,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
