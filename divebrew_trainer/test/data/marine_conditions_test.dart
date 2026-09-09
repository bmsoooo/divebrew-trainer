// 해양 예보 파싱과 다이빙 적합도 기준을 검증하는 테스트
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/marine_conditions.dart';
import 'package:divebrew_trainer/data/khoa_marine_api.dart';

class MockKhoaMarineApi extends KhoaMarineApi {
  final bool shouldFail;

  MockKhoaMarineApi({this.shouldFail = false});

  @override
  Future<MarineCondition?> fetchSkinScubaIndex(String placeCode) async {
    if (shouldFail) throw StateError('API failure');
    if (placeCode == 'SS1') {
      return MarineCondition(
        waveHeightM: 0.4,
        seaSurfaceTemperatureC: 22.6,
        waveDirectionDegrees: 0,
        observedAt: DateTime(2026, 7, 10, 9),
        tideStationName: '동명항',
        apiSuitability: DiveSuitability.favorable,
      );
    }
    return null;
  }

  @override
  Future<TideForecastResult?> fetchTideForecast(String obsCode) async {
    if (shouldFail) throw StateError('API failure');
    if (obsCode == 'DT_0012') {
      return const TideForecastResult(
        tideText: '오전: 만조 00:47 (1.5m)\n오후: 간조 13:05 (0.2m)',
        stationName: '속초',
      );
    }
    return null;
  }
}

void main() {
  group('MarineForecastRepository', () {
    test('KHOA API 응답을 최근접 관측소 기준으로 다이빙 컨디션으로 변환한다', () async {
      final repository = MarineForecastRepository(
        khoa: MockKhoaMarineApi(),
      );

      // Sokcho (SS1, DT_0012)
      final condition = await repository.load(diveSites[1]);

      expect(condition.waveHeightM, 0.4);
      expect(condition.seaSurfaceTemperatureC, 22.6);
      expect(condition.tideStationName, '속초');
      expect(condition.waveStationName, '동명항');
      expect(condition.tide, contains('오전: 만조 00:47'));
      expect(condition.suitability, DiveSuitability.favorable);
    });

    test('최근접 관측소가 100km를 초과하면 정보 없음(null)으로 처리한다', () async {
      final repository = MarineForecastRepository(
        khoa: MockKhoaMarineApi(),
      );

      // 위경도 (0, 0)은 한국 관측소와 100km 이상 떨어져 있음
      const farSite = DiveSite(id: 'far_away', latitude: 0.0, longitude: 0.0);
      final condition = await repository.load(farSite);

      expect(condition.waveHeightM, isNull);
      expect(condition.seaSurfaceTemperatureC, isNull);
      expect(condition.tideStationName, isNull);
      expect(condition.waveStationName, isNull);
      expect(condition.tide, isNull);
    });
  });

  group('다이빙 적합도', () {
    MarineCondition condition({required double? wave, required double? water}) =>
        MarineCondition(
          waveHeightM: wave,
          seaSurfaceTemperatureC: water,
          waveDirectionDegrees: 0,
          observedAt: DateTime(2026, 7, 10, 9),
        );

    test('낮은 파고와 온화한 수온이면 현장 확인 단계다', () {
      expect(
        condition(wave: 0.6, water: 18).suitability,
        DiveSuitability.favorable,
      );
    });

    test('파고 0.6m 초과 또는 수온 14도 미만이면 주의 단계다', () {
      expect(
        condition(wave: 0.7, water: 18).suitability,
        DiveSuitability.caution,
      );
      expect(
        condition(wave: 0.4, water: 13.9).suitability,
        DiveSuitability.caution,
      );
    });

    test('파고 1.2m 초과 또는 수온 10도 미만이면 휴식 단계다', () {
      expect(
        condition(wave: 1.3, water: 18).suitability,
        DiveSuitability.avoid,
      );
      expect(
        condition(wave: 0.4, water: 9.9).suitability,
        DiveSuitability.avoid,
      );
    });

    test('관측 정보가 부재할 경우 보통(주의) 단계다', () {
      expect(
        condition(wave: null, water: null).suitability,
        DiveSuitability.caution,
      );
    });
  });
}
