import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/skeleton.dart';
import '../../controllers/pesanan_controller.dart';
import '../components/pesanan_component/app_bar.dart';
import '../components/pesanan_component/history_tab.dart';
import '../components/pesanan_component/ongoing_tab.dart';

class PesananScreen extends StatelessWidget {
  const PesananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PesananController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildAppBar(),
        body: Obx(() {
          if (controller.isLoading.value &&
              controller.displayedOngoing.isEmpty &&
              controller.displayedHistory.isEmpty) {
            return const Center(
              child: SkeletonLoading(count: 3, width: 100.0, height: 50.0),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          return TabBarView(
            children: [
              buildOngoingOrdersTab(controller),
              buildHistoryOrdersTab(controller),
            ],
          );
        }),
      ),
    );
  }
}
