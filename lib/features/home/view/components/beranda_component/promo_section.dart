import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../configs/routes/route.dart';
import '../../../../../constants/cores/assets/image_constant.dart';
import '../../../../../shared/styles/color_style.dart';
import '../../../../../shared/widgets/skeleton.dart';

Widget buildPromoSection(controller) {
  return Obx(() {
    if (controller.isPromoLoading.value) {
      return const SkeletonLoading(count: 1, width: 100.0, height: 100.0);
    }

    if (controller.promos.isEmpty) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.local_offer,
                  color: ColorStyle.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                "Promo yang Tersedia".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorStyle.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.promos.length,
            itemBuilder: (context, index) {
              final promo = controller.promos[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: const AssetImage(ImageConstant.bgVoucher),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      ColorStyle.primary.withOpacity(0.9),
                      BlendMode.darken,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.detailPromoRoute, arguments: {
                        'id': promo.id,
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (promo.type.toLowerCase() == 'diskon')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                promo.type[0].toUpperCase() +
                                    promo.type.substring(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  letterSpacing: 1.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 8),
                              Stack(
                                children: [
                                  Text(
                                    promo.displayValue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color = Colors.white,
                                        ),
                                  ),
                                  Text(
                                    promo.displayValue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.transparent,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Text(
                                promo.type[0].toUpperCase() +
                                    promo.type.substring(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  letterSpacing: 1.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Stack(
                                children: [
                                  Text(
                                    promo.displayValue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color = Colors.white,
                                        ),
                                  ),
                                  Text(
                                    promo.displayValue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.transparent,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Text(
                          _stripHtmlTags(promo.terms).tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  });
}

String _stripHtmlTags(String htmlText) {
  return htmlText
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .trim();
}
