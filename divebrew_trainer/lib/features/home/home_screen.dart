// 홈 화면 — 오늘의 훈련 제안 + PB 요약 + 빠른 시작 (현재는 테이블 목록 진입만)
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.appTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/tables'),
              child: Text(l10n.homeTables),
            ),
          ],
        ),
      ),
    );
  }
}
