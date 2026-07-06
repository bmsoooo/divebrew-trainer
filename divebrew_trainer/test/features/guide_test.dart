// 훈련 가이드 화면 + 진입점(홈·설정) 테스트
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/features/guide/guide_screen.dart';
import 'package:divebrew_trainer/features/settings/settings_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget home, {List<GoRoute> extra = const []}) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (c, s) => home),
        GoRoute(path: '/guide', builder: (c, s) => const GuideScreen()),
        ...extra,
      ],
    );
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ko'),
      routerConfig: router,
    );
  }

  testWidgets('가이드 화면에 5개 섹션이 모두 표시된다', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const GuideScreen()));
    await tester.pumpAndSettle();

    expect(find.text('스태틱 훈련이 뭐예요?'), findsOneWidget);
    expect(find.text('CO2 테이블이란?'), findsOneWidget);
    expect(find.text('O2 테이블이란?'), findsOneWidget);
    expect(find.text('왜 훈련하면 숨참기가 늘어요?'), findsOneWidget);
    expect(find.text('딱 하나, 꼭 기억해요'), findsOneWidget);
    // 과호흡 금지 안전 메시지가 실제로 담겨 있는지.
    expect(find.textContaining('과호흡'), findsOneWidget);
  });

  testWidgets('설정의 훈련 가이드 행을 누르면 가이드 화면으로 이동', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(wrap(SettingsScreen(db: db)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('settings-guide')));
    await tester.pumpAndSettle();

    expect(find.text('스태틱 훈련이 뭐예요?'), findsOneWidget);
  });
}
