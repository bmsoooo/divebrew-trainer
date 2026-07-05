// 라운드별 진행 상황 타임라인 — 완료/진행중/예정 상태를 한눈에 (테이블 상세·세션 화면 공용)
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/models.dart';

class RoundTimeline extends StatelessWidget {
  final List<Round> rounds;
  final List<RoundResult> results;

  /// 현재 진행 중인 라운드 인덱스(0-based). null이면 전부 예정 상태로 표시.
  final int? currentRoundIndex;

  const RoundTimeline({
    super.key,
    required this.rounds,
    this.results = const [],
    this.currentRoundIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rounds.length; i++)
          _RoundRow(
            key: ValueKey('timeline-round-$i'),
            index: i,
            round: rounds[i],
            result: i < results.length ? results[i] : null,
            isCurrent: i == currentRoundIndex,
          ),
      ],
    );
  }
}

class _RoundRow extends StatelessWidget {
  final int index;
  final Round round;
  final RoundResult? result;
  final bool isCurrent;

  const _RoundRow({
    super.key,
    required this.index,
    required this.round,
    required this.result,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final done = result != null;
    final icon = done
        ? Icons.check_circle
        : isCurrent
            ? Icons.play_circle_fill
            : Icons.circle_outlined;
    final color = done || isCurrent
        ? snorkelYellow
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  ),
            ),
          ),
          Text(
            done ? '${result!.actualHoldSec}s' : '${round.holdSec}s',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
