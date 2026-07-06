// 개인정보처리방침·이용약관 본문 페이지 — 정적 텍스트, 뒤로가기로 복귀
import 'package:flutter/material.dart';

import '../../app/theme.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final String body;

  const LegalPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              body,
              style: const TextStyle(fontSize: 15, color: foam, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
