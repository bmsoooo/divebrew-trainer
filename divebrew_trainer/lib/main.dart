// 앱 진입점 — DB 생성·프리셋 시드 후 라우터를 연결한 MaterialApp 루트
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

import 'app/router.dart';
import 'data/database.dart';
import 'data/presets.dart';

void main() {
  final db = AppDatabase();
  seedPresetsIfEmpty(db);
  runApp(DivebrewTrainerApp(db: db));
}

class DivebrewTrainerApp extends StatefulWidget {
  final AppDatabase db;

  const DivebrewTrainerApp({super.key, required this.db});

  @override
  State<DivebrewTrainerApp> createState() => _DivebrewTrainerAppState();
}

class _DivebrewTrainerAppState extends State<DivebrewTrainerApp> {
  late final router = createRouter(widget.db);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'divebrew trainer',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E8F)),
      ),
      routerConfig: router,
    );
  }
}
