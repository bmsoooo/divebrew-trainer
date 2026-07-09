// 앱 진입점 — DB 생성·프리셋 시드·동의 상태 로드 후 라우터를 연결한 MaterialApp 루트
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

import 'app/consent_state.dart';
import 'app/licenses.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'data/database.dart';
import 'data/presets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerBundledLicenses();
  final db = AppDatabase();
  await seedPresetsIfEmpty(db);
  final consent = ConsentState(consented: await db.safetyConsented);
  runApp(DivebrewTrainerApp(db: db, consent: consent));
}

class DivebrewTrainerApp extends StatefulWidget {
  final AppDatabase db;
  final ConsentState consent;

  const DivebrewTrainerApp({super.key, required this.db, required this.consent});

  @override
  State<DivebrewTrainerApp> createState() => _DivebrewTrainerAppState();
}

class _DivebrewTrainerAppState extends State<DivebrewTrainerApp> {
  late final router = createRouter(widget.db, widget.consent);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'divebrew trainer',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildDivebrewTheme(),
      routerConfig: router,
    );
  }
}
