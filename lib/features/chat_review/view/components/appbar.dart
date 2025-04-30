import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Column(
      children: [
        Text(
          'Balasan Review'.tr,
          style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold, color: ColorStyle.primary),
        ),
        Container(
          width: 65.w,
          height: 2.h,
          color: ColorStyle.primary,
        ),
      ],
    ),
    centerTitle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    elevation: 3,
    shadowColor: const Color.fromARGB(66, 0, 0, 0),
    backgroundColor: Colors.white,
  );
}
