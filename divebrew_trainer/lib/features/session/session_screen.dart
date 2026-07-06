// 세션 실행 — Abyss 몰입 배경, 88px 타이머, 컨트랙션 카운터, 미니 프로파일 플레이헤드, 1탭 중단 (디자인 04-session, A4)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/models.dart';
import '../../l10n/app_localizations.dart';
import '../tables/dive_profile_line.dart';
import 'session_engine.dart';
import 'voice_guide.dart';
import 'wake_lock.dart';

class SessionScreen extends StatefulWidget {
  final AppDatabase db;
  final int tableId;

  /// 테스트에서 교체 가능. null이면 플랫폼 기본 구현 사용.
  final VoiceGuide? voiceGuide;
  final SessionWakeLock? wakeLock;

  const SessionScreen({
    super.key,
    required this.db,
    required this.tableId,
    this.voiceGuide,
    this.wakeLock,
  });

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  SessionEngine? _engine;
  Timer? _timer;
  DateTime? _startedAt;
  TableType? _tableType;
  String _tableName = '';
  bool _saved = false;
  late final VoiceGuide _voice = widget.voiceGuide ?? createVoiceGuide();
  late final SessionWakeLock _wakeLock = widget.wakeLock ?? createWakeLock();

  /// 단계 표시 도트 펄스 — 틱마다 목표 투명도를 토글 (연속 애니메이션 없음, 테스트 안정).
  bool _pulseOn = true;

  @override
  void initState() {
    super.initState();
    _start();
  }

  String get _voiceLang =>
      Localizations.localeOf(context).languageCode == 'ko' ? 'ko-KR' : 'en-US';

  /// 세션 누적 수 기반 안전 리마인더 로테이션 인덱스 (0~3).
  int _reminderIndex = 0;

  Future<void> _start() async {
    final table = await (widget.db.select(widget.db.trainingTables)
          ..where((t) => t.id.equals(widget.tableId)))
        .getSingle();
    final sessionCount = await widget.db
        .customSelect('SELECT COUNT(*) AS c FROM sessions')
        .getSingle()
        .then((row) => row.read<int>('c'));
    if (!mounted) return;

    final engine = SessionEngine(rounds: table.rounds);
    engine.start();
    setState(() {
      _reminderIndex = sessionCount % 4;
      _engine = engine;
      _tableType = table.type;
      _tableName = table.name;
      _startedAt = DateTime.now();
    });
    _wakeLock.acquire();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    _pulseOn = !_pulseOn;
    _runEngineEvent(_engine!.tick);
  }

  void _endHoldEarly() => _runEngineEvent(_engine!.endHoldEarly);

  /// 엔진 이벤트 실행 후 단계 전환 안내·종료 처리를 일괄 수행.
  void _runEngineEvent(void Function() event) {
    final engine = _engine!;
    final phaseBefore = engine.phase;
    event();
    if (engine.phase != phaseBefore) _announcePhase(engine.phase);
    if (!engine.isRunning) {
      _timer?.cancel();
      if (!engine.isActive) {
        _wakeLock.release();
        _saveIfNeeded(completed: engine.phase == SessionPhase.finished);
      }
    }
    setState(() {});
  }

  void _announcePhase(SessionPhase phase) {
    final l10n = AppLocalizations.of(context)!;
    final text = switch (phase) {
      SessionPhase.holding => l10n.voiceHoldStart,
      SessionPhase.preparing => l10n.voiceBreathe,
      SessionPhase.finished => l10n.voiceSessionFinished,
      _ => null,
    };
    if (text != null) _voice.speak(text, lang: _voiceLang);
  }

  void _pause() {
    _timer?.cancel();
    _engine?.pause();
    _voice.stop();
    setState(() {});
  }

  void _resume() {
    _engine?.resume();
    _startTimer();
    setState(() {});
  }

  void _stop() {
    _engine?.stop();
    _timer?.cancel();
    _voice.stop();
    _wakeLock.release();
    _saveIfNeeded(completed: false);
    setState(() {});
  }

  Future<void> _saveIfNeeded({required bool completed}) async {
    final engine = _engine!;
    if (_saved || engine.results.isEmpty) return;
    _saved = true;

    await widget.db.saveSession(
      tableId: widget.tableId,
      type: _tableType!,
      startedAt: _startedAt!,
      completedAt: completed ? DateTime.now() : null,
      results: engine.results,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _voice.stop();
    _wakeLock.release();
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
      return const Scaffold(
        backgroundColor: abyss,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!engine.isActive) {
      return _ResultView(
        engine: engine,
        finished: engine.phase == SessionPhase.finished,
      );
    }

    final isHolding = engine.phase == SessionPhase.holding;
    final isPaused = engine.phase == SessionPhase.paused;
    final phaseLabel = isHolding
        ? l10n.sessionPhaseHolding
        : engine.currentRound == 1
            ? l10n.sessionPhasePreparing
            : l10n.sessionPhaseRecovery;

    // 깊이 스테이징 3단계 — 세션은 가장 깊은 Abyss.
    return Scaffold(
      backgroundColor: abyss,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    key: const ValueKey('stop-session'),
                    onTap: _stop,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        l10n.sessionExit,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: mist,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.sessionHeader(
                          _tableName, engine.currentRound, engine.totalRounds),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: mist,
                      ),
                    ),
                  ),
                  const SizedBox(width: 56),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: isPaused || _pulseOn ? 1.0 : 0.4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isHolding ? snorkelYellow : mist,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPaused ? l10n.sessionPausedLabel : phaseLabel,
                    key: const ValueKey('phase-label'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: isHolding ? snorkelYellow : mist,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _formatSec(engine.remainingSec),
                key: const ValueKey('timer'),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 28),
              if (isHolding) ...[
                OutlinedButton(
                  key: const ValueKey('contraction-tap'),
                  onPressed: () =>
                      setState(engine.tapContraction),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.sessionContractionCount),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 1),
                        decoration: BoxDecoration(
                          color: midWater,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${engine.currentContractionCount}',
                          key: const ValueKey('contraction-count'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: foam,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  key: const ValueKey('end-hold-early'),
                  onPressed: _endHoldEarly,
                  child: Text(l10n.sessionStartRecovery),
                ),
              ],
              const Spacer(),
              DiveProfileLine(
                rounds: engine.rounds,
                progress: engine.progress,
                height: 60,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: ValueKey(
                          isPaused ? 'resume-session' : 'pause-session'),
                      onPressed: isPaused ? _resume : _pause,
                      child: Text(
                          isPaused ? l10n.sessionResume : l10n.sessionPause),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      key: const ValueKey('stop-session-pill'),
                      onPressed: _stop,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: oceanRaised,
                        side: BorderSide.none,
                        foregroundColor:
                            Theme.of(context).colorScheme.error,
                      ),
                      child: Text(l10n.sessionStop),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // 안전 리마인더 — 하단 상시 노출 1줄 로테이션 (A4).
              Text(
                switch (_reminderIndex) {
                  0 => l10n.safetyReminder1,
                  1 => l10n.safetyReminder2,
                  2 => l10n.safetyReminder3,
                  _ => l10n.safetyReminder4,
                },
                key: const ValueKey('safety-reminder'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12.5, color: mist, height: 1.4),
              ),
            ],
          ),
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
      backgroundColor: abyss,
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: foam, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    for (final r in engine.results)
                      ListTile(
                        title: Text(
                            l10n.sessionResultRound(r.round, r.actualHoldSec)),
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
