// 비웹 플랫폼용 Wake Lock 스텁 — M3(iOS)에서 네이티브 구현으로 교체
import 'wake_lock.dart';

SessionWakeLock createPlatformWakeLock() => NoopWakeLock();
