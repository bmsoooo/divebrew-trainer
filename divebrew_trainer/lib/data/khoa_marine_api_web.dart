// 국립해양조사원(KHOA) 스킨스쿠버 지수 API 서비스
import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'marine_conditions.dart';

const _khoaApiKey = '3d30f2dc2e73f9d445393efe4721ab89777dc3bfcd2992885d6859d173ed2201';

class KhoaMarineApi {
  /// 스킨스쿠버 지수 조회
  /// http://www.khoa.go.kr/api/oceangrid/skinScuba/search.do
  Future<MarineCondition?> fetchSkinScubaIndex(String placeCode) async {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    
    final uri = Uri.parse(
      'https://www.khoa.go.kr/api/oceangrid/skinScuba/search.do'
      '?ServiceKey=$_khoaApiKey'
      '&Type=json'
      '&ResultType=json'
      '&SearchTime=$dateStr'
      '&SkinScubaCode=$placeCode',
    );

    try {
      final response = await web.window.fetch(uri.toString().toJS).toDart;
      if (!response.ok) return null;

      final body = (await response.text().toDart).toDart;
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return null;

      final result = decoded['result'];
      if (result is! Map<String, dynamic>) return null;

      final data = result['data'];
      if (data is! List || data.isEmpty) return null;

      // 오늘 날짜의 첫 번째 데이터 사용
      final item = data[0] as Map<String, dynamic>;

      final waveHeight = _parseDouble(item['wave_height']) ?? 0.0;
      final waterTemp = _parseDouble(item['water_temp']) ?? 0.0;
      final totalIndex = item['total_index']?.toString() ?? '';
      final tideTime = item['tide_time_score']?.toString() ?? '';

      // totalIndex 기반 suitability 매핑
      DiveSuitability? apiSuitability;
      if (totalIndex.contains('매우좋음') || totalIndex.contains('좋음')) {
        apiSuitability = DiveSuitability.favorable;
      } else if (totalIndex.contains('보통')) {
        apiSuitability = DiveSuitability.caution;
      } else if (totalIndex.contains('나쁨') || totalIndex.contains('매우나쁨')) {
        apiSuitability = DiveSuitability.avoid;
      }

      // 물때 정보 파싱
      String? tide;
      if (tideTime.isNotEmpty) {
        tide = tideTime;
      }

      return MarineCondition(
        waveHeightM: waveHeight,
        seaSurfaceTemperatureC: waterTemp,
        waveDirectionDegrees: 0,
        observedAt: now,
        tide: tide,
        apiSuitability: apiSuitability,
      );
    } catch (_) {
      return null;
    }
  }

  /// 조석예보 조회 (물때 보조 정보) - 공공데이터포털 API 활용
  Future<String?> fetchTideForecast(String obsCode) async {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    final uri = Uri.parse(
      'https://apis.data.go.kr/1192136/tideFcstHghLw/GetTideFcstHghLwApiService'
      '?serviceKey=$_khoaApiKey'
      '&numOfRows=10'
      '&pageNo=1'
      '&type=json'
      '&obsCode=$obsCode'
      '&reqDate=$dateStr',
    );

    try {
      final response = await web.window.fetch(uri.toString().toJS).toDart;
      if (!response.ok) return null;

      final body = (await response.text().toDart).toDart;
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return null;

      final bodyNode = decoded['body'] ?? decoded['response']?['body'];
      if (bodyNode is! Map<String, dynamic>) return null;
      
      final itemsNode = bodyNode['items'];
      if (itemsNode is! Map<String, dynamic>) return null;
      
      final item = itemsNode['item'];
      if (item is! List || item.isEmpty) return null;

      // 오늘의 조석 정보 (만조/간조 시각들)
      final tideEntries = <String>[];
      for (final entry in item) {
        if (entry is Map<String, dynamic>) {
          final predcDt = entry['predcDt']?.toString() ?? ''; // "2025-11-26 00:47"
          final level = entry['predcTdlvVl']?.toString() ?? '';
          final extrSe = entry['extrSe']?.toString() ?? ''; // 1, 3: 만조 / 2, 4: 간조
          
          if (predcDt.isNotEmpty) {
            final timePart = predcDt.length > 11 ? predcDt.substring(11, 16) : predcDt;
            final isHighTide = extrSe == '1' || extrSe == '3';
            final label = isHighTide ? '만조' : '간조';
            
            String formattedLevel = '${level}cm';
            final levelValue = _parseDouble(level);
            if (levelValue != null) {
              formattedLevel = '${(levelValue / 100).toStringAsFixed(1)}m';
            }
            tideEntries.add('$label $timePart ($formattedLevel)');
          }
        }
      }

      return tideEntries.isNotEmpty ? tideEntries.join(' · ') : null;
    } catch (_) {
      return null;
    }
  }

  double? _parseDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
