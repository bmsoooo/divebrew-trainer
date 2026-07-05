// 앱 루트 스모크 테스트 — 동의 여부에 따른 첫 화면 분기
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/app/consent_state.dart';
import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/main.dart';

void main() {
  testWidgets('동의 완료 상태면 홈 화면이 표시된다', (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(DivebrewTrainerApp(
      db: db,
      consent: ConsentState(consented: true),
    ));
    await tester.pumpAndSettle();

    expect(find.text('divebrew trainer'), findsOneWidget);
  });
}
