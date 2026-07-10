// Open-Meteo 해양 예보를 앱의 다이빙 컨디션 모델과 적합도 판정으로 변환
import 'marine_forecast_loader.dart';

typedef MarineForecastLoader = Future<Map<String, dynamic>> Function(Uri uri);

class DiveSite {
  final String id;
  final double latitude;
  final double longitude;

  const DiveSite({
    required this.id,
    required this.latitude,
    required this.longitude,
  });
}

const diveSites = [
  DiveSite(id: 'goseong', latitude: 38.3806, longitude: 128.4677),
  DiveSite(id: 'sokcho', latitude: 38.2070, longitude: 128.5918),
  DiveSite(id: 'yangyang', latitude: 38.0754, longitude: 128.6192),
  DiveSite(id: 'gangneung', latitude: 37.7518, longitude: 128.8760),
  DiveSite(id: 'donghae', latitude: 37.5247, longitude: 129.1143),
  DiveSite(id: 'uljin', latitude: 36.9930, longitude: 129.4002),
  DiveSite(id: 'yeongdeok', latitude: 36.4047, longitude: 129.3732),
  DiveSite(id: 'pohang', latitude: 36.0190, longitude: 129.3435),
  DiveSite(id: 'ulleungdo', latitude: 37.4988, longitude: 130.8656),
  DiveSite(id: 'busan', latitude: 35.0970, longitude: 129.0350),
  DiveSite(id: 'geoje', latitude: 34.8806, longitude: 128.6210),
  DiveSite(id: 'tongyeong', latitude: 34.8544, longitude: 128.4332),
  DiveSite(id: 'namhae', latitude: 34.8377, longitude: 127.8924),
  DiveSite(id: 'yeosu', latitude: 34.7604, longitude: 127.6622),
  DiveSite(id: 'jeju', latitude: 33.4996, longitude: 126.5311),
  DiveSite(id: 'seogwipo', latitude: 33.2397, longitude: 126.5618),
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

  const MarineCondition({
    required this.waveHeightM,
    required this.seaSurfaceTemperatureC,
    required this.waveDirectionDegrees,
    required this.observedAt,
  });

  DiveSuitability get suitability {
    if (waveHeightM > 1.2 || seaSurfaceTemperatureC < 10) {
      return DiveSuitability.avoid;
    }
    if (waveHeightM > 0.6 || seaSurfaceTemperatureC < 14) {
      return DiveSuitability.caution;
    }
    return DiveSuitability.favorable;
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
