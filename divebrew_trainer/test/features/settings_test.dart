// 설정 화면 위젯 테스트 — 확인 다이얼로그를 거쳐야 데이터 액션이 실행됨
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/data/presets.dart';
import 'package:divebrew_trainer/features/settings/settings_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(db: db),
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

  Future<void> seedSessionAndCustom() async {
    await seedPresetsIfEmpty(db);
    final id = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: '내 커스텀',
            type: TableType.custom,
            rounds: const [Round(breathSec: 60, holdSec: 30)],
          ),
        );
    await db.saveSession(
      tableId: id,
      type: TableType.custom,
      startedAt: DateTime(2026, 7, 1),
      results: const [RoundResult(round: 1, actualHoldSec: 60)],
    );
  }

  testWidgets('설정 섹션·행이 표시된다', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('설정'), findsWidgets);
    expect(find.text('@divebrew.soo'), findsOneWidget);
    expect(find.text('데이터 관리'), findsOneWidget);
    expect(find.text('이 기기에만 저장'), findsOneWidget);
    expect(find.text('앱 정보'), findsOneWidget);
    expect(find.text('1.0.0 (1)'), findsOneWidget);
  });

  testWidgets('훈련 기록 삭제 — 확인을 눌러야 실행된다', (tester) async {
    await seedSessionAndCustom();
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('훈련 기록 전체 삭제'));
    await tester.pumpAndSettle();

    // 다이얼로그가 뜨고, 아직 삭제되지 않음.
    expect(find.text('취소'), findsOneWidget);
    expect(await db.select(db.sessions).get(), isNotEmpty);

    await tester.tap(find.text('삭제'));
    await tester.pumpAndSettle();

    expect(await db.select(db.sessions).get(), isEmpty);
    // 테이블은 유지.
    expect(await db.select(db.trainingTables).get(), isNotEmpty);
  });

  testWidgets('취소를 누르면 아무것도 지워지지 않는다', (tester) async {
    await seedSessionAndCustom();
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('루틴 + 기록 초기화'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(await db.select(db.sessions).get(), isNotEmpty);
    final tables = await db.select(db.trainingTables).get();
    expect(tables.any((t) => t.name == '내 커스텀'), isTrue);
  });

  testWidgets('루틴 + 기록 초기화 — 확인 시 커스텀·기록이 사라진다', (tester) async {
    await seedSessionAndCustom();
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('루틴 + 기록 초기화'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('삭제'));
    await tester.pumpAndSettle();

    expect(await db.select(db.sessions).get(), isEmpty);
    final tables = await db.select(db.trainingTables).get();
    expect(tables.every((t) => t.isPreset), isTrue);
  });
}
