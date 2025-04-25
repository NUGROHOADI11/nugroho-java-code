import 'package:get/get.dart';
import '../../../utils/services/hive_service.dart';
import '../../controllers/global_controllers/global_controller.dart';

class GlobalBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
    Get.putAsync<LocalStorageService>(() => LocalStorageService().init());
  }
}
