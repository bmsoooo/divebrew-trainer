// DiveBrew 디자인 시스템 테마 — Deep Ocean/Espresso/Snorkel Yellow 3색, Pretendard, 무그라데이션·절제된 모션
import 'package:flutter/material.dart';

/// 브랜드 3색 (Design System.md — 이 3색 외 추가 금지, 악센트는 옐로 하나만).
const deepOcean = Color(0xFF0A2342);
const espresso = Color(0xFF3C2A21);
const snorkelYellow = Color(0xFFFFC300);

/// Deep Ocean 위 텍스트용 밝은 톤.
const _foam = Color(0xFFF2F6FA);
const _oceanSurface = Color(0xFF12325C); // 카드 등 한 단계 밝은 오션 필드
const _oceanBorder = Color(0xFF1E4275);

ThemeData buildDivebrewTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: snorkelYellow,
    onPrimary: deepOcean,
    secondary: espresso,
    onSecondary: _foam,
    surface: deepOcean,
    onSurface: _foam,
    surfaceContainerHighest: _oceanSurface,
    error: Color(0xFFFF6B6B),
    onError: deepOcean,
    outline: _oceanBorder,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: deepOcean,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: deepOcean,
      foregroundColor: _foam,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: _foam,
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: _oceanSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: snorkelYellow,
        foregroundColor: deepOcean,
        textStyle: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(64, 52),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _foam,
        side: const BorderSide(color: _oceanBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(64, 52),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: snorkelYellow),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: snorkelYellow,
      foregroundColor: deepOcean,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: _foam,
      iconColor: _foam,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _oceanSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _oceanBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _oceanBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: snorkelYellow, width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFFB8C7D9)),
      hintStyle: const TextStyle(color: Color(0xFF6E8299)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _oceanSurface,
      contentTextStyle: TextStyle(fontFamily: 'Pretendard', color: _foam),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? snorkelYellow
            : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(deepOcean),
      side: const BorderSide(color: _oceanBorder, width: 2),
    ),
    dividerTheme: const DividerThemeData(color: _oceanBorder),
  );
}
