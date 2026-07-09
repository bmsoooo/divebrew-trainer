// 법률 문서·문의 이메일 테스트 — 개인정보 보호법 제30조 필수 항목 포함 검증
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/features/settings/legal_page.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) {
    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (c, s) => child)],
    );
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ko'),
      routerConfig: router,
    );
  }

  Future<AppLocalizations> loadKo() =>
      AppLocalizations.delegate.load(const Locale('ko'));

  test('개인정보처리방침 — 제30조 필수 항목이 모두 포함된다', () async {
    final l10n = await loadKo();
    final body = l10n.privacyBody;

    // 법 제30조 및 시행령이 요구하는 목차 항목들.
    expect(body, contains('처리 목적'));
    expect(body, contains('보유 기간'));
    expect(body, contains('제3자 제공'));
    expect(body, contains('위탁'));
    expect(body, contains('파기'));
    expect(body, contains('정보주체의 권리'));
    expect(body, contains('자동 수집 장치'));
    expect(body, contains('안전성 확보 조치'));
    expect(body, contains('개인정보 보호책임자'));
    expect(body, contains('divebrew@gmail.com'));
    // 미수집·로컬 저장 명시.
    expect(body, contains('수집'));
    expect(body, contains('기기'));
    // 시행일.
    expect(body, contains('2026년 7월 9일'));
  });

  test('이용약관 — 표준 조 구성과 안전·면책·준거법이 포함된다', () async {
    final l10n = await loadKo();
    final body = l10n.termsBody;

    expect(body, contains('제1조'));
    expect(body, contains('목적'));
    expect(body, contains('약관의 효력'));
    expect(body, contains('안전'));
    expect(body, contains('과호흡'));
    expect(body, contains('의료기기가 아니'));
    expect(body, contains('책임의 제한'));
    expect(body, contains('준거법'));
    expect(body, contains('대한민국'));
    expect(body, contains('divebrew@gmail.com'));
  });

  testWidgets('LegalPage — 조 제목이 렌더링된다', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final l10n = await loadKo();
    await tester.pumpWidget(
        wrap(LegalPage(title: l10n.settingsPrivacy, body: l10n.privacyBody)));
    await tester.pumpAndSettle();

    expect(find.textContaining('제1조'), findsOneWidget);
    expect(find.text(l10n.settingsPrivacy), findsOneWidget);
  });
}
