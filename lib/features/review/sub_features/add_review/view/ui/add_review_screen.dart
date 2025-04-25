import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../shared/styles/color_style.dart';
import '../../controllers/review_add_review_controller.dart';

class AddReviewScreen extends StatelessWidget {
  AddReviewScreen({super.key});

  final controller = Get.put(ReviewAddReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Review'.tr,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorStyle.primary,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 65.w,
              height: 2.h,
              color: ColorStyle.primary,
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        elevation: 3,
        shadowColor: const Color.fromARGB(66, 0, 0, 0),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (controller.imageFile != null) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          controller.imageFile!,
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            controller.removeImage();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Belum ada gambar yang dipilih',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              }),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berikan Penilaianmu!',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorStyle.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () => controller.selectedRating.value =
                                      index + 1,
                                  child: Icon(
                                    Icons.star,
                                    color:
                                        index < controller.selectedRating.value
                                            ? Colors.amber
                                            : Colors.grey,
                                    size: 32.sp,
                                  ),
                                );
                              }),
                            ),
                            Text(
                              controller.getRatingText(
                                  controller.selectedRating.value),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apa yang bisa ditingkatkan?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.categories.map((label) {
                            final isSelected =
                                controller.selectedCategories.contains(label);
                            return ChoiceChip(
                              label: Text(label),
                              selected: isSelected,
                              selectedColor: Colors.cyan[50],
                              labelStyle: TextStyle(
                                color:
                                    isSelected ? Colors.cyan : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              backgroundColor: Colors.grey[200],
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.cyan
                                    : Colors.transparent,
                              ),
                              onSelected: (_) =>
                                  controller.toggleCategory(label),
                            );
                          }).toList(),
                        )),
                    const SizedBox(height: 20),
                    Text(
                      'Tulis Review',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Tambahkan komentar disini',
                        fillColor: Colors.grey[50],
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.submitReview,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.primary,
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Kirim Penilaian',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(color: ColorStyle.primary),
                          ),
                          child: IconButton(
                            onPressed: () {
                              controller.pickImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                              color: ColorStyle.primary,
                              size: 28.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
