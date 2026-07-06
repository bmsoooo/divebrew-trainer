// 세션 타이머 상태 머신 — 준비 호흡→홀드→(일시정지) 라운드 진행, 컨트랙션 기록, 1탭 중단 (Timer 미내장, tick 주입식)
import '../../data/models.dart';

enum SessionPhase { idle, preparing, holding, paused, finished, stopped }

/// 훈련 세션의 상태 머신. UI(또는 테스트)가 1초 단위로 [tick]을 호출해 진행한다.
/// 안전 요구사항(A4): [stop]은 어떤 상태에서든(일시정지 포함) 즉시 종료하며 확인 절차가 없다.
class SessionEngine {
  final List<Round> rounds;

  SessionPhase _phase = SessionPhase.idle;
  SessionPhase? _phaseBeforePause;
  int _roundIndex = 0;
  int _remainingSec = 0;
  int _heldSec = 0;
  final List<RoundResult> _results = [];
  final List<int> _contractionAtMs = [];

  SessionEngine({required this.rounds}) {
    assert(rounds.isNotEmpty);
  }

  SessionPhase get phase => _phase;

  /// 현재 라운드 (1-based).
  int get currentRound => _roundIndex + 1;

  int get totalRounds => rounds.length;

  /// 현재 단계의 남은 시간(초).
  int get remainingSec => _remainingSec;

  /// 지금까지 확정된 라운드 결과.
  List<RoundResult> get results => List.unmodifiable(_results);

  /// 현재 홀드에서 기록된 컨트랙션 수 (UI 카운터 뱃지용).
  int get currentContractionCount => _contractionAtMs.length;

  /// 세션 전체 진행률 0.0~1.0 — 프로파일 플레이헤드용.
  double get progress {
    if (_phase == SessionPhase.finished) return 1.0;
    final round = rounds[_roundIndex];
    final total = round.breathSec + round.holdSec;
    final activePhase =
        _phase == SessionPhase.paused ? _phaseBeforePause : _phase;
    final elapsed = switch (activePhase) {
      SessionPhase.preparing => round.breathSec - _remainingSec,
      SessionPhase.holding => round.breathSec + (round.holdSec - _remainingSec),
      _ => 0,
    };
    return (_roundIndex + elapsed / total) / rounds.length;
  }

  /// 타이머가 실제로 흐르고 있는 상태(준비/홀드). 일시정지는 포함하지 않는다.
  bool get isRunning =>
      _phase == SessionPhase.preparing || _phase == SessionPhase.holding;

  /// 세션이 아직 종료되지 않은 상태(실행 중 또는 일시정지). 화면 분기에 사용.
  bool get isActive => isRunning || _phase == SessionPhase.paused;

  /// 세션 시작 — 1라운드 준비 호흡부터.
  void start() {
    if (_phase != SessionPhase.idle) return;
    _phase = SessionPhase.preparing;
    _remainingSec = rounds[0].breathSec;
  }

  /// 1초 경과. 남은 시간이 0이 되는 시점에 단계를 전이한다.
  void tick() {
    if (!isRunning) return;

    _remainingSec--;
    if (_phase == SessionPhase.holding) _heldSec++;
    if (_remainingSec > 0) return;

    if (_phase == SessionPhase.preparing) {
      _phase = SessionPhase.holding;
      _remainingSec = rounds[_roundIndex].holdSec;
      _heldSec = 0;
      _contractionAtMs.clear();
    } else {
      _finishHold();
    }
  }

  /// 일시정지 — 남은 시간·홀드 경과·컨트랙션 기록을 그대로 보존.
  void pause() {
    if (!isRunning) return;
    _phaseBeforePause = _phase;
    _phase = SessionPhase.paused;
  }

  /// 재개 — 일시정지 전 단계로 복귀.
  void resume() {
    if (_phase != SessionPhase.paused) return;
    _phase = _phaseBeforePause!;
    _phaseBeforePause = null;
  }

  /// 홀드 중 컨트랙션 탭 — 홀드 시작 기준 경과 ms를 기록.
  /// [atMs]를 주지 않으면 tick 기반 경과 초를 ms로 환산해 기록한다.
  void tapContraction({int? atMs}) {
    if (_phase != SessionPhase.holding) return;
    _contractionAtMs.add(atMs ?? _heldSec * 1000);
  }

  /// 홀드 조기 종료 ("숨 쉬었어요") — 실제 홀드 시간으로 결과 확정 후 다음 라운드로.
  void endHoldEarly() {
    if (_phase != SessionPhase.holding) return;
    _finishHold();
  }

  /// 즉시 중단 — 진행 중이던 홀드(일시정지 중이었어도)는 실제 시간으로 기록 (부분 결과 보존).
  void stop() {
    if (!isActive) return;
    final heldPhase = _phase == SessionPhase.paused ? _phaseBeforePause : _phase;
    if (heldPhase == SessionPhase.holding && _heldSec > 0) {
      _recordCurrentHold();
    }
    _phaseBeforePause = null;
    _phase = SessionPhase.stopped;
    _remainingSec = 0;
  }

  void _finishHold() {
    _recordCurrentHold();
    if (_roundIndex + 1 >= rounds.length) {
      _phase = SessionPhase.finished;
      _remainingSec = 0;
    } else {
      _roundIndex++;
      _phase = SessionPhase.preparing;
      _remainingSec = rounds[_roundIndex].breathSec;
    }
  }

  void _recordCurrentHold() {
    _results.add(RoundResult(
      round: _roundIndex + 1,
      actualHoldSec: _heldSec,
      contractionAtMs: List.of(_contractionAtMs),
    ));
    _contractionAtMs.clear();
  }
}
