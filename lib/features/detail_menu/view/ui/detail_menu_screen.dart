import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../controllers/detail_menu_controller.dart';
import '../components/action_button.dart';
import '../components/detail_tile.dart';
import '../components/header.dart';

class DetailMenuScreen extends StatelessWidget {
  const DetailMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailMenuController());
    final cartController = Get.put(CartController());

    final arguments = Get.arguments ?? {};
    final int menuId = arguments['menuId'];
    final int qtyArg = arguments['quantity'] ?? 0;

    if (controller.menuDetail.value == null) {
      controller.fetchDetail(menuId);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: CustomAppBar(
        title: 'Detail Menu'.tr,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const SkeletonLoading(count: 1, width: 100.0, height: 300.0);
        }

        final menu = controller.menuDetail.value;
        if (menu == null) {
          return const Center(child: Text("Data tidak tersedia"));
        }

        return Column(
          children: [
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                menu.menu.foto,
                height: 200,
                width: 300,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 100, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  children: [
                    buildHeader(menu, controller),
                    const SizedBox(height: 8),
                    Text(menu.menu.deskripsi,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    buildDetailTile(Icons.attach_money, 'Harga',
                        menu.menu.harga.formatCurrency(),
                        isPrice: true),
                    buildDetailTile(
                      Icons.local_fire_department,
                      'Level',
                      controller.selectedLevel.value > 0
                          ? (menu.level
                                  .firstWhereOrNull((e) =>
                                      e.id == controller.selectedLevel.value)
                                  ?.keterangan ??
                              'Level tidak ditemukan')
                          : (menu.level.isNotEmpty
                              ? menu.level.first.keterangan
                              : 'Tidak tersedia'),
                      showArrow: menu.level.isNotEmpty,
                      onTap: menu.level.isNotEmpty
                          ? () => _showLevelBottomSheet(context, menu)
                          : null,
                    ),
                    buildDetailTile(
                      Icons.fastfood,
                      'Topping',
                      controller.selectedTopping.isNotEmpty
                          ? menu.topping
                              .where((e) =>
                                  controller.selectedTopping.contains(e.id))
                              .map((e) => e.keterangan)
                              .join(', ')
                          : (menu.topping.isNotEmpty
                              ? 'Pilih Topping'
                              : 'Tidak tersedia'),
                      showArrow: menu.topping.isNotEmpty,
                      onTap: menu.topping.isNotEmpty
                          ? () => _showToppingBottomSheet(context, menu)
                          : null,
                    ),
                    buildDetailTile(
                      Icons.note_alt,
                      'Catatan',
                      controller.note.value.isNotEmpty
                          ? controller.note.value
                          : 'Tambahkan catatan',
                      showArrow: true,
                      onTap: () => _showNoteBottomSheet(context),
                    ),
                    const SizedBox(height: 20),
                    buildActionButton(
                        controller, cartController, menuId, qtyArg, menu),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showLevelBottomSheet(BuildContext context, dynamic menu) {
    final controller = Get.find<DetailMenuController>();

    if (controller.selectedLevel.value == 0 && menu.level.isNotEmpty) {
      controller.selectedLevel.value = menu.level.first.id;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text('Pilih Level'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(() => Wrap(
                    spacing: 8,
                    children: menu.level.map<Widget>((item) {
                      final isSelected =
                          controller.selectedLevel.value == item.id;
                      return ChoiceChip(
                        label: Text(
                          item.keterangan,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          controller.selectedLevel.value = item.id;
                        },
                        selectedColor: ColorStyle.primary,
                        backgroundColor: Colors.grey[200],
                        checkmarkColor: Colors.white,
                      );
                    }).toList(),
                  ))
            ],
          ),
        );
      },
    );
  }

  void _showToppingBottomSheet(BuildContext context, dynamic menu) {
    final controller = Get.find<DetailMenuController>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text('Pilih Topping'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: menu.topping.map<Widget>((item) {
                      final isSelected =
                          controller.selectedTopping.contains(item.id);
                      return ChoiceChip(
                        label: Text(
                          item.keterangan,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            controller.selectedTopping.add(item.id);
                          } else {
                            controller.selectedTopping.remove(item.id);
                          }
                        },
                        selectedColor: ColorStyle.primary,
                        backgroundColor: Colors.grey[200],
                        checkmarkColor: Colors.white,
                      );
                    }).toList(),
                  ))
            ],
          ),
        );
      },
    );
  }

  void _showNoteBottomSheet(BuildContext context) {
    final controller = Get.find<DetailMenuController>();
    final noteController = TextEditingController(text: controller.note.value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding:
              MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text('Buat Catatan'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: 'Contoh: Tidak pedas'.tr,
                  suffixIcon:
                      const Icon(Icons.check_circle, color: ColorStyle.primary),
                ),
                onSubmitted: (val) {
                  controller.note.value = val;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
