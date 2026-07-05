// 웹 음성 가이드 — Web Speech API(speechSynthesis) 구현
import 'package:web/web.dart' as web;

import 'voice_guide.dart';

class WebVoiceGuide implements VoiceGuide {
  @override
  void speak(String text, {required String lang}) {
    final utterance = web.SpeechSynthesisUtterance(text)..lang = lang;
    web.window.speechSynthesis.speak(utterance);
  }

  @override
  void stop() {
    web.window.speechSynthesis.cancel();
  }
}

VoiceGuide createPlatformVoiceGuide() => WebVoiceGuide();
