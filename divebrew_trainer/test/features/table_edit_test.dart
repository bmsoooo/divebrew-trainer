// 커스텀 테이블 편집 화면 위젯 테스트 — 라운드 추가/삭제/저장 (checklist M1 verify)
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/features/tables/table_edit_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildApp({int? tableId, String initialPath = '/tables/new'}) {
    final router = GoRouter(
      initialLocation: initialPath,
      routes: [
        GoRoute(
          path: '/tables',
          builder: (context, state) =>
              const Scaffold(body: Text('table-list')),
        ),
        GoRoute(
          path: '/tables/new',
          builder: (context, state) => TableEditScreen(db: db),
        ),
        GoRoute(
          path: '/tables/edit/:id',
          builder: (context, state) => TableEditScreen(
            db: db,
            tableId: int.parse(state.pathParameters['id']!),
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

  testWidgets('라운드 추가 — 카드가 2개로 늘어난다', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('round-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-1')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('add-round')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('round-1')), findsOneWidget);
  });

  testWidgets('라운드 삭제 — 카드가 사라진다', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('remove-0')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('round-0')), findsNothing);
  });

  testWidgets('저장 — 이름·라운드 값이 DB에 기록되고 목록으로 이동한다', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, '').first, '내 커스텀');
    await tester.enterText(find.byKey(const ValueKey('hold-0')), '75');
    await tester.tap(find.byKey(const ValueKey('add-round')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('save-table')));
    await tester.tap(find.byKey(const ValueKey('save-table')));
    await tester.pumpAndSettle();

    expect(find.text('table-list'), findsOneWidget);

    final saved = await db.select(db.trainingTables).get();
    expect(saved, hasLength(1));
    expect(saved.single.name, '내 커스텀');
    expect(saved.single.type, TableType.custom);
    expect(saved.single.rounds, hasLength(2));
    expect(saved.single.rounds.first.holdSec, 75);
  });

  testWidgets('빈 이름으로 저장하면 DB에 기록되지 않는다', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('save-table')));
    await tester.tap(find.byKey(const ValueKey('save-table')));
    await tester.pumpAndSettle();

    expect(await db.select(db.trainingTables).get(), isEmpty);
  });

  testWidgets('기존 테이블 편집 — 라운드 추가 후 저장하면 갱신된다', (tester) async {
    final id = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: '기존 테이블',
            type: TableType.custom,
            rounds: const [Round(breathSec: 100, holdSec: 50)],
          ),
        );

    await tester.pumpWidget(buildApp(initialPath: '/tables/edit/$id'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('add-round')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('save-table')));
    await tester.tap(find.byKey(const ValueKey('save-table')));
    await tester.pumpAndSettle();

    final saved = await (db.select(db.trainingTables)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(saved.rounds, hasLength(2));
    expect(saved.rounds.last, const Round(breathSec: 100, holdSec: 50));
  });
}
