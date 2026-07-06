// 단발 스테틱 상세 — 설명 + "시작하기"로만 세션 진입 (테이블 상세와 동일 패턴)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

class StaticDetailScreen extends StatelessWidget {
  const StaticDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: midWater,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.homeStaticTitle),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: abyss,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: snorkelYellow, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.staticPrepInfo,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: foam),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.staticDetailBody,
                    style:
                        const TextStyle(fontSize: 15, color: foam, height: 1.7),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                key: const ValueKey('static-detail-start'),
                onPressed: () => context.push('/static/run'),
                child: Text(l10n.tableDetailStart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
