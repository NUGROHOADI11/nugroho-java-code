import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/pesanan_controller.dart';
import 'build_order_list.dart';

Widget buildOngoingOrdersTab(PesananController controller) {
  return RefreshIndicator(
    onRefresh: () async {
      await controller.fetchOrders();
    },
    child: Obx(() {
      return buildOrderList(controller.displayedOngoing, controller,
          isOngoing: true);
    }),
  );
}
