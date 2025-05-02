import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../controllers/detail_promo_controller.dart';
import '../components/detail_section.dart';
import '../components/promo_header.dart';

class DetailPromoScreen extends StatelessWidget {
  const DetailPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailPromoController>();
    final promoId = Get.arguments['id'];

    if (promoId != null) {
      controller.detailPromo(promoId);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: CustomAppBar(title: "Promo".tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: SkeletonLoading(count: 1, width: 100.0, height: 300.0));
        }

        final promo = controller.promoDetail.value;
        if (promo == null) {
          return const Center(child: Text('Promo not found'));
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            buildPromoHeader(context, promo, controller),
            const SizedBox(height: 16),
            buildPromoDetails(promo, controller),
          ],
        );
      }),
    );
  }
}
