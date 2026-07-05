// 음성 가이드 추상화 계층 — 웹(Web Speech API)/앱(flutter_tts, M3)을 같은 인터페이스로 분기
import 'voice_guide_stub.dart'
    if (dart.library.js_interop) 'voice_guide_web.dart';

abstract class VoiceGuide {
  /// [lang]은 BCP-47 코드 (예: 'ko-KR', 'en-US').
  void speak(String text, {required String lang});

  /// 재생 중인 음성을 즉시 중단.
  void stop();
}

/// 음성 미지원 환경(테스트·미구현 플랫폼)용.
class NoopVoiceGuide implements VoiceGuide {
  @override
  void speak(String text, {required String lang}) {}

  @override
  void stop() {}
}

/// 현재 플랫폼에 맞는 구현을 반환한다.
VoiceGuide createVoiceGuide() => createPlatformVoiceGuide();
