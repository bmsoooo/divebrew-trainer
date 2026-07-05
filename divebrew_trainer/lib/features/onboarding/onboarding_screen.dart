// 온보딩 안전 동의 게이트 — 4항목 전체 동의 없이는 앱 진행 불가 (A4 안전 요구사항)
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../app/consent_state.dart';
import '../../data/database.dart';

class OnboardingScreen extends StatefulWidget {
  final AppDatabase db;
  final ConsentState consent;

  const OnboardingScreen({super.key, required this.db, required this.consent});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _checked = List<bool>.filled(4, false);

  bool get _allChecked => _checked.every((c) => c);

  Future<void> _agree() async {
    await widget.db.setSafetyConsented();
    widget.consent.consented = true;
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = [
      (l10n.onboardingDryOnly, l10n.onboardingDryOnlyDetail),
      (l10n.onboardingNoHyperventilation, l10n.onboardingNoHyperventilationDetail),
      (l10n.onboardingSeatedOnLand, l10n.onboardingSeatedOnLandDetail),
      (l10n.onboardingStopWhenDizzy, l10n.onboardingStopWhenDizzyDetail),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.onboardingTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.onboardingIntro,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Card(
                        child: CheckboxListTile(
                          key: ValueKey('consent-$i'),
                          value: _checked[i],
                          onChanged: (v) =>
                              setState(() => _checked[i] = v ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            items[i].$1,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(items[i].$2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const ValueKey('agree-button'),
                onPressed: _allChecked ? _agree : null,
                child: Text(l10n.onboardingAgreeButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
