// 홈에서 선택한 포인트의 해양 예보와 다이빙 적합도를 표시하는 카드
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../app/theme.dart';
import '../../data/marine_conditions.dart';
import '../../l10n/app_localizations.dart';

class MarineConditionsCard extends StatefulWidget {
  final MarineForecastRepository? repository;

  const MarineConditionsCard({super.key, this.repository});

  @override
  State<MarineConditionsCard> createState() => _MarineConditionsCardState();
}

class _MarineConditionsCardState extends State<MarineConditionsCard> {
  static const DiveSite _currentLocationSite = DiveSite(
    id: 'current_location',
    latitude: 0,
    longitude: 0,
  );

  DiveSite _site = _currentLocationSite;
  late final MarineForecastRepository _repository;
  late Future<MarineCondition> _condition;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MarineForecastRepository();
    _condition = _loadForSite(_site);
  }

  Future<MarineCondition> _loadForSite(DiveSite site) async {
    if (site.id == 'current_location') {
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) throw Exception('Location services disabled.');

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception('Location permission denied.');
          }
        }
        if (permission == LocationPermission.deniedForever) {
          throw Exception('Location permission permanently denied.');
        }

        final pos = await Geolocator.getCurrentPosition();
        return await _repository.load(
          DiveSite(
            id: 'current_location',
            latitude: pos.latitude,
            longitude: pos.longitude,
          ),
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _site = diveSites.first;
          });
        }
        return _repository.load(diveSites.first);
      }
    }
    return _repository.load(site);
  }

  void _selectSite(DiveSite site) {
    setState(() {
      _site = site;
      _condition = _loadForSite(site);
    });
  }

  void _retry() {
    setState(() => _condition = _loadForSite(_site));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      key: const ValueKey('marine-conditions-card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: abyss,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: oceanBorder),
      ),
      child: FutureBuilder<MarineCondition>(
        future: _condition,
        builder: (context, snapshot) {
          final condition = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.marineTitle, style: utilityLabelStyle),
                  ),
                  PopupMenuButton<DiveSite>(
                    tooltip: l10n.marineSelectSite,
                    color: oceanRaised,
                    onSelected: _selectSite,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _currentLocationSite,
                        child: Text(_siteName(l10n, _currentLocationSite)),
                      ),
                      for (final site in diveSites)
                        PopupMenuItem(
                          value: site,
                          child: Text(_siteName(l10n, site)),
                        ),
                    ],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _siteName(l10n, _site),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: foam,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: mist,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SurfaceTrace(),
              const SizedBox(height: 12),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SizedBox(
                  height: 76,
                  child: Center(
                    child: CircularProgressIndicator(color: snorkelYellow),
                  ),
                )
              else if (snapshot.hasError || condition == null)
                _FailureState(onRetry: _retry)
              else
                _ConditionBody(condition: condition),
              const SizedBox(height: 12),
              Text(
                l10n.marineDisclaimer,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.45,
                  color: mist,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _siteName(AppLocalizations l10n, DiveSite site) => switch (site.id) {
    'current_location' => l10n.marineSiteCurrentLocation,
    'goseong' => l10n.marineSiteGoseong,
    'sokcho' => l10n.marineSiteSokcho,
    'yangyang' => l10n.marineSiteYangyang,
    'gangneung' => l10n.marineSiteGangneung,
    'donghae' => l10n.marineSiteDonghae,
    'uljin' => l10n.marineSiteUljin,
    'yeongdeok' => l10n.marineSiteYeongdeok,
    'pohang' => l10n.marineSitePohang,
    'ulleungdo' => l10n.marineSiteUlleungdo,
    'busan' => l10n.marineSiteBusan,
    'geoje' => l10n.marineSiteGeoje,
    'tongyeong' => l10n.marineSiteTongyeong,
    'namhae' => l10n.marineSiteNamhae,
    'yeosu' => l10n.marineSiteYeosu,
    'jeju' => l10n.marineSiteJeju,
    'seogwipo' => l10n.marineSiteSeogwipo,
    _ => site.id,
  };
}

class _ConditionBody extends StatelessWidget {
  final MarineCondition condition;

