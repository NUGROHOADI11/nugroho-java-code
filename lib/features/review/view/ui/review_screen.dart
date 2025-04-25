import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';

class ReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      'category': 'Penyajian Makanan',
      'rating': 3,
      'text':
          'Penyajian kurang menarik, tidak ada timun Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'category': 'Fasilitas',
      'rating': 2,
      'text':
          'Mohon menjaga kebersihan meja, meja ma Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'category': 'Rasa',
      'rating': 3,
      'text':
          'Padahal saya pesen Nasi Goreng Level 1, tap Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'category': 'Penyajian Makanan',
      'rating': 4,
      'text':
          'Penyajian kurang menarik, tidak ada timun Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
  ];

  ReviewScreen({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.blueGrey, size: 15.sp),
                    SizedBox(width: 8.w),
                    Text(
                      review['category'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        return Icon(
                          Icons.star,
                          size: 16.sp,
                          color: i < review['rating']
                              ? Colors.amber
                              : Colors.grey.shade300,
                        );
                      }),
                    ),
                  ],
                ),
                subtitle: Text(
                  review['text'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
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
