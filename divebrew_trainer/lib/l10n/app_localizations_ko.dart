// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'divebrew trainer';

  @override
  String get homeQuickStart => '빠른 시작';

  @override
  String get homeTables => '훈련 테이블';

  @override
  String get tableListTitle => '훈련 테이블';

  @override
  String get tableListNewCustom => '커스텀 테이블 만들기';

  @override
  String get tableTypeCo2 => 'CO2';

  @override
  String get tableTypeO2 => 'O2';

  @override
  String get tableTypeStatic => '스태틱';

  @override
  String get tableTypeCustom => '커스텀';

  @override
  String get tableEditTitleNew => '새 커스텀 테이블';

  @override
  String get tableEditTitleEdit => '테이블 편집';

  @override
  String get tableEditName => '테이블 이름';

  @override
  String get tableEditNameHint => '예: 내 CO2 테이블';

  @override
  String tableEditRound(int number) {
    return '라운드 $number';
  }

  @override
  String get tableEditBreathSec => '준비 호흡(초)';

  @override
  String get tableEditHoldSec => '숨참기(초)';

  @override
  String get tableEditAddRound => '라운드 추가';

  @override
  String get tableEditRemoveRound => '라운드 삭제';

  @override
  String get tableEditSave => '저장';

  @override
  String tableEditTotalDuration(String duration) {
    return '총 훈련 시간: $duration';
  }

  @override
  String get tableEditNeedName => '테이블 이름을 입력해주세요';

  @override
  String get tableEditNeedRound => '라운드를 1개 이상 추가해주세요';

  @override
  String tableRoundsSummary(int count, String duration) {
    return '$count라운드 · $duration';
  }
}
