// 웹 이미지 선택 — <input type=file accept=image/*> + FileReader로 바이트 읽기
import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<Uint8List?> platformPickImageBytes() async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = 'image/*';

  final completer = Completer<Uint8List?>();
  input.onchange = ((web.Event _) {
    final file = input.files?.item(0);
    if (file == null) {
      completer.complete(null);
      return;
    }
    final reader = web.FileReader();
    reader.onload = ((web.Event _) {
      final buffer = reader.result as JSArrayBuffer?;
      completer.complete(buffer?.toDart.asUint8List());
    }).toJS;
    reader.onerror = ((web.Event _) => completer.complete(null)).toJS;
    reader.readAsArrayBuffer(file);
  }).toJS;
  input.click();
  return completer.future;
}
