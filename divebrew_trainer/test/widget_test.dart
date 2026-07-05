// 앱 루트가 홈 화면을 렌더링하는지 확인하는 스모크 테스트
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/main.dart';

void main() {
  testWidgets('앱 실행 시 홈 화면이 표시된다', (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(DivebrewTrainerApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('divebrew trainer'), findsOneWidget);
  });
}
