import 'package:get/get.dart';

import '../controllers/detail_promo_controller.dart';

class DetailPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailPromoController());
  }
}
