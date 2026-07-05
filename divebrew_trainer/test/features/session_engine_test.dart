// 세션 상태 머신의 상태 전이 단위 테스트 (checklist M1 verify)
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/features/session/session_engine.dart';

void main() {
  const twoRounds = [
    Round(breathSec: 3, holdSec: 2),
    Round(breathSec: 2, holdSec: 4),
  ];

  SessionEngine started(List<Round> rounds) {
    final e = SessionEngine(rounds: rounds);
    e.start();
    return e;
  }

  void tickN(SessionEngine e, int n) {
    for (var i = 0; i < n; i++) {
      e.tick();
    }
  }

  test('시작 전에는 idle, start로 1라운드 준비 호흡 진입', () {
    final e = SessionEngine(rounds: twoRounds);
    expect(e.phase, SessionPhase.idle);

    e.start();

    expect(e.phase, SessionPhase.preparing);
    expect(e.currentRound, 1);
    expect(e.remainingSec, 3);
  });

  test('준비 호흡이 끝나면 홀드로 전이', () {
    final e = started(twoRounds);

    tickN(e, 2);
    expect(e.phase, SessionPhase.preparing);
    expect(e.remainingSec, 1);

    e.tick();
    expect(e.phase, SessionPhase.holding);
    expect(e.remainingSec, 2);
  });

  test('홀드가 끝나면 다음 라운드 준비로, 결과가 기록된다', () {
    final e = started(twoRounds);
    tickN(e, 3 + 2);

    expect(e.phase, SessionPhase.preparing);
    expect(e.currentRound, 2);
    expect(e.remainingSec, 2);
    expect(e.results, hasLength(1));
    expect(e.results.first.round, 1);
    expect(e.results.first.actualHoldSec, 2);
  });

  test('마지막 라운드 홀드가 끝나면 finished, 전체 결과 확정', () {
    final e = started(twoRounds);
    tickN(e, 3 + 2 + 2 + 4);

    expect(e.phase, SessionPhase.finished);
    expect(e.results, hasLength(2));
    expect(e.results.last.round, 2);
    expect(e.results.last.actualHoldSec, 4);
    expect(e.isRunning, isFalse);
  });

  test('finished 이후 tick은 무시된다', () {
    final e = started(twoRounds);
    tickN(e, 11 + 5);

    expect(e.phase, SessionPhase.finished);
    expect(e.results, hasLength(2));
  });

  test('홀드 중 컨트랙션 탭 — 홀드 시작 기준 ms로 기록', () {
    final e = started(twoRounds);
    tickN(e, 3);
    expect(e.phase, SessionPhase.holding);

    e.tick();
    e.tapContraction();
    e.tapContraction(atMs: 1500);
    e.tick();

    expect(e.results.single.contractionAtMs, [1000, 1500]);
  });

  test('준비 호흡 중 컨트랙션 탭은 무시된다', () {
    final e = started(twoRounds);
    e.tapContraction();
    tickN(e, 3 + 2);

    expect(e.results.first.contractionAtMs, isEmpty);
  });

  test('홀드 조기 종료 — 실제 홀드 시간으로 기록 후 다음 라운드', () {
    final e = started(twoRounds);
    tickN(e, 3);
    e.tick();
    e.endHoldEarly();

    expect(e.phase, SessionPhase.preparing);
    expect(e.currentRound, 2);
    expect(e.results.single.actualHoldSec, 1);
  });

  test('1탭 중단 — 홀드 중이면 부분 결과 보존', () {
    final e = started(twoRounds);
    tickN(e, 3);
    e.tick();
    e.stop();

    expect(e.phase, SessionPhase.stopped);
    expect(e.results.single.actualHoldSec, 1);
    expect(e.isRunning, isFalse);
  });

  test('준비 호흡 중 중단 — 결과 없이 즉시 종료', () {
    final e = started(twoRounds);
    e.tick();
    e.stop();

    expect(e.phase, SessionPhase.stopped);
    expect(e.results, isEmpty);
  });

  test('중단 후 tick·탭은 무시된다', () {
    final e = started(twoRounds);
    e.stop();
    e.tick();
    e.tapContraction();

    expect(e.phase, SessionPhase.stopped);
    expect(e.results, isEmpty);
  });

  test('1라운드 테이블 — 홀드 종료 즉시 finished', () {
    final e = started(const [Round(breathSec: 1, holdSec: 1)]);
    tickN(e, 2);

    expect(e.phase, SessionPhase.finished);
    expect(e.results.single.actualHoldSec, 1);
  });

  group('일시정지/재개', () {
    test('일시정지 중에는 tick이 시간을 흘리지 않는다', () {
      final e = started(twoRounds);
      tickN(e, 3); // 준비 종료 → 홀드 진입, 남은 2초
      e.tick(); // 홀드 1초 경과, 남은 1초

      e.pause();
      expect(e.phase, SessionPhase.paused);
      expect(e.remainingSec, 1);

      e.tick();
      e.tick();
      expect(e.phase, SessionPhase.paused);
      expect(e.remainingSec, 1);
    });

    test('재개하면 일시정지 전 단계에서 그대로 이어진다', () {
      final e = started(twoRounds);
      tickN(e, 3);
      e.tick();

      e.pause();
      e.resume();
      expect(e.phase, SessionPhase.holding);
      expect(e.remainingSec, 1);

      e.tick();
      expect(e.phase, SessionPhase.preparing);
      expect(e.results.single.actualHoldSec, 2);
    });

    test('일시정지 중 컨트랙션 탭은 무시된다', () {
      final e = started(twoRounds);
      tickN(e, 3);
      e.pause();
      e.tapContraction();
      e.resume();

      expect(e.results, isEmpty);
      e.tick();
      e.tick();
      expect(e.results.single.contractionAtMs, isEmpty);
    });

    test('일시정지 중에도 중단 가능 — 홀드 부분 결과 보존', () {
      final e = started(twoRounds);
      tickN(e, 3);
      e.tick(); // 홀드 1초 경과
      e.pause();
      e.stop();

      expect(e.phase, SessionPhase.stopped);
      expect(e.results.single.actualHoldSec, 1);
      expect(e.isActive, isFalse);
    });

    test('준비 호흡 중 일시정지 후 중단 — 결과 없이 종료', () {
      final e = started(twoRounds);
      e.pause();
      e.stop();

      expect(e.phase, SessionPhase.stopped);
      expect(e.results, isEmpty);
    });

    test('실행 중이 아니면 pause는 무시된다', () {
      final e = SessionEngine(rounds: twoRounds);
      e.pause();
      expect(e.phase, SessionPhase.idle);
    });

    test('일시정지 상태가 아니면 resume은 무시된다', () {
      final e = started(twoRounds);
      e.resume();
      expect(e.phase, SessionPhase.preparing);
    });

    test('isActive는 실행 중·일시정지 모두 true, 종료 상태는 false', () {
      final e = started(twoRounds);
      expect(e.isActive, isTrue);
      e.pause();
      expect(e.isActive, isTrue);
      e.stop();
      expect(e.isActive, isFalse);
    });
  });
}
