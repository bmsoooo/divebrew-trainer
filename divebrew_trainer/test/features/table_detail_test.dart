// 테이블 상세 화면 테스트 — 라운드 미리보기, 시작 버튼 진입, 편집 진입점 (프리셋은 편집 불가)
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/features/tables/table_detail_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildApp(int tableId) {
    final router = GoRouter(
      initialLocation: '/tables/$tableId',
      routes: [
        GoRoute(
          path: '/tables/:id',
          builder: (context, state) => TableDetailScreen(
            db: db,
            tableId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/tables/edit/:id',
          builder: (context, state) =>
              Scaffold(body: Text('edit-${state.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/session/:tableId',
          builder: (context, state) =>
              Scaffold(body: Text('session-${state.pathParameters['tableId']}')),
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

  testWidgets('라운드 미리보기와 총 훈련 시간이 표시된다', (tester) async {
    final tableId = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: '내 커스텀',
            type: TableType.custom,
            rounds: const [
              Round(breathSec: 60, holdSec: 30),
              Round(breathSec: 60, holdSec: 45),
            ],
          ),
        );

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    expect(find.textContaining('내 커스텀'), findsOneWidget);
    expect(find.byKey(const ValueKey('timeline-round-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('timeline-round-1')), findsOneWidget);
    expect(find.text('숨참기 0:30'), findsOneWidget);
    expect(find.text('숨참기 0:45'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('커스텀 테이블은 편집 아이콘이 있고 탭하면 편집 화면으로 이동', (tester) async {
    final tableId = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: '내 커스텀',
            type: TableType.custom,
            rounds: const [Round(breathSec: 60, holdSec: 30)],
          ),
        );

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('detail-edit')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('detail-edit')));
    await tester.pumpAndSettle();

    expect(find.text('edit-$tableId'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('프리셋은 편집 아이콘이 없다', (tester) async {
    final tableId = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: 'CO2 입문',
            type: TableType.co2,
            rounds: const [Round(breathSec: 60, holdSec: 30)],
            isPreset: const Value(true),
          ),
        );

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('detail-edit')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('시작하기 버튼을 누르면 세션 화면으로 이동한다', (tester) async {
    final tableId = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: '내 커스텀',
            type: TableType.custom,
            rounds: const [Round(breathSec: 60, holdSec: 30)],
          ),
        );

    await tester.pumpWidget(buildApp(tableId));
    await tester.pumpAndSettle();

    expect(find.text('session-$tableId'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('table-detail-start')));
    await tester.pumpAndSettle();

    expect(find.text('session-$tableId'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
