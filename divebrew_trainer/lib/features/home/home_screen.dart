// 홈 화면 — 인사말, 스테틱 PB 요약, 단발 스테틱 시작 카드, 가이드 진입, 테이블 CTA (디자인 핸드오프 01-home)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/models.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final AppDatabase db;

  const HomeScreen({super.key, required this.db});

  String _formatSec(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
              Row(
                children: [
                  Expanded(
                    child: Text('DIVEBREW TRAINER',
                        key: const ValueKey('home-eyebrow'),
                        style: utilityLabelStyle),
                  ),
                  // 내 자격증 빠른 진입 — 세로 공간 안 잡고 상단에서 바로.
                  IconButton(
                    key: const ValueKey('home-license'),
                    tooltip: l10n.licenseHomeTooltip,
                    icon: const Icon(Icons.badge_outlined, color: mist),
                    onPressed: () => context.push('/license'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeGreeting,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: foam,
                ),
              ),
              const SizedBox(height: 20),
              // PB 요약 카드 — 단발 스테틱 최고 기록만 반영 (옐로 세로 바가 유일한 악센트).
              StreamBuilder<PersonalBest?>(
                stream: (db.select(db.personalBests)
                      ..where((p) => p.type.equals(TableType.static_.name)))
                    .watchSingleOrNull(),
                builder: (context, snapshot) {
                  final best = snapshot.data;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: oceanRaised,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.homePbLabel, style: utilityLabelStyle),
                              const SizedBox(height: 6),
                              Text(
                                best == null
                                    ? '-:--'
                                    : _formatSec(best.valueSec),
                                key: const ValueKey('home-pb'),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                best == null
                                    ? l10n.homePbEmpty
                                    : l10n.homePbDate(
                                        '${best.achievedAt.month}월 ${best.achievedAt.day}일'),
                                style:
                                    const TextStyle(fontSize: 13, color: mist),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 52,
                          color: snorkelYellow.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(l10n.homeStaticSection, style: utilityLabelStyle),
              const SizedBox(height: 10),
              // 단발 스테틱 시작 카드 — 탭하면 3→2→1 카운트다운 후 열린 숨참기.
              InkWell(
                key: const ValueKey('home-static'),
                borderRadius: BorderRadius.circular(24),
                onTap: () => context.push('/static'),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: midWater,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: abyss,
                        child: Icon(Icons.timer_outlined,
                            color: snorkelYellow, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.homeStaticTitle,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: foam)),
                            const SizedBox(height: 3),
                            Text(l10n.homeStaticSubtitle,
                                style: const TextStyle(
                                    fontSize: 13, color: mist, height: 1.4)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: mist),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 초보자 가이드 진입 — 신규 사용자가 홈에서 바로 발견하도록.
              InkWell(
                key: const ValueKey('home-guide'),
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.push('/guide'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: oceanBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_outlined,
                          color: snorkelYellow, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.homeGuideCard,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: foam)),
                            const SizedBox(height: 3),
                            Text(l10n.homeGuideCardSub,
                                style: const TextStyle(
                                    fontSize: 12.5, color: mist, height: 1.4)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: mist),
                    ],
                  ),
                ),
              ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const ValueKey('home-cta'),
                onPressed: () => context.go('/tables'),
                child: Text(l10n.homeBrowseTables),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
