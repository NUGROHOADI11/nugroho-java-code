import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nugroho_javacode/features/cart/controllers/cart_controller.dart';

import '../../../configs/routes/route.dart';
import '../../../shared/styles/color_style.dart';
import '../../../shared/widgets/image_picker_dialog.dart';
import '../../../utils/services/dio_service.dart';
import '../../../utils/services/hive_service.dart';
import '../models/user_detail_model.dart';

class ProfilController extends GetxController {
  static ProfilController get to => Get.find();

  // User data
  final int? idUser = LocalStorageService.getUserData()["id_user"];
  final Rx<UserDetail?> user = Rx<UserDetail?>(null);
  final Rx<File?> imageFile = Rx<File?>(null);
  final RxString imageUrl = RxString('');
  final RxString nama = RxString('');
  final RxString birthDate = RxString('');
  final RxString phoneNumber = RxString('');
  final RxString email = RxString('');
  final RxString currentPin = RxString('');
  final RxBool isPinVisible = false.obs;


  // Language preference
  final String? language = LocalStorageService.getLanguagePreference();
  final RxString selectedLanguage = RxString('');

  // Device info
  final RxString deviceModel = RxString('');
  final RxString deviceVersion = RxString('');

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = language ?? '';
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      getDeviceInformation(),
      fetchUser(),
    ]);
  }

  Future<void> fetchUser() async {
    if (idUser == null) {
      log("No user ID found");
      return;
    }

    try {
      EasyLoading.show(
        status: 'loading'.tr,
        maskType: EasyLoadingMaskType.black,
      );

      final userData = await DioService.getUserDetail(idUser!);
      user.value = userData;
      nama.value = userData.name;
      birthDate.value = userData.birthDate;
      phoneNumber.value = userData.phone;
      email.value = userData.email;
      currentPin.value = userData.pin;

      if (userData.photo.isNotEmpty) {
        imageFile.value = File(userData.photo);
      } else {
        imageFile.value = null;
      }

      EasyLoading.dismiss();
    } catch (e) {
      log("Error fetching user: $e");
      EasyLoading.dismiss();
      Get.snackbar(
        'error'.tr,
        'failed_to_load_user_data'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void updateNama(String newNama) {
    if (newNama.trim().isNotEmpty) {
      nama.value = newNama.trim();
    }
  }

  void updateBirthDate(String newDate) {
    if (newDate.isNotEmpty) {
      birthDate.value = newDate;
    }
  }

  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^08[0-9]{8,11}$');
    return phoneRegex.hasMatch(phone);
  }

  bool updatePhoneNumber(String newPhone) {
    final trimmedPhone = newPhone.trim();
    if (trimmedPhone.isNotEmpty && isValidPhone(trimmedPhone)) {
      phoneNumber.value = trimmedPhone;
      return true;
    } else {
      Get.snackbar(
        'Invalid Phone Number'.tr,
        'Please enter a valid phone number'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool updateEmail(String newEmail) {
    final trimmedEmail = newEmail.trim();
    if (trimmedEmail.isNotEmpty && isValidEmail(trimmedEmail)) {
      email.value = trimmedEmail;
      return true;
    } else {
      Get.snackbar(
        'Invalid Email'.tr,
        'Please enter a valid email address'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> verifyOldPin(String enteredPin) async {
    return enteredPin == currentPin.value;
  }

  Future<void> updatePin(String currentPin, String newPin) async {
    try {
      EasyLoading.show(status: 'Verifying...'.tr);

      final isVerified = await verifyOldPin(currentPin);
      if (!isVerified) {
        EasyLoading.showError('Old PIN is incorrect'.tr);
        return;
      }

      if (newPin.length != 6) {
        EasyLoading.showError('PIN must be 6 digits'.tr);
        return;
      }

      EasyLoading.showSuccess('PIN updated successfully'.tr);
      this.currentPin.value = newPin;
    } catch (e) {
      EasyLoading.showError('Failed to update PIN'.tr);
      log("Error updating PIN: $e");
    }
  }

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    final locale = languageCode == 'id'
        ? const Locale('id', 'ID')
        : const Locale('en', 'US');
    Get.updateLocale(locale);
    LocalStorageService.saveLanguagePreference(languageCode);
  }

  Future<void> getDeviceInformation() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (GetPlatform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel.value = androidInfo.model;
        deviceVersion.value = androidInfo.version.release;
      } else if (GetPlatform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel.value = iosInfo.model;
        deviceVersion.value = iosInfo.systemVersion;
      }
    } catch (e) {
      log("Error getting device info: $e");
    }
  }

  Future<void> pickImage() async {
    try {
      ImageSource? imageSource = await Get.defaultDialog(
        title: '',
        titleStyle: const TextStyle(fontSize: 0),
        content: const ImagePickerDialog(),
      );

      if (imageSource == null) return;

      final pickedFile = await ImagePicker().pickImage(
        source: imageSource,
        maxWidth: 1400,
        maxHeight: 1400,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        await _cropImage(File(pickedFile.path));
      }
    } catch (e) {
      log("Error picking image: $e");
      Get.snackbar(
        'error'.tr,
        'failed_to_pick_image'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'cropper'.tr,
            toolbarColor: ColorStyle.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'cropper'.tr,
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        this.imageFile.value = File(croppedFile.path);
      }
    } catch (e) {
      log("Error cropping image: $e");
      throw Exception('failed_to_crop_image'.tr);
    }
  }

  Future<void> logout() async {
    try {
      EasyLoading.show(
        status: 'logging_out'.tr,
        dismissOnTap: false,
      );
      CartController.to.clearCart();
      await LocalStorageService.deleteAuth();
      EasyLoading.dismiss();
      Get.offAllNamed(Routes.signInRoute);
    } catch (e) {
      log("Logout error: $e");
      EasyLoading.dismiss();
      await LocalStorageService.deleteAuth();
      Get.offAllNamed(Routes.signInRoute);
    }
  }
}
