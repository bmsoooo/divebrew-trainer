// 세션 실행 화면 — 대형 타이머, 라운드 진행, 컨트랙션 탭, 1탭 중단 (A4: 중단 버튼 상시 노출·확인 팝업 없음)
import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import 'session_engine.dart';

class SessionScreen extends StatefulWidget {
  final AppDatabase db;
  final int tableId;

  const SessionScreen({super.key, required this.db, required this.tableId});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  SessionEngine? _engine;
  Timer? _timer;
  DateTime? _startedAt;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final table = await (widget.db.select(widget.db.trainingTables)
          ..where((t) => t.id.equals(widget.tableId)))
        .getSingle();
    if (!mounted) return;

    final engine = SessionEngine(rounds: table.rounds);
    engine.start();
    setState(() {
      _engine = engine;
      _startedAt = DateTime.now();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    final engine = _engine!;
    engine.tick();
    if (!engine.isRunning) {
      _timer?.cancel();
      _saveIfNeeded(completed: engine.phase == SessionPhase.finished);
    }
    setState(() {});
  }

  void _stop() {
    _engine?.stop();
    _timer?.cancel();
    _saveIfNeeded(completed: false);
    setState(() {});
  }

  Future<void> _saveIfNeeded({required bool completed}) async {
    final engine = _engine!;
    if (_saved || engine.results.isEmpty) return;
    _saved = true;

    await widget.db.into(widget.db.sessions).insert(
          SessionsCompanion.insert(
            tableId: widget.tableId,
            startedAt: _startedAt!,
            completedAt:
                completed ? Value(DateTime.now()) : const Value.absent(),
            results: engine.results,
          ),
        );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatSec(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final engine = _engine;

    if (engine == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!engine.isRunning) {
      return _ResultView(
        engine: engine,
        finished: engine.phase == SessionPhase.finished,
      );
    }

    final isHolding = engine.phase == SessionPhase.holding;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              l10n.sessionRoundProgress(engine.currentRound, engine.totalRounds),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              isHolding ? l10n.sessionPhaseHolding : l10n.sessionPhasePreparing,
              key: const ValueKey('phase-label'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _formatSec(engine.remainingSec),
              key: const ValueKey('timer'),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const Spacer(),
            if (isHolding) ...[
              FilledButton.tonal(
                key: const ValueKey('contraction-tap'),
                onPressed: engine.tapContraction,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(l10n.sessionContractionTap),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                key: const ValueKey('end-hold-early'),
                onPressed: () => setState(engine.endHoldEarly),
                child: Text(l10n.sessionEndHoldEarly),
              ),
            ],
            const SizedBox(height: 24),
            // 안전 요구사항: 중단 버튼 상시 노출, 확인 팝업 없이 1탭 종료.
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OutlinedButton(
                  key: const ValueKey('stop-session'),
                  onPressed: _stop,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(l10n.sessionStop),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// 세션 종료(완료/중단) 후 결과 요약.
class _ResultView extends StatelessWidget {
  final SessionEngine engine;
  final bool finished;

  const _ResultView({required this.engine, required this.finished});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                finished ? l10n.sessionFinished : l10n.sessionStopped,
                key: const ValueKey('session-end-title'),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    for (final r in engine.results)
                      ListTile(
                        title:
                            Text(l10n.sessionResultRound(r.round, r.actualHoldSec)),
                        subtitle: r.contractionAtMs.isEmpty
                            ? null
                            : Text(l10n.sessionResultContractions(
                                r.contractionAtMs.length)),
                      ),
                  ],
                ),
              ),
              FilledButton(
                key: const ValueKey('back-home'),
                onPressed: () => context.go('/'),
                child: Text(l10n.sessionBackHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
