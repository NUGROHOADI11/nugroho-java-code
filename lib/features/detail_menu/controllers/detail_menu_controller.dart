import 'dart:developer';
import 'package:get/get.dart';
import '../../../utils/services/dio_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../models/detail_menu_model.dart';

class DetailMenuController extends GetxController {
  static DetailMenuController get to => Get.put(DetailMenuController());
  var menuDetail = Rxn<MenuDetailModel>();
  var isLoading = false.obs;
  var selectedLevel = 0.obs;
  var selectedTopping = <int>[].obs;
  var note = ''.obs;
  var quantity = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      quantity.value = Get.arguments['quantity'];
    }
    final int id = Get.arguments['menuId'];
    final detailCart = CartController.to.getItem(id);
    if (detailCart != null) {
      selectedLevel.value = detailCart.level ?? 0;
      selectedTopping.value = detailCart.topping ?? [];
      note.value = detailCart.notes ?? '';
    }

    fetchDetail(id);
  }

  Future<void> fetchDetail(int id) async {
    isLoading.value = true;
    try {
      isLoading.value = true;
      final response = await DioService.getMenuById(id);
      log('Response: $response');
      if (response != null && response['status_code'] == 200) {
        final data = response['data'];
        if (data != null) {
          menuDetail.value = MenuDetailModel.fromJson(data);
        } else {
          throw Exception('No data found');
        }
      } else if (response != null) {
        throw Exception(
            'Failed to load menu detail: ${response['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Empty response');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail menu');
      log('Error fetching menu detail: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
