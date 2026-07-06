// 외부 링크 열기 추상화 — 웹: 새 탭, 비웹: no-op (M3에서 url_launcher로 교체)
import 'link_launcher_stub.dart'
    if (dart.library.js_interop) 'link_launcher_web.dart';

/// [url]을 외부 브라우저/탭에서 연다.
void openExternalLink(String url) => platformOpenLink(url);
