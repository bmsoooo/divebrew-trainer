// 내 자격증 화면 — 다이빙 자격증 사진 업로드/보기/교체/삭제 (로컬 저장, 다이빙 센터 제시용)
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/image_picker.dart';
import '../../l10n/app_localizations.dart';

class LicenseScreen extends StatelessWidget {
  final AppDatabase db;

  const LicenseScreen({super.key, required this.db});

  Future<void> _upload(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final bytes = await pickImageBytes();
    if (bytes == null) return;
    await db.setLicenseImage(base64Encode(bytes));
    messenger.showSnackBar(SnackBar(content: Text(l10n.licenseSaved)));
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: oceanRaised,
        content: Text(l10n.licenseDeleteConfirm,
            style: const TextStyle(color: foam)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel,
                style: const TextStyle(color: mist)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.licenseDelete,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await db.clearLicenseImage();
    messenger.showSnackBar(SnackBar(content: Text(l10n.licenseDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.licenseTitle)),
      body: SafeArea(
        child: StreamBuilder<String?>(
          stream: db.watchLicenseImage(),
          builder: (context, snapshot) {
            final base64 = snapshot.data;
            if (base64 == null || base64.isEmpty) {
              return _EmptyState(onUpload: () => _upload(context));
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          base64Decode(base64),
                          key: const ValueKey('license-image'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          key: const ValueKey('license-replace'),
                          onPressed: () => _upload(context),
                          child: Text(l10n.licenseReplace),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          key: const ValueKey('license-delete'),
                          onPressed: () => _delete(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          child: Text(l10n.licenseDelete),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onUpload;

  const _EmptyState({required this.onUpload});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.badge_outlined, size: 64, color: mist),
          const SizedBox(height: 20),
          Text(
            l10n.licenseEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: foam),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.licenseEmptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: mist, height: 1.6),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const ValueKey('license-upload'),
              onPressed: onUpload,
              child: Text(l10n.licenseUpload),
            ),
          ),
        ],
      ),
    );
  }
}
