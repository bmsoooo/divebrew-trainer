// 세션 실행 화면 위젯 테스트 — 컨트랙션 탭 기록·세션 저장 (checklist M1 verify 2건)
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/features/session/session_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertTable(List<Round> rounds) =>
      db.into(db.trainingTables).insert(TrainingTablesCompanion.insert(
            name: '테스트 테이블',
            type: TableType.custom,
            rounds: rounds,
          ));

  Widget buildApp(int tableId) {
    final router = GoRouter(
      initialLocation: '/session/$tableId',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('home')),
        ),
        GoRoute(
          path: '/session/:tableId',
          builder: (context, state) => SessionScreen(
            db: db,
            tableId: int.parse(state.pathParameters['tableId']!),
          ),
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

  testWidgets('완주 — 컨트랙션 탭이 세션 결과 타임스탬프로 저장된다', (tester) async {
    final tableId = await insertTable(
        const [Round(breathSec: 2, holdSec: 3)]);

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('phase-label')), findsOneWidget);

    // 준비 호흡 2초 경과 → 홀드 진입.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.byKey(const ValueKey('contraction-tap')), findsOneWidget);

    // 홀드 1초 후 컨트랙션 탭.
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const ValueKey('contraction-tap')));

    // 홀드 종료까지 진행.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('session-end-title')), findsOneWidget);

    final sessions = await db.select(db.sessions).get();
    expect(sessions, hasLength(1));
    expect(sessions.single.completedAt, isNotNull);
    expect(sessions.single.results.single.actualHoldSec, 3);
    expect(sessions.single.results.single.contractionAtMs, [1000]);
  });

  testWidgets('중단 버튼 — 확인 팝업 없이 1탭 종료, 부분 결과 저장', (tester) async {
    final tableId = await insertTable(
        const [Round(breathSec: 1, holdSec: 30)]);

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    // 홀드 2초 진행 후 중단.
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.byKey(const ValueKey('stop-session')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('session-end-title')), findsOneWidget);

    final sessions = await db.select(db.sessions).get();
    expect(sessions, hasLength(1));
    expect(sessions.single.completedAt, isNull);
    expect(sessions.single.results.single.actualHoldSec, 2);
  });

  testWidgets('준비 호흡 중 중단 — 결과가 없으면 저장하지 않는다', (tester) async {
    final tableId = await insertTable(
        const [Round(breathSec: 30, holdSec: 30)]);

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(const ValueKey('stop-session')));
    await tester.pumpAndSettle();

    expect(await db.select(db.sessions).get(), isEmpty);
  });

  testWidgets('저장된 세션은 DB 재조회에서도 유지된다 (기록 저장 왕복)', (tester) async {
    final tableId = await insertTable(
        const [Round(breathSec: 1, holdSec: 1)]);

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // 홈으로 이동 후 별도 쿼리로 재조회 — 세션 화면 상태와 무관하게 남아 있어야 함.
    await tester.tap(find.byKey(const ValueKey('back-home')));
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);

    final again = await (db.select(db.sessions)
          ..where((s) => s.tableId.equals(tableId)))
        .get();
    expect(again, hasLength(1));
  });
}
