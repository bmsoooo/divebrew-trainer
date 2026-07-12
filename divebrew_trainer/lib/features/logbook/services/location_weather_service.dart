import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../../../data/models.dart';

class LocationWeatherService {
  /// 현재 위치(GPS) 정보 가져오기 (권한 요청 포함)
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }

  /// 역지오코딩: 좌표로 장소명 가져오기 (OSM Nominatim)
  Future<String?> getPlaceName(double lat, double lon) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=jsonv2');
      final response = await http.get(url, headers: {
        'User-Agent': 'DiveBrew/1.0',
        'Accept-Language': 'ko-KR,ko;q=0.9',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['address'] != null) {
          final addr = data['address'];
          // 명칭 우선순위: 특정 지역명 > 동/읍/면 > 시/군/구
          return addr['village'] ??
              addr['town'] ??
              addr['suburb'] ??
              addr['city'] ??
              data['display_name'];
        }
      }
    } catch (e) {
      debugPrint('Nominatim Error: $e');
    }
    return null;
  }

  /// 포워드 지오코딩: 장소명으로 좌표 가져오기 (OSM Nominatim)
  Future<Map<String, double>?> searchPlace(String query) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&limit=1');
      final response = await http.get(url, headers: {
        'User-Agent': 'DiveBrew/1.0',
        'Accept-Language': 'ko-KR,ko;q=0.9',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final first = data.first;
          return {
            'lat': double.parse(first['lat'].toString()),
            'lon': double.parse(first['lon'].toString()),
          };
        }
      }
    } catch (e) {
      debugPrint('Nominatim Search Error: $e');
    }
    return null;
  }

  /// 해양 데이터: 좌표로 파고, 수온, 파향 가져오기 (Open-Meteo Marine API)
  Future<DiveCondition> getMarineData(double lat, double lon) async {
    try {
      final url = Uri.parse(
          'https://marine-api.open-meteo.com/v1/marine?latitude=$lat&longitude=$lon&current=wave_height,wave_direction,sea_surface_temperature');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final current = data['current'];
        if (current != null) {
          return DiveCondition(
            waveHeightM: (current['wave_height'] as num?)?.toDouble(),
            waveDirectionDeg: (current['wave_direction'] as num?)?.toDouble(),
            waterTempC: (current['sea_surface_temperature'] as num?)?.toDouble(),
            source: ConditionSource.auto,
          );
        }
      }
    } catch (e) {
      debugPrint('Marine API Error: $e');
    }
    
    // 실패 시 빈 값 반환
    return const DiveCondition(source: ConditionSource.manual);
  }
}
