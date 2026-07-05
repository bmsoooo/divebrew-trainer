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
