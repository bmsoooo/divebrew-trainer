// drift 로컬 DB 진입점 — 웹은 sqlite3 WASM(IndexedDB), 앱은 SQLite로 동일 API 제공
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'models.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TrainingTables, Sessions, PersonalBests, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(settings);
          }
        },
      );

  static const _safetyConsentKey = 'safetyConsentedAt';

  /// 온보딩 안전 동의 여부 — 미동의 시 앱 진행 불가 (A4).
  Future<bool> get safetyConsented async {
    final row = await (select(settings)
          ..where((s) => s.key.equals(_safetyConsentKey)))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> setSafetyConsented() => into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(
          key: _safetyConsentKey,
          value: DateTime.now().toIso8601String(),
        ),
      );

  static const _licenseImageKey = 'licenseImageBase64';

  /// 저장된 자격증 사진(base64)을 실시간 구독 — 없으면 null.
  Stream<String?> watchLicenseImage() =>
      (select(settings)..where((s) => s.key.equals(_licenseImageKey)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  Future<void> setLicenseImage(String base64) =>
      into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: _licenseImageKey, value: base64),
      );

  Future<void> clearLicenseImage() =>
      (delete(settings)..where((s) => s.key.equals(_licenseImageKey))).go();

  /// 세션 저장 + 해당 종류 PB가 갱신되면 함께 upsert.
  Future<int> saveSession({
    required int tableId,
    required TableType type,
    required DateTime startedAt,
    DateTime? completedAt,
    required List<RoundResult> results,
  }) async {
    final id = await into(sessions).insert(SessionsCompanion.insert(
      tableId: tableId,
      startedAt: startedAt,
      completedAt: Value.absentIfNull(completedAt),
      results: results,
    ));

    final maxHold = results.fold(0, (max, r) => r.actualHoldSec > max ? r.actualHoldSec : max);
    final current = await (select(personalBests)
          ..where((p) => p.type.equals(type.name)))
        .getSingleOrNull();
    if (maxHold > 0 && (current == null || maxHold > current.valueSec)) {
      await into(personalBests).insertOnConflictUpdate(
        PersonalBestsCompanion.insert(
          type: type,
          valueSec: maxHold,
          achievedAt: startedAt,
        ),
      );
    }
    return id;
  }

  /// 세션 + 테이블 정보 조인 (최신순) — 히스토리 화면용.
  Stream<List<SessionWithTable>> watchSessionsWithTable() {
    final query = (select(sessions)
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .join([
      innerJoin(trainingTables, trainingTables.id.equalsExp(sessions.tableId)),
    ]);
    return query.watch().map((rows) => [
          for (final row in rows)
            SessionWithTable(
              session: row.readTable(sessions),
              table: row.readTable(trainingTables),
            ),
        ]);
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'divebrew_trainer',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}

/// 히스토리 화면용 세션+테이블 조인 결과.
class SessionWithTable {
  final Session session;
  final TrainingTable table;

  const SessionWithTable({required this.session, required this.table});
}
