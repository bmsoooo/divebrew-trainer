// 앱 루트가 홈 화면을 렌더링하는지 확인하는 스모크 테스트
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/main.dart';

void main() {
  testWidgets('앱 실행 시 홈 화면이 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const DivebrewTrainerApp());
    await tester.pumpAndSettle();

    expect(find.text('divebrew trainer'), findsOneWidget);
  });
}
