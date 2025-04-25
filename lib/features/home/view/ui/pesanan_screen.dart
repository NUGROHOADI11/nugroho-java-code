import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../controllers/pesanan_controller.dart';
import '../../models/order_model.dart';

class PesananScreen extends StatelessWidget {
  const PesananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PesananController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Obx(() {
          if (controller.isLoading.value && controller.orders.isEmpty) {
            return const Center(
              child: SkeletonLoading(count: 3, width: 100.0, height: 50.0),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          final ongoingOrders = _filterOrders(controller.orders, [
            OrderStatus.inQueue,
            OrderStatus.preparing,
            OrderStatus.readyForPickup,
          ]);

          final historyOrders = _filterOrders(controller.orders, [
            OrderStatus.completed,
            OrderStatus.cancelled,
          ]);

          return TabBarView(
            children: [
              _buildOngoingOrdersTab(controller, ongoingOrders),
              _buildHistoryOrdersTab(controller, historyOrders),
            ],
          );
        }),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: TabBar(
        dividerColor: Colors.transparent,
        labelColor: ColorStyle.primary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: ColorStyle.primary,
        tabs: [
          Tab(
            child: Text(
              'Sedang Berjalan'.tr,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              'Riwayat'.tr,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      elevation: 3,
      shadowColor: const Color.fromARGB(66, 0, 0, 0),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildOngoingOrdersTab(
      PesananController controller, List<Order> ongoingOrders) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchOrders();
      },
      child: _buildOrderList(ongoingOrders, controller),
    );
  }

  Widget _buildHistoryOrdersTab(
      PesananController controller, List<Order> historyOrders) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildFilterRow(controller),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchOrders();
            },
            child: Obx(() {
              var filteredOrders = _applyFilters(
                historyOrders,
                controller.selectedFilter.value,
                controller.selectedDate.value,
              );

              return _buildOrderList(filteredOrders, controller);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow(PesananController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusDropdown(controller),
          _buildDatePickerButton(controller),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(PesananController controller) {
    return Obx(
      () => DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: controller.selectedFilter.value,
          items: [
            const DropdownMenuItem<String>(
              value: 'Semua',
              child: Text('Semua Status'),
            ),
            DropdownMenuItem<String>(
              value: OrderStatus.completed.value.toString(),
              child: Text(OrderStatus.completed.displayName.toString()),
            ),
            DropdownMenuItem<String>(
              value: OrderStatus.cancelled.value.toString(),
              child: Text(OrderStatus.cancelled.displayName.toString()),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              controller.selectedFilter.value = value;
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: ColorStyle.primary),
            ),
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerButton(PesananController controller) {
    return Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: ColorStyle.primary),
          ),
        ),
        onPressed: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: Get.context!,
            initialDate: controller.selectedDate.value ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            controller.selectedDate.value = pickedDate;
          }
        },
        child: Row(
          children: [
            Text(
              controller.selectedDate.value != null
                  ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                  : 'Pilih Tanggal',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorStyle.secondary,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.calendar_month,
                size: 16, color: ColorStyle.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, PesananController controller) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada pesanan.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length + (controller.hasMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == orders.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: controller.isLoadingMore.value
                  ? const SkeletonLoading()
                  : const SizedBox(),
            ),
          );
        }

        final order = orders[index];
        return _buildOrderCard(order, controller);
      },
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
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.fastfood),
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
        onTap: () {
          if (order.status.value < 4) {
            Get.toNamed(Routes.detailOrderRoute, arguments: {'id': order.id});
          }
        },
      ),
    );
  }

  List<Order> _filterOrders(List<Order> orders, List<OrderStatus> statuses) {
    return orders.where((order) => statuses.contains(order.status)).toList();
  }

  List<Order> _applyFilters(
      List<Order> orders, String selectedFilter, DateTime? selectedDate) {
    var filteredOrders = selectedFilter == 'Semua'
        ? orders
        : orders
            .where((order) => order.status.value.toString() == selectedFilter)
            .toList();

    if (selectedDate != null) {
      filteredOrders = filteredOrders.where((order) {
        final orderDate = order.date;
        return orderDate.year == selectedDate.year &&
            orderDate.month == selectedDate.month &&
            orderDate.day == selectedDate.day;
      }).toList();
    }

    return filteredOrders;
  }
}
