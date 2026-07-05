// 훈련 테이블 목록 화면 — 프리셋 + 커스텀 나열, 커스텀 생성/편집 진입
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../data/models.dart';
import '../../data/presets.dart';

class TableListScreen extends StatelessWidget {
  final AppDatabase db;

  const TableListScreen({super.key, required this.db});

  String _typeLabel(AppLocalizations l10n, TableType type) => switch (type) {
        TableType.co2 => l10n.tableTypeCo2,
        TableType.o2 => l10n.tableTypeO2,
        TableType.static_ => l10n.tableTypeStatic,
        TableType.custom => l10n.tableTypeCustom,
      };

  String _formatDuration(int totalSec) {
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tableListTitle)),
      body: StreamBuilder<List<TrainingTable>>(
        stream: db.select(db.trainingTables).watch(),
        builder: (context, snapshot) {
          final tables = snapshot.data ?? const [];
          return ListView(
            children: [
              for (final table in tables)
                ListTile(
                  key: ValueKey('table-${table.id}'),
                  leading: CircleAvatar(
                    child: Text(_typeLabel(l10n, table.type)),
                  ),
                  title: Text(table.name),
                  subtitle: Text(l10n.tableRoundsSummary(
                    table.rounds.length,
                    _formatDuration(totalDurationSec(table.rounds)),
                  )),
                  trailing: table.isPreset
                      ? null
                      : IconButton(
                          key: ValueKey('edit-${table.id}'),
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () =>
                              context.go('/tables/edit/${table.id}'),
                        ),
                  onTap: () => context.go('/session/${table.id}'),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/tables/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.tableListNewCustom),
      ),
    );
  }
}
