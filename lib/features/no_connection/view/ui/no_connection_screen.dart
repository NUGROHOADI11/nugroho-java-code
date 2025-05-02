import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/shared/controllers/global_controllers/global_controller.dart';
import '../../../../shared/styles/color_style.dart';
import '../../constants/no_connection_assets_constant.dart';

class NoConnectionScreen extends StatelessWidget {
  NoConnectionScreen({super.key});

  final assetsConstant = NoConnectionAssetsConstant();
  final GlobalController connectivityController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.signal_wifi_off,
              size: 100,
              color: ColorStyle.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops Tidak ada koneksi internet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorStyle.primary),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pastikan wifi atau data seluler terhubung,',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Text(
              'lalu tekan tombol coba lagi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  await connectivityController.checkConnection();
                  if (connectivityController.isConnected.value) {
                    Get.back();
                  } else {
                    Get.snackbar(
                      "Tidak Ada Koneksi".tr,
                      "Masih tidak ada koneksi, coba lagi nanti.".tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
