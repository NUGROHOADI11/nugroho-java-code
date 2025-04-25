import 'package:get/get.dart';

import '../controllers/get_location_controller.dart';
    class GetLocationBinding extends Bindings {
      @override
      void dependencies() {
        Get.put(GetLocationController());
      }
    }
    