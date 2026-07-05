// 웹 Wake Lock — Screen Wake Lock API로 세션 중 화면 유지 (미지원 브라우저는 조용히 무시)
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'wake_lock.dart';

class WebWakeLock implements SessionWakeLock {
  web.WakeLockSentinel? _sentinel;

  @override
  Future<void> acquire() async {
    try {
      _sentinel = await web.window.navigator.wakeLock.request('screen').toDart;
    } catch (_) {
      // 미지원 브라우저·권한 거부 — 화면 유지 없이 세션은 계속 진행.
      _sentinel = null;
    }
  }

  @override
  Future<void> release() async {
    try {
      await _sentinel?.release().toDart;
    } catch (_) {
      // 이미 해제된 경우 무시.
    }
    _sentinel = null;
  }
}

SessionWakeLock createPlatformWakeLock() => WebWakeLock();
