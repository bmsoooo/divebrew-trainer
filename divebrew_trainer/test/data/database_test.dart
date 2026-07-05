// AppDatabase의 테이블 CRUD 왕복 단위 테스트 (인메모리 SQLite)
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('훈련 테이블 저장·조회 왕복 — 라운드 JSON 변환 포함', () async {
    const rounds = [
      Round(breathSec: 120, holdSec: 90),
      Round(breathSec: 105, holdSec: 90),
    ];

    final id = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: 'CO2 입문',
            type: TableType.co2,
            rounds: rounds,
          ),
        );

    final saved = await (db.select(db.trainingTables)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    expect(saved.name, 'CO2 입문');
    expect(saved.type, TableType.co2);
    expect(saved.rounds, rounds);
    expect(saved.isPreset, false);
  });

  test('세션 저장·조회 왕복 — 결과·컨트랙션·메모 포함', () async {
    final tableId = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: 'O2 중급',
            type: TableType.o2,
            rounds: const [Round(breathSec: 120, holdSec: 60)],
          ),
        );

    final startedAt = DateTime(2026, 7, 5, 9, 30);
    const results = [
      RoundResult(round: 1, actualHoldSec: 58, contractionAtMs: [40000]),
    ];

    final sessionId = await db.into(db.sessions).insert(
          SessionsCompanion.insert(
            tableId: tableId,
            startedAt: startedAt,
            results: results,
            note: const Value('오늘 컨디션 좋음'),
          ),
        );

    final saved = await (db.select(db.sessions)
          ..where((s) => s.id.equals(sessionId)))
        .getSingle();

    expect(saved.tableId, tableId);
    expect(saved.startedAt, startedAt);
    expect(saved.completedAt, isNull);
    expect(saved.results, results);
    expect(saved.results.first.contractionAtMs, [40000]);
    expect(saved.note, '오늘 컨디션 좋음');
  });

  test('PB는 종류별 1건 — 같은 종류로 다시 쓰면 갱신', () async {
    Future<void> upsert(int valueSec, DateTime at) =>
        db.into(db.personalBests).insertOnConflictUpdate(
              PersonalBestsCompanion.insert(
                type: TableType.static_,
                valueSec: valueSec,
                achievedAt: at,
              ),
            );

    await upsert(120, DateTime(2026, 7, 1));
    await upsert(135, DateTime(2026, 7, 5));

    final all = await db.select(db.personalBests).get();

    expect(all, hasLength(1));
    expect(all.single.valueSec, 135);
    expect(all.single.achievedAt, DateTime(2026, 7, 5));
  });
}
