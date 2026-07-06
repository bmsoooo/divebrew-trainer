// 훈련 가이드 — 스태틱/CO2/O2 원리·왜 늘어나는지·안전을 설명하는 교육 화면 (홈·설정에서 진입)
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final sections = <(String, String, IconData, bool)>[
      (l10n.guideIntroTitle, l10n.guideIntroBody, Icons.self_improvement, false),
      (l10n.guideCo2Title, l10n.guideCo2Body, Icons.trending_down, false),
      (l10n.guideO2Title, l10n.guideO2Body, Icons.trending_up, false),
      (l10n.guideWhyTitle, l10n.guideWhyBody, Icons.insights, false),
      // 안전 섹션 — 옐로 강조로 시각적 무게를 실어 반드시 눈에 띄게.
      (l10n.guideSafetyTitle, l10n.guideSafetyBody, Icons.warning_amber, true),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.guideTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            for (final (title, body, icon, highlight) in sections)
              _GuideSection(
                title: title,
                body: body,
                icon: icon,
                highlight: highlight,
              ),
          ],
        ),
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final bool highlight;

  const _GuideSection({
    required this.title,
    required this.body,
    required this.icon,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final accent = highlight ? snorkelYellow : foam;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: oceanRaised,
        borderRadius: BorderRadius.circular(24),
        border: highlight
            ? Border.all(color: snorkelYellow.withValues(alpha: 0.5))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: const TextStyle(fontSize: 15, color: foam, height: 1.7),
          ),
        ],
      ),
    );
  }
}
