// 훈련 테이블 목록 — CO2/O2/커스텀 섹션 카드 + "나만의 테이블 만들기" (디자인 핸드오프 02-tables)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/models.dart';
import '../../data/presets.dart';
import '../../l10n/app_localizations.dart';

class TableListScreen extends StatelessWidget {
  final AppDatabase db;

  const TableListScreen({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<TrainingTable>>(
          stream: db.select(db.trainingTables).watch(),
          builder: (context, snapshot) {
            final tables = snapshot.data ?? const <TrainingTable>[];
            final co2 =
                tables.where((t) => t.type == TableType.co2).toList();
            final o2 = tables.where((t) => t.type == TableType.o2).toList();
            // 단발 스테틱 시드 테이블(static_)은 홈 카드에서만 진입 — 목록엔 커스텀만.
            final custom =
                tables.where((t) => t.type == TableType.custom).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text(l10n.tableListTitle,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: foam)),
                const SizedBox(height: 6),
                Text(l10n.tableListIntro,
                    style: const TextStyle(
                        fontSize: 13, color: mist, height: 1.5)),
                const SizedBox(height: 20),
                if (co2.isNotEmpty) ...[
                  Text(l10n.tableListSectionCo2, style: utilityLabelStyle),
                  const SizedBox(height: 10),
                  for (final t in co2) _TableCard(table: t),
                  const SizedBox(height: 20),
                ],
                if (o2.isNotEmpty) ...[
                  Text(l10n.tableListSectionO2, style: utilityLabelStyle),
                  const SizedBox(height: 10),
                  for (final t in o2) _TableCard(table: t),
                  const SizedBox(height: 20),
                ],
                Text(l10n.tableListSectionCustom, style: utilityLabelStyle),
                const SizedBox(height: 10),
                for (final t in custom) _TableCard(table: t),
                _CreateCustomCard(l10n: l10n),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TableCard extends StatelessWidget {
  final TrainingTable table;

  const _TableCard({required this.table});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalMin = (totalDurationSec(table.rounds) / 60).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        key: ValueKey('table-${table.id}'),
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/tables/${table.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: oceanRaised,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${table.name} · ${table.rounds.length}라운드',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: foam,
                      ),
                    ),
                  ),
                  Text(
                    l10n.tableListMinutes(totalMin),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: mist,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateCustomCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _CreateCustomCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const ValueKey('create-custom'),
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push('/tables/new'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: foam.withValues(alpha: 0.14),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            l10n.tableListCreateCustom,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: mist,
            ),
          ),
        ),
      ),
    );
  }
}
