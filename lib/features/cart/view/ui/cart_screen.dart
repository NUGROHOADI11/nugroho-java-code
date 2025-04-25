import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../components/appbar.dart';
import '../components/cart_item.dart';
import '../components/empty_cart.dart';
import '../components/summary.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  final CartController controller = CartController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return buildEmptyCart();
        }
        return Column(
          children: [
            buildCartItemsList(),
            buildOrderSummary(context),
          ],
        );
      }),
    );
  }
}
