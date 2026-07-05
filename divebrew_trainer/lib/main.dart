// 앱 진입점 — 라우터를 연결한 MaterialApp 루트
import 'package:flutter/material.dart';

import 'app/router.dart';

void main() {
  runApp(const DivebrewTrainerApp());
}

class DivebrewTrainerApp extends StatelessWidget {
  const DivebrewTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'divebrew trainer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E8F)),
      ),
      routerConfig: appRouter,
    );
  }
}
