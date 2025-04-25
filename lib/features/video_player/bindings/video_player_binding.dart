import 'package:get/get.dart';

import '../controllers/video_player_screen_controller.dart';

class VideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoPlayerScreenController());
  }
}
