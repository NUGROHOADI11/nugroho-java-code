import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
          const Icon(
            Icons.notifications_none_outlined,
            color: ColorStyle.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'Detail Order'.tr,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
