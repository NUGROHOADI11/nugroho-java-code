import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../../shared/styles/google_text_style.dart';
import '../../constants/music_player_assets_constant.dart';
import '../../controllers/music_player_controller.dart';

class MusicPlayerScreen extends StatelessWidget {
  MusicPlayerScreen({super.key});

  final assetsConstant = MusicPlayerAssetsConstant();
  @override
  Widget build(BuildContext context) {
    var controller = MusicPlayerController.to;

    return Scaffold(
    backgroundColor: ColorStyle.dark,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            Row(
              children: [
                SizedBox(width: 24.w),
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: ColorStyle.white,
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Icon(
                  Icons.share,
                  color: ColorStyle.white,
                ),
                SizedBox(width: 16.w),
                const Icon(
                  Icons.more_vert,
                  color: ColorStyle.white,
                ),
                SizedBox(width: 24.w),
              ],
            ),
            SizedBox(height: 36.h),
            Container(
              constraints: BoxConstraints(maxHeight: 300.h, maxWidth: 300.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  'https://i.scdn.co/image/ab67616d0000b2734718e2b124f79258be7bc452',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Starboy',
              style: GoogleTextStyle.fw700.copyWith(
                color: ColorStyle.white,
                fontSize: 36.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'The Weeknd ft. Deaft Punk',
              style: GoogleTextStyle.fw500.copyWith(
                color: ColorStyle.white.withOpacity(0.8),
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),
            StreamBuilder(
              stream: controller.audioPlayer.positionStream,
              builder: (context, positionStreamSnapshot) {
                return Row(
                  children: [
                    Expanded(
                      child: SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 3,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                            pressedElevation: 2,
                          ),
                        ),
                        child: Obx(() {
                          var seekValue = positionStreamSnapshot
                                  .data?.inMilliseconds
                                  .toDouble() ??
                              0;

                          var isSeeking = controller.isSeeking.value;
                          if (isSeeking) {
                            seekValue = controller.seekbarValue.value;
                          }

                          return Slider(
                            max: controller
                                    .audioPlayer.duration?.inMilliseconds
                                    .toDouble() ??
                                1,
                            min: 0,
                            value: seekValue,
                            onChanged: (value) {
                              controller.changeSeekbarValue(value);
                            },
                            onChangeStart: (value) {
                              controller.setIsSeeking(true);
                            },
                            onChangeEnd: (value) {
                              controller.setIsSeeking(false);
                            },
                            activeColor: ColorStyle.white,
                            inactiveColor: ColorStyle.white.withOpacity(0.3),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              children: [
                SizedBox(width: 24.w),
                StreamBuilder(
                  stream: controller.audioPlayer.positionStream,
                  builder: (context, positionStreamSnapshot) {
                    var duration = positionStreamSnapshot.data;
                    var durationSecond = duration?.inSeconds;

                    if ((duration?.inSeconds ?? 0) > 59) {
                      durationSecond = (duration?.inSeconds ?? 1) % 60;
                    }
                    return Text(
                      '0${duration?.inMinutes}:${(durationSecond ?? 0) < 10 ? '0' : ''}$durationSecond',
                      style: GoogleTextStyle.fw600.copyWith(
                        color: ColorStyle.white,
                      ),
                    );
                  },
                ),
                const Expanded(child: SizedBox()),
                Obx(() {
                  var audioDuration = controller.audioDuration.value;
                  var secondsLeft = audioDuration.inSeconds % 60;

                  return Text(
                    '0${audioDuration.inMinutes}:${secondsLeft < 10 ? '0' : ''}$secondsLeft',
                    style: GoogleTextStyle.fw600.copyWith(
                      color: ColorStyle.white,
                    ),
                  );
                }),
                SizedBox(width: 24.w),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 24.w),
                InkWell(
                  child: Icon(
                    Icons.shuffle,
                    color: ColorStyle.white.withOpacity(0.4),
                  ),
                ),
                const Expanded(child: SizedBox()),
                const InkWell(
                  child: Icon(
                    Icons.skip_previous_rounded,
                    color: ColorStyle.white,
                    size: 36,
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () => controller.playAudio(),
                  child: Obx(() {
                    var isPlaying = controller.isPlaying.value;
                    return Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: ColorStyle.white,
                      size: 64,
                    );
                  }),
                ),
                SizedBox(width: 8.w),
                const InkWell(
                  child: Icon(
                    Icons.skip_next_rounded,
                    color: ColorStyle.white,
                    size: 36,
                  ),
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  child: Icon(
                    Icons.repeat,
                    color: ColorStyle.white.withOpacity(0.4),
                  ),
                ),
                SizedBox(width: 24.w),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
}