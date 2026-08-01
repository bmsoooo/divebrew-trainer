// 해양 예보를 앱의 다이빙 컨디션 모델과 적합도 판정으로 변환
// 국내 포인트는 국립해양조사원(KHOA) API를 우선 사용하고, 나머지는 Open-Meteo를 사용합니다.
import 'khoa_marine_api.dart';
import 'marine_forecast_loader.dart';

typedef MarineForecastLoader = Future<Map<String, dynamic>> Function(Uri uri);

class DiveSite {
  final String id;
  final double latitude;
  final double longitude;
  final String? khoaPlaceCode;
  final String? khoaObsCode;

  const DiveSite({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.khoaPlaceCode,
    this.khoaObsCode,
  });
}

const diveSites = [
  DiveSite(id: 'goseong', latitude: 38.3806, longitude: 128.4677, khoaObsCode: 'DT_0004'),
  DiveSite(id: 'sokcho', latitude: 38.2070, longitude: 128.5918, khoaPlaceCode: 'SS1', khoaObsCode: 'DT_0004'),
  DiveSite(id: 'yangyang', latitude: 38.0754, longitude: 128.6192, khoaPlaceCode: 'SS2', khoaObsCode: 'DT_0004'),
  DiveSite(id: 'gangneung', latitude: 37.7518, longitude: 128.8760, khoaPlaceCode: 'SS3', khoaObsCode: 'DT_0005'),
  DiveSite(id: 'donghae', latitude: 37.5247, longitude: 129.1143, khoaPlaceCode: 'SS18', khoaObsCode: 'DT_0005'),
  DiveSite(id: 'uljin', latitude: 36.9930, longitude: 129.4002, khoaObsCode: 'DT_0007'),
  DiveSite(id: 'yeongdeok', latitude: 36.4047, longitude: 129.3732, khoaObsCode: 'DT_0007'),
  DiveSite(id: 'pohang', latitude: 36.0190, longitude: 129.3435, khoaPlaceCode: 'SS5', khoaObsCode: 'DT_0006'),
  DiveSite(id: 'ulleungdo', latitude: 37.4988, longitude: 130.8656, khoaPlaceCode: 'SS12', khoaObsCode: 'DT_0008'),
  DiveSite(id: 'busan', latitude: 35.0970, longitude: 129.0350, khoaPlaceCode: 'SS14', khoaObsCode: 'DT_0010'),
  DiveSite(id: 'geoje', latitude: 34.8806, longitude: 128.6210, khoaPlaceCode: 'SS6', khoaObsCode: 'DT_0012'),
  DiveSite(id: 'tongyeong', latitude: 34.8544, longitude: 128.4332, khoaObsCode: 'DT_0013'),
  DiveSite(id: 'namhae', latitude: 34.8377, longitude: 127.8924, khoaPlaceCode: 'SS7', khoaObsCode: 'DT_0013'),
  DiveSite(id: 'yeosu', latitude: 34.7604, longitude: 127.6622, khoaPlaceCode: 'SS8', khoaObsCode: 'DT_0016'),
  DiveSite(id: 'jeju', latitude: 33.4996, longitude: 126.5311, khoaPlaceCode: 'SS9', khoaObsCode: 'DT_0023'),
  DiveSite(id: 'seogwipo', latitude: 33.2397, longitude: 126.5618, khoaPlaceCode: 'SS10', khoaObsCode: 'DT_0024'),
];

enum DiveSuitability { favorable, caution, avoid }

enum WaveDirection {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest,
}

class MarineCondition {
  final double waveHeightM;
  final double seaSurfaceTemperatureC;
  final double waveDirectionDegrees;
  final DateTime observedAt;
  final String? tide;
  final DiveSuitability? apiSuitability; // KHOA에서 제공하는 totalIndex 기반

  const MarineCondition({
    required this.waveHeightM,
    required this.seaSurfaceTemperatureC,
    required this.waveDirectionDegrees,
    required this.observedAt,
    this.tide,
    this.apiSuitability,
  });

