// 설정 데이터 관리 액션 단위 테스트 — 복원/기록삭제/전체초기화
import 'package:drift/drift.dart' show Value;
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

  Future<int> addCustom() =>
      db.into(db.trainingTables).insert(TrainingTablesCompanion.insert(
            name: '내 커스텀',
            type: TableType.custom,
            rounds: const [Round(breathSec: 60, holdSec: 30)],
          ));

  group('기본 루틴 복원', () {
    test('편집된 프리셋 라운드가 기본값으로 되돌아간다', () async {
      await seedPresetsIfEmpty(db);
      final preset = await (db.select(db.trainingTables)
            ..where((t) => t.name.equals('CO2 입문')))
          .getSingle();

      // 프리셋을 임의로 변조.
      await (db.update(db.trainingTables)..where((t) => t.id.equals(preset.id)))
          .write(const TrainingTablesCompanion(
              rounds: Value([Round(breathSec: 1, holdSec: 1)])));

      await restoreDefaultTables(db);

      final restored = await (db.select(db.trainingTables)
            ..where((t) => t.id.equals(preset.id)))
          .getSingle();
      expect(restored.rounds, presets.first.rounds);
    });

    test('커스텀 테이블은 건드리지 않는다', () async {
      await seedPresetsIfEmpty(db);
      final customId = await addCustom();

      await restoreDefaultTables(db);

      final custom = await (db.select(db.trainingTables)
            ..where((t) => t.id.equals(customId)))
          .getSingleOrNull();
      expect(custom, isNotNull);
      expect(custom!.name, '내 커스텀');
    });

    test('삭제된 프리셋은 다시 추가된다', () async {
      await seedPresetsIfEmpty(db);
      await (db.delete(db.trainingTables)
            ..where((t) => t.isPreset.equals(true)))
          .go();

      await restoreDefaultTables(db);

      final presetsInDb = await (db.select(db.trainingTables)
            ..where((t) => t.isPreset.equals(true)))
          .get();
      expect(presetsInDb, hasLength(presets.length + 1)); // +스테틱
    });
  });

  group('훈련 기록 전체 삭제', () {
    test('세션·PB만 지우고 테이블은 유지', () async {
      await seedPresetsIfEmpty(db);
      final tableId = (await db.select(db.trainingTables).get()).first.id;
      await db.saveSession(
        tableId: tableId,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 1),
        results: const [RoundResult(round: 1, actualHoldSec: 60)],
      );

      await clearHistory(db);

      expect(await db.select(db.sessions).get(), isEmpty);
      expect(await db.select(db.personalBests).get(), isEmpty);
      expect(await db.select(db.trainingTables).get(), isNotEmpty);
    });
  });

  group('루틴 + 기록 초기화', () {
    test('모든 데이터 삭제 후 프리셋 재시드, 커스텀은 사라진다', () async {
      await seedPresetsIfEmpty(db);
      final customId = await addCustom();
      await db.saveSession(
        tableId: customId,
        type: TableType.custom,
        startedAt: DateTime(2026, 7, 1),
        results: const [RoundResult(round: 1, actualHoldSec: 60)],
      );

      await resetAll(db);

      final tables = await db.select(db.trainingTables).get();
      expect(tables, hasLength(presets.length + 1)); // +스테틱
      expect(tables.every((t) => t.isPreset), isTrue);
      expect(await db.select(db.sessions).get(), isEmpty);
      expect(await db.select(db.personalBests).get(), isEmpty);
    });

    test('안전 동의는 초기화 후에도 유지된다', () async {
      await db.setSafetyConsented();
      await seedPresetsIfEmpty(db);

      await resetAll(db);

      expect(await db.safetyConsented, isTrue);
    });
  });
}
