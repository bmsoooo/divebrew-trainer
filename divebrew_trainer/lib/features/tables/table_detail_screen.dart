// 테이블 상세 화면 — 라운드 미리보기 + 총 훈련 시간, 명시적 "시작하기" 버튼으로만 세션 진입
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../data/presets.dart';
import 'round_timeline.dart';

class TableDetailScreen extends StatelessWidget {
  final AppDatabase db;
  final int tableId;

  const TableDetailScreen({super.key, required this.db, required this.tableId});

  String _formatDuration(int totalSec) {
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(table.name),
            actions: [
              if (!table.isPreset)
                IconButton(
                  key: const ValueKey('detail-edit'),
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push('/tables/edit/${table.id}'),
                ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    l10n.tableEditTotalDuration(
                        _formatDuration(totalDurationSec(table.rounds))),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      RoundTimeline(rounds: table.rounds),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
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
