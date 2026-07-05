// 커스텀 테이블 편집 화면 — 라운드 추가/삭제, breath/hold 편집, 총 시간 표시, 저장
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../data/models.dart';
import '../../data/presets.dart';

class TableEditScreen extends StatefulWidget {
  final AppDatabase db;

  /// null이면 새 커스텀 테이블 생성.
  final int? tableId;

  const TableEditScreen({super.key, required this.db, this.tableId});

  @override
  State<TableEditScreen> createState() => _TableEditScreenState();
}

class _TableEditScreenState extends State<TableEditScreen> {
  final _nameController = TextEditingController();
  final List<Round> _rounds = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.tableId == null) {
      _rounds.add(const Round(breathSec: 120, holdSec: 60));
      _loaded = true;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    final table = await (widget.db.select(widget.db.trainingTables)
          ..where((t) => t.id.equals(widget.tableId!)))
        .getSingle();
    setState(() {
      _nameController.text = table.name;
      _rounds.addAll(table.rounds);
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addRound() {
    setState(() {
      // 마지막 라운드를 복제해 추가 (연속 편집 편의).
      _rounds.add(_rounds.isEmpty
          ? const Round(breathSec: 120, holdSec: 60)
          : _rounds.last);
    });
  }

  void _removeRound(int index) {
    setState(() => _rounds.removeAt(index));
  }

  void _updateRound(int index, {int? breathSec, int? holdSec}) {
    setState(() {
      _rounds[index] = Round(
        breathSec: breathSec ?? _rounds[index].breathSec,
        holdSec: holdSec ?? _rounds[index].holdSec,
      );
    });
  }

  String _formatDuration(int totalSec) {
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.tableEditNeedName)));
      return;
    }
    if (_rounds.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.tableEditNeedRound)));
      return;
    }

    if (widget.tableId == null) {
      await widget.db.into(widget.db.trainingTables).insert(
            TrainingTablesCompanion.insert(
              name: name,
              type: TableType.custom,
              rounds: List.of(_rounds),
            ),
          );
    } else {
      await (widget.db.update(widget.db.trainingTables)
            ..where((t) => t.id.equals(widget.tableId!)))
          .write(TrainingTablesCompanion(
        name: Value(name),
        rounds: Value(List.of(_rounds)),
      ));
    }
    if (mounted) context.go('/tables');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tableId == null
            ? l10n.tableEditTitleNew
            : l10n.tableEditTitleEdit),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.tableEditName,
              hintText: l10n.tableEditNameHint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tableEditTotalDuration(
                _formatDuration(totalDurationSec(_rounds))),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _rounds.length; i++)
            Card(
              key: ValueKey('round-$i'),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(child: Text(l10n.tableEditRound(i + 1))),
                    SizedBox(
                      width: 90,
                      child: _SecondsField(
                        key: ValueKey('breath-$i'),
                        label: l10n.tableEditBreathSec,
                        value: _rounds[i].breathSec,
                        onChanged: (v) => _updateRound(i, breathSec: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 90,
                      child: _SecondsField(
                        key: ValueKey('hold-$i'),
                        label: l10n.tableEditHoldSec,
                        value: _rounds[i].holdSec,
                        onChanged: (v) => _updateRound(i, holdSec: v),
                      ),
                    ),
                    IconButton(
                      key: ValueKey('remove-$i'),
                      tooltip: l10n.tableEditRemoveRound,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeRound(i),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const ValueKey('add-round'),
            onPressed: _addRound,
            icon: const Icon(Icons.add),
            label: Text(l10n.tableEditAddRound),
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const ValueKey('save-table'),
            onPressed: _save,
            child: Text(l10n.tableEditSave),
          ),
        ],
      ),
    );
  }
}

/// 초 단위 숫자 입력 필드 — 잘못된 입력은 기존 값 유지.
class _SecondsField extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _SecondsField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: '$value',
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, isDense: true),
      onChanged: (text) {
        final parsed = int.tryParse(text);
        if (parsed != null && parsed > 0) onChanged(parsed);
      },
    );
  }
}
