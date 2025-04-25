import 'dart:developer';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../../../utils/services/dio_service.dart';
import '../../detail_menu/models/detail_menu_model.dart';
import '../models/cart_model.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  final logger = Logger();
  late final Box<CartItemModel> _cartBox;

  final items = <CartItemModel>[].obs;
  final menuDetails = <int, MenuDetailModel>{};

  final menuDetail = Rxn<MenuDetailModel>();
  final discounts = <dynamic>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedVoucherId = (-1).obs;
  final selectedVoucherValue = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _cartBox = Hive.box<CartItemModel>('cart');
    loadCartItems();
    preloadMenuDetails();
    fetchDiscounts();
  }

  // Load & Update Cart
  void loadCartItems() => items.assignAll(_cartBox.values.toList());

  void addItem(CartItemModel newItem) {
    final index = items.indexWhere((item) => item.isSameItem(newItem));
    if (index != -1) {
      final updated = items[index].copyWith(
        jumlah: items[index].jumlah + newItem.jumlah,
      );
      updateItem(index, updated);
    } else {
      _cartBox.add(newItem);
      loadCartItems();
    }
  }

  void updateItem(int index, CartItemModel updatedItem) {
    if (index < 0 || index >= _cartBox.length) return;
    final key = _cartBox.keyAt(index);
    _cartBox.put(key, updatedItem);
    loadCartItems();
  }

  void removeItem(int index) {
    if (index < 0 || index >= _cartBox.length) return;
    final key = _cartBox.keyAt(index);
    _cartBox.delete(key);
    loadCartItems();
  }

  void clearCart() {
    _cartBox.clear();
    loadCartItems();
  }

  // Menu Details
  void preloadMenuDetails() {
    for (final item in items) {
      if (!menuDetails.containsKey(item.menuId)) {
        fetchDetail(item.menuId);
      }
    }
  }

  Future<void> fetchDetail(int id) async {
    _setLoading(true);
    try {
      final response = await DioService.getMenuById(id);
      _handleMenuDetailResponse(id, response);
      logger.d(response);
    } catch (e) {
      log('Error fetching menu detail: $e');
      Get.snackbar('Error', 'Gagal memuat detail menu');
    } finally {
      _setLoading(false);
    }
  }

  void _handleMenuDetailResponse(int id, dynamic response) {
    if (response != null && response['status_code'] == 200) {
      final data = response['data'];
      if (data != null) {
        final detail = MenuDetailModel.fromJson(data);
        menuDetails[id] = detail;
        menuDetail.value = detail;
      }
    } else {
      final message = response?['message'] ?? 'Unknown error';
      throw Exception('Failed to load menu detail: $message');
    }
  }

  // Voucher
  Future<void> fetchDiscounts() async {
    _setLoading(true);
    try {
      final response = await DioService.getPromos(type: 'diskon');
      if (response != null && response['status_code'] == 200) {
        discounts.assignAll(response['data'] ?? []);
      } else {
        errorMessage('No vouchers available'.tr);
      }
    } catch (e) {
      log('Error fetching vouchers: $e');
      errorMessage('Failed to load vouchers'.tr);
    } finally {
      _setLoading(false);
    }
  }

  void applyVoucher(int id, int value) {
    selectedVoucherId.value = id;
    selectedVoucherValue.value = value;
  }

  int calculateDiscount() {
    try {
      if (discounts.isEmpty) return 0;

      double totalDiscount = 0;
      double remainingAmount = subTotalPrice.toDouble();

      for (var item in discounts) {
        final percent = (item['diskon']?.toDouble() ?? 0);
        final discount = (percent / 100) * remainingAmount;
        totalDiscount += discount;
        remainingAmount -= discount;
      }

      return totalDiscount.round();
    } catch (e) {
      log('Error calculating discount: $e');
      return 0;
    }
  }

  // Calculate
  int get subTotalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalLevelPrice =>
      items.fold(0, (sum, item) => sum + (item.hargaLevel ?? 0));

  int get totalToppingPrice =>
      items.fold(0, (sum, item) => sum + (item.hargaTopping ?? 0));

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.jumlah);

  int get totalPrice {
    final discount =
        hasSelectedVoucher ? selectedVoucherValue.value : calculateDiscount();
    return math.max(0, subTotalPrice - discount);
  }

  // Helper Getters
  bool get hasSelectedVoucher => selectedVoucherId.value != -1;

  bool isItemInCart(int id) => items.any((item) => item.menuId == id);

  int getQuantity(int id) => items
      .where((item) => item.menuId == id)
      .fold(0, (sum, item) => sum + item.jumlah);

  CartItemModel? getItem(int id) =>
      items.firstWhereOrNull((item) => item.menuId == id);

  // Utility
  void _setLoading(bool value) => isLoading.value = value;
}
