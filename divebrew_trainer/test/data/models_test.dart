// 값 객체(Round, RoundResult)의 JSON 직렬화 왕복 단위 테스트
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/models.dart';

void main() {
  group('Round JSON 왕복', () {
    test('encode 후 decode하면 동일한 리스트', () {
      const rounds = [
        Round(breathSec: 120, holdSec: 90),
        Round(breathSec: 105, holdSec: 90),
        Round(breathSec: 90, holdSec: 90),
      ];

      expect(decodeRounds(encodeRounds(rounds)), rounds);
    });

    test('빈 리스트도 왕복 가능', () {
      expect(decodeRounds(encodeRounds([])), isEmpty);
    });
  });

  group('RoundResult JSON 왕복', () {
    test('컨트랙션 타임스탬프 포함 왕복', () {
      const results = [
        RoundResult(round: 1, actualHoldSec: 88, contractionAtMs: [61200, 75800]),
        RoundResult(round: 2, actualHoldSec: 90),
      ];

      final decoded = decodeRoundResults(encodeRoundResults(results));

      expect(decoded, results);
      expect(decoded.first.contractionAtMs, [61200, 75800]);
      expect(decoded.last.contractionAtMs, isEmpty);
    });
  });
}
