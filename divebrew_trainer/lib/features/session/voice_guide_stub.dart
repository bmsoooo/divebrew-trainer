// 비웹 플랫폼용 음성 가이드 스텁 — M3(iOS)에서 flutter_tts 구현으로 교체
import 'voice_guide.dart';

VoiceGuide createPlatformVoiceGuide() => NoopVoiceGuide();
