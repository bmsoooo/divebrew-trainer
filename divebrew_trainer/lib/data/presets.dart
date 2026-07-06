// CO2/O2 프리셋 테이블 정의와 최초 실행 시 DB 시드 — 값은 운영자 튜닝 대상 (context-notes D19)
import 'package:drift/drift.dart';

import 'database.dart';
import 'models.dart';

class PresetDef {
  final String name;
  final TableType type;
  final List<Round> rounds;

  const PresetDef({required this.name, required this.type, required this.rounds});
}

/// CO2: 숨참기 고정, 준비 호흡 점감.
List<Round> _co2(int holdSec, int breathStart, int breathStep, int count) => [
      for (var i = 0; i < count; i++)
        Round(breathSec: breathStart - breathStep * i, holdSec: holdSec),
    ];

/// O2: 준비 호흡 고정, 숨참기 점증.
List<Round> _o2(int breathSec, int holdStart, int holdStep, int count) => [
      for (var i = 0; i < count; i++)
        Round(breathSec: breathSec, holdSec: holdStart + holdStep * i),
    ];

final presets = <PresetDef>[
  PresetDef(name: 'CO2 입문', type: TableType.co2, rounds: _co2(45, 90, 10, 6)),
  PresetDef(name: 'CO2 중급', type: TableType.co2, rounds: _co2(90, 120, 10, 8)),
  PresetDef(name: 'CO2 상급', type: TableType.co2, rounds: _co2(120, 105, 10, 8)),
  PresetDef(name: 'O2 입문', type: TableType.o2, rounds: _o2(120, 45, 10, 6)),
  PresetDef(name: 'O2 중급', type: TableType.o2, rounds: _o2(120, 90, 10, 8)),
  PresetDef(name: 'O2 상급', type: TableType.o2, rounds: _o2(120, 120, 15, 8)),
];

/// 프리셋이 없으면 시드한다 (최초 실행 1회).
Future<void> seedPresetsIfEmpty(AppDatabase db) async {
  final existing = await (db.select(db.trainingTables)
        ..where((t) => t.isPreset.equals(true)))
      .get();
  if (existing.isNotEmpty) return;

  await db.batch((batch) {
    batch.insertAll(db.trainingTables, [
      for (final p in presets)
        TrainingTablesCompanion.insert(
          name: p.name,
          type: p.type,
          rounds: p.rounds,
          isPreset: const Value(true),
        ),
    ]);
  });
}

/// 기본 루틴 복원 — 프리셋 라운드를 원래 값으로 되돌리고, 삭제된 프리셋은 다시 추가.
/// 커스텀 테이블·훈련 기록은 건드리지 않는다 (이름으로 매칭, 참조 무결성 유지).
Future<void> restoreDefaultTables(AppDatabase db) async {
  final existing = await (db.select(db.trainingTables)
        ..where((t) => t.isPreset.equals(true)))
      .get();
  final byName = {for (final t in existing) t.name: t};

  await db.transaction(() async {
    for (final p in presets) {
      final current = byName[p.name];
      if (current == null) {
        await db.into(db.trainingTables).insert(
              TrainingTablesCompanion.insert(
                name: p.name,
                type: p.type,
                rounds: p.rounds,
                isPreset: const Value(true),
              ),
            );
      } else {
        await (db.update(db.trainingTables)
              ..where((t) => t.id.equals(current.id)))
            .write(TrainingTablesCompanion(rounds: Value(p.rounds)));
      }
    }
  });
}

/// 훈련 기록 전체 삭제 — 세션·PB만 제거, 테이블은 유지.
Future<void> clearHistory(AppDatabase db) async {
  await db.transaction(() async {
    await db.delete(db.sessions).go();
    await db.delete(db.personalBests).go();
  });
}

/// 루틴 + 기록 초기화 — 세션·PB·모든 테이블 삭제 후 기본 프리셋 재시드.
/// 안전 동의(Settings)는 유지한다.
Future<void> resetAll(AppDatabase db) async {
  await db.transaction(() async {
    await db.delete(db.sessions).go();
    await db.delete(db.personalBests).go();
    await db.delete(db.trainingTables).go();
  });
  await seedPresetsIfEmpty(db);
}

/// 테이블 총 소요 시간(초).
int totalDurationSec(List<Round> rounds) =>
    rounds.fold(0, (sum, r) => sum + r.breathSec + r.holdSec);
