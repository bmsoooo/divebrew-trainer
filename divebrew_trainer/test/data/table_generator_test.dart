// PB 기반 테이블 생성 로직 단위 테스트 — PB 입력값별 산출 검증 (checklist M1 verify)
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/table_generator.dart';

void main() {
  group('CO2 생성', () {
    test('PB 180초 — 홀드 108→105(5초 내림) 고정, 호흡 120→50 점감', () {
      final rounds = generateCo2FromPb(180);

      expect(rounds, hasLength(8));
      expect(rounds.map((r) => r.holdSec).toSet(), {105});
      expect(rounds.first.breathSec, 120);
      expect(rounds.last.breathSec, 50);
      for (var i = 1; i < rounds.length; i++) {
        expect(rounds[i].breathSec, rounds[i - 1].breathSec - 10);
      }
    });

    test('PB 100초 — 홀드 60초 고정', () {
      final rounds = generateCo2FromPb(100);
      expect(rounds.map((r) => r.holdSec).toSet(), {60});
    });

    test('아주 짧은 PB(20초)도 최소 10초 보장', () {
      final rounds = generateCo2FromPb(20);
      expect(rounds.every((r) => r.holdSec >= 10), isTrue);
    });
  });

  group('O2 생성', () {
    test('PB 200초 — 홀드 80(40%)→160(80%) 점증, 호흡 120 고정', () {
      final rounds = generateO2FromPb(200);

      expect(rounds, hasLength(8));
      expect(rounds.map((r) => r.breathSec).toSet(), {120});
      expect(rounds.first.holdSec, 80);
      expect(rounds.last.holdSec, 160);
      for (var i = 1; i < rounds.length; i++) {
        expect(rounds[i].holdSec, greaterThan(rounds[i - 1].holdSec));
      }
    });

    test('모든 홀드가 PB의 40~80% 구간(5초 내림 오차 허용) 안에 있다', () {
      for (final pb in [90, 120, 150, 240, 300]) {
        final rounds = generateO2FromPb(pb);
        for (final r in rounds) {
          expect(r.holdSec, lessThanOrEqualTo((pb * pbRatioMax).ceil()),
              reason: 'PB $pb');
          expect(r.holdSec, greaterThanOrEqualTo(pb * pbRatioMin - 5),
              reason: 'PB $pb');
        }
      }
    });

    test('아주 짧은 PB(20초)도 최소 10초 보장', () {
      final rounds = generateO2FromPb(20);
      expect(rounds.every((r) => r.holdSec >= 10), isTrue);
    });
  });
}
