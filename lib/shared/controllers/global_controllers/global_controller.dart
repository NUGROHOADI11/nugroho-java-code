import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/cores/api/api_constant.dart';
import '../../../features/get_location/view/ui/get_location_screen.dart';
import '../../../features/no_connection/view/ui/no_connection_screen.dart';
import '../../../utils/services/hive_service.dart';
import '../../../utils/services/location_service.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();
  var isConnected = false.obs;
  var baseUrl = ApiConstant.production;
  var isStaging = false.obs;

  var id = ''.obs;
  var name = ''.obs;
  var photo = ''.obs;
  RxString statusLocation = RxString('loading');
  RxString messageLocation = RxString('');
  Rxn<Position> position = Rxn<Position>();
  RxnString address = RxnString();

  var locationPermissionGranted = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
    checkConnection();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool hasInternet =
          results.any((result) => result != ConnectivityResult.none);
      isConnected.value = hasInternet;
      if (!hasInternet) {
        Get.to(() => NoConnectionScreen());
      }
    });
  }

  @override
  void onReady() {
    super.onReady();

    getLocation();
    LocationServices.streamService.listen((status) => getLocation());

    id.value = LocalStorageService.box.get("idUser") ?? "";
    name.value = LocalStorageService.box.get("nama") ?? "";
    photo.value = LocalStorageService.box.get("foto") ?? "";
  }

  Future<void> checkConnection() async {
    try {
      List<ConnectivityResult> connectivityResults =
          await Connectivity().checkConnectivity();
      bool hasInternet = connectivityResults
          .any((result) => result != ConnectivityResult.none);
      isConnected.value = hasInternet;
      if (!hasInternet) {
        Get.to(() => NoConnectionScreen());
      }
    } catch (e) {
      isConnected.value = false;
    }
  }

  Future<void> getLocation() async {
    if (Get.isDialogOpen == false) {
      Get.dialog(const GetLocationScreen(), barrierDismissible: false);
    }

    try {
      /// Mendapatkan Lokasi saat ini
      statusLocation.value = 'loading';
      final locationResult = await LocationServices.getCurrentPosition();

      if (locationResult.success) {
        /// Jika jarak lokasi cukup dekat, dapatkan informasi alamat
        position.value = locationResult.position;
        address.value = locationResult.address;
        statusLocation.value = 'success';

        await Future.delayed(const Duration(seconds: 5));
        // Get.offAllNamed(Routes.splashRoute);
      } else {
        /// Jika jarak lokasi tidak cukup dekat, tampilkan pesan
        statusLocation.value = 'error';
        messageLocation.value = locationResult.message!;
      }
    } catch (e) {
      /// Jika terjadi kesalahan server
      statusLocation.value = 'error';
      messageLocation.value = 'Server error'.tr;
    }
  }
}
