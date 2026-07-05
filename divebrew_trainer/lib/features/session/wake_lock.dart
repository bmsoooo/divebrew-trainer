// Wake Lock 추상화 — 세션 중 화면 꺼짐 방지 (웹: Screen Wake Lock API / 비웹: no-op)
import 'wake_lock_stub.dart'
    if (dart.library.js_interop) 'wake_lock_web.dart';

abstract class SessionWakeLock {
  Future<void> acquire();
  Future<void> release();
}

/// 미지원 환경용.
class NoopWakeLock implements SessionWakeLock {
  @override
  Future<void> acquire() async {}

  @override
  Future<void> release() async {}
}

SessionWakeLock createWakeLock() => createPlatformWakeLock();
