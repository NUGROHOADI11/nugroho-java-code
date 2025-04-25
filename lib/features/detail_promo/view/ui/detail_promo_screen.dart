import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';

import '../../../../shared/widgets/skeleton.dart';
import '../../controllers/detail_promo_controller.dart';

class DetailPromoScreen extends StatelessWidget {
  const DetailPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailPromoController>();
    final promoId = Get.arguments['id'];

    if (promoId != null) {
      controller.detailPromo(promoId);
    }

    String stripHtmlTags(String htmlString) {
      final RegExp exp =
          RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(exp, '');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Detail Promo'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: SkeletonLoading(count: 1, width: 100.0, height: 300.0));
        }

        final promo = controller.promoDetail.value;
        if (promo == null) {
          return const Center(
            child: Text('Promo not found'),
          );
        }
        return Column(children: [
          const SizedBox(height: 16),
          Container(
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              color: ColorStyle.primary,
              borderRadius: BorderRadius.circular(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (promo.type.toLowerCase() == 'diskon')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${promo.type[0].toUpperCase()}${promo.type.substring(1)}",
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
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
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
                                      color: ColorStyle.primary,
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
                            "${promo.type[0].toUpperCase()}${promo.type.substring(1)}",
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
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
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
                                      color: ColorStyle.primary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      stripHtmlTags(promo.terms).tr,
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
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Promo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          promo.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorStyle.primary),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: const Color(0xFFE2E2E2),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Syarat dan Ketentuan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stripHtmlTags(promo.terms),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ]);
      }),
    );
  }
}
