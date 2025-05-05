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
        enablePullDown: true,
        enablePullUp: false,
        physics: const AlwaysScrollableScrollPhysics(),
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  buildPromoSection(),
                  const SizedBox(height: 10),
                  buildCategoryButtons(controller),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isMenuLoading.value &&
                    controller.menuItems.isEmpty) {
                  return const SkeletonLoading(
                      count: 3, width: 100.0, height: 50.0);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.selectedCategory.value == 'semua')
                      buildAllCategoriesView(controller, cartController)
                    else
                      buildSingleCategoryView(controller, cartController),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    try {
      await controller.fetchMenuItems();
      await controller.fetchPromos();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }
}
