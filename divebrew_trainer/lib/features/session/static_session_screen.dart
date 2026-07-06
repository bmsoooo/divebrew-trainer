// 단발 스테틱 세션 — 3→2→1 카운트다운 후 열린 숨참기(카운트업), 완료 시 스테틱 PB 갱신 (A4: 1탭 종료)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/models.dart';
import '../../data/presets.dart';
import '../../l10n/app_localizations.dart';
import 'countdown_view.dart';
import 'voice_guide.dart';
import 'wake_lock.dart';

class StaticSessionScreen extends StatefulWidget {
  final AppDatabase db;
  final VoiceGuide? voiceGuide;
  final SessionWakeLock? wakeLock;

  /// 시작 전 카운트다운 초. 0이면 즉시 숨참기 시작 (테스트 결정성용).
  final int countdownSeconds;

  const StaticSessionScreen({
    super.key,
    required this.db,
    this.voiceGuide,
    this.wakeLock,
    this.countdownSeconds = 3,
  });

  @override
  State<StaticSessionScreen> createState() => _StaticSessionScreenState();
}

class _StaticSessionScreenState extends State<StaticSessionScreen> {
  late final VoiceGuide _voice = widget.voiceGuide ?? createVoiceGuide();
  late final SessionWakeLock _wakeLock = widget.wakeLock ?? createWakeLock();

  int? _countdown;
  Timer? _timer;
  DateTime? _startedAt;
  int _elapsed = 0;
  int _contractions = 0;
  final List<int> _contractionAtMs = [];

  bool _done = false;
  int? _resultSec;
  bool _isNewPb = false;
  int? _prevPbSec;

  @override
  void initState() {
    super.initState();
    _countdown = widget.countdownSeconds > 0 ? widget.countdownSeconds : null;
    if (_countdown == null) _startedAt = DateTime.now();
    _wakeLock.acquire();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  String get _voiceLang =>
      Localizations.localeOf(context).languageCode == 'ko' ? 'ko-KR' : 'en-US';

  void _tick() {
    setState(() {
      if (_countdown != null) {
        final next = _countdown! - 1;
        if (next <= 0) {
          _countdown = null;
          _startedAt = DateTime.now();
          _voice.speak(AppLocalizations.of(context)!.voiceHoldStart,
              lang: _voiceLang);
        } else {
          _countdown = next;
        }
        return;
      }
      _elapsed++;
    });
  }

  void _tapContraction() {
    setState(() {
      _contractions++;
      _contractionAtMs.add(_elapsed * 1000);
    });
  }

  Future<void> _finish() async {
    if (_done) return;
    _timer?.cancel();
    _voice.stop();
    _wakeLock.release();

    final elapsed = _elapsed;
    final staticTable = await findStaticTable(widget.db);
    final prev = await (widget.db.select(widget.db.personalBests)
          ..where((p) => p.type.equals(TableType.static_.name)))
        .getSingleOrNull();

    // 유효한 기록(1초 이상)만 저장.
    if (staticTable != null && elapsed > 0) {
      await widget.db.saveSession(
        tableId: staticTable.id,
        type: TableType.static_,
        startedAt: _startedAt ?? DateTime.now(),
        completedAt: DateTime.now(),
        results: [
          RoundResult(
            round: 1,
            actualHoldSec: elapsed,
            contractionAtMs: List.of(_contractionAtMs),
          ),
        ],
      );
    }

    if (!mounted) return;
    setState(() {
      _done = true;
      _resultSec = elapsed;
      _prevPbSec = prev?.valueSec;
      _isNewPb = elapsed > 0 && (prev == null || elapsed > prev.valueSec);
    });
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

    if (_countdown != null) {
      return CountdownView(value: _countdown!);
    }

    if (_done) {
      return _StaticResultView(
        resultSec: _resultSec ?? 0,
        isNewPb: _isNewPb,
        prevPbSec: _prevPbSec,
      );
    }

    return Scaffold(
      backgroundColor: abyss,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: snorkelYellow),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.sessionPhaseHolding,
                    key: const ValueKey('static-phase'),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: snorkelYellow),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 열린 숨참기 — 시간이 위로 올라감.
              Text(
                _formatSec(_elapsed),
                key: const ValueKey('static-timer'),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 28),
              OutlinedButton(
                key: const ValueKey('static-contraction'),
                onPressed: _tapContraction,
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
                      child: Text('$_contractions',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: foam)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 안전: 1탭 종료 — 완료를 누르면 즉시 기록.
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const ValueKey('static-done'),
                  onPressed: _finish,
                  child: Text(l10n.staticDone),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.safetyReminder1,
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

class _StaticResultView extends StatelessWidget {
  final int resultSec;
  final bool isNewPb;
  final int? prevPbSec;

  const _StaticResultView({
    required this.resultSec,
    required this.isNewPb,
    required this.prevPbSec,
  });

  String _formatSec(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

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
              const Spacer(),
              Text(l10n.staticResultLabel,
                  textAlign: TextAlign.center, style: utilityLabelStyle),
              const SizedBox(height: 8),
              Text(
                _formatSec(resultSec),
                key: const ValueKey('static-result'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              if (isNewPb)
                Text(
                  l10n.staticNewPb,
                  key: const ValueKey('static-new-pb'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: snorkelYellow),
                )
              else if (prevPbSec != null)
                Text(
                  l10n.staticPrevPb(_formatSec(prevPbSec!)),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: mist),
                ),
              const Spacer(),
              FilledButton(
                key: const ValueKey('static-back-home'),
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
