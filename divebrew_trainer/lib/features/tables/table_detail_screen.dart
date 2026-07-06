// 테이블 상세 — Mid-water 배경, 다이브 프로파일 카드, 스탯 타일, 라운드 리스트, 하단 "시작하기" (디자인 03-detail)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/models.dart';
import '../../data/presets.dart';
import '../../l10n/app_localizations.dart';
import 'dive_profile_line.dart';

class TableDetailScreen extends StatelessWidget {
  final AppDatabase db;
  final int tableId;

  const TableDetailScreen({super.key, required this.db, required this.tableId});

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<TrainingTable>(
      stream: (db.select(db.trainingTables)
            ..where((t) => t.id.equals(tableId)))
          .watchSingle(),
      builder: (context, snapshot) {
        final table = snapshot.data;
        if (table == null) {
          return const Scaffold(
            backgroundColor: midWater,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final totalMin = (totalDurationSec(table.rounds) / 60).round();

        // 깊이 스테이징 2단계 — 상세 화면은 Mid-water 배경.
        return Scaffold(
          backgroundColor: midWater,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => context.pop(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                l10n.detailBack,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: mist,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (!table.isPreset)
                            IconButton(
                              key: const ValueKey('detail-edit'),
                              icon: const Icon(Icons.edit_outlined,
                                  color: mist, size: 20),
                              onPressed: () =>
                                  context.push('/tables/edit/${table.id}'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: snorkelYellow,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              _typeLabel(l10n, table.type),
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
                              '${table.name} · ${table.rounds.length}라운드',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: foam,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 다이브 프로파일 카드 (Abyss 중첩 타일).
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                        decoration: BoxDecoration(
                          color: abyss,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.detailProfileLabel,
                                style: utilityLabelStyle.copyWith(
                                    fontSize: 11)),
                            const SizedBox(height: 10),
                            DiveProfileLine(rounds: table.rounds),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(l10n.detailColRound(1),
                                    style: const TextStyle(
                                        fontSize: 11, color: mist)),
                                Text(
                                    l10n.detailColRound(table.rounds.length),
                                    style: const TextStyle(
                                        fontSize: 11, color: mist)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              label: l10n.detailStatTotal,
                              value: l10n.tableListMinutes(totalMin),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatTile(
                              label: l10n.detailStatRounds,
                              value: l10n
                                  .detailStatRoundsValue(table.rounds.length),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      for (var i = 0; i < table.rounds.length; i++)
                        Container(
                          key: ValueKey('timeline-round-$i'),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: foam.withValues(alpha: 0.14)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(l10n.detailColRound(i + 1),
                                    style: const TextStyle(
                                        fontSize: 13, color: foam)),
                              ),
                              Expanded(
                                child: Text(
                                  l10n.detailColHold(
                                      _formatSec(table.rounds[i].holdSec)),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: foam),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  l10n.detailColBreath(
                                      _formatSec(table.rounds[i].breathSec)),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 13, color: mist),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: FilledButton(
                    key: const ValueKey('table-detail-start'),
                    onPressed: () => context.push('/session/${table.id}'),
                    child: Text(l10n.tableDetailStart),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: abyss,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: utilityLabelStyle.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: foam,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
