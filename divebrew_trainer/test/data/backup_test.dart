// JSON 내보내기/가져오기 왕복 단위 테스트 (checklist M2 verify)
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/backup.dart';
import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/data/presets.dart';

void main() {
  test('내보내기 → 새 DB 가져오기 왕복 — 테이블·세션·PB·참조 유지', () async {
    final source = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(source.close);

    await seedPresetsIfEmpty(source);
    final customId = await source.into(source.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: '내 커스텀',
            type: TableType.custom,
            rounds: const [Round(breathSec: 90, holdSec: 75)],
          ),
        );
    await source.saveSession(
      tableId: customId,
      type: TableType.custom,
      startedAt: DateTime(2026, 7, 5, 9, 30),
      completedAt: DateTime(2026, 7, 5, 9, 50),
      results: const [
        RoundResult(round: 1, actualHoldSec: 72, contractionAtMs: [55000]),
      ],
    );

    final json = await exportToJson(source);

    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(target.close);
    await importFromJson(target, json);

    final tables = await target.select(target.trainingTables).get();
    expect(tables, hasLength(7)); // 프리셋 6 + 커스텀 1

    final custom = tables.singleWhere((t) => t.name == '내 커스텀');
    expect(custom.id, customId);
    expect(custom.rounds, const [Round(breathSec: 90, holdSec: 75)]);

    final session = await target.select(target.sessions).getSingle();
    expect(session.tableId, customId);
    expect(session.completedAt, DateTime(2026, 7, 5, 9, 50));
    expect(session.results.single.contractionAtMs, [55000]);

    final pb = await target.select(target.personalBests).getSingle();
    expect(pb.type, TableType.custom);
    expect(pb.valueSec, 72);
  });

  test('가져오기는 기존 데이터를 대체한다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // 내보낼 원본: 테이블 1개.
    await db.into(db.trainingTables).insert(TrainingTablesCompanion.insert(
          name: '원본',
          type: TableType.custom,
          rounds: const [Round(breathSec: 60, holdSec: 30)],
        ));
    final json = await exportToJson(db);

    // 이후 추가된 데이터는 가져오기 시 사라져야 한다.
    await db.into(db.trainingTables).insert(TrainingTablesCompanion.insert(
          name: '나중에 추가',
          type: TableType.custom,
          rounds: const [Round(breathSec: 60, holdSec: 30)],
        ));

    await importFromJson(db, json);

    final tables = await db.select(db.trainingTables).get();
    expect(tables.map((t) => t.name), ['원본']);
  });

  test('잘못된 JSON — FormatException, 기존 데이터 보존', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.into(db.trainingTables).insert(TrainingTablesCompanion.insert(
          name: '보존 대상',
          type: TableType.custom,
          rounds: const [Round(breathSec: 60, holdSec: 30)],
        ));

    await expectLater(
        importFromJson(db, '{"oops": true}'), throwsFormatException);
    await expectLater(importFromJson(db, 'not json'), throwsFormatException);
    await expectLater(
      importFromJson(db, '{"version": 999, "trainingTables": [], "sessions": [], "personalBests": []}'),
      throwsFormatException,
    );

    final tables = await db.select(db.trainingTables).get();
    expect(tables.single.name, '보존 대상');
  });
}
