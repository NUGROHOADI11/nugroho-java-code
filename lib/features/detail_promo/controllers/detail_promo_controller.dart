import 'package:get/get.dart';

import '../../../utils/services/dio_service.dart';
import '../../home/models/promo_model.dart';

class DetailPromoController extends GetxController {
  static DetailPromoController get to => Get.find();
  var quantity = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var promoDetail = Rxn<Promo>();

  Future<void> detailPromo(int id) async {
    try {
      isLoading(true);
      final response = await DioService.getPromoById(id);

      if (response != null && response['status_code'] == 200) {
        final data = response['data'];
        if (data != null) {
          promoDetail.value = Promo.fromJson(data);
        } else {
          throw Exception('No promo data found');
        }
      } else {
        throw Exception(
            'Failed to load promo detail: ${response?['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load promo detail: ${e.toString()}';
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
