import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/features/splash/constants/splash_assets_constant.dart';
import '../../../../configs/routes/route.dart';
import '../../../../utils/services/hive_service.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final assetsConstant = SplashAssetsConstant();
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), (() {
      String? token = LocalStorageService.getToken();
      // String? idUser = LocalStorageService.getUserData()["id_user"].toString();
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(Routes.homeRoute);
      } else {
        Get.offAllNamed(Routes.signInRoute);
      }
    }));
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/Java-Code.png'),
              scale: 2,
            )),
          ),
        ),
      ),
    );
  }
}
