// 해양 예보 요청을 웹과 비웹 구현으로 분기하는 진입점
export 'marine_forecast_loader_stub.dart'
    if (dart.library.js_interop) 'marine_forecast_loader_web.dart';
