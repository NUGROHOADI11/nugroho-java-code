import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/features/home/controllers/profil_controller.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';
import 'package:pinput/pinput.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/widgets/app_bar.dart';
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
      appBar: CustomAppBar(title: 'Profil'.tr, showUnderline: true,),
        
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
                buildListTile(
                  "Tanggal Lahir".tr,
                  controller.birthDate.value.isNotEmpty
                      ? controller.birthDate.value
                      : user?.birthDate ?? "-",
                  withArrow: true,
                  onTap: () => _selectBirthDate(context),
                ),
                buildListTile(
                  "No.Telepon".tr,
                  controller.phoneNumber.value.isNotEmpty
                      ? controller.phoneNumber.value
                      : user?.phone ?? "-",
                  withArrow: true,
                  onTap: () => _showPhoneBottomSheet(context),
                ),
                buildListTile(
                    "Email".tr,
                    controller.email.value.isNotEmpty
                        ? controller.email.value
                        : user?.phone ?? "-",
                    withArrow: true,
                    onTap: () => _showEmailBottomSheet(context)),
                buildListTile(
                  "Ubah PIN".tr,
                  '••••••',
                  withArrow: true,
                  onTap: () => _showPinBottomSheet(context),
                ),
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
    final textController = TextEditingController(text: controller.nama.value);
    final focusNode = FocusNode();

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        focusNode.addListener(() {
          if (!focusNode.hasFocus) {
            controller.updateNama(textController.text);
            Get.back();
          }
        });

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Enter your name'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8.0),
                TextField(
                  focusNode: focusNode,
                  autofocus: true,
                  controller: textController,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorStyle.primary)),
                    focusColor: ColorStyle.primary,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controller.updateNama(textController.text);
                        Get.back();
                      },
                      child: const Icon(Icons.check_circle,
                          color: ColorStyle.primary),
                    ),
                  ),
                  onSubmitted: (value) {
                    controller.updateNama(value);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectBirthDate(BuildContext context) async {
    final controller = ProfilController.to;
    final initialDate = controller.user.value?.birthDate != null
        ? DateTime.tryParse(controller.user.value!.birthDate)
        : DateTime(2000);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Get.locale,
    );

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      controller.updateBirthDate(formattedDate);
    }
  }

  void _showPhoneBottomSheet(BuildContext context) {
    final controller = ProfilController.to;
    final textController =
        TextEditingController(text: controller.phoneNumber.value);
    final focusNode = FocusNode();

    void validateAndClose() {
      if (controller.updatePhoneNumber(textController.text)) {
        Get.back();
      }
    }

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Enter your phone number'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8.0),
                TextField(
                  focusNode: focusNode,
                  autofocus: true,
                  controller: textController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'e.g. 081234567890',
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorStyle.primary)),
                    focusColor: ColorStyle.primary,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check_circle,
                          color: ColorStyle.primary),
                      onPressed: validateAndClose,
                    ),
                  ),
                  onSubmitted: (_) => validateAndClose(),
                ),
                const SizedBox(height: 16),
                if (controller.phoneNumber.value.isNotEmpty)
                  Text(
                    'Current: ${controller.phoneNumber.value}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEmailBottomSheet(BuildContext context) {
    final controller = ProfilController.to;
    final textController = TextEditingController(text: controller.email.value);
    final focusNode = FocusNode();

    void validateAndClose() {
      if (controller.updateEmail(textController.text)) {
        Get.back();
      }
    }

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Enter your email'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8.0),
                TextField(
                  focusNode: focusNode,
                  autofocus: true,
                  controller: textController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'e.g. example@domain.com',
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorStyle.primary)),
                    focusColor: ColorStyle.primary,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check_circle,
                          color: ColorStyle.primary),
                      onPressed: validateAndClose,
                    ),
                  ),
                  onSubmitted: (_) => validateAndClose(),
                ),
                const SizedBox(height: 16),
                if (controller.email.value.isNotEmpty)
                  Text(
                    'Current: ${controller.email.value}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPinBottomSheet(BuildContext context) {
    final controller = ProfilController.to;
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    // 0 = enter old PIN, 1 = enter new PIN, 2 = confirm new PIN
    int currentStep = 0;

    void proceedToNextStep() {
      if (currentStep < 2) {
        currentStep++;
      } else {
        if (newPinController.text == confirmPinController.text) {
          controller.updatePin(oldPinController.text, newPinController.text);
          Get.back();
        } else {
          EasyLoading.showError('New PINs do not match'.tr);
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                currentStep == 0
                    ? 'Enter Old PIN'.tr
                    : currentStep == 1
                        ? 'Enter New PIN'.tr
                        : 'Confirm New PIN'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Obx(
                    () => Pinput(
                      length: 6,
                      controller: currentStep == 0
                          ? oldPinController
                          : currentStep == 1
                              ? newPinController
                              : confirmPinController,
                      obscureText: !controller.isPinVisible.value,
                      keyboardType: TextInputType.number,
                      closeKeyboardWhenCompleted: true,
                      defaultPinTheme: PinTheme(
                        width: 45,
                        height: 45,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyle.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 45,
                        height: 45,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyle.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 45,
                        height: 45,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyle.primary),
                          borderRadius: BorderRadius.circular(10),
                          color: ColorStyle.primary.withOpacity(0.1),
                        ),
                      ),
                      onCompleted: (pin) async {
                        if (currentStep == 0) {
                          // Verify old PIN
                          final isValid = await controller.verifyOldPin(pin);
                          if (isValid) {
                            proceedToNextStep();
                          } else {
                            EasyLoading.showError('Old PIN is incorrect'.tr);
                            oldPinController.clear();
                          }
                        } else {
                          proceedToNextStep();
                        }
                      },
                    ),
                  ),
                  Obx(() => IconButton(
                        onPressed: () {
                          controller.isPinVisible.toggle();
                        },
                        icon: Icon(
                          controller.isPinVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final currentPin = currentStep == 0
                        ? oldPinController.text
                        : currentStep == 1
                            ? newPinController.text
                            : confirmPinController.text;

                    if (currentPin.length == 6) {
                      if (currentStep == 0) {
                        controller.verifyOldPin(currentPin).then((isValid) {
                          if (isValid) {
                            proceedToNextStep();
                          } else {
                            EasyLoading.showError('Old PIN is incorrect'.tr);
                            oldPinController.clear();
                          }
                        });
                      } else {
                        proceedToNextStep();
                      }
                    } else {
                      EasyLoading.showError('PIN must be 6 digits'.tr);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyle.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    currentStep == 2 ? 'Confirm'.tr : 'Next'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
