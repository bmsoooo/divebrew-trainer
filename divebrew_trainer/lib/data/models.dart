// 훈련 테이블·세션의 값 객체와 enum — 라운드 구성, 라운드 결과의 JSON 직렬화 담당
import 'dart:convert';

/// 훈련 테이블 종류.
enum TableType { co2, o2, static_, custom }

/// 한 라운드의 구성 — 준비 호흡 시간과 숨참기 시간(초).
class Round {
  final int breathSec;
  final int holdSec;

  const Round({required this.breathSec, required this.holdSec});

  Map<String, dynamic> toJson() => {'breathSec': breathSec, 'holdSec': holdSec};

  factory Round.fromJson(Map<String, dynamic> json) =>
      Round(breathSec: json['breathSec'] as int, holdSec: json['holdSec'] as int);

  @override
  bool operator ==(Object other) =>
      other is Round && other.breathSec == breathSec && other.holdSec == holdSec;

  @override
  int get hashCode => Object.hash(breathSec, holdSec);
}

/// 한 라운드의 실제 결과 — 실제 숨참기 시간과 컨트랙션 탭 시점(홀드 시작 기준 ms).
class RoundResult {
  final int round;
  final int actualHoldSec;
  final List<int> contractionAtMs;

  const RoundResult({
    required this.round,
    required this.actualHoldSec,
    this.contractionAtMs = const [],
  });

  Map<String, dynamic> toJson() => {
        'round': round,
        'actualHoldSec': actualHoldSec,
        'contractionAtMs': contractionAtMs,
      };

  factory RoundResult.fromJson(Map<String, dynamic> json) => RoundResult(
        round: json['round'] as int,
        actualHoldSec: json['actualHoldSec'] as int,
        contractionAtMs:
            (json['contractionAtMs'] as List? ?? const []).cast<int>(),
      );

  @override
  bool operator ==(Object other) =>
      other is RoundResult &&
      other.round == round &&
      other.actualHoldSec == actualHoldSec &&
      _listEquals(other.contractionAtMs, contractionAtMs);

  @override
  int get hashCode =>
      Object.hash(round, actualHoldSec, Object.hashAll(contractionAtMs));
}

bool _listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

String encodeRounds(List<Round> rounds) =>
    jsonEncode(rounds.map((r) => r.toJson()).toList());

List<Round> decodeRounds(String json) => (jsonDecode(json) as List)
    .map((e) => Round.fromJson(e as Map<String, dynamic>))
    .toList();

String encodeRoundResults(List<RoundResult> results) =>
    jsonEncode(results.map((r) => r.toJson()).toList());

List<RoundResult> decodeRoundResults(String json) => (jsonDecode(json) as List)
    .map((e) => RoundResult.fromJson(e as Map<String, dynamic>))
    .toList();

// Logbook Enums
enum SiteType { pool, sea, lake }
enum PurposeTag { training, leisure, spearfishing, photo, competitionPractice, other }
enum ConditionSource { auto, manual }
enum FinType { monofin, bifin, barefoot }
enum IncidentType { none, samba, blackout }
enum RecoveryType { normal, delayed, assisted }
enum Discipline { sta, dyn, dnf, cwt, cwtb, cnf, fim, custom }
enum PerformanceUnit { sec, m }

class DiveCondition {
  final double? waveHeightM;
  final double? waterTempC;
  final double? waveDirectionDeg;
  final double? visibilityM;
  final ConditionSource source;

  const DiveCondition({
    this.waveHeightM,
    this.waterTempC,
    this.waveDirectionDeg,
    this.visibilityM,
    this.source = ConditionSource.manual,
  });

  Map<String, dynamic> toJson() => {
        'waveHeightM': waveHeightM,
        'waterTempC': waterTempC,
        'waveDirectionDeg': waveDirectionDeg,
        'visibilityM': visibilityM,
        'source': source.name,
      };

  DiveCondition copyWith({
    double? waveHeightM,
    double? waterTempC,
    double? waveDirectionDeg,
    double? visibilityM,
    ConditionSource? source,
  }) {
    return DiveCondition(
      waveHeightM: waveHeightM ?? this.waveHeightM,
      waterTempC: waterTempC ?? this.waterTempC,
      waveDirectionDeg: waveDirectionDeg ?? this.waveDirectionDeg,
      visibilityM: visibilityM ?? this.visibilityM,
      source: source ?? this.source,
    );
  }

  factory DiveCondition.fromJson(Map<String, dynamic> json) => DiveCondition(
        waveHeightM: (json['waveHeightM'] as num?)?.toDouble(),
        waterTempC: (json['waterTempC'] as num?)?.toDouble(),
        waveDirectionDeg: (json['waveDirectionDeg'] as num?)?.toDouble(),
        visibilityM: (json['visibilityM'] as num?)?.toDouble(),
        source: ConditionSource.values.firstWhere(
          (e) => e.name == json['source'],
          orElse: () => ConditionSource.manual,
        ),
      );
}

class DiveGear {
  final double? weightKg;
  final double? suitThicknessMm;
  final FinType? finType;

  const DiveGear({this.weightKg, this.suitThicknessMm, this.finType});

  Map<String, dynamic> toJson() => {
        'weightKg': weightKg,
        'suitThicknessMm': suitThicknessMm,
        'finType': finType?.name,
      };

  factory DiveGear.fromJson(Map<String, dynamic> json) => DiveGear(
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        suitThicknessMm: (json['suitThicknessMm'] as num?)?.toDouble(),
        finType: json['finType'] != null
            ? FinType.values.firstWhere((e) => e.name == json['finType'])
            : null,
      );
}
