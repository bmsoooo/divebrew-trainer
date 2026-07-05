// 비웹 플랫폼용 파일 저장/열기 스텁 — M3(iOS)에서 share/document picker로 교체
Future<void> platformSaveTextFile(String filename, String text) async {}

Future<String?> platformPickTextFile() async => null;
