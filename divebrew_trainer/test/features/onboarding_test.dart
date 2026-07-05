// 온보딩 안전 동의 게이트 테스트 — 미동의 시 진행 불가 (checklist M2 verify)
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/app/consent_state.dart';
import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/main.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget app({bool consented = false}) => DivebrewTrainerApp(
        db: db,
        consent: ConsentState(consented: consented),
      );

  /// 4항목이 모두 화면에 들어오도록 세로 뷰포트를 키운다.
  void useTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('미동의 상태면 어떤 경로든 온보딩으로 리다이렉트된다', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('agree-button')), findsOneWidget);
    expect(find.text('divebrew trainer'), findsNothing);
  });

  testWidgets('4항목 전체 체크 전에는 동의 버튼이 비활성', (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    FilledButton button() =>
        tester.widget(find.byKey(const ValueKey('agree-button')));
    expect(button().onPressed, isNull);

    // 3개만 체크 — 여전히 비활성.
    for (var i = 0; i < 3; i++) {
      await tester.ensureVisible(find.byKey(ValueKey('consent-$i')));
      await tester.tap(find.byKey(ValueKey('consent-$i')));
    }
    await tester.pumpAndSettle();
    expect(button().onPressed, isNull);

    // 4번째 체크 — 활성화.
    await tester.ensureVisible(find.byKey(const ValueKey('consent-3')));
    await tester.tap(find.byKey(const ValueKey('consent-3')));
    await tester.pumpAndSettle();
    expect(button().onPressed, isNotNull);
  });

  testWidgets('전체 동의 후 홈으로 진행되고 DB에 영구 저장된다', (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    for (var i = 0; i < 4; i++) {
      await tester.ensureVisible(find.byKey(ValueKey('consent-$i')));
      await tester.tap(find.byKey(ValueKey('consent-$i')));
    }
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('agree-button')));
    await tester.pumpAndSettle();

    expect(find.text('divebrew trainer'), findsOneWidget);
    expect(await db.safetyConsented, isTrue);
  });

  testWidgets('이미 동의한 사용자는 온보딩을 건너뛴다', (tester) async {
    await tester.pumpWidget(app(consented: true));
    await tester.pumpAndSettle();

    expect(find.text('divebrew trainer'), findsOneWidget);
    expect(find.byKey(const ValueKey('agree-button')), findsNothing);
  });
}