  DiveSuitability get suitability {
    if (apiSuitability != null) return apiSuitability!;
    if (waveHeightM > 1.2 || seaSurfaceTemperatureC < 10) {
      return DiveSuitability.avoid;
    }
    if (waveHeightM > 0.6 || seaSurfaceTemperatureC < 14) {
      return DiveSuitability.caution;
    }
    return DiveSuitability.favorable;
  }

  String get suitRecommendation {
    if (seaSurfaceTemperatureC >= 28) return '3mm 숏티 / 래쉬가드';
    if (seaSurfaceTemperatureC >= 24) return '3mm 풀수트';
    if (seaSurfaceTemperatureC >= 20) return '5mm 풀수트';
    if (seaSurfaceTemperatureC >= 16) return '7mm / 세미드라이';
    return '드라이수트';
  }

  WaveDirection get waveDirection {
    final normalized = waveDirectionDegrees % 360;
    final index = ((normalized + 22.5) ~/ 45) % WaveDirection.values.length;
    return WaveDirection.values[index];
  }
}

class MarineForecastRepository {
  final MarineForecastLoader _loader;

  MarineForecastRepository({MarineForecastLoader? loader})
    : _loader = loader ?? loadMarineForecast;

  Future<MarineCondition> load(DiveSite site) async {
    final khoa = KhoaMarineApi();
    String? tideForecast;

    if (site.khoaObsCode != null) {
      try {
        tideForecast = await khoa.fetchTideForecast(site.khoaObsCode!);
      } catch (_) {}
    }

    if (site.khoaPlaceCode != null) {
      try {
        final result = await khoa.fetchSkinScubaIndex(site.khoaPlaceCode!);
        if (result != null) {
          final combinedTide = (result.tide != null && tideForecast != null)
              ? '${result.tide} / $tideForecast'
              : (tideForecast ?? result.tide);

          return MarineCondition(
            waveHeightM: result.waveHeightM,
            seaSurfaceTemperatureC: result.seaSurfaceTemperatureC,
            waveDirectionDegrees: result.waveDirectionDegrees,
            observedAt: result.observedAt,
            tide: combinedTide,
            apiSuitability: result.apiSuitability,
          );
        }
      } catch (_) {
        // KHOA 실패 시 Open-Meteo로 fallback
      }
    }
    
    final openMeteoResult = await _loadOpenMeteo(site);
    return MarineCondition(
      waveHeightM: openMeteoResult.waveHeightM,
      seaSurfaceTemperatureC: openMeteoResult.seaSurfaceTemperatureC,
      waveDirectionDegrees: openMeteoResult.waveDirectionDegrees,
      observedAt: openMeteoResult.observedAt,
      tide: tideForecast,
      apiSuitability: openMeteoResult.apiSuitability,
    );
  }

  Future<MarineCondition> _loadOpenMeteo(DiveSite site) async {
    final uri = Uri.https('marine-api.open-meteo.com', '/v1/marine', {
      'latitude': site.latitude.toString(),
      'longitude': site.longitude.toString(),
      'current': 'wave_height,wave_direction,sea_surface_temperature',
      'timezone': 'Asia/Seoul',
    });
    final payload = await _loader(uri);
    final current = payload['current'];
    if (current is! Map<String, dynamic>) {
      throw const FormatException(
        'Marine forecast does not contain current data.',
      );
    }

    final waveHeight = _number(current['wave_height']);
    final waterTemperature = _number(current['sea_surface_temperature']);
    final direction = _number(current['wave_direction']);
    final time = current['time'];
    if (waveHeight == null ||
        waterTemperature == null ||
        direction == null ||
        time is! String) {
      throw const FormatException(
        'Marine forecast contains incomplete current data.',
      );
    }

    return MarineCondition(
      waveHeightM: waveHeight,
      seaSurfaceTemperatureC: waterTemperature,
      waveDirectionDegrees: direction,
      observedAt: DateTime.parse(time),
    );
  }

  double? _number(Object? value) => switch (value) {
    num number => number.toDouble(),
    _ => null,
  };
}
