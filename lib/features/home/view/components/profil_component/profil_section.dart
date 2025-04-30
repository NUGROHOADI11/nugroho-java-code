 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../shared/styles/color_style.dart';
import '../../../controllers/profil_controller.dart';

Widget buildProfileSection(ProfilController controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Obx(() {
              final user = controller.user.value;
              ImageProvider? profileImage;
              
              if (controller.imageFile.value != null) {
                profileImage = FileImage(controller.imageFile.value!);
              } else if (user?.photo != null && user!.photo.isNotEmpty) {
                profileImage = NetworkImage(user.photo);
              }

              return Container(
                width: 120.r,
                height: 120.r,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorStyle.info, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: ColorStyle.info,
                      backgroundImage: profileImage,
                      child: profileImage == null
                          ? Icon(
                              Icons.person,
                              size: 40.r,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: ColorStyle.primary,
                      child: InkWell(
                        onTap: controller.pickImage,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 8.r, bottom: 10.r),
                          child: Text(
                            "Ubah".tr,
                            style: Get.textTheme.labelMedium!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              );
            }),
          ),
          21.verticalSpacingRadius,
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.credit_card, color: ColorStyle.primary),
          const SizedBox(width: 5),
          Text(
            'Verifikasi KTP mu sekarang!'.tr,
            style: const TextStyle(
                color: ColorStyle.primary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ],
  );
}