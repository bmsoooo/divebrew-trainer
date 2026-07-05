// PB(개인 최고 기록) 기반 CO2/O2 테이블 자동 생성 — 홀드는 PB의 40~80% 구간 (기획서 §4)
import 'models.dart';

/// PB 대비 홀드 비율 하한/상한 (기획서: 40~80% 구간).
const pbRatioMin = 0.4;
const pbRatioMax = 0.8;

const _roundCount = 8;

/// 5초 단위로 내림 (음성 카운트 UX 정합).
int _floorTo5(double sec) => (sec ~/ 5) * 5;

/// CO2 테이블: 홀드는 PB의 60%(40~80%의 중앙)로 고정, 준비 호흡 120초→50초 점감.
List<Round> generateCo2FromPb(int pbSec) {
  final hold = _floorTo5(pbSec * 0.6).clamp(10, 600);
  return [
    for (var i = 0; i < _roundCount; i++)
      Round(breathSec: 120 - 10 * i, holdSec: hold),
  ];
}

/// O2 테이블: 준비 호흡 120초 고정, 홀드는 PB의 40%→80% 균등 점증.
List<Round> generateO2FromPb(int pbSec) {
  final step = (pbRatioMax - pbRatioMin) / (_roundCount - 1);
  return [
    for (var i = 0; i < _roundCount; i++)
      Round(
        breathSec: 120,
        holdSec: _floorTo5(pbSec * (pbRatioMin + step * i)).clamp(10, 600),
      ),
  ];
}
