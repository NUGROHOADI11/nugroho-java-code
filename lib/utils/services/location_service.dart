import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationServices {
  LocationServices._();

  static Stream<ServiceStatus> streamService =
      Geolocator.getServiceStatusStream();

  static Future<LocationResult> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult.error(message: 'Layanan lokasi tidak aktif'.tr);
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult.error(
          message: 'Tidak mendapatkan izin lokasi'.tr,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult.error(
        message: 'Izin lokasi ditolak'.tr,
      );
    }

    late Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      return LocationResult.error(message: 'Layanan lokasi tidak aktif'.tr);
    }

    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        -7.719722251040289,
        113.00967241225585);

    if (distanceInMeters > 100000000) {
      return LocationResult.error(message: 'terlalu jauh dari lokasi'.tr);
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      return LocationResult.error(message: 'Lokasi tidak diketahui'.tr);
    }

    return LocationResult.success(
      position: position,
      address: [
        placemarks.first.name,
        placemarks.first.subLocality,
        placemarks.first.locality,
        placemarks.first.administrativeArea,
        placemarks.first.postalCode,
        placemarks.first.country,
      ].where((e) => e != null).join(', '),
    );
  }
}

class LocationResult {
  final bool success;
  final Position? position;
  final String? address;
  final String? message;

  LocationResult({
    required this.success,
    this.position,
    this.address,
    this.message,
  });

  factory LocationResult.success(
      {required Position position, required String address}) {
    return LocationResult(
      success: true,
      position: position,
      address: address,
    );
  }

  factory LocationResult.error({required String message}) {
    return LocationResult(
      success: false,
      message: message,
    );
  }
}