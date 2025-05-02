import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_bar.dart';
import '../../controllers/cart_controller.dart';
import '../components/cart_item.dart';
import '../components/empty_cart.dart';
import '../components/summary.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  final CartController controller = CartController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cart'.tr,
        titleIcon: Icons.shopping_cart,
        // action: IconButton(
        //     onPressed: controller.clearCart,
        //     icon: const Icon(
        //       Icons.delete,
        //       color: ColorStyle.primary,
        //     )),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
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
