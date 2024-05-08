import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

import '../helpers/utils.dart';

class AgoraController extends GetxController {
  // Meeeting Timer Helper
  Timer? meetingTimer;
  int meetingDuration = 0;
  var meetingDurationTxt = "00:00".obs;

  // Agora utitilty
  bool muted = false;
  bool muteVideo = false;
  bool backCamera = false;

  late RtcEngine engine;

  @override
  void onReady() {
    initialEngine();
    super.onReady();
  }

  Future initialEngine() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: "appId",
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
  }

  void onToggleMuteAudio() {
    muted = !muted;
    // AgoraRtcEngine.muteLocalAudioStream(muted);
    engine.muteLocalAudioStream(muted);
  }

  void onToggleMuteVideo() {
    muteVideo = !muteVideo;
    engine.muteLocalVideoStream(muteVideo);
  }

  void onSwitchCamera() {
    backCamera = !backCamera;
    engine.switchCamera();
  }

  void startMeetingTimer() async {
    meetingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (meetingTimer) {
        int min = (meetingDuration ~/ 60);
        int sec = (meetingDuration % 60).toInt();

        meetingDurationTxt.value = "$min:$sec";

        if (checkNoSignleDigit(min)) {
          meetingDurationTxt.value = "0$min:$sec";
        }
        if (checkNoSignleDigit(sec)) {
          if (checkNoSignleDigit(min)) {
            meetingDurationTxt.value = "0$min:0$sec";
          } else {
            meetingDurationTxt.value = "$min:0$sec";
          }
        }
        meetingDuration = meetingDuration + 1;
      },
    );
  }
}
