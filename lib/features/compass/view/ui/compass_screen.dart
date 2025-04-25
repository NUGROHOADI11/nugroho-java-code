import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../constants/cores/assets/image_constant.dart';
import '../../constants/compass_assets_constant.dart';
import '../../controllers/compass_controller.dart';

class CompassScreen extends StatelessWidget {
  CompassScreen({super.key});

  final assetsConstant = CompassAssetsConstant();
  @override
  Widget build(BuildContext context) {
    var controller = CompassController.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Compass'),
        leading: const BackButton(),
      ),
      body: Obx(() {
        var locationPermissionGranted =
            controller.locationPermissionGranted.value;

        if (!locationPermissionGranted) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.requestLocationPermission(),
                  child: const Text('Izinkan Akses Lokasi'),
                ),
                ElevatedButton(
                  onPressed: () => openAppSettings(),
                  child: const Text('Buka Pengaturan Aplikasi'),
                ),
              ],
            ),
          );
        }

        var lastRead = controller.lastReadEvent;
        var lastReadAt = controller.lastReadAt;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    child: const Text('Read Value'),
                    onPressed: () => controller.setCompassEvent(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '$lastRead',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '$lastReadAt',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<CompassEvent>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error reading heading: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    double? direction = snapshot.data!.heading ?? 0.0;

                    return Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 4.0,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Transform.rotate(
                          angle: (direction * (3.14 / 180) * -1),
                          child: Image.asset(
                            ImageConstant.icCompass,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