  const _ConditionBody({required this.condition});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rating = _rating(l10n, condition.suitability);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 다이빙 상태 배지
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: rating.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: rating.color.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(rating.icon, color: rating.color, size: 20),
              const SizedBox(width: 8),
              Text(
                rating.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: rating.color,
                ),
              ),
              const Spacer(),
              Text(
                l10n.marineUpdatedAt(_time(condition.observedAt)),
                style: const TextStyle(fontSize: 11, color: mist),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 수온·파고·파향 수치 (색상 강조)
        Row(
          children: [
            _Reading(
              label: l10n.marineWave,
              value: '${condition.waveHeightM.toStringAsFixed(1)} m',
              valueColor: condition.waveHeightM > 1.2
                  ? const Color(0xFFFF6B6B)
                  : condition.waveHeightM > 0.6
                      ? snorkelYellow
                      : const Color(0xFF4ADE80),
            ),
            _Reading(
              label: l10n.marineWaterTemp,
              value: '${condition.seaSurfaceTemperatureC.toStringAsFixed(1)}°',
              valueColor: condition.seaSurfaceTemperatureC < 14
                  ? const Color(0xFF60A5FA)
                  : condition.seaSurfaceTemperatureC < 20
                      ? foam
                      : const Color(0xFF4ADE80),
            ),
            _Reading(
              label: l10n.marineWaveDirection,
              value: l10n.marineFrom(_direction(l10n, condition.waveDirection)),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 수트 추천 & 물때 정보
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: midWater.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 수트 추천
              Row(
                children: [
                  const Icon(Icons.checkroom, color: snorkelYellow, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '추천 수트',
                    style: utilityLabelStyle.copyWith(fontSize: 11),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      condition.suitRecommendation,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: foam,
                      ),
                    ),
                  ),
                ],
              ),
              // 물때 정보 (KHOA 데이터가 있을 때만)
              if (condition.tide != null) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.waves, color: Color(0xFF60A5FA), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '물때',
                      style: utilityLabelStyle.copyWith(fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        condition.tide!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: foam,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _time(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _direction(AppLocalizations l10n, WaveDirection direction) =>
      switch (direction) {
        WaveDirection.north => l10n.marineDirectionNorth,
        WaveDirection.northEast => l10n.marineDirectionNorthEast,
        WaveDirection.east => l10n.marineDirectionEast,
        WaveDirection.southEast => l10n.marineDirectionSouthEast,
        WaveDirection.south => l10n.marineDirectionSouth,
        WaveDirection.southWest => l10n.marineDirectionSouthWest,
        WaveDirection.west => l10n.marineDirectionWest,
        WaveDirection.northWest => l10n.marineDirectionNorthWest,
      };

  _Rating _rating(
    AppLocalizations l10n,
    DiveSuitability suitability,
  ) => switch (suitability) {
    DiveSuitability.favorable => _Rating(l10n.marineFavorable, const Color(0xFF4ADE80), Icons.check_circle),
    DiveSuitability.caution => _Rating(l10n.marineCaution, snorkelYellow, Icons.warning_amber_rounded),
    DiveSuitability.avoid => _Rating(l10n.marineAvoid, const Color(0xFFFF6B6B), Icons.dangerous),
  };
}

class _Reading extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Reading({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: utilityLabelStyle.copyWith(fontSize: 10.5)),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor ?? foam,
          ),
        ),
      ],
    ),
  );
}

class _FailureState extends StatelessWidget {
  final VoidCallback onRetry;

  const _FailureState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 76,
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, color: mist),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.marineLoadError,
              style: const TextStyle(fontSize: 13, color: mist),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(l10n.marineRetry)),
        ],
      ),
    );
  }
}

class _SurfaceTrace extends StatelessWidget {
  const _SurfaceTrace();

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(double.infinity, 8),
    painter: _SurfaceTracePainter(),
  );
}

class _SurfaceTracePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = snorkelYellow.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..moveTo(0, size.height / 2);
    for (var x = 0.0; x <= size.width; x += 18) {
      path.quadraticBezierTo(x + 4.5, 0, x + 9, size.height / 2);
      path.quadraticBezierTo(x + 13.5, size.height, x + 18, size.height / 2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Rating {
  final String label;
  final Color color;
  final IconData icon;

  const _Rating(this.label, this.color, this.icon);
}
