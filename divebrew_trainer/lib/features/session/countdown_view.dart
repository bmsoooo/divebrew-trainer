// 세션 시작 전 3→2→1 카운트다운 화면 — 테이블 세션·단발 스테틱 공용
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

class CountdownView extends StatelessWidget {
  /// 현재 카운트 숫자 (3, 2, 1).
  final int value;

  const CountdownView({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: abyss,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.countdownReady,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: mist),
              ),
              const SizedBox(height: 16),
              Text(
                '$value',
                key: ValueKey('countdown-$value'),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: snorkelYellow, fontSize: 120),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
