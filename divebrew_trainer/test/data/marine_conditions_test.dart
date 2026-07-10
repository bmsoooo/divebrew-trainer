// 해양 예보 파싱과 다이빙 적합도 기준을 검증하는 테스트
import 'package:flutter_test/flutter_test.dart';

import 'package:divebrew_trainer/data/marine_conditions.dart';

void main() {
  group('MarineForecastRepository', () {
    test('Open-Meteo current 응답을 다이빙 컨디션으로 변환한다', () async {
      Uri? requestedUri;
      final repository = MarineForecastRepository(
        loader: (uri) async {
          requestedUri = uri;
          return {
            'current': {
              'time': '2026-07-10T09:00',
              'wave_height': 0.4,
              'wave_direction': 45,
              'sea_surface_temperature': 22.6,
            },
          };
        },
      );

      final condition = await repository.load(diveSites.first);

      expect(requestedUri?.host, 'marine-api.open-meteo.com');
      expect(
        requestedUri?.queryParameters['current'],
        'wave_height,wave_direction,sea_surface_temperature',
      );
      expect(condition.waveHeightM, 0.4);
      expect(condition.seaSurfaceTemperatureC, 22.6);
      expect(condition.waveDirection, WaveDirection.northEast);
      expect(condition.suitability, DiveSuitability.favorable);
    });

    test('필수 현재값이 없으면 응답을 거부한다', () async {
      final repository = MarineForecastRepository(
        loader: (uri) async => {
          'current': {'wave_height': 0.4},
        },
      );

      expect(() => repository.load(diveSites.first), throwsFormatException);
    });
  });

  group('다이빙 적합도', () {
    MarineCondition condition({required double wave, required double water}) =>
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
  });
}
