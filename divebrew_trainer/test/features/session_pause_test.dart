// 세션 화면의 일시정지/재개 UI 테스트 — 버튼 전환, 타이머 정지·재개, 일시정지 중 중단 가능
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/features/session/session_screen.dart';
import 'package:divebrew_trainer/features/tables/dive_profile_line.dart';
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

  testWidgets('일시정지 누르면 재개 버튼으로 바뀌고 타이머가 멈춘다', (tester) async {
    final tableId = await insertTable(const [Round(breathSec: 10, holdSec: 10)]);
    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('pause-session')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('resume-session')), findsOneWidget);
    expect(find.text('일시정지됨'), findsOneWidget);
    expect(find.text('0:10'), findsOneWidget);

    // 일시정지 중에는 시간이 흐르지 않아야 한다.
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('0:10'), findsOneWidget);
  });

  testWidgets('홀드 중 일시정지하면 컨트랙션/조기종료 버튼이 숨겨진다', (tester) async {
    final tableId = await insertTable(const [Round(breathSec: 1, holdSec: 10)]);
    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 1)); // 홀드 진입
    expect(find.byKey(const ValueKey('contraction-tap')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('pause-session')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('contraction-tap')), findsNothing);
    expect(find.byKey(const ValueKey('end-hold-early')), findsNothing);
  });

  testWidgets('재개하면 타이머가 다시 흐른다', (tester) async {
    final tableId = await insertTable(const [Round(breathSec: 10, holdSec: 10)]);
    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(const ValueKey('pause-session')));
    await tester.pumpAndSettle();
    expect(find.text('0:08'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('resume-session')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('0:06'), findsOneWidget);
  });

  testWidgets('일시정지 중에도 중단 가능 — 결과가 저장된다', (tester) async {
    final tableId = await insertTable(const [Round(breathSec: 1, holdSec: 30)]);
    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 3)); // 준비1초+홀드2초
    await tester.tap(find.byKey(const ValueKey('pause-session')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('stop-session')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('session-end-title')), findsOneWidget);

    final sessions = await db.select(db.sessions).get();
    expect(sessions, hasLength(1));
    expect(sessions.single.results.single.actualHoldSec, 2);
  });

  testWidgets('세션 화면에 다이브 프로파일 라인이 표시된다', (tester) async {
    final tableId = await insertTable(const [
      Round(breathSec: 1, holdSec: 2),
      Round(breathSec: 1, holdSec: 5),
    ]);
    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    expect(find.byType(DiveProfileLine), findsOneWidget);

    await tester.pump(const Duration(seconds: 3)); // 1라운드 완주 (준비1+홀드2)
    expect(find.byType(DiveProfileLine), findsOneWidget);
  });
}
