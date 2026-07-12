import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/database.dart';
import '../../../data/models.dart';

class LogbookCard extends StatelessWidget {
  final DiveSession session;
  final VoidCallback onTap;

  const LogbookCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  Future<void> _shareToInstagram(BuildContext context) async {
    try {
      final controller = ScreenshotController();
      final theme = Theme.of(context);
      
      // 공유 전용 UI를 캡처
      final imageBytes = await controller.captureFromWidget(
        Material(
          child: Container(
            width: 400,
            height: 500,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (session.photoPaths.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: kIsWeb
                        ? Image.network(session.photoPaths.first, width: 200, height: 200, fit: BoxFit.cover)
                        : Image.file(File(session.photoPaths.first), width: 200, height: 200, fit: BoxFit.cover),
                  )
                else
                  const Icon(Icons.water, size: 100, color: Colors.white),
                const SizedBox(height: 24),
                Text(
                  'DiveBrew Log',
                  style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  session.siteName,
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag(context, DateFormat('yy.MM.dd').format(session.date)),
                    const SizedBox(width: 8),
                    _buildTag(context, _getPurposeText(session.purposeTag)),
                  ],
                ),
              ],
            ),
          ),
        ),
        context: context,
        delay: const Duration(milliseconds: 100),
      );

      final xFile = XFile.fromData(
        imageBytes,
        mimeType: 'image/png',
        name: 'divebrew_log_${session.id}.png',
      );

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [xFile],
        text: '다이브브루에서 기록한 프리다이빙 로그입니다! 🌊\n장소: ${session.siteName}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('공유 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(session.date);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일 (혹은 아이콘)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: session.photoPaths.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          session.photoPaths.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(theme),
                        ),
                      )
                    : _buildPlaceholderIcon(theme),
              ),
              const SizedBox(width: 16),
              // 정보 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.siteName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTag(
                          context,
                          _getPurposeText(session.purposeTag),
                        ),
                        const SizedBox(width: 8),
                        if (session.overallRating != null)
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < session.overallRating!
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // 공유 버튼
              IconButton(
                icon: const Icon(Icons.ios_share),
                onPressed: () => _shareToInstagram(context),
                tooltip: '인스타그램 공유',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(ThemeData theme) {
    return Icon(
      session.siteType == SiteType.pool ? Icons.pool : Icons.water,
      color: theme.colorScheme.onSecondaryContainer,
      size: 32,
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  String _getPurposeText(PurposeTag tag) {
    switch (tag) {
      case PurposeTag.training:
        return '트레이닝';
      case PurposeTag.leisure:
        return '펀다이빙';
      case PurposeTag.spearfishing:
        return '스피어피싱';
      case PurposeTag.photo:
        return '수중촬영';
      case PurposeTag.competitionPractice:
        return '대회준비';
      case PurposeTag.other:
        return '기타';
    }
  }
}
