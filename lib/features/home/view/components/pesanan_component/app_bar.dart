import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/styles/color_style.dart';

AppBar buildAppBar() {
  return AppBar(
    title: TabBar(
      dividerColor: Colors.transparent,
      labelColor: ColorStyle.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: ColorStyle.primary,
      tabs: [
        Tab(
          child: Text(
            'Sedang Berjalan'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Tab(
          child: Text(
            'Riwayat'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    elevation: 3,
    shadowColor: const Color.fromARGB(66, 0, 0, 0),
    backgroundColor: Colors.white,
  );
}
