// 비웹 환경에서 KHOA API가 지원되지 않음을 알리는 대체 구현
import 'marine_conditions.dart';

class KhoaMarineApi {
  Future<MarineCondition?> fetchSkinScubaIndex(String placeCode) async => null;
  Future<TideForecastResult?> fetchTideForecast(String obsCode) async => null;
}
