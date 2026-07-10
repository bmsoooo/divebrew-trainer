// 비웹 환경에서 해양 예보 요청이 지원되지 않음을 알리는 대체 구현
Future<Map<String, dynamic>> loadMarineForecast(Uri uri) =>
    throw UnsupportedError('Marine forecasts are available on the web only.');
