 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';

import '../../../../../configs/routes/route.dart';
import '../../../controllers/pesanan_controller.dart';
import '../../../models/order_model.dart';

Widget buildOrderList(List<Order> orders, PesananController controller,
      {required bool isOngoing}) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada pesanan.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!controller.isLoadingMoreOngoing.value &&
            !controller.isLoadingMoreHistory.value &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          if (isOngoing) {
            controller.loadMoreOngoing();
          } else {
            controller.loadMoreHistory();
          }
        }
        return false;
      },
      child: ListView.builder(
        itemCount: orders.length + 1,
        itemBuilder: (context, index) {
          if (index < orders.length) {
            final order = orders[index];
            return _buildOrderCard(order, controller);
          } else {
            return Obx(() {
              bool isLoading = isOngoing
                  ? controller.isLoadingMoreOngoing.value
                  : controller.isLoadingMoreHistory.value;

              if (isLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: const Center(child: CircularProgressIndicator.adaptive()),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Load More',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order, PesananController controller) {
    final itemNames = order.items.map((e) => e.name).join(', ');
    final totalQty = order.items.fold(0, (sum, item) => sum + item.quantity);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            order.items.first.image,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.fastfood,
              size: 60,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, color: order.statusColor, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.formattedStatus,
                    style: TextStyle(
                      color: order.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  order.formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              itemNames,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${order.totalPayment.formatCurrency()} ($totalQty item)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        onTap: (order.status.value < 3)
            ? () {
                Get.toNamed(Routes.detailOrderRoute,
                    arguments: {'id': order.id});
              }
            : null,
      ),
    );
  }