import 'dart:developer';

import 'package:get/get.dart';

import '../../../utils/services/dio_service.dart';
import '../../cart/controllers/cart_controller.dart';

class VoucherController extends GetxController {
  static VoucherController get to => Get.find();

  RxInt selectedVoucherId = (-1).obs;
  RxBool isLoading = false.obs;
  RxList<dynamic> vouchers = <dynamic>[].obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVouchers();
    if (CartController.to.selectedVoucherId.value != -1) {
      selectedVoucherId = CartController.to.selectedVoucherId;
    }
  }

  Future<void> fetchVouchers() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await DioService.getPromos(type: 'voucher');

      if (response != null && response['status_code'] == 200) {
        vouchers.assignAll(response['data'] ?? []);
      } else {
        errorMessage('No vouchers available'.tr);
      }
    } catch (e) {
      errorMessage('Failed to load vouchers'.tr);
      log('Error fetching vouchers: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchVoucherDetail () async {
    
  }

  void selectVoucher(int id) {
    if (selectedVoucherId.value == id) {
      selectedVoucherId.value = -1;
    } else {
      selectedVoucherId.value = id;
    }
  }

  bool isVoucherSelected(int id) {
    return selectedVoucherId.value == id;
  }

  String formatExpiry(int days) {
    if (days == 1) return 'Expires in 1 day';
    return 'Expires in $days days';
  }
}
