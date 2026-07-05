// 히스토리 화면 — 세션 목록 + 종류별 최고 홀드 추이 그래프 (fl_chart)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

import '../../app/theme.dart';
import '../../data/backup.dart';
import '../../data/database.dart';
import '../../data/file_transfer.dart';
import '../../data/models.dart';

class HistoryScreen extends StatefulWidget {
  final AppDatabase db;

  const HistoryScreen({super.key, required this.db});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TableType _chartType = TableType.co2;

  String _typeLabel(AppLocalizations l10n, TableType type) => switch (type) {
        TableType.co2 => l10n.tableTypeCo2,
        TableType.o2 => l10n.tableTypeO2,
        TableType.static_ => l10n.tableTypeStatic,
        TableType.custom => l10n.tableTypeCustom,
      };

  int _maxHold(Session s) =>
      s.results.fold(0, (max, r) => r.actualHoldSec > max ? r.actualHoldSec : max);

  String _formatDate(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        actions: [
          IconButton(
            key: const ValueKey('export-backup'),
            tooltip: l10n.backupExport,
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () async {
              final json = await exportToJson(widget.db);
              final stamp =
                  DateTime.now().toIso8601String().split('T').first;
              await saveTextFile('divebrew_trainer_$stamp.json', json);
            },
          ),
          IconButton(
            key: const ValueKey('import-backup'),
            tooltip: l10n.backupImport,
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final content = await pickTextFile();
              if (content == null) return;
              try {
                await importFromJson(widget.db, content);
                messenger.showSnackBar(
                    SnackBar(content: Text(l10n.backupImportDone)));
              } on FormatException {
                messenger.showSnackBar(
                    SnackBar(content: Text(l10n.backupImportFailed)));
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<SessionWithTable>>(
        stream: widget.db.watchSessionsWithTable(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? const <SessionWithTable>[];

          if (snapshot.hasData && items.isEmpty) {
            return Center(
              child: Text(
                l10n.historyEmpty,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          // 그래프 데이터: 선택 종류의 세션을 시간 오름차순으로.
          final chartItems = items
              .where((e) => e.table.type == _chartType)
              .toList()
              .reversed
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.historyPbChartTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<TableType>(
                segments: [
                  for (final t in [TableType.co2, TableType.o2, TableType.custom])
                    ButtonSegment(value: t, label: Text(_typeLabel(l10n, t))),
                ],
                selected: {_chartType},
                onSelectionChanged: (s) => setState(() => _chartType = s.first),
                showSelectedIcon: false,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: chartItems.isEmpty
                    ? Card(
                        child: Center(
                          child: Text(
                            l10n.historyEmpty,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      )
                    : Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: const FlTitlesData(
                                topTitles: AxisTitles(),
                                rightTitles: AxisTitles(),
                                bottomTitles: AxisTitles(),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true, reservedSize: 36),
                                ),
                              ),
                              minY: 0,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    for (var i = 0; i < chartItems.length; i++)
                                      FlSpot(
                                        i.toDouble(),
                                        _maxHold(chartItems[i].session)
                                            .toDouble(),
                                      ),
                                  ],
                                  color: snorkelYellow,
                                  barWidth: 3,
                                  isCurved: false,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              for (final item in items)
                Card(
                  key: ValueKey('history-${item.session.id}'),
                  child: ListTile(
                    title: Text(item.table.name),
                    subtitle: Text(
                      '${_formatDate(item.session.startedAt)} · '
                      '${l10n.historyRounds(item.session.results.length, item.table.rounds.length)}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.historyMaxHold(_maxHold(item.session)),
                          style: const TextStyle(
                            color: snorkelYellow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (item.session.completedAt == null)
                          Text(
                            l10n.historyStoppedBadge,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
