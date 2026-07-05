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

  @override
  String sessionRoundProgress(int current, int total) {
    return '라운드 $current/$total';
  }

  @override
  String get sessionPhasePreparing => '준비 호흡';

  @override
  String get sessionPhaseHolding => '숨참기';

  @override
  String get sessionContractionTap => '컨트랙션';

  @override
  String get sessionEndHoldEarly => '숨 쉬었어요';

  @override
  String get sessionStop => '중단';

  @override
  String get sessionFinished => '세션 완료!';

  @override
  String get sessionStopped => '세션을 중단했어요';

  @override
  String sessionResultRound(int number, int holdSec) {
    return '라운드 $number: $holdSec초';
  }

  @override
  String sessionResultContractions(int count) {
    return '컨트랙션 $count회';
  }

  @override
  String get sessionBackHome => '홈으로';

  @override
  String get sessionStart => '세션 시작';

  @override
  String get voiceHoldStart => '숨을 참으세요';

  @override
  String get voiceBreathe => '숨을 쉬세요';

  @override
  String get voiceSessionFinished => '세션 완료. 수고했어요';

  @override
  String get onboardingTitle => '시작하기 전에,\n저와 약속 하나만 해요';

  @override
  String get onboardingIntro => '저도 매번 지키는 네 가지예요. 함께 지켜야 훈련을 시작할 수 있어요.';

  @override
  String get onboardingDryOnly => '물 밖에서만 훈련할게요';

  @override
  String get onboardingDryOnlyDetail =>
      '이 앱은 드라이(물 밖) 전용이에요. 저도 물속 연습은 꼭 교육받고 버디와 함께해요.';

  @override
  String get onboardingNoHyperventilation => '몰아쉬기(과호흡)는 하지 않을게요';

  @override
  String get onboardingNoHyperventilationDetail =>
      '저도 급하게 몰아쉬던 시절이 있었는데, 편안한 호흡이 더 오래 더 안전하게 가더라고요.';

  @override
  String get onboardingSeatedOnLand => '앉거나 누워서, 땅 위에서만 할게요';

  @override
  String get onboardingSeatedOnLandDetail =>
      '저도 항상 소파에 앉아서 해요. 서서 하다 어지러우면 크게 다칠 수 있거든요.';

  @override
  String get onboardingStopWhenDizzy => '조금이라도 어지러우면 바로 멈출게요';

  @override
  String get onboardingStopWhenDizzyDetail =>
      '기록보다 몸이 먼저예요. 저도 이상하다 싶으면 그날 훈련은 접어요.';

  @override
  String get onboardingAgreeButton => '네, 약속할게요';

  @override
  String get safetyReminder1 => '오늘도 앉아서, 물 밖에서 해요. 저도 소파에서 하고 있어요.';

  @override
  String get safetyReminder2 => '시작 전 몰아쉬기 금지예요. 편안한 호흡 몇 번이면 충분해요.';

  @override
  String get safetyReminder3 => '어지러우면 바로 중단 버튼이에요. 기록은 다음에 또 세우면 돼요.';

  @override
  String get safetyReminder4 => '숨참기는 절대 물속에서 연습하지 않아요. 저도 바다는 버디랑만 가요.';

  @override
  String get historyTitle => '기록';

  @override
  String get historyEmpty => '아직 기록이 없어요.\n첫 세션을 마치면 여기에 쌓여요.';

  @override
  String historyMaxHold(int sec) {
    return '최고 $sec초';
  }

  @override
  String historyRounds(int done, int total) {
    return '$done/$total라운드';
  }

  @override
  String get historyStoppedBadge => '중단';

  @override
  String get historyPbChartTitle => '세션별 최고 홀드 추이';

  @override
  String get homeHistory => '기록 보기';
}
