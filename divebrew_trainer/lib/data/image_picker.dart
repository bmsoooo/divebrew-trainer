// 이미지 파일 선택 추상화 — 웹: <input type=file> + FileReader, 비웹: no-op (M3에서 교체)
import 'dart:typed_data';

import 'image_picker_stub.dart'
    if (dart.library.js_interop) 'image_picker_web.dart';

/// 이미지 파일을 선택해 바이트로 반환한다. 취소하면 null.
Future<Uint8List?> pickImageBytes() => platformPickImageBytes();
