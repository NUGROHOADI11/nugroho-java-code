import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget buildDivider() {
  return Row(
    children: [
      Expanded(
        child: Divider(
          color: Colors.grey.shade400,
          thickness: 1,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          'atau'.tr,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
      Expanded(
        child: Divider(
          color: Colors.grey.shade400,
          thickness: 1,
        ),
      ),
    ],
  );
}
