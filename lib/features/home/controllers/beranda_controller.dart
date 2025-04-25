import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../utils/services/dio_service.dart';
import '../models/menu_model.dart';
import '../models/promo_model.dart';

class BerandaController extends GetxController {
  static BerandaController get to => Get.find();

  var menuItems = <MenuItem>[].obs;
  var filteredItems = <MenuItem>[].obs;
  var promos = <Promo>[].obs;
  var promoDetail = Rxn<Promo>();
  var selectedCategory = 'semua'.obs;
  var quantity = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
    fetchPromos();
  }

  Future<void> fetchPromos() async {
    try {
      isLoading(true);
      final response = await DioService.getPromos();

      if (response != null && response['status_code'] == 200) {
        final List<dynamic> promoData = response['data'] ?? [];
        promos.assignAll(promoData.map((json) => Promo.fromJson(json)));
      } else {
        throw Exception(
            'Failed to load promos: ${response?['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load promos: ${e.toString()}';
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) print('Promo fetch error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMenuItems() async {
    try {
      isLoading(true);
      errorMessage('');

      Map<String, dynamic>? response;
      if (selectedCategory.value == 'semua') {
        response = await DioService.getMenu();
      } else {
        response = await DioService.getMenu(category: selectedCategory.value);
      }

      if (response == null || response['data'] == null) {
        throw Exception('No menu items found');
      }

      final data = List<Map<String, dynamic>>.from(response['data']);
      menuItems.assignAll(data.map((item) => MenuItem(
            id: item['id_menu'] ?? '0',
            name: item['nama'] ?? 'Unknown Item',
            price: item['harga']?.toInt() ?? 0,
            image: item['foto'] ?? '',
            stock: item['status'] == 1,
            category: item['kategori']?.toLowerCase() ?? 'other',
            description: item['deskripsi'] ?? '',
          )));

      applyFilters();
    } catch (e) {
      errorMessage.value = 'Failed to load menu: ${e.toString()}';
      if (kDebugMode) {
        print('Error in fetchMenuItems: $e');
      }
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category.toLowerCase();
    applyFilters();
    fetchMenuItems();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilters();
  }

  void applyFilters() {
    List<MenuItem> filtered = [];
    if (selectedCategory.value == 'semua') {
      filtered = List.from(menuItems);
    } else {
      filtered = menuItems
          .where((item) => item.category == selectedCategory.value)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) => item.name.toLowerCase().contains(searchQuery.value))
          .toList();
    }

    filteredItems.assignAll(filtered);
  }

  List<MenuItem> getItemsByCategory(String category, {int limit = 0}) {
    var items =
        filteredItems.where((item) => item.category == category).toList();
    if (limit > 0 && items.length > limit) {
      return items.sublist(0, limit);
    }
    return items;
  }

  List<String> getAvailableCategories() {
    return menuItems.map((item) => item.category).toSet().toList();
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }
}
