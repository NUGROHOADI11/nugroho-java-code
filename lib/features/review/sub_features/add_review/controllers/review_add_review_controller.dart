import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nugroho_javacode/features/review/controllers/review_controller.dart';
import 'package:nugroho_javacode/shared/widgets/image_picker_dialog.dart';

class ReviewAddReviewController extends GetxController {
  static ReviewAddReviewController get to => Get.put(ReviewAddReviewController());

  final RxInt selectedRating = 5.obs;
  final RxList<String> selectedCategories = <String>[].obs;
  final TextEditingController reviewController = TextEditingController();
  final Rx<File?> imageFile = Rx<File?>(null);
  final RxString imagePath = RxString('');
  final RxString errorMessage = ''.obs;

  final List<String> reviewCategories = [
    'Harga',
    'Rasa',
    'Penyajian makanan',
    'Pelayanan',
    'Fasilitas',
  ];

  String getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Buruk';
      case 2:
        return 'Kurang Baik';
      case 3:
        return 'Cukup Baik';
      case 4:
        return 'Hampir Sempurna';
      case 5:
        return 'Sempurna';
      default:
        return 'Pilih Rating';
    }
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
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
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 85,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Edit Gambar',
              toolbarColor: Get.theme.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Edit Gambar',
              aspectRatioLockEnabled: true,
            ),
          ],
        );

        if (croppedFile != null) {
          imageFile.value = File(croppedFile.path);
          imagePath.value = croppedFile.path;
        }
      }
    } catch (e) {
      errorMessage.value = 'Gagal mengambil gambar: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
    }
  }

  void removeImage() {
    imageFile.value = null;
    imagePath.value = '';
  }

  Future<void> submitReview() async {
    try {
      if (selectedRating.value == 0) {
        throw 'Harap berikan rating';
      }

      if (selectedCategories.isEmpty) {
        throw 'Harap pilih minimal satu kategori';
      }

      if (reviewController.text.isEmpty) {
        throw 'Harap tulis review Anda';
      }

      final reviewData = {
        'category': selectedCategories.join(', '),
        'rating': selectedRating.value,
        'desc': reviewController.text,
        'imagePath': imagePath.value,
        'createdAt': DateTime.now(),
      };

      await ReviewController.to.addReview(reviewData);
      resetForm();
      Get.back(result: true);
      Get.snackbar('Success', 'Review berhasil ditambahkan');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    }
  }

  void resetForm() {
    selectedRating.value = 0;
    selectedCategories.clear();
    reviewController.clear();
    removeImage();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}