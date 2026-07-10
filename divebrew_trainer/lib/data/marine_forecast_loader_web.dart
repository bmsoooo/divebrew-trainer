// Open-Meteo Marine API의 JSON 응답을 브라우저 fetch로 가져오는 웹 구현
import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<Map<String, dynamic>> loadMarineForecast(Uri uri) async {
  final response = await web.window.fetch(uri.toString().toJS).toDart;
  if (!response.ok) {
    throw StateError('Marine forecast request failed: ${response.status}');
  }

  final body = (await response.text().toDart).toDart;
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Marine forecast response is not an object.');
  }
  return decoded;
}
