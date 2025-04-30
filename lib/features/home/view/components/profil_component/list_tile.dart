import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profil_controller.dart';

Widget buildListTile(String title, String value,
    {bool withArrow = false, VoidCallback? onTap}) {
  return Column(
    children: [
      ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            title == "Nama".tr
                ? Obx(() => Text(
                      ProfilController.to.nama.value,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ))
                : Text(value,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            if (withArrow) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(height: 1, thickness: 0.5),
      ),
    ],
  );
}
