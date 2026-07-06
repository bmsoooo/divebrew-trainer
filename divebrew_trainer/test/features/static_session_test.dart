// 단발 스테틱 세션 + 카운트다운 테스트 — 열린 숨참기, 스테틱 PB 갱신
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/data/presets.dart';
import 'package:divebrew_trainer/features/session/countdown_view.dart';
import 'package:divebrew_trainer/features/session/session_screen.dart';
import 'package:divebrew_trainer/features/session/static_session_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget wrapStatic({int countdown = 0}) {
    final router = GoRouter(
      initialLocation: '/static',
      routes: [
        GoRoute(
            path: '/', builder: (c, s) => const Scaffold(body: Text('home'))),
        GoRoute(
          path: '/static',
          builder: (c, s) =>
              StaticSessionScreen(db: db, countdownSeconds: countdown),
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

  testWidgets('열린 숨참기 — 시간이 위로 올라가고 완료 시 스테틱 PB 저장', (tester) async {
    await seedPresetsIfEmpty(db);
    await tester.pumpWidget(wrapStatic());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('static-timer')), findsOneWidget);
    expect(find.text('0:00'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('0:05'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('static-done')));
    await tester.pumpAndSettle();

    // 결과 화면 + 새 PB.
    expect(find.byKey(const ValueKey('static-result')), findsOneWidget);
    expect(find.byKey(const ValueKey('static-new-pb')), findsOneWidget);

    // 스테틱 PB가 저장됐다.
    final pb = await (db.select(db.personalBests)
          ..where((p) => p.type.equals(TableType.static_.name)))
        .getSingle();
    expect(pb.valueSec, 5);

    // 세션도 단발 스테틱 테이블에 저장.
    final staticTable = await findStaticTable(db);
    final sessions = await db.select(db.sessions).get();
    expect(sessions.single.tableId, staticTable!.id);
  });

  testWidgets('이전 PB보다 짧으면 새 기록 문구가 안 뜬다', (tester) async {
    await seedPresetsIfEmpty(db);
    final staticTable = await findStaticTable(db);
    await db.saveSession(
      tableId: staticTable!.id,
      type: TableType.static_,
      startedAt: DateTime(2026, 7, 1),
      results: const [RoundResult(round: 1, actualHoldSec: 60)],
    );

    await tester.pumpWidget(wrapStatic());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.byKey(const ValueKey('static-done')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('static-new-pb')), findsNothing);
    // PB는 60초 그대로.
    final pb = await (db.select(db.personalBests)
          ..where((p) => p.type.equals(TableType.static_.name)))
        .getSingle();
    expect(pb.valueSec, 60);
  });

  testWidgets('카운트다운 3→2→1 후 숨참기 시작', (tester) async {
    await seedPresetsIfEmpty(db);
    await tester.pumpWidget(wrapStatic(countdown: 3));
    await tester.pumpAndSettle();

    expect(find.byType(CountdownView), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));

    // 카운트다운 끝 → 숨참기 화면.
    expect(find.byType(CountdownView), findsNothing);
    expect(find.byKey(const ValueKey('static-timer')), findsOneWidget);
  });

  testWidgets('테이블 세션도 카운트다운 후 시작된다', (tester) async {
    final tableId = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: 'CO2',
            type: TableType.co2,
            rounds: const [Round(breathSec: 5, holdSec: 5)],
          ),
        );
    final router = GoRouter(
      initialLocation: '/session/$tableId',
      routes: [
        GoRoute(
          path: '/session/:tableId',
          builder: (c, s) => SessionScreen(
            db: db,
            tableId: int.parse(s.pathParameters['tableId']!),
            countdownSeconds: 3,
          ),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ko'),
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CountdownView), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(CountdownView), findsNothing);
    expect(find.byKey(const ValueKey('timer')), findsOneWidget);
  });
}
