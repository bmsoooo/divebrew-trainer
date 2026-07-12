import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database.dart';
import '../../../data/models.dart';
import 'logbook_image.dart';

class LogbookCard extends StatelessWidget {
  final DiveSession session;
  final VoidCallback onTap;

  const LogbookCard({
    super.key,
    required this.session,
    required this.onTap,
  });



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
                        child: LogbookImage(
                          path: session.photoPaths.first,
                          fit: BoxFit.cover,
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
                onPressed: () {
                  if (session.photoPaths.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('사진을 먼저 추가해주세요.')),
                    );
                  } else {
                    context.push('/logbook/share', extra: session);
                  }
                },
                tooltip: '공유 카드 만들기',
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
