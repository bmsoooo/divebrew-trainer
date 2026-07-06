// 웹 링크 열기 — 새 탭으로 오픈 (noopener 보안 옵션)
import 'package:web/web.dart' as web;

void platformOpenLink(String url) {
  web.window.open(url, '_blank', 'noopener');
}
