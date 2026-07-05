// 텍스트 파일 저장/열기 추상화 — 웹: 다운로드/파일 선택, 비웹: no-op (M3에서 교체)
import 'file_transfer_stub.dart'
    if (dart.library.js_interop) 'file_transfer_web.dart';

/// [text]를 [filename]으로 저장(다운로드)한다.
Future<void> saveTextFile(String filename, String text) =>
    platformSaveTextFile(filename, text);

/// 텍스트 파일을 선택해 내용을 반환한다. 취소하면 null.
Future<String?> pickTextFile() => platformPickTextFile();
