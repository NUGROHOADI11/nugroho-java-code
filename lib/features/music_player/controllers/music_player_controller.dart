import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerController extends GetxController {
  static MusicPlayerController get to => Get.find();

  var seekbarValue = 0.0.obs;
  var isPlaying = false.obs;
  var isSeeking = false.obs;
  var audioDuration = Duration.zero.obs; // FIX: Menyimpan durasi audio

  var audioPlayer = AudioPlayer();

  void changeSeekbarValue(double value) {
    seekbarValue.value = value;
  }

  void setIsSeeking(bool value) {
    isSeeking.value = value;
  }

  void playAudio() {
    if (audioPlayer.playerState.processingState == ProcessingState.ready) {
      if (isPlaying.value) {
        audioPlayer.pause();
      } else {
        audioPlayer.play();
      }
      isPlaying.value = !isPlaying.value;
    }
  }

  void setupAudio() async {
    try {
      await audioPlayer.setAsset('assets/audios/starboy-the-weekend.mp3');

      // FIX: Update durasi saat audio selesai dimuat
      audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          audioDuration.value = duration;
        }
      });

    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    setupAudio();
  }

  @override
  void onClose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.onClose();
  }
}
