import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CompassController extends GetxController {
  static CompassController get to => Get.find();

  var locationPermissionGranted = false.obs;

  CompassEvent? lastReadEvent;
  var lastReadAt = "".obs;

  void checkLocationPermission() async {
    var granted = await Permission.locationWhenInUse.status;

    locationPermissionGranted.value = granted == PermissionStatus.granted;
  }

  void requestLocationPermission() async {
    Permission.locationWhenInUse.request().then((value) {
      checkLocationPermission();
    });
  }

  void setCompassEvent() async {
    final CompassEvent event = await FlutterCompass.events!.first;

    lastReadEvent = event;
    lastReadAt.value = DateTime.now().toIso8601String();
  }

  @override
  void onInit() {
    super.onInit();

    checkLocationPermission();
  }
}
