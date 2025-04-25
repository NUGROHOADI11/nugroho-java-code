import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/skeleton.dart';
import '../../constants/detail_order_assets_constant.dart';
import '../../controllers/detail_order_controller.dart';
import '../components/appbar.dart';
import '../components/content_order.dart';
import '../components/summary_order.dart';

class DetailOrderScreen extends StatelessWidget {
  DetailOrderScreen({super.key});

  final assetsConstant = DetailOrderAssetsConstant();
  final controller = DetailOrderController.to;

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final int orderId = arguments['id'] ?? 0;

    return Scaffold(
        appBar: buildAppBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const SkeletonLoading(count: 1, width: 100.0, height: 300.0);
          }

          final order = controller.orderDetail.value;
          controller.logger.d("logger order $order");
          if (order == null) {
            return const Center(child: Text("Data tidak tersedia"));
          }

          return Column(
            children: [
              buildCartItemsList(orderId),
              if (order.order.status < 4) ...[
                buildOrderSummary(context, orderId),
              ]
            ],
          );
        }));
  }
}
