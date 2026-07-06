// 히스토리 — 스탯 칩 3개, PB 추이 라인, 세션 리스트 행 (디자인 05-history) + JSON 내보내기/가져오기
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/backup.dart';
import '../../data/database.dart';
import '../../data/file_transfer.dart';
import '../../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  final AppDatabase db;

  const HistoryScreen({super.key, required this.db});

  int _maxHold(Session s) => s.results
      .fold(0, (max, r) => r.actualHoldSec > max ? r.actualHoldSec : max);

  String _formatSec(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime d) => '${d.month}월 ${d.day}일';

  int _daysThisWeek(List<SessionWithTable> items) {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return items
        .where((e) => !e.session.startedAt.isBefore(weekStart))
        .map((e) => DateTime(e.session.startedAt.year,
            e.session.startedAt.month, e.session.startedAt.day))
        .toSet()
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<SessionWithTable>>(
          stream: db.watchSessionsWithTable(),
          builder: (context, snapshot) {
            final items = snapshot.data ?? const <SessionWithTable>[];
            final pb = items.isEmpty
                ? 0
                : items.map((e) => _maxHold(e.session)).reduce(
                    (a, b) => a >= b ? a : b);
            // 추이: 최근 6세션, 과거→최신.
            final trend = items.take(6).toList().reversed.toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(l10n.historyTitle,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: foam)),
                    ),
                    IconButton(
                      key: const ValueKey('export-backup'),
                      tooltip: l10n.backupExport,
                      icon: const Icon(Icons.file_download_outlined,
                          color: mist, size: 20),
                      onPressed: () async {
                        final json = await exportToJson(db);
                        final stamp =
                            DateTime.now().toIso8601String().split('T').first;
                        await saveTextFile(
                            'divebrew_trainer_$stamp.json', json);
                      },
                    ),
                    IconButton(
                      key: const ValueKey('import-backup'),
                      tooltip: l10n.backupImport,
                      icon: const Icon(Icons.file_upload_outlined,
                          color: mist, size: 20),
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final content = await pickTextFile();
                        if (content == null) return;
                        try {
                          await importFromJson(db, content);
                          messenger.showSnackBar(SnackBar(
                              content: Text(l10n.backupImportDone)));
                        } on FormatException {
                          messenger.showSnackBar(SnackBar(
                              content: Text(l10n.backupImportFailed)));
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatChip(
                        label: l10n.historyStatSessions,
                        value: l10n.historyStatSessionsValue(items.length),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatChip(
                        label: l10n.historyStatPb,
                        value: pb == 0 ? '-:--' : _formatSec(pb),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatChip(
                        label: l10n.historyStatWeek,
                        value: l10n.historyStatWeekValue(_daysThisWeek(items)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                  decoration: BoxDecoration(
                    color: oceanRaised,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.historyPbTrend, style: utilityLabelStyle),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 64,
                        child: trend.length < 2
                            ? Center(
                                child: Text(
                                  l10n.historyEmpty.split('\n').first,
                                  style: const TextStyle(
                                      fontSize: 12, color: mist),
                                ),
                              )
                            : LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: const FlTitlesData(
                                    topTitles: AxisTitles(),
                                    rightTitles: AxisTitles(),
                                    bottomTitles: AxisTitles(),
                                    leftTitles: AxisTitles(),
                                  ),
                                  lineTouchData:
                                      const LineTouchData(enabled: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [
                                        for (var i = 0;
                                            i < trend.length;
                                            i++)
                                          FlSpot(
                                              i.toDouble(),
                                              _maxHold(trend[i].session)
                                                  .toDouble()),
                                      ],
                                      color: snorkelYellow,
                                      barWidth: 2.5,
                                      isCurved: false,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, _, bar, index) =>
                                            FlDotCirclePainter(
                                          radius: index == trend.length - 1
                                              ? 4.5
                                              : 3,
                                          color: snorkelYellow,
                                          strokeWidth: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      l10n.historyEmpty,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, color: mist, height: 1.6),
                    ),
                  ),
                for (final item in items)
                  Container(
                    key: ValueKey('history-${item.session.id}'),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: foam.withValues(alpha: 0.14)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.table.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: foam,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${_formatDate(item.session.startedAt)} · '
                                '${l10n.historyRounds(item.session.results.length, item.table.rounds.length)}'
                                '${item.session.completedAt == null ? ' · ${l10n.historyStoppedBadge}' : ''}',
                                style: const TextStyle(
                                    fontSize: 12.5, color: mist),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatSec(_maxHold(item.session)),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: snorkelYellow,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: oceanRaised,
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
