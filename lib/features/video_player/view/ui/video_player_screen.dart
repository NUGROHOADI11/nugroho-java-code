import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/video_player_assets_constant.dart';
import '../../controllers/video_player_screen_controller.dart';

class VideoPlayerScreen extends StatelessWidget {
VideoPlayerScreen({super.key});

final assetsConstant = VideoPlayerAssetsConstant();
@override
Widget build(BuildContext context) {
  var controller = VideoPlayerScreenController.to;

  return Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: Column(
        children: [
          Obx(() {
            var isVideoInitialized = controller.isVideoInitialized.value;
            if (!isVideoInitialized) {
              return const Center(child: CircularProgressIndicator());
            }

            return AspectRatio(
              aspectRatio: controller.videoController.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Chewie(controller: controller.chewieController),
                ],
              ),
            );
          }),
        ],
      ),
    ),
  );
}
}