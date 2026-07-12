import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/models.dart';

class LogbookRepository {
  final AppDatabase db;

  const LogbookRepository(this.db);

  /// 다이빙 세션 저장 (Session + 1:N Reps)
  Future<int> saveSession({
    required DateTime date,
    required SiteType siteType,
    required String siteName,
    required PurposeTag purposeTag,
    required int overallRating,
    required List<DiveRepsCompanion> reps,
    double? lat,
    double? lon,
    DiveCondition? condition,
    List<String>? photoPaths,
    String? leaderName,
    String? note,
  }) async {
    return db.transaction(() async {
      final sessionId = await db.into(db.diveSessions).insert(
            DiveSessionsCompanion.insert(
              date: date,
              siteType: siteType,
              siteName: siteName,
              lat: Value(lat),
              lon: Value(lon),
              purposeTag: purposeTag,
              overallRating: Value(overallRating == 0 ? null : overallRating),
              condition: condition ?? const DiveCondition(),
              gear: const DiveGear(),           // 임시 기본값
              buddyIds: const [],
              photoPaths: photoPaths ?? const [],
              leaderName: Value(leaderName),
              note: Value(note),
            ),
          );

      for (var i = 0; i < reps.length; i++) {
        final rep = reps[i].copyWith(
          sessionId: Value(sessionId),
          sequence: Value(i + 1),
        );
        await db.into(db.diveReps).insert(rep);
      }
      return sessionId;
    });
  }

  /// 다이빙 세션 리스트 스트림 반환
  Stream<List<DiveSession>> watchSessions() {
    return (db.select(db.diveSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// 단일 다이빙 세션 조회
  Future<DiveSession?> getSession(int id) {
    return (db.select(db.diveSessions)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 단일 다이빙 세션의 Reps 조회
  Future<List<DiveRep>> getRepsForSession(int sessionId) {
    return (db.select(db.diveReps)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.sequence)]))
        .get();
  }

  /// 다이빙 세션 업데이트
  Future<void> updateSession({
    required int sessionId,
    required DateTime date,
    required SiteType siteType,
    required String siteName,
    required PurposeTag purposeTag,
    required int overallRating,
    required List<DiveRepsCompanion> reps,
    double? lat,
    double? lon,
    DiveCondition? condition,
    List<String>? photoPaths,
    String? leaderName,
    String? note,
  }) async {
    return db.transaction(() async {
      await (db.update(db.diveSessions)..where((t) => t.id.equals(sessionId))).write(
        DiveSessionsCompanion(
          date: Value(date),
          siteType: Value(siteType),
          siteName: Value(siteName),
          lat: Value(lat),
          lon: Value(lon),
          purposeTag: Value(purposeTag),
          overallRating: Value(overallRating == 0 ? null : overallRating),
          condition: Value(condition ?? const DiveCondition()),
          photoPaths: Value(photoPaths ?? const []),
          leaderName: Value(leaderName),
          note: Value(note),
        ),
      );

      // 기존 Reps 삭제 후 재삽입
      await (db.delete(db.diveReps)..where((t) => t.sessionId.equals(sessionId))).go();

      for (var i = 0; i < reps.length; i++) {
        final rep = reps[i].copyWith(
          sessionId: Value(sessionId),
          sequence: Value(i + 1),
        );
        await db.into(db.diveReps).insert(rep);
      }
    });
  }

  /// 다이빙 세션 삭제
  Future<void> deleteSession(int sessionId) async {
    return db.transaction(() async {
      // 관련된 Reps 삭제
      await (db.delete(db.diveReps)..where((t) => t.sessionId.equals(sessionId))).go();
      // 세션 본체 삭제
      await (db.delete(db.diveSessions)..where((t) => t.id.equals(sessionId))).go();
    });
  }
}
