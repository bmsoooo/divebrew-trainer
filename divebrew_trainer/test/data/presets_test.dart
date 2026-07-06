// 프리셋 시드의 멱등성과 CO2/O2 구조 규칙 단위 테스트
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/data/presets.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('프리셋 시드 — 두 번 호출해도 중복 없음 (CO2 3 + O2 3 + 스테틱 1)', () async {
    await seedPresetsIfEmpty(db);
    await seedPresetsIfEmpty(db);

    final all = await db.select(db.trainingTables).get();

    expect(all, hasLength(7));
    expect(all.every((t) => t.isPreset), isTrue);
    expect(all.where((t) => t.type == TableType.co2), hasLength(3));
    expect(all.where((t) => t.type == TableType.o2), hasLength(3));
    expect(all.where((t) => t.type == TableType.static_), hasLength(1));
  });

  test('CO2 프리셋: 숨참기 고정, 준비 호흡 점감', () {
    for (final p in presets.where((p) => p.type == TableType.co2)) {
      final holds = p.rounds.map((r) => r.holdSec).toSet();
      expect(holds, hasLength(1), reason: '${p.name}: 숨참기 시간이 고정이어야 함');

      for (var i = 1; i < p.rounds.length; i++) {
        expect(p.rounds[i].breathSec, lessThan(p.rounds[i - 1].breathSec),
            reason: '${p.name}: 준비 호흡이 점감해야 함');
      }
    }
  });

  test('O2 프리셋: 준비 호흡 고정, 숨참기 점증', () {
    for (final p in presets.where((p) => p.type == TableType.o2)) {
      final breaths = p.rounds.map((r) => r.breathSec).toSet();
      expect(breaths, hasLength(1), reason: '${p.name}: 준비 호흡이 고정이어야 함');

      for (var i = 1; i < p.rounds.length; i++) {
        expect(p.rounds[i].holdSec, greaterThan(p.rounds[i - 1].holdSec),
            reason: '${p.name}: 숨참기가 점증해야 함');
      }
    }
  });

  test('총 훈련 시간 계산', () {
    const rounds = [
      Round(breathSec: 60, holdSec: 30),
      Round(breathSec: 50, holdSec: 30),
    ];
    expect(totalDurationSec(rounds), 170);
    expect(totalDurationSec([]), 0);
  });
}
