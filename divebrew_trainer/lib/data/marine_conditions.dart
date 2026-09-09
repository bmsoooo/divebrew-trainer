// 해양 예보를 앱의 다이빙 컨디션 모델과 적합도 판정으로 변환
// 국내 포인트는 국립해양조사원(KHOA) API를 우선 사용합니다.
import 'dart:math';
import 'khoa_marine_api.dart';
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

class TideForecastResult {
  final String tideText;
  final String stationName;

  const TideForecastResult({
    required this.tideText,
    required this.stationName,
  });
}

class SkinScubaStation {
  final String code;
  final String name;
  final double latitude;
  final double longitude;

  const SkinScubaStation({
    required this.code,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class TideStation {
  final String code;
  final String name;
  final double latitude;
  final double longitude;

  const TideStation({
    required this.code,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

const skinScubaStations = [
  SkinScubaStation(code: 'SS1', name: '동명항', latitude: 38.2097, longitude: 128.6136),
  SkinScubaStation(code: 'SS2', name: '남애항', latitude: 37.9442, longitude: 128.7951),
  SkinScubaStation(code: 'SS3', name: '강문해변', latitude: 37.8025, longitude: 128.934),
  SkinScubaStation(code: 'SS4', name: '오산항', latitude: 36.8856, longitude: 129.429),
  SkinScubaStation(code: 'SS5', name: '월포해수욕장', latitude: 36.1961, longitude: 129.4123),
  SkinScubaStation(code: 'SS6', name: '구조라해수욕장', latitude: 34.8058, longitude: 128.6874),
  SkinScubaStation(code: 'SS7', name: '미조도', latitude: 34.7209, longitude: 128.0551),
  SkinScubaStation(code: 'SS8', name: '거문도', latitude: 34.0239, longitude: 127.328),
  SkinScubaStation(code: 'SS9', name: '성산일출봉', latitude: 33.4534, longitude: 126.9453),
  SkinScubaStation(code: 'SS10', name: '문섬', latitude: 33.2273, longitude: 126.568),
  SkinScubaStation(code: 'SS11', name: '홍도', latitude: 34.67377, longitude: 125.1996),
  SkinScubaStation(code: 'SS12', name: '울릉도', latitude: 37.55982, longitude: 130.9003),
  SkinScubaStation(code: 'SS13', name: '어영', latitude: 33.5196, longitude: 126.4849),
  SkinScubaStation(code: 'SS14', name: '태종대', latitude: 35.0598, longitude: 129.0775),
  SkinScubaStation(code: 'SS15', name: '격렬비열도', latitude: 36.61711, longitude: 125.56112),
  SkinScubaStation(code: 'SS16', name: '추자도', latitude: 33.97684, longitude: 126.2661),
  SkinScubaStation(code: 'SS17', name: '욕지도', latitude: 34.6276, longitude: 128.2977),
  SkinScubaStation(code: 'SS18', name: '추암', latitude: 37.4793, longitude: 129.1617),
];

const tideStations = [
  TideStation(code: 'DT_0001', name: '인천', latitude: 37.45194, longitude: 126.59222),
  TideStation(code: 'DT_0002', name: '평택', latitude: 36.96694, longitude: 126.82277),
  TideStation(code: 'DT_0003', name: '영광', latitude: 35.42611, longitude: 126.42055),
  TideStation(code: 'DT_0004', name: '제주', latitude: 33.5275, longitude: 126.54305),
  TideStation(code: 'DT_0005', name: '부산', latitude: 35.09638, longitude: 129.03527),
  TideStation(code: 'DT_0006', name: '묵호', latitude: 37.55027, longitude: 129.11638),
  TideStation(code: 'DT_0007', name: '목포', latitude: 34.77972, longitude: 126.37555),
  TideStation(code: 'DT_0008', name: '안산', latitude: 37.19222, longitude: 126.64722),
  TideStation(code: 'DT_0010', name: '서귀포', latitude: 33.24, longitude: 126.56166),
  TideStation(code: 'DT_0011', name: '후포', latitude: 36.6775, longitude: 129.45305),
  TideStation(code: 'DT_0012', name: '속초', latitude: 38.20722, longitude: 128.59416),
  TideStation(code: 'DT_0013', name: '울릉도', latitude: 37.49138, longitude: 130.91361),
  TideStation(code: 'DT_0014', name: '통영', latitude: 34.82777, longitude: 128.43472),
  TideStation(code: 'DT_0016', name: '여수', latitude: 34.74722, longitude: 127.76555),
  TideStation(code: 'DT_0017', name: '대산', latitude: 37.0075, longitude: 126.35277),
  TideStation(code: 'DT_0018', name: '군산', latitude: 35.97555, longitude: 126.56305),
  TideStation(code: 'DT_0020', name: '울산', latitude: 35.50194, longitude: 129.38722),
  TideStation(code: 'DT_0021', name: '추자도', latitude: 33.96194, longitude: 126.30027),
  TideStation(code: 'DT_0022', name: '성산포', latitude: 33.47472, longitude: 126.92777),
  TideStation(code: 'DT_0023', name: '모슬포', latitude: 33.21444, longitude: 126.25111),
  TideStation(code: 'DT_0024', name: '장항', latitude: 36.00694, longitude: 126.6875),
  TideStation(code: 'DT_0025', name: '보령', latitude: 36.40638, longitude: 126.48611),
  TideStation(code: 'DT_0026', name: '고흥발포', latitude: 34.48111, longitude: 127.34277),
  TideStation(code: 'DT_0027', name: '완도', latitude: 34.31555, longitude: 126.75972),
  TideStation(code: 'DT_0028', name: '진도', latitude: 34.37777, longitude: 126.30861),
  TideStation(code: 'DT_0029', name: '거제도', latitude: 34.80138, longitude: 128.69916),
  TideStation(code: 'DT_0031', name: '거문도', latitude: 34.02833, longitude: 127.30888),
  TideStation(code: 'DT_0032', name: '강화대교', latitude: 37.73194, longitude: 126.52222),
  TideStation(code: 'DT_0035', name: '흑산도', latitude: 34.68416, longitude: 125.43555),
  TideStation(code: 'DT_0036', name: '대청도', latitude: 37.82522, longitude: 124.71805),
  TideStation(code: 'DT_0037', name: '어청도', latitude: 36.11722, longitude: 125.98472),
  TideStation(code: 'DT_0038', name: '굴업도', latitude: 37.19444, longitude: 125.995),
  TideStation(code: 'DT_0039', name: '왕돌초', latitude: 36.71916, longitude: 129.7325),
  TideStation(code: 'DT_0041', name: '복사초', latitude: 34.09833, longitude: 126.16833),
  TideStation(code: 'DT_0042', name: '교본초', latitude: 34.70472, longitude: 128.30638),
  TideStation(code: 'DT_0043', name: '영흥도', latitude: 37.23861, longitude: 126.42861),
  TideStation(code: 'DT_0044', name: '영종대교', latitude: 37.54555, longitude: 126.58444),
  TideStation(code: 'DT_0046', name: '쌍정초', latitude: 37.55616, longitude: 130.93921),
  TideStation(code: 'DT_0047', name: '도농탄', latitude: 33.15805, longitude: 126.27472),
  TideStation(code: 'DT_0048', name: '속초등표', latitude: 38.19947, longitude: 128.61308),
  TideStation(code: 'DT_0049', name: '광양', latitude: 34.90367, longitude: 127.75483),
  TideStation(code: 'DT_0050', name: '태안', latitude: 36.91305, longitude: 126.23888),
  TideStation(code: 'DT_0051', name: '서천마량', latitude: 36.12888, longitude: 126.49527),
  TideStation(code: 'DT_0052', name: '인천송도', latitude: 37.33805, longitude: 126.58611),
  TideStation(code: 'DT_0054', name: '진해', latitude: 35.14722, longitude: 128.64305),
  TideStation(code: 'DT_0056', name: '부산항신항', latitude: 35.0775, longitude: 128.78472),
  TideStation(code: 'DT_0057', name: '동해항', latitude: 37.49472, longitude: 129.14388),
  TideStation(code: 'DT_0058', name: '경인항', latitude: 37.56083, longitude: 126.60111),
  TideStation(code: 'DT_0059', name: '백령도', latitude: 37.95565, longitude: 124.73608),
  TideStation(code: 'DT_0060', name: '연평도', latitude: 37.65766, longitude: 125.71441),
  TideStation(code: 'DT_0061', name: '삼천포', latitude: 34.92416, longitude: 128.06972),
  TideStation(code: 'DT_0062', name: '마산', latitude: 35.1975, longitude: 128.57638),
  TideStation(code: 'DT_0063', name: '가덕도', latitude: 35.02417, longitude: 128.81093),
  TideStation(code: 'DT_0064', name: '교동대교', latitude: 37.78961, longitude: 126.33961),
  TideStation(code: 'DT_0065', name: '덕적도', latitude: 37.22633, longitude: 126.15655),
  TideStation(code: 'DT_0066', name: '향화도', latitude: 35.16766, longitude: 126.35955),
  TideStation(code: 'DT_0067', name: '안흥', latitude: 36.67463, longitude: 126.12955),
  TideStation(code: 'DT_0068', name: '위도', latitude: 35.61808, longitude: 126.30181),
  TideStation(code: 'DT_0091', name: '포항', latitude: 36.05177, longitude: 129.37627),
  TideStation(code: 'DT_0092', name: '여호항', latitude: 34.66194, longitude: 127.46916),
  TideStation(code: 'DT_0093', name: '소무의도', latitude: 37.37306, longitude: 126.44006),
  TideStation(code: 'DT_0094', name: '서거차도', latitude: 34.25142, longitude: 125.91544),
];

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
  final double? waveHeightM;
  final double? seaSurfaceTemperatureC;
  final double? waveDirectionDegrees;
  final DateTime observedAt;
  final String? tide;
  final String? tideStationName;
  final String? waveStationName;
  final DiveSuitability? apiSuitability; // KHOA에서 제공하는 totalIndex 기반

  const MarineCondition({
    this.waveHeightM,
    this.seaSurfaceTemperatureC,
    this.waveDirectionDegrees,
    required this.observedAt,
    this.tide,
    this.tideStationName,
    this.waveStationName,
    this.apiSuitability,
  });

  DiveSuitability get suitability {
    if (apiSuitability != null) return apiSuitability!;
    final wave = waveHeightM;
    final temp = seaSurfaceTemperatureC;
    if (wave == null || temp == null) {
      return DiveSuitability.caution; // 관측 정보가 부족할 경우 보통(caution)으로 안전하게 처리
    }
    if (wave > 1.2 || temp < 10) {
      return DiveSuitability.avoid;
    }
    if (wave > 0.6 || temp < 14) {
      return DiveSuitability.caution;
    }
    return DiveSuitability.favorable;
  }

  String get suitRecommendation {
    final temp = seaSurfaceTemperatureC;
    if (temp == null) return '수온 정보 없음';
    if (temp >= 28) return '3mm 숏티 / 래쉬가드';
    if (temp >= 24) return '3mm 풀수트';
    if (temp >= 20) return '5mm 풀수트';
    if (temp >= 16) return '7mm / 세미드라이';
    return '드라이수트';
  }

  WaveDirection get waveDirection {
    final deg = waveDirectionDegrees ?? 0.0;
    final normalized = deg % 360;
    final index = ((normalized + 22.5) ~/ 45) % WaveDirection.values.length;
    return WaveDirection.values[index];
  }
}

class MarineForecastRepository {
  final KhoaMarineApi _khoa;
  
  // ignore: unused_field
  final MarineForecastLoader _loader;

  MarineForecastRepository({
    KhoaMarineApi? khoa,
    MarineForecastLoader? loader,
  })  : _khoa = khoa ?? KhoaMarineApi(),
        _loader = loader ?? loadMarineForecast;

  Future<MarineCondition> load(DiveSite site) async {
    final khoa = _khoa;

    // 1. 물때용 조위관측소 탐색 (최근접)
    TideStation? closestTideStation;
    double minTideDist = double.infinity;
    for (final station in tideStations) {
      final dist = _calculateDistance(site.latitude, site.longitude, station.latitude, station.longitude);
      if (dist < minTideDist) {
        minTideDist = dist;
        closestTideStation = station;
      }
    }

    String? tideForecast;
    String? tideStationName;
    if (closestTideStation != null && minTideDist <= 100.0) {
      try {
        final tideResult = await khoa.fetchTideForecast(closestTideStation.code);
        if (tideResult != null) {
          tideForecast = tideResult.tideText;
          tideStationName = tideResult.stationName;
        }
      } catch (_) {}
    }

    // 2. 파고·수온·파향용 KHOA 관측소 탐색 (최근접)
    SkinScubaStation? closestScubaStation;
    double minScubaDist = double.infinity;
    for (final station in skinScubaStations) {
      final dist = _calculateDistance(site.latitude, site.longitude, station.latitude, station.longitude);
      if (dist < minScubaDist) {
        minScubaDist = dist;
        closestScubaStation = station;
      }
    }

    double? waveHeight;
    double? waterTemp;
    String? waveStationName;
    DiveSuitability? suitability;

    if (closestScubaStation != null && minScubaDist <= 100.0) {
      final result = await khoa.fetchSkinScubaIndex(closestScubaStation.code);
      if (result != null) {
        waveHeight = result.waveHeightM;
        waterTemp = result.seaSurfaceTemperatureC;
        waveStationName = result.tideStationName ?? closestScubaStation.name;
        suitability = result.apiSuitability;
      }
    }

    return MarineCondition(
      waveHeightM: waveHeight,
      seaSurfaceTemperatureC: waterTemp,
      waveDirectionDegrees: 0.0,
      observedAt: DateTime.now(),
      tide: tideForecast,
      tideStationName: tideStationName ?? (minTideDist <= 100.0 ? closestTideStation?.name : null),
      waveStationName: waveStationName,
      apiSuitability: suitability,
    );
  }

  // Haversine 거리 계산식 (단위: km)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _rad(double degree) => degree * pi / 180.0;
}
