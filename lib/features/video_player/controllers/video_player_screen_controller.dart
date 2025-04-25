import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreenController extends GetxController {
static VideoPlayerScreenController get to => Get.find();

late VideoPlayerController videoController;
late ChewieController chewieController;

var isVideoInitialized = false.obs;
var isVideoPlaying = false.obs;
var isPlayerOnTouch = true.obs;

@override
void onInit() {
  super.onInit();

  setupVideoPlayerController();
}

void setupVideoPlayerController() {
  videoController = VideoPlayerController.asset(
    'assets/videos/senja-teduh-pelita.mp4',
  );

  videoController.initialize().then((value) {
    Future.delayed(const Duration(milliseconds: 500), () {
      isVideoInitialized.value = true;
    });
  });

  chewieController = ChewieController(
    videoPlayerController: videoController,
    autoPlay: true,
  );

  playVideo();
}

void playVideo() {
  if (isVideoPlaying.value) {
    videoController.pause();
    isVideoPlaying.value = !isVideoPlaying.value;
    isPlayerOnTouch.value = true;

    return;
  }

  if (!isVideoPlaying.value) {
    videoController.play();
    isVideoPlaying.value = !isVideoPlaying.value;

    Future.delayed(const Duration(seconds: 2), () {
      isPlayerOnTouch.value = false;
    });

    return;
  }
}

void touchPlayer() {
  isPlayerOnTouch.value = !isPlayerOnTouch.value;

  if (videoController.value.isPlaying) {
    Future.delayed(const Duration(seconds: 2), () {
      isPlayerOnTouch.value = false;
    });

    return;
  }
}

@override
void onClose() {
  videoController.dispose();
  super.onClose();
}
}