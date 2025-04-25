import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:nugroho_javacode/features/home/controllers/beranda_controller.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../configs/routes/route.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../components/beranda_component/category_button.dart';
import '../components/beranda_component/category_components.dart';
import '../components/beranda_component/promo_section.dart';
import '../components/beranda_component/search_field.dart';

class BerandaScreen extends StatelessWidget {
  BerandaScreen({super.key});

  final BerandaController controller =
      Get.put(BerandaController(), permanent: true);
  final CartController cartController = Get.put(CartController());
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearchField(controller),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        elevation: 1,
        shadowColor: const Color.fromARGB(66, 0, 0, 0),
        backgroundColor: Colors.white,
        actions: [
          Obx(() {
            return IconButton(
              icon: badges.Badge(
                showBadge: cartController.totalQuantity > 0,
                badgeContent: Text(
                  cartController.totalQuantity.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child:
                    const Icon(Icons.shopping_cart, color: ColorStyle.primary),
              ),
              onPressed: () {
                Get.toNamed(Routes.cartRoute);
              },
            );
          }),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await controller.fetchMenuItems();
          await controller.fetchPromos();
          _refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildPromoSection(controller),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: buildCategoryButtons(controller),
              ),
              Obx(() {
                if (controller.isLoading.value &&
                    controller.menuItems.isEmpty) {
                  return const SkeletonLoading(
                      count: 3, width: 100.0, height: 50.0);
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.fetchMenuItems();
                        _refreshController.refreshCompleted();
                      },
                      child: Text('Retry'.tr),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.selectedCategory.value == 'semua')
                        buildAllCategoriesView(controller, cartController)
                      else
                        buildSingleCategoryView(controller, cartController),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
