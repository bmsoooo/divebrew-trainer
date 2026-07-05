// 기록 JSON 내보내기/가져오기 — 웹 기록 유실 대비 + iOS 이관 경로 (기획서 §4 데이터)
import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'models.dart';

const backupVersion = 1;

/// 전체 기록을 JSON 문자열로 내보낸다.
Future<String> exportToJson(AppDatabase db) async {
  final tables = await db.select(db.trainingTables).get();
  final sessions = await db.select(db.sessions).get();
  final pbs = await db.select(db.personalBests).get();

  return jsonEncode({
    'version': backupVersion,
    'exportedAt': DateTime.now().toIso8601String(),
    'trainingTables': [
      for (final t in tables)
        {
          'id': t.id,
          'name': t.name,
          'type': t.type.name,
          'rounds': [for (final r in t.rounds) r.toJson()],
          'isPreset': t.isPreset,
        },
    ],
    'sessions': [
      for (final s in sessions)
        {
          'id': s.id,
          'tableId': s.tableId,
          'startedAt': s.startedAt.toIso8601String(),
          'completedAt': s.completedAt?.toIso8601String(),
          'results': [for (final r in s.results) r.toJson()],
          'note': s.note,
        },
    ],
    'personalBests': [
      for (final p in pbs)
        {
          'type': p.type.name,
          'valueSec': p.valueSec,
          'achievedAt': p.achievedAt.toIso8601String(),
        },
    ],
  });
}

/// JSON 백업을 가져온다 — 기존 데이터를 전부 대체 (ID·참조 유지).
/// 형식이 잘못되면 [FormatException]을 던지고 기존 데이터는 보존된다.
Future<void> importFromJson(AppDatabase db, String json) async {
  final Map<String, dynamic> data;
  try {
    data = jsonDecode(json) as Map<String, dynamic>;
  } on Object {
    throw const FormatException('잘못된 백업 파일');
  }
  final version = data['version'];
  if (version is! int || version > backupVersion) {
    throw const FormatException('지원하지 않는 백업 버전');
  }
  final tables = data['trainingTables'];
  final sessions = data['sessions'];
  final pbs = data['personalBests'];
  if (tables is! List || sessions is! List || pbs is! List) {
    throw const FormatException('잘못된 백업 파일');
  }

  await db.transaction(() async {
    await db.delete(db.sessions).go();
    await db.delete(db.trainingTables).go();
    await db.delete(db.personalBests).go();

    for (final raw in tables) {
      final t = raw as Map<String, dynamic>;
      await db.into(db.trainingTables).insert(TrainingTablesCompanion.insert(
            id: Value(t['id'] as int),
            name: t['name'] as String,
            type: TableType.values.byName(t['type'] as String),
            rounds: [
              for (final r in t['rounds'] as List)
                Round.fromJson(r as Map<String, dynamic>),
            ],
            isPreset: Value(t['isPreset'] as bool? ?? false),
          ));
    }
    for (final raw in sessions) {
      final s = raw as Map<String, dynamic>;
      await db.into(db.sessions).insert(SessionsCompanion.insert(
            id: Value(s['id'] as int),
            tableId: s['tableId'] as int,
            startedAt: DateTime.parse(s['startedAt'] as String),
            completedAt: Value(s['completedAt'] == null
                ? null
                : DateTime.parse(s['completedAt'] as String)),
            results: [
              for (final r in s['results'] as List)
                RoundResult.fromJson(r as Map<String, dynamic>),
            ],
            note: Value(s['note'] as String?),
          ));
    }
    for (final raw in pbs) {
      final p = raw as Map<String, dynamic>;
      await db.into(db.personalBests).insert(PersonalBestsCompanion.insert(
            type: TableType.values.byName(p['type'] as String),
            valueSec: p['valueSec'] as int,
            achievedAt: DateTime.parse(p['achievedAt'] as String),
          ));
    }
  });
}
