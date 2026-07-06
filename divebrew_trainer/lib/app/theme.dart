// DiveBrew 디자인 시스템 테마 — 수심 팔레트(Abyss~Foam)+Snorkel Yellow, Pretendard, 무그라데이션·절제된 모션
import 'package:flutter/material.dart';

/// 브랜드 3색 (Design System.md — 이 3색 외 발명 금지, 악센트는 옐로 하나만).
const deepOcean = Color(0xFF0A2342);
const espresso = Color(0xFF3C2A21);
const snorkelYellow = Color(0xFFFFC300);

/// 앱 전용 수심 팔레트 (디자인 핸드오프 "depth staging").
const abyss = Color(0xFF061527); // 세션 실행 배경·중첩 타일 (가장 깊음)
const midWater = Color(0xFF12325C); // 테이블 상세 배경·카드 서피스
const mist = Color(0xFFB8C7D9); // 보조 텍스트·디바이더
const foam = Color(0xFFF2F6FA); // 본문 텍스트
const yellowInk = Color(0xFF2A1D00); // 옐로 위 텍스트

/// Deep Ocean 위 카드 한 단계 밝은 서피스.
const oceanRaised = Color(0xFF12325C);
const oceanBorder = Color(0xFF1E4275);

/// 탭바·화면 전환 애니메이션 (브랜드: ease-out, 바운스 금지).
const depthTransition = Duration(milliseconds: 480);

ThemeData buildDivebrewTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: snorkelYellow,
    onPrimary: yellowInk,
    secondary: espresso,
    onSecondary: foam,
    surface: deepOcean,
    onSurface: foam,
    surfaceContainerHighest: oceanRaised,
    error: Color(0xFFFF6B6B),
    onError: deepOcean,
    outline: oceanBorder,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: deepOcean,
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      // Display: 타이머·PB 숫자 전용 — tabular figures로 카운트다운 떨림 방지.
      displayLarge: const TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w800,
        fontSize: 88,
        height: 1.0,
        letterSpacing: -1.5,
        color: foam,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      displayMedium: const TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w800,
        fontSize: 40,
        height: 1.1,
        letterSpacing: -0.5,
        color: foam,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: foam,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: foam,
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: oceanRaised,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: snorkelYellow,
        foregroundColor: yellowInk,
        textStyle: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        shape: const StadiumBorder(),
        minimumSize: const Size(64, 52),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foam,
        side: const BorderSide(color: oceanBorder),
        shape: const StadiumBorder(),
        minimumSize: const Size(64, 52),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: snorkelYellow),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: snorkelYellow,
      foregroundColor: yellowInk,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: foam,
      iconColor: foam,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: oceanRaised,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: oceanBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: oceanBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: snorkelYellow, width: 2),
      ),
      labelStyle: const TextStyle(color: mist),
      hintStyle: const TextStyle(color: Color(0xFF6E8299)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: oceanRaised,
      contentTextStyle: TextStyle(fontFamily: 'Pretendard', color: foam),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? snorkelYellow
            : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(yellowInk),
      side: const BorderSide(color: oceanBorder, width: 2),
    ),
    dividerTheme: const DividerThemeData(color: oceanBorder),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: abyss,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.04 * 12,
          color: states.contains(WidgetState.selected) ? snorkelYellow : mist,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? snorkelYellow : mist,
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        foregroundColor: mist,
        selectedForegroundColor: yellowInk,
        selectedBackgroundColor: snorkelYellow,
        side: const BorderSide(color: oceanBorder),
      ),
    ),
  );
}

/// 섹션 라벨(Utility 역할) 공용 스타일 — 12px SemiBold, 자간 넓게.
const utilityLabelStyle = TextStyle(
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  fontSize: 12,
  letterSpacing: 0.6,
  color: mist,
);
