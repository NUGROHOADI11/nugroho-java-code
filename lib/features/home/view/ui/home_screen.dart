import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:nugroho_javacode/features/home/controllers/pesanan_controller.dart';
import '../../../../shared/styles/color_style.dart';
import '../../constants/home_assets_constant.dart';
import '../../controllers/home_controller.dart';
import 'beranda_screen.dart';
import 'pesanan_screen.dart';
import 'profil_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controll = Get.put(HomeController());
  final PesananController orderControll = Get.put(PesananController());

  final assetsConstant = HomeAssetsConstant();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: _buildBody(controll.currentNavIndex.value),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BottomNavigationBar(
              backgroundColor: ColorStyle.dark,
              selectedItemColor: ColorStyle.light,
              unselectedItemColor: ColorStyle.secondary,
              showUnselectedLabels: true,
              currentIndex: controll.currentNavIndex.value,
              onTap: (index) {
                controll.currentNavIndex.value = index;
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: 'Beranda'.tr,
                ),
                BottomNavigationBarItem(
                  icon: badges.Badge(
                      showBadge: orderControll.displayedOngoing.isNotEmpty,
                      badgeContent: Text(
                        orderControll.getActiveOrderCount().toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      badgeStyle: BadgeStyle(
                      badgeColor: ColorStyle.primary,
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorStyle.light, 
                        width: 1, 
                      ),
                    ),
                      child: const Icon(Icons.notifications_sharp)),
                  label: 'Pesanan'.tr,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_circle_outlined),
                  label: 'Profil'.tr,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return BerandaScreen();
      case 1:
        return const PesananScreen();
      case 2:
        return ProfilScreen();
      default:
        return Container();
    }
  }
}
