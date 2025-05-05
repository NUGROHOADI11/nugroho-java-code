import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../home/models/promo_model.dart';

Widget buildVoucherCard(Promo voucher, controller) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.voucherDetailRoute, arguments: {
          'id': voucher.id,
          'title': voucher.name,
          'terms': voucher.terms,
          'valid': voucher.exp,
          'image': voucher.photo
        });
      },
      child: Obx(() {
        final isSelected = controller.isVoucherSelected(voucher.id);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(color: ColorStyle.primary, width: 2)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          voucher.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) =>
                              controller.selectVoucher(voucher.id),
                          activeColor: ColorStyle.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                child: CachedNetworkImage(
                  imageUrl: voucher.photo.toString(),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: SkeletonLoading()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }