 import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/styles/color_style.dart';
import '../../../controllers/pesanan_controller.dart';
import '../../../models/order_model.dart';
import 'build_order_list.dart';
 
 Widget buildHistoryOrdersTab(PesananController controller) {
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
              var filteredOrders = controller.displayedHistory;

              // Apply filter status
              if (controller.selectedFilter.value != 'Semua') {
                final selectedStatus =
                    int.tryParse(controller.selectedFilter.value);
                if (selectedStatus != null) {
                  filteredOrders = filteredOrders
                      .where((order) => order.status.value == selectedStatus)
                      .toList()
                      .obs;
                }
              }

              // Apply filter date
              if (controller.selectedDate.value != null) {
                filteredOrders = filteredOrders
                    .where((order) =>
                        order.date.year ==
                            controller.selectedDate.value!.year &&
                        order.date.month ==
                            controller.selectedDate.value!.month &&
                        order.date.day == controller.selectedDate.value!.day)
                    .toList()
                    .obs;
              }

              return buildOrderList(filteredOrders, controller,
                  isOngoing: false);
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