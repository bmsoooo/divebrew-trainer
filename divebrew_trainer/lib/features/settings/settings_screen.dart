// 설정 화면 — 인스타 링크, 데이터 관리(복원/삭제/초기화, 확인 다이얼로그), 앱 정보 (디자인 06-settings)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/link_launcher.dart';
import '../../data/presets.dart';
import '../../l10n/app_localizations.dart';

/// pubspec version 1.0.0+1 과 일치 — 릴리스 시 함께 갱신.
const _appVersion = '1.0.0 (1)';
const _instagramUrl = 'https://instagram.com/divebrew.soo';

class SettingsScreen extends StatelessWidget {
  final AppDatabase db;

  const SettingsScreen({super.key, required this.db});

  Future<bool> _confirm(
    BuildContext context, {
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: oceanRaised,
        content: Text(message, style: const TextStyle(color: foam)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel,
                style: const TextStyle(color: mist)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: destructive
                    ? Theme.of(context).colorScheme.error
                    : snorkelYellow,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(l10n.settingsTitle,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w700, color: foam)),
            const SizedBox(height: 16),
            // 인스타그램 — 유일하게 외부로 나가는 링크.
            _InstagramCard(
              onTap: () => openExternalLink(_instagramUrl),
              handle: l10n.settingsInstagramHandle,
              label: l10n.settingsInstagram,
            ),
            const SizedBox(height: 24),
            Text(l10n.settingsDataSection, style: utilityLabelStyle),
            const SizedBox(height: 10),
            _GroupedCard(
              rows: [
                _SettingRow(
                  icon: Icons.cloud_outlined,
                  label: l10n.settingsICloud,
                  trailing: Text(l10n.settingsICloudStatus,
                      style: const TextStyle(fontSize: 13, color: mist)),
                ),
                _SettingRow(
                  icon: Icons.refresh,
                  label: l10n.settingsRestoreDefaults,
                  showChevron: true,
                  onTap: () async {
                    final ok = await _confirm(context,
                        message: l10n.settingsRestoreDefaultsConfirm,
                        confirmLabel: l10n.commonRestore);
                    if (!ok || !context.mounted) return;
                    await restoreDefaultTables(db);
                    if (context.mounted) {
                      _snack(context, l10n.settingsRestoreDefaultsDone);
                    }
                  },
                ),
                _SettingRow(
                  icon: Icons.delete_outline,
                  label: l10n.settingsClearHistory,
                  destructive: true,
                  showChevron: true,
                  onTap: () async {
                    final ok = await _confirm(context,
                        message: l10n.settingsClearHistoryConfirm,
                        confirmLabel: l10n.commonDelete,
                        destructive: true);
                    if (!ok || !context.mounted) return;
                    await clearHistory(db);
                    if (context.mounted) {
                      _snack(context, l10n.settingsClearHistoryDone);
                    }
                  },
                ),
                _SettingRow(
                  icon: Icons.restart_alt,
                  label: l10n.settingsResetAll,
                  destructive: true,
                  showChevron: true,
                  onTap: () async {
                    final ok = await _confirm(context,
                        message: l10n.settingsResetAllConfirm,
                        confirmLabel: l10n.commonDelete,
                        destructive: true);
                    if (!ok || !context.mounted) return;
                    await resetAll(db);
                    if (context.mounted) {
                      _snack(context, l10n.settingsResetAllDone);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.settingsInfoSection, style: utilityLabelStyle),
            const SizedBox(height: 10),
            _GroupedCard(
              rows: [
                _SettingRow(
                  label: l10n.settingsVersion,
                  trailing: const Text(
                    _appVersion,
                    style: TextStyle(
                      fontSize: 14,
                      color: mist,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                _SettingRow(
                  label: l10n.settingsContact,
                  showChevron: true,
                  onTap: () => openExternalLink(_instagramUrl),
                ),
                _SettingRow(
                  label: l10n.settingsPrivacy,
                  showChevron: true,
                  onTap: () => context.push('/settings/privacy'),
                ),
                _SettingRow(
                  label: l10n.settingsTerms,
                  showChevron: true,
                  onTap: () => context.push('/settings/terms'),
                ),
                _SettingRow(
                  label: l10n.settingsLicenses,
                  showChevron: true,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'divebrew trainer',
                    applicationVersion: _appVersion,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InstagramCard extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String handle;

  const _InstagramCard(
      {required this.onTap, required this.label, required this.handle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const ValueKey('settings-instagram'),
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: oceanRaised,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: midWater,
              ),
              child: const Icon(Icons.camera_alt_outlined,
                  color: snorkelYellow, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: foam)),
                  const SizedBox(height: 2),
                  Text(handle,
                      style: const TextStyle(fontSize: 13, color: mist)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: mist),
          ],
        ),
      ),
    );
  }
}

/// 행들을 하나의 카드로 묶고 divider로 구분 (내부 행은 라운드 없음).
class _GroupedCard extends StatelessWidget {
  final List<Widget> rows;

  const _GroupedCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: oceanRaised,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(height: 1, color: foam.withValues(alpha: 0.1)),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Widget? trailing;
  final bool showChevron;
  final bool destructive;
  final VoidCallback? onTap;

  const _SettingRow({
    this.icon,
    required this.label,
    this.trailing,
    this.showChevron = false,
    this.destructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Theme.of(context).colorScheme.error : foam;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: color),
              ),
            ),
            ?trailing,
            if (showChevron) ...[
              const SizedBox(width: 6),
              Icon(Icons.chevron_right,
                  color: destructive ? color : mist, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
