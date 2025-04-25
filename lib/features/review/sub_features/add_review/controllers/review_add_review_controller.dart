import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nugroho_javacode/shared/widgets/image_picker_dialog.dart';

import '../../../../../shared/styles/color_style.dart';

class ReviewAddReviewController extends GetxController {
  static ReviewAddReviewController get to => Get.find();

  var selectedRating = 5.obs;
  var selectedCategories = <String>[].obs;
  final reviewController = TextEditingController();
  final Rx<File?> _imageFile = Rx<File?>(null);
  File? get imageFile => _imageFile.value;

  final categories = [
    'Harga',
    'Rasa',
    'Penyajian makanan',
    'Pelayanan',
    'Fasilitas',
  ];

  String getRatingText(int rating) {
    switch (rating) {
      case 5:
        return 'Sempurna';
      case 4:
        return 'Hampir Sempurna';
      case 3:
        return 'Cukup Baik';
      case 2:
        return 'Kurang Baik';
      case 1:
        return 'Buruk';
      default:
        return '';
    }
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void submitReview() {
    // final rating = selectedRating.value;
    // final categories = selectedCategories;
    // final comment = reviewController.text;
    // print("Rating: $rating");
    // print("Kategori: $categories");
    // print("Review: $comment");
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
        imageQuality: 100,
      );

      if (pickedFile != null) {
        _imageFile.value = File(pickedFile.path);
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _imageFile.value!.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper'.tr,
              toolbarColor: ColorStyle.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
          ],
        );

        if (croppedFile != null) {
          _imageFile.value = File(croppedFile.path);
        }
      }
    } catch (e) {
      log("Error picking image: $e");
      Get.snackbar("Error", "Gagal mengambil gambar $e");
    }
  }

  void removeImage() {
    _imageFile.value = null;
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
