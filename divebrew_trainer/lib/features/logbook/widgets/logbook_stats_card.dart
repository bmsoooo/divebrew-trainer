import 'package:flutter/material.dart';
import '../../../data/database.dart';
import '../../../data/models.dart';
import '../../../app/theme.dart';

class LogbookStatsCard extends StatelessWidget {
  final List<DiveSession> sessions;

  const LogbookStatsCard({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) return const SizedBox.shrink();

    final totalDives = sessions.length;
    
    // 주력 장소 계산 (가장 많이 간 SiteType)
    final Map<SiteType, int> siteCounts = {};
    for (var s in sessions) {
      siteCounts[s.siteType] = (siteCounts[s.siteType] ?? 0) + 1;
    }
    SiteType? favoriteSite;
    int maxSiteCount = 0;
    siteCounts.forEach((key, value) {
      if (value > maxSiteCount) {
        maxSiteCount = value;
        favoriteSite = key;
      }
    });

    String favoriteSiteText = '-';
    if (favoriteSite != null) {
      switch (favoriteSite!) {
        case SiteType.sea: favoriteSiteText = '바다 ($maxSiteCount회)'; break;
        case SiteType.pool: favoriteSiteText = '풀장 ($maxSiteCount회)'; break;
        case SiteType.lake: favoriteSiteText = '호수 ($maxSiteCount회)'; break;
      }
    }

    // 평균 별점 계산
    int validRatingCount = 0;
    double totalRating = 0;
    for (var s in sessions) {
      if (s.overallRating != null && s.overallRating! > 0) {
        validRatingCount++;
        totalRating += s.overallRating!;
      }
    }
    
    final String avgRatingText = validRatingCount > 0 
      ? (totalRating / validRatingCount).toStringAsFixed(1) 
      : '-';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: oceanRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: oceanBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '내 다이빙 통계 요약',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: foam,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.pool,
                label: '총 횟수',
                value: '$totalDives회',
              ),
              _StatItem(
                icon: Icons.place_outlined,
                label: '주력 장소',
                value: favoriteSiteText,
              ),
              _StatItem(
                icon: Icons.star_border,
                label: '평균 만족도',
                value: avgRatingText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: snorkelYellow, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: mist),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: foam,
          ),
        ),
      ],
    );
  }
}
