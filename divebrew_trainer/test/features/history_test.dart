// 히스토리 화면·PB 갱신 로직 테스트 (checklist M2 verify)
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/features/history/history_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertTable({TableType type = TableType.co2}) =>
      db.into(db.trainingTables).insert(TrainingTablesCompanion.insert(
            name: 'CO2 테이블',
            type: type,
            rounds: const [Round(breathSec: 60, holdSec: 60)],
          ));

  group('saveSession PB 갱신', () {
    test('첫 세션 — PB가 새로 생성된다', () async {
      final tableId = await insertTable();
      await db.saveSession(
        tableId: tableId,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 1),
        completedAt: DateTime(2026, 7, 1, 0, 20),
        results: const [RoundResult(round: 1, actualHoldSec: 55)],
      );

      final pb = await db.select(db.personalBests).getSingle();
      expect(pb.type, TableType.co2);
      expect(pb.valueSec, 55);
    });

    test('더 낮은 기록은 PB를 덮어쓰지 않는다', () async {
      final tableId = await insertTable();
      await db.saveSession(
        tableId: tableId,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 1),
        results: const [RoundResult(round: 1, actualHoldSec: 90)],
      );
      await db.saveSession(
        tableId: tableId,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 2),
        results: const [RoundResult(round: 1, actualHoldSec: 60)],
      );

      final pb = await db.select(db.personalBests).getSingle();
      expect(pb.valueSec, 90);
    });

    test('더 높은 기록은 PB를 갱신한다 (종류별 분리)', () async {
      final co2Id = await insertTable();
      final o2Id = await insertTable(type: TableType.o2);
      await db.saveSession(
        tableId: co2Id,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 1),
        results: const [RoundResult(round: 1, actualHoldSec: 60)],
      );
      await db.saveSession(
        tableId: co2Id,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 2),
        results: const [RoundResult(round: 1, actualHoldSec: 80)],
      );
      await db.saveSession(
        tableId: o2Id,
        type: TableType.o2,
        startedAt: DateTime(2026, 7, 3),
        results: const [RoundResult(round: 1, actualHoldSec: 100)],
      );

      final pbs = await db.select(db.personalBests).get();
      expect(pbs, hasLength(2));
      expect(
          pbs.firstWhere((p) => p.type == TableType.co2).valueSec, 80);
      expect(pbs.firstWhere((p) => p.type == TableType.o2).valueSec, 100);
    });
  });

  group('히스토리 화면', () {
    Widget buildApp() {
      final router = GoRouter(
        initialLocation: '/history',
        routes: [
          GoRoute(
            path: '/history',
            builder: (context, state) => HistoryScreen(db: db),
          ),
        ],
      );
      return MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        routerConfig: router,
      );
    }

    testWidgets('세션 목록이 최고 홀드와 함께 표시되고 그래프가 렌더링된다', (tester) async {
      final tableId = await insertTable();
      await db.saveSession(
        tableId: tableId,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 1, 9),
        completedAt: DateTime(2026, 7, 1, 9, 20),
        results: const [
          RoundResult(round: 1, actualHoldSec: 50),
          RoundResult(round: 2, actualHoldSec: 62),
        ],
      );
      await db.saveSession(
        tableId: tableId,
        type: TableType.co2,
        startedAt: DateTime(2026, 7, 3, 9),
        completedAt: DateTime(2026, 7, 3, 9, 20),
        results: const [RoundResult(round: 1, actualHoldSec: 71)],
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('CO2 테이블'), findsNWidgets(2));
      expect(find.text('1:02'), findsOneWidget); // 첫 세션 최고 홀드 62초
      expect(find.byType(LineChart), findsOneWidget);

      // drift watch() 스트림의 keep-alive 타이머를 소진시켜 타이머 누수 방지.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('기록이 없으면 빈 상태 문구', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('아직 기록이 없어요'), findsWidgets);
      expect(find.byType(LineChart), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
