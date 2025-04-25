import 'package:get/get.dart';

import '../controllers/no_connection_controller.dart';

class NoConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NoConnectionController());
  }
}
