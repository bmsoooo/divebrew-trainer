// 시그니처 "다이브 프로파일 라인" — 라운드 구조를 다이브 컴퓨터 수심 그래프처럼 그리는 CustomPaint
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/models.dart';

/// 홀드 = 하강(깊이는 해당 테이블 최대 홀드 대비 비율), 호흡 = 수면 복귀.
/// [progress]를 주면 미니 모드 — 라인은 Mist 40%로 흐리게, 옐로 플레이헤드 도트가 진행 위치를 따라간다.
class DiveProfileLine extends StatelessWidget {
  final List<Round> rounds;

  /// 0.0~1.0 세션 진행률 (라운드 인덱스 + 단계 진행 기반). null이면 풀 프로파일 모드.
  final double? progress;
  final double height;

  const DiveProfileLine({
    super.key,
    required this.rounds,
    this.progress,
    this.height = 132,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ProfilePainter(rounds: rounds, progress: progress),
      ),
    );
  }
}

class _ProfilePainter extends CustomPainter {
  final List<Round> rounds;
  final double? progress;

  _ProfilePainter({required this.rounds, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (rounds.isEmpty) return;
    final mini = progress != null;

    const surfaceY = 8.0;
    final maxDepthY = size.height - 10;
    final maxHold =
        rounds.fold(1, (m, r) => math.max(m, r.holdSec)).toDouble();

    // 수면 대시 라인.
    final dashPaint = Paint()
      ..color = mist.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, surfaceY), Offset(x + 4, surfaceY), dashPaint);
      x += 8;
    }

    // 라운드별 V자 경로 — 각 라운드가 동일한 가로 폭을 차지한다.
    final roundWidth = size.width / rounds.length;
    final path = Path()..moveTo(0, surfaceY);
    final troughs = <Offset>[];
    for (var i = 0; i < rounds.length; i++) {
      final depthY = surfaceY +
          (maxDepthY - surfaceY) * (rounds[i].holdSec / maxHold);
      final startX = roundWidth * i;
      final troughX = startX + roundWidth * 0.5;
      final endX = startX + roundWidth;
      path.lineTo(troughX, depthY);
      path.lineTo(endX, surfaceY);
      troughs.add(Offset(troughX, depthY));
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = mini ? mist.withValues(alpha: 0.4) : snorkelYellow;
    canvas.drawPath(path, linePaint);

    if (!mini) {
      final dotPaint = Paint()..color = snorkelYellow;
      for (final t in troughs) {
        canvas.drawCircle(t, 3.5, dotPaint);
      }
      return;
    }

    // 미니 모드: 진행률 위치에 옐로 플레이헤드.
    final p = progress!.clamp(0.0, 1.0);
    final headX = size.width * p;
    final roundIndex =
        math.min((p * rounds.length).floor(), rounds.length - 1);
    final localT = (p * rounds.length) - roundIndex;
    final depthY = surfaceY +
        (maxDepthY - surfaceY) * (rounds[roundIndex].holdSec / maxHold);
    // V자 경로 위 y 보간: 전반 하강, 후반 상승.
    final headY = localT <= 0.5
        ? surfaceY + (depthY - surfaceY) * (localT / 0.5)
        : depthY - (depthY - surfaceY) * ((localT - 0.5) / 0.5);
    canvas.drawCircle(Offset(headX, headY), 5, Paint()..color = snorkelYellow);
  }

  @override
  bool shouldRepaint(covariant _ProfilePainter old) =>
      old.rounds != rounds || old.progress != progress;
}
