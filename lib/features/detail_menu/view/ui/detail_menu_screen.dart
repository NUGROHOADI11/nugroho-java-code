import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/extensions/int_extensions.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../../cart/models/cart_model.dart';
import '../../controllers/detail_menu_controller.dart';
import '../../models/detail_menu_model.dart';
import '../components/detail_tile.dart';
import '../components/qty_button.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Detail Menu'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
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
                    _buildHeader(menu, controller),
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
                    _buildActionButton(
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

  Widget _buildHeader(menu, DetailMenuController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          menu.menu.nama,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00838F),
          ),
        ),
        Obx(() {
          final qty = controller.quantity.value;
          return Row(
            children: [
              if (qty > 0)
                buildQtyButton(Icons.remove, () {
                  if (qty > 0) controller.quantity.value--;
                }),
              if (qty > 0) ...[
                const SizedBox(width: 8),
                Text('$qty',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
              ],
              buildQtyButton(Icons.add, () {
                controller.quantity.value++;
              }),
            ],
          );
        })
      ],
    );
  }

  Widget _buildActionButton(
    DetailMenuController controller,
    CartController cartController,
    int menuId,
    int qtyArg,
    dynamic menu,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final qty = controller.quantity.value;

          if (qty == 0) {
            Get.snackbar(
              'Peringatan',
              'Silahkan pilih jumlah pesanan',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final selectedLevelDetail = controller.menuDetail.value!.level
              .firstWhere((level) => level.id == controller.selectedLevel.value,
                  orElse: () => DetailItem(id: 0, keterangan: '', harga: 0));

          final selectedToppingDetails =
              controller.selectedTopping.map((toppingId) {
            return controller.menuDetail.value!.topping.firstWhere(
                (topping) => topping.id == toppingId,
                orElse: () => DetailItem(id: 0, keterangan: '', harga: 0));
          }).toList();

          final totalToppingPrice = selectedToppingDetails
              .map((topping) => topping.harga)
              .fold(0, (previousValue, element) => previousValue + element);

          final totalPrice =
              menu.menu.harga + selectedLevelDetail.harga + totalToppingPrice;

          if (qtyArg > 0) {
            final existingIndex =
                cartController.cartItems.indexWhere((e) => e.menuId == menuId);
            if (existingIndex != -1) {
              final updatedItem =
                  cartController.cartItems[existingIndex].copyWith(
                jumlah: qty,
                level: controller.selectedLevel.value,
                topping: controller.selectedTopping,
                notes: controller.note.value,
                hargaLevel: selectedLevelDetail.harga,
                hargaTopping: totalToppingPrice,
              );
              cartController.updateItem(existingIndex, updatedItem);
            }
            Get.back();
            Get.snackbar("Sukses", "Pesanan diperbarui",
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3));
          } else {
            cartController.addItem(CartItemModel(
              menuId: menuId,
              productName: menu.menu.nama,
              harga: totalPrice,
              jumlah: qty,
              imageUrl: menu.menu.foto,
              level: controller.selectedLevel.value,
              hargaLevel: selectedLevelDetail.harga,
              topping: controller.selectedTopping,
              hargaTopping: totalToppingPrice,
              notes: controller.note.value,
            ));
            Get.back();
            Get.snackbar("Sukses", "Pesanan ditambahkan",
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorStyle.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          qtyArg > 0 ? 'Update Pesanan'.tr : 'Tambahkan Ke Pesanan'.tr,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
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
              const Text('Pilih Level',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              const Text('Pilih Topping',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              const Text('Buat Catatan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Tidak pedas',
                  suffixIcon:
                      Icon(Icons.check_circle, color: ColorStyle.primary),
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
