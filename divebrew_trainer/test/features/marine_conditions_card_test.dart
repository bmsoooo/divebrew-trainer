// 다이빙 컨디션 카드의 예보 표시와 실패 안내를 검증하는 위젯 테스트
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/marine_conditions.dart';
import 'package:divebrew_trainer/features/home/marine_conditions_card.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  Widget buildApp(MarineForecastRepository repository) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('ko'),
    home: Scaffold(body: MarineConditionsCard(repository: repository)),
  );

  testWidgets('파고, 수온, 파향과 적합도를 표시한다', (tester) async {
    final repository = MarineForecastRepository(
      loader: (uri) async => {
        'current': {
          'time': '2026-07-10T09:30',
          'wave_height': 0.4,
          'wave_direction': 45,
          'sea_surface_temperature': 21.5,
        },
      },
    );

    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('입수 전 현장 확인'), findsOneWidget);
    expect(find.text('0.4 m'), findsOneWidget);
    expect(find.text('21.5°'), findsOneWidget);
    expect(find.text('북동쪽에서'), findsOneWidget);
  });

  testWidgets('예보 요청이 실패하면 재시도 안내를 표시한다', (tester) async {
    final repository = MarineForecastRepository(
      loader: (uri) async => throw StateError('network unavailable'),
    );

    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('바다 예보를 불러오지 못했어요'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
  });
}
