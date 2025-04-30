import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/features/review/controllers/review_controller.dart';
import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({super.key});

  final ReviewController _controller = ReviewController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Review'.tr,
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
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(_controller.errorMessage.value));
        }

        return Padding(
          padding: EdgeInsets.all(14.0.w),
          child: ListView.builder(
            itemCount: _controller.reviews.length,
            itemBuilder: (context, index) {
              final review = _controller.reviews[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (review.imagePath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(review.imagePath!),
                            width: 80.w,
                            height: 80.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80.w,
                              height: 80.w,
                              color: Colors.grey[200],
                              child: Icon(Icons.broken_image,
                                  size: 30.sp, color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.image,
                              size: 30.sp, color: Colors.grey),
                        ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.blueGrey, size: 15.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    review.category,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorStyle.info,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      Icons.star,
                                      size: 16.sp,
                                      color: i < review.rating
                                          ? Colors.amber
                                          : Colors.grey.shade300,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              review.desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.chatReviewRoute,
                                arguments: {'reviewId': review.id});
                          },
                          icon: const Icon(
                            Icons.reply_outlined,
                            color: ColorStyle.success,
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.reviewAddReviewRoute);
        },
        backgroundColor: ColorStyle.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
