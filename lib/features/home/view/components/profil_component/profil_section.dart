 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../shared/styles/color_style.dart';
import '../../../controllers/profil_controller.dart';

Widget buildProfileSection(controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Container(
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
                    child: Obx(() {
                      final user = controller.user.value;
                      return CircleAvatar(
                        radius: 80,
                        backgroundColor: ColorStyle.info,
                        backgroundImage: controller.imageFile.value != null
                            ? NetworkImage(user!.photo)
                            : null,
                        child: controller.imageFile.value == null
                            ? (user?.photo != null && user!.photo.isNotEmpty
                                ? Image.network(
                                    user.photo,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 40.r,
                                        color: Colors.white,
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 40.r,
                                    color: Colors.white,
                                  ))
                            : null,
                      );
                    }),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: ColorStyle.primary,
                      child: InkWell(
                        onTap: () {
                          ProfilController.to.pickImage();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 10.r, bottom: 15.r),
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
              ),
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
