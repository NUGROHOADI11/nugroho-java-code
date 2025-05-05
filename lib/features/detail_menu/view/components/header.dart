 import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/detail_menu_controller.dart';
import 'qty_button.dart';

Widget buildHeader(menu, DetailMenuController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          menu.menu.nama,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00838F),
          ),
        ),
        Obx(() {
          final qty = controller.quantity.value;
          return Row(
            children: [
              if (qty > 0)
                buildQtyButton(Icons.remove, () {
                  if (qty > 0) controller.quantity.value--;
                }),
              if (qty > 0) ...[
                const SizedBox(width: 8),
                Text('$qty',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
              ],
              buildQtyButton(Icons.add, () {
                controller.quantity.value++;
              }),
            ],
          );
        })
      ],
    );
  }