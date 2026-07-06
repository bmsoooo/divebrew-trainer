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

  @override
  String get backupExport => '기록 내보내기';

  @override
  String get backupImport => '기록 가져오기';

  @override
  String get backupImportDone => '기록을 가져왔어요';

  @override
  String get backupImportFailed => '백업 파일을 읽지 못했어요. 파일을 확인해주세요';

  @override
  String get tableDetailStart => '시작하기';

  @override
  String get sessionPause => '일시정지';

  @override
  String get sessionResume => '재개';

  @override
  String get sessionPausedLabel => '일시정지됨';

  @override
  String get homeGreeting => '안녕하세요, 오늘도\n천천히 내려가볼까요';

  @override
  String get homePbLabel => '최고 기록 · PB';

  @override
  String homePbDate(String date) {
    return '$date 기록';
  }

  @override
  String get homePbEmpty => '아직 기록이 없어요';

  @override
  String get homeSuggestionLabel => '오늘의 훈련 제안';

  @override
  String get homeSuggestionFirst => '처음이시죠? CO2 입문 테이블로 가볍게 시작해볼까요';

  @override
  String homeSuggestionAlternate(String type, String suggested) {
    return '지난번엔 $type 테이블이었으니, 이번엔 $suggested 테이블로 균형을 맞춰봐요';
  }

  @override
  String get homeSuggestionDetail => '자세히 보기 →';

  @override
  String get homeCta => '오늘의 훈련 보러가기';

  @override
  String get tabHome => '홈';

  @override
  String get tabTables => '테이블';

  @override
  String get tabHistory => '히스토리';

  @override
  String get tableListIntro => 'CO2 테이블은 회복호흡을 줄이고, O2 테이블은 숨참기를 늘려요';

  @override
  String get tableListSectionCo2 => 'CO2 테이블';

  @override
  String get tableListSectionO2 => 'O2 테이블';

  @override
  String get tableListSectionCustom => '커스텀';

  @override
  String get tableListCreateCustom => '+ 나만의 테이블 만들기';

  @override
  String tableListMinutes(int min) {
    return '$min분';
  }

  @override
  String get detailBack => '← 테이블';

  @override
  String get detailProfileLabel => '다이브 프로파일';

  @override
  String get detailStatTotal => '총 훈련 시간';

  @override
  String get detailStatRounds => '라운드';

  @override
  String detailStatRoundsValue(int count) {
    return '$count개';
  }

  @override
  String detailColRound(int n) {
    return '라운드 $n';
  }

  @override
  String detailColHold(String time) {
    return '숨참기 $time';
  }

  @override
  String detailColBreath(String time) {
    return '호흡 $time';
  }

  @override
  String get sessionExit => '✕ 중단';

  @override
  String sessionHeader(String table, int n, int total) {
    return '$table · 라운드 $n/$total';
  }

  @override
  String get sessionPhaseRecovery => '회복호흡';

  @override
  String get sessionContractionCount => '컨트랙션 탭';

  @override
  String get sessionStartRecovery => '회복호흡 시작';

  @override
  String get historyStatSessions => '총 세션';

  @override
  String historyStatSessionsValue(int count) {
    return '$count회';
  }

  @override
  String get historyStatPb => '최고 기록';

  @override
  String get historyStatWeek => '이번주';

  @override
  String historyStatWeekValue(int days) {
    return '$days일';
  }

  @override
  String get historyPbTrend => 'PB 추이';

  @override
  String get tabSettings => '설정';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsInstagram => '인스타그램';

  @override
  String get settingsInstagramHandle => '@divebrew.soo';

  @override
  String get settingsDataSection => '데이터 관리';

  @override
  String get settingsICloud => 'iCloud 동기화';

  @override
  String get settingsICloudStatus => '이 기기에만 저장';

  @override
  String get settingsRestoreDefaults => '기본 루틴 복원';

  @override
  String get settingsRestoreDefaultsConfirm =>
      '기본 CO2/O2 루틴을 처음 상태로 되돌릴까요? 직접 만든 커스텀 테이블은 그대로 남아요.';

  @override
  String get settingsRestoreDefaultsDone => '기본 루틴을 복원했어요';

  @override
  String get settingsClearHistory => '훈련 기록 전체 삭제';

  @override
  String get settingsClearHistoryConfirm =>
      '지금까지의 훈련 기록과 최고 기록이 모두 지워져요. 테이블은 그대로 남아요. 되돌릴 수 없어요.';

  @override
  String get settingsClearHistoryDone => '훈련 기록을 삭제했어요';

  @override
  String get settingsResetAll => '루틴 + 기록 초기화';

  @override
  String get settingsResetAllConfirm =>
      '테이블과 훈련 기록을 모두 지우고 기본 상태로 되돌려요. 되돌릴 수 없어요.';

  @override
  String get settingsResetAllDone => '모두 초기화했어요';

  @override
  String get settingsInfoSection => '앱 정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsContact => '문의';

  @override
  String get settingsPrivacy => '개인정보처리방침';

  @override
  String get settingsTerms => '이용약관';

  @override
  String get settingsLicenses => '오픈소스 라이선스';

  @override
  String get commonCancel => '취소';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonRestore => '복원';

  @override
  String get privacyBody =>
      '다이브로 트레이너는 훈련 기록을 이 기기 안에만 저장해요. 계정도, 서버도 없어요.\n\n심박·수심 같은 건강 데이터는 이 웹 버전에서 수집하지 않아요. 훈련 시간과 컨트랙션 기록은 브라우저 로컬 저장소(IndexedDB)에만 남고, 브라우저 데이터를 지우면 함께 사라져요. 기록을 지키고 싶으면 설정이 아닌 히스토리 화면에서 JSON으로 내보내 두세요.\n\n제3자에게 어떤 데이터도 전송하지 않아요.';

  @override
  String get termsBody =>
      '다이브로 트레이너는 프리다이빙 스태틱(숨참기)을 물 밖(드라이)에서 연습하기 위한 훈련 보조 도구예요.\n\n이 앱은 의료 기기가 아니고, 안전을 보장하지 않아요. 숨참기 훈련에는 블랙아웃 위험이 있어요. 저도 항상 앉아서, 물 밖에서, 무리하지 않고 해요. 어지럽거나 이상하면 바로 멈춰주세요.\n\n물속·욕조에서는 절대 사용하지 마세요. 이 앱을 사용해 발생한 결과에 대한 책임은 사용자 본인에게 있어요.';

  @override
  String get tabGuideEntry => '초보자 가이드';

  @override
  String get guideTitle => '훈련 가이드';

  @override
  String get homeGuideCard => '프리다이빙 스태틱이 처음이라면';

  @override
  String get homeGuideCardSub => 'CO2·O2 테이블이 뭔지, 왜 숨참기가 느는지 3분이면 이해돼요';

  @override
  String get settingsGuide => '훈련 가이드';

  @override
  String get guideIntroTitle => '스태틱 훈련이 뭐예요?';

  @override
  String get guideIntroBody =>
      '스태틱(STA)은 움직이지 않고 숨을 참는 프리다이빙 종목이에요. 이 앱은 물 밖에서(드라이) 편하게 앉아 숨참기를 연습하는 훈련 도구예요.\n\n숨을 참다 보면 답답한 느낌과 함께 배가 꿀렁이는 횡격막 수축이 와요. 이건 산소가 바닥나서가 아니라, 몸에 이산화탄소(CO2)가 쌓이면서 \'숨 쉬어!\' 하고 보내는 신호예요. 훈련은 이 신호를 견디고 몸을 이완하는 연습이에요.\n\n저도 왕초보 때는 1분도 버거웠어요. 매일 조금씩, 무리하지 않고 쌓으면 늘어요.';

  @override
  String get guideCo2Title => 'CO2 테이블이란?';

  @override
  String get guideCo2Body =>
      '숨참기 시간은 그대로 두고, 사이사이 회복 호흡 시간을 점점 줄여가는 훈련이에요.\n\n회복이 짧아질수록 몸에 CO2가 덜 빠진 채로 다음 숨참기에 들어가요. 그래서 \'숨 쉬고 싶은 충동\'을 점점 더 일찍, 더 세게 느끼게 되고, 이걸 반복하면 그 답답함에 대한 내성이 길러져요.\n\n한마디로 \'답답함을 견디는 힘\'을 키우는 훈련이에요. 초반에 충동이 빨리 오는 분에게 특히 좋아요.';

  @override
  String get guideO2Title => 'O2 테이블이란?';

  @override
  String get guideO2Body =>
      '회복 호흡은 넉넉하게 고정하고, 숨참기 시간을 라운드마다 점점 늘려가는 훈련이에요.\n\n충분히 회복한 상태에서 점점 더 오래 참기 때문에, 몸이 낮은 산소 농도에 적응해가요. 실제로 오래 참는 능력 자체를 넓히는 훈련이에요.\n\n보통 CO2 테이블로 충동 내성을 먼저 기른 뒤, O2 테이블로 최대 시간을 늘려가요. 회복이 넉넉해서 CO2 테이블보다 덜 답답해요.';

  @override
  String get guideWhyTitle => '왜 훈련하면 숨참기가 늘어요?';

  @override
  String get guideWhyBody =>
      '세 가지가 함께 작용해요.\n\n1. CO2 내성 — 숨 쉬고 싶은 충동은 대부분 CO2 때문이에요. 훈련으로 이 충동을 견디는 여유가 생기면, 예전 같으면 포기했을 지점을 지나갈 수 있어요.\n\n2. 이완 — 긴장하면 산소를 더 빨리 써요. 몸에 힘 빼는 법을 익히면 같은 산소로 더 오래 버텨요. \'힘을 빼야 뜬다\'는 말이 여기에도 통해요.\n\n3. 저산소 적응 — O2 훈련으로 몸이 낮은 산소에 조금씩 익숙해져요.\n\n폐를 크게 만드는 게 아니라, 몸과 마음이 \'적응\'하는 거예요. 그래서 꾸준함이 재능을 이겨요.';

  @override
  String get guideSafetyTitle => '딱 하나, 꼭 기억해요';

  @override
  String get guideSafetyBody =>
      '빠르게 몰아쉬는 과호흡은 절대 하지 마세요. 과호흡은 CO2를 억지로 날려서 충동을 늦출 뿐, 산소를 늘려주지 않아요. 그래서 \'괜찮은 줄 알았는데 갑자기 정신을 잃는\' 블랙아웃 위험이 커져요.\n\n저는 항상 편안한 호흡 몇 번만 하고, 앉아서, 물 밖에서, 어지러우면 바로 멈춰요. 기록보다 안전이 먼저예요.';

  @override
  String get homeStaticSection => '단발 스테틱';

  @override
  String get homeStaticTitle => '스테틱 한 번 해볼까요';

  @override
  String get homeStaticSubtitle => '오늘도 나의 PB를 갱신해보세요';

  @override
  String get homeBrowseTables => '훈련 테이블 둘러보기';

  @override
  String get countdownReady => '준비하세요';

  @override
  String get staticDone => '완료';

  @override
  String get staticResultLabel => '이번 기록';

  @override
  String get staticNewPb => '새 최고 기록을 세웠어요';

  @override
  String staticPrevPb(String time) {
    return '이전 최고 $time';
  }

  @override
  String get licenseTitle => '내 자격증';

  @override
  String get licenseHomeTooltip => '내 자격증';

  @override
  String get licenseEmptyTitle => '자격증 사진을 올려두세요';

  @override
  String get licenseEmptyBody =>
      '다이빙 센터나 버디에게 자격증을 바로 보여줄 수 있어요. 사진은 이 기기에만 저장돼요.';

  @override
  String get licenseUpload => '사진 올리기';

  @override
  String get licenseReplace => '사진 교체';

  @override
  String get licenseDelete => '삭제';

  @override
  String get licenseDeleteConfirm => '저장된 자격증 사진을 삭제할까요?';

  @override
  String get licenseSaved => '자격증 사진을 저장했어요';

  @override
  String get licenseDeleted => '자격증 사진을 삭제했어요';

  @override
  String get staticDetailBody =>
      '단발 스테틱은 라운드 없이 한 번의 숨참기로 내 최고 기록에 도전하는 훈련이에요.\n\n시작하면 3·2·1 카운트다운 뒤 1분 동안 편안하게 준비 호흡을 하고, 그다음 숨참기가 시작돼요. 준비가 되면 바로 참기 시작을 눌러도 돼요.';

  @override
  String get staticPrepInfo => '준비 호흡 1분 뒤 숨참기가 시작돼요';

  @override
  String get staticPrepLabel => '준비 호흡';

  @override
  String get staticStartHoldNow => '지금 참기 시작';
}
