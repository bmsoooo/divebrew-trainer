// 홈 화면 — 인사말, PB 요약 카드, 오늘의 훈련 제안, 빠른 시작 CTA (디자인 핸드오프 01-home)
import 'package:drift/drift.dart' hide Column;
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

  String _typeLabel(AppLocalizations l10n, TableType type) => switch (type) {
        TableType.co2 => l10n.tableTypeCo2,
        TableType.o2 => l10n.tableTypeO2,
        TableType.static_ => l10n.tableTypeStatic,
        TableType.custom => l10n.tableTypeCustom,
      };

  /// 오늘의 훈련 제안 — 첫 훈련이면 CO2 입문, 이후엔 지난 세션과 다른 타입의 첫 프리셋.
  Future<(TrainingTable, String)?> _suggest(AppLocalizations l10n) async {
    final tables = await (db.select(db.trainingTables)
          ..where((t) => t.isPreset.equals(true)))
        .get();
    if (tables.isEmpty) return null;

    final lastSession = await (db.select(db.sessions)
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .getSingleOrNull();

    if (lastSession == null) {
      final first = tables.firstWhere(
        (t) => t.type == TableType.co2,
        orElse: () => tables.first,
      );
      return (first, l10n.homeSuggestionFirst);
    }

    final lastTable = await (db.select(db.trainingTables)
          ..where((t) => t.id.equals(lastSession.tableId)))
        .getSingleOrNull();
    final lastType = lastTable?.type ?? TableType.co2;
    final suggestedType =
        lastType == TableType.co2 ? TableType.o2 : TableType.co2;
    final suggested = tables.firstWhere(
      (t) => t.type == suggestedType,
      orElse: () => tables.first,
    );
    return (
      suggested,
      l10n.homeSuggestionAlternate(
          _typeLabel(l10n, lastType), _typeLabel(l10n, suggestedType)),
    );
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
              Text('DIVEBREW TRAINER',
                  key: const ValueKey('home-eyebrow'),
                  style: utilityLabelStyle),
              const SizedBox(height: 8),
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
              // PB 요약 카드 — 옐로 세로 바가 이 화면의 유일한 악센트.
              StreamBuilder<List<PersonalBest>>(
                stream: db.select(db.personalBests).watch(),
                builder: (context, snapshot) {
                  final pbs = snapshot.data ?? const <PersonalBest>[];
                  final best = pbs.isEmpty
                      ? null
                      : pbs.reduce((a, b) => a.valueSec >= b.valueSec ? a : b);
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
              Text(l10n.homeSuggestionLabel, style: utilityLabelStyle),
              const SizedBox(height: 10),
              FutureBuilder<(TrainingTable, String)?>(
                future: _suggest(l10n),
                builder: (context, snapshot) {
                  final suggestion = snapshot.data;
                  if (suggestion == null) return const SizedBox.shrink();
                  final (table, reason) = suggestion;
                  return _SuggestionCard(
                    table: table,
                    reason: reason,
                    typeLabel: _typeLabel(l10n, table.type),
                  );
                },
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
              const Spacer(),
              FutureBuilder<(TrainingTable, String)?>(
                future: _suggest(l10n),
                builder: (context, snapshot) {
                  final table = snapshot.data?.$1;
                  return FilledButton(
                    key: const ValueKey('home-cta'),
                    onPressed: table == null
                        ? () => context.go('/tables')
                        : () => context.push('/tables/${table.id}'),
                    child: Text(l10n.homeCta),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final TrainingTable table;
  final String reason;
  final String typeLabel;

  const _SuggestionCard({
    required this.table,
    required this.reason,
    required this.typeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      key: const ValueKey('home-suggestion'),
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.push('/tables/${table.id}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: midWater,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: snorkelYellow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    typeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: yellowInk,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    table.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: foam,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(reason,
                style: const TextStyle(fontSize: 14, color: mist, height: 1.5)),
            const SizedBox(height: 12),
            Text(
              l10n.homeSuggestionDetail,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: snorkelYellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
