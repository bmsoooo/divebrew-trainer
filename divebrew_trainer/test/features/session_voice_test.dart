// 세션 화면의 음성 가이드 호출·Wake Lock 획득/해제 테스트 (fake 주입)
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:divebrew_trainer/data/database.dart';
import 'package:divebrew_trainer/data/models.dart';
import 'package:divebrew_trainer/features/session/session_screen.dart';
import 'package:divebrew_trainer/features/session/voice_guide.dart';
import 'package:divebrew_trainer/features/session/wake_lock.dart';
import 'package:divebrew_trainer/l10n/app_localizations.dart';

class FakeVoiceGuide implements VoiceGuide {
  final List<(String, String)> spoken = [];
  int stopCount = 0;

  @override
  void speak(String text, {required String lang}) => spoken.add((text, lang));

  @override
  void stop() => stopCount++;
}

class FakeWakeLock implements SessionWakeLock {
  int acquired = 0;
  int released = 0;

  @override
  Future<void> acquire() async => acquired++;

  @override
  Future<void> release() async => released++;
}

void main() {
  late AppDatabase db;
  late FakeVoiceGuide voice;
  late FakeWakeLock wakeLock;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    voice = FakeVoiceGuide();
    wakeLock = FakeWakeLock();
  });

  tearDown(() async {
    await db.close();
  });

  Future<Widget> buildApp() async {
    final tableId = await db.into(db.trainingTables).insert(
          TrainingTablesCompanion.insert(
            name: '테스트',
            type: TableType.custom,
            rounds: const [Round(breathSec: 1, holdSec: 2)],
          ),
        );
    final router = GoRouter(
      initialLocation: '/session/$tableId',
      routes: [
        GoRoute(
          path: '/session/:tableId',
          builder: (context, state) => SessionScreen(
            db: db,
            tableId: tableId,
            voiceGuide: voice,
            wakeLock: wakeLock,
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

  testWidgets('단계 전환마다 음성 안내 — 홀드 시작·세션 완료 (ko-KR)', (tester) async {
    await tester.pumpWidget(await buildApp());
    await tester.pumpAndSettle();

    expect(wakeLock.acquired, 1);

    await tester.pump(const Duration(seconds: 1)); // 준비 → 홀드
    await tester.pump(const Duration(seconds: 2)); // 홀드 → 완료
    await tester.pumpAndSettle();

    expect(voice.spoken, [
      ('숨을 참으세요', 'ko-KR'),
      ('세션 완료. 수고했어요', 'ko-KR'),
    ]);
    expect(wakeLock.released, greaterThanOrEqualTo(1));
  });

  testWidgets('중단 시 음성 정지 + wake lock 해제', (tester) async {
    await tester.pumpWidget(await buildApp());
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const ValueKey('stop-session')));
    await tester.pumpAndSettle();

    expect(voice.stopCount, greaterThanOrEqualTo(1));
    expect(wakeLock.released, greaterThanOrEqualTo(1));
  });
}
