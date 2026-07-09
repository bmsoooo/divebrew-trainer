// 개인정보처리방침·이용약관 본문 페이지 — 조(條) 제목을 구분 렌더링해 긴 법률 문서 가독성 확보
import 'package:flutter/material.dart';

import '../../app/theme.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final String body;

  const LegalPage({super.key, required this.title, required this.body});

  /// 조 제목·부칙·요약 라인 여부 — 해당 줄은 볼드 + 위 여백으로 렌더링.
  static final _headingPattern =
      RegExp(r'^(제\d+조|Article \d+|부칙|Addendum|핵심 요약|Summary)');

  @override
  Widget build(BuildContext context) {
    final paragraphs = body.split('\n\n');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            for (final paragraph in paragraphs) ...[
              if (_headingPattern.hasMatch(paragraph)) ...[
                // 문단 첫 줄(제목)과 나머지(본문)를 분리.
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 6),
                  child: Text(
                    paragraph.split('\n').first,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: foam,
                    ),
                  ),
                ),
                if (paragraph.contains('\n'))
                  Text(
                    paragraph.split('\n').skip(1).join('\n'),
                    style: const TextStyle(
                        fontSize: 14.5, color: foam, height: 1.7),
                  ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    paragraph,
                    style: const TextStyle(
                        fontSize: 14.5, color: foam, height: 1.7),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
