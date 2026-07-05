// 웹 파일 저장/열기 — Blob 다운로드 + <input type=file> 선택
import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<void> platformSaveTextFile(String filename, String text) async {
  final blob = web.Blob(
    [text.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  web.URL.revokeObjectURL(url);
}

Future<String?> platformPickTextFile() async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = '.json,application/json';

  final completer = Completer<String?>();
  input.onchange = ((web.Event _) {
    final file = input.files?.item(0);
    if (file == null) {
      completer.complete(null);
      return;
    }
    final reader = web.FileReader();
    reader.onload = ((web.Event _) {
      completer.complete((reader.result as JSString?)?.toDart);
    }).toJS;
    reader.onerror = ((web.Event _) {
      completer.complete(null);
    }).toJS;
    reader.readAsText(file);
  }).toJS;
  input.click();
  return completer.future;
}
