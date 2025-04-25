import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/features/home/controllers/profil_controller.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';

import '../../../../configs/routes/route.dart';
import '../components/profil_component/info_card.dart';
import '../components/profil_component/language_option.dart';
import '../components/profil_component/list_tile.dart';
import '../components/profil_component/profil_section.dart';
import '../components/profil_component/section_tile.dart';

class ProfilScreen extends StatelessWidget {
  ProfilScreen({super.key});
  final ProfilController controller = Get.put(ProfilController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Profil'.tr,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorStyle.primary,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 65.w,
              height: 2.h,
              color: ColorStyle.primary,
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        elevation: 3,
        shadowColor: const Color.fromARGB(66, 0, 0, 0),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final user = controller.user.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileSection(controller),
              const SizedBox(height: 16),
              buildSectionTitle("Info Akun".tr),
              buildInfoCard([
                buildListTile("Nama".tr, user?.name ?? "-",
                    withArrow: true,
                    onTap: () => _showNamaBottomSheet(context)),
                buildListTile("Tanggal Lahir".tr, user?.birthDate ?? "-",
                    withArrow: true),
                buildListTile("No.Telepon".tr, user?.phone ?? "-",
                    withArrow: true),
                buildListTile("Email".tr, user?.email ?? "-", withArrow: true),
                buildListTile("Ubah PIN".tr, user?.pin ?? "-", withArrow: true),
                buildListTile(
                  "Ganti Bahasa".tr,
                  controller.selectedLanguage.value == 'id'
                      ? 'Bahasa Indonesia'.tr
                      : 'English'.tr,
                  withArrow: true,
                  onTap: () => _showLanguageBottomSheet(context),
                ),
              ]),
              const SizedBox(height: 16),
              buildInfoCard([
                ListTile(
                  title: Text("Nilai Sekarang".tr),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.reviewRoute);
                    },
                    child: Text(
                      "Rate Now".tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              buildSectionTitle("Info Lainnya".tr),
              buildInfoCard([
                buildListTile(
                  "Device Info".tr,
                  controller.deviceModel.value,
                  withArrow: true,
                ),
                Obx(() => buildListTile(
                    "Device Version".tr, controller.deviceVersion.value,
                    withArrow: true)),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyle.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Log Out'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showNamaBottomSheet(BuildContext context) {
    final controller = ProfilController.to;
    final TextEditingController textController =
        TextEditingController(text: controller.nama.value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("Nama".tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.updateNama(textController.text);
                      Get.back();
                    },
                    child: const Icon(Icons.check_circle, color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final controller = ProfilController.to;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("Ganti Bahasa".tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeLanguage('id'),
                        child: languageOption(
                          "Indonesia".tr,
                          "🇮🇩",
                          isSelected: controller.selectedLanguage.value == 'id',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeLanguage('en'),
                        child: languageOption(
                          "Inggris".tr,
                          "🇬🇧",
                          isSelected: controller.selectedLanguage.value == 'en',
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
