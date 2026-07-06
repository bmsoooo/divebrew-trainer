// 자격증 사진 저장/조회/삭제 + 화면 상태 테스트
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/features/license/license_screen.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('자격증 사진 저장·조회·삭제 왕복', () async {
    expect(await db.watchLicenseImage().first, isNull);

    final b64 = base64Encode([1, 2, 3, 4]);
    await db.setLicenseImage(b64);
    expect(await db.watchLicenseImage().first, b64);

    await db.clearLicenseImage();
    expect(await db.watchLicenseImage().first, isNull);
  });

  Widget wrap() {
    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (c, s) => LicenseScreen(db: db))],
    );
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ko'),
      routerConfig: router,
    );
  }

  testWidgets('사진 없으면 빈 상태 + 올리기 버튼', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('license-upload')), findsOneWidget);
    expect(find.byKey(const ValueKey('license-image')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('사진 있으면 이미지 + 교체/삭제 버튼', (tester) async {
    // 1x1 투명 PNG.
    const png =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';
    await db.setLicenseImage(png);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('license-image')), findsOneWidget);
    expect(find.byKey(const ValueKey('license-replace')), findsOneWidget);
    expect(find.byKey(const ValueKey('license-delete')), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
