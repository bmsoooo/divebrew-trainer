import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'divebrew trainer'**
  String get appTitle;

  /// No description provided for @homeQuickStart.
  ///
  /// In ko, this message translates to:
  /// **'빠른 시작'**
  String get homeQuickStart;

  /// No description provided for @homeTables.
  ///
  /// In ko, this message translates to:
  /// **'훈련 테이블'**
  String get homeTables;

  /// No description provided for @tableListTitle.
  ///
  /// In ko, this message translates to:
  /// **'훈련 테이블'**
  String get tableListTitle;

  /// No description provided for @tableListNewCustom.
  ///
  /// In ko, this message translates to:
  /// **'커스텀 테이블 만들기'**
  String get tableListNewCustom;

  /// No description provided for @tableTypeCo2.
  ///
  /// In ko, this message translates to:
  /// **'CO2'**
  String get tableTypeCo2;

  /// No description provided for @tableTypeO2.
  ///
  /// In ko, this message translates to:
  /// **'O2'**
  String get tableTypeO2;

  /// No description provided for @tableTypeStatic.
  ///
  /// In ko, this message translates to:
  /// **'스태틱'**
  String get tableTypeStatic;

  /// No description provided for @tableTypeCustom.
  ///
  /// In ko, this message translates to:
  /// **'커스텀'**
  String get tableTypeCustom;

  /// No description provided for @tableEditTitleNew.
  ///
  /// In ko, this message translates to:
  /// **'새 커스텀 테이블'**
  String get tableEditTitleNew;

  /// No description provided for @tableEditTitleEdit.
  ///
  /// In ko, this message translates to:
  /// **'테이블 편집'**
  String get tableEditTitleEdit;

  /// No description provided for @tableEditName.
  ///
  /// In ko, this message translates to:
  /// **'테이블 이름'**
  String get tableEditName;

  /// No description provided for @tableEditNameHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 내 CO2 테이블'**
  String get tableEditNameHint;

  /// No description provided for @tableEditRound.
  ///
  /// In ko, this message translates to:
  /// **'라운드 {number}'**
  String tableEditRound(int number);

  /// No description provided for @tableEditBreathSec.
  ///
  /// In ko, this message translates to:
  /// **'준비 호흡(초)'**
  String get tableEditBreathSec;

  /// No description provided for @tableEditHoldSec.
  ///
  /// In ko, this message translates to:
  /// **'숨참기(초)'**
  String get tableEditHoldSec;

  /// No description provided for @tableEditAddRound.
  ///
  /// In ko, this message translates to:
  /// **'라운드 추가'**
  String get tableEditAddRound;

  /// No description provided for @tableEditRemoveRound.
  ///
  /// In ko, this message translates to:
  /// **'라운드 삭제'**
  String get tableEditRemoveRound;

  /// No description provided for @tableEditSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get tableEditSave;

  /// No description provided for @tableEditTotalDuration.
  ///
  /// In ko, this message translates to:
  /// **'총 훈련 시간: {duration}'**
  String tableEditTotalDuration(String duration);

  /// No description provided for @tableEditNeedName.
  ///
  /// In ko, this message translates to:
  /// **'테이블 이름을 입력해주세요'**
  String get tableEditNeedName;

  /// No description provided for @tableEditNeedRound.
  ///
  /// In ko, this message translates to:
  /// **'라운드를 1개 이상 추가해주세요'**
  String get tableEditNeedRound;

  /// No description provided for @tableRoundsSummary.
  ///
  /// In ko, this message translates to:
  /// **'{count}라운드 · {duration}'**
  String tableRoundsSummary(int count, String duration);

  /// No description provided for @sessionRoundProgress.
  ///
  /// In ko, this message translates to:
  /// **'라운드 {current}/{total}'**
  String sessionRoundProgress(int current, int total);

  /// No description provided for @sessionPhasePreparing.
  ///
  /// In ko, this message translates to:
  /// **'준비 호흡'**
  String get sessionPhasePreparing;

  /// No description provided for @sessionPhaseHolding.
  ///
  /// In ko, this message translates to:
  /// **'숨참기'**
  String get sessionPhaseHolding;

  /// No description provided for @sessionContractionTap.
  ///
  /// In ko, this message translates to:
  /// **'컨트랙션'**
  String get sessionContractionTap;

  /// No description provided for @sessionEndHoldEarly.
  ///
  /// In ko, this message translates to:
  /// **'숨 쉬었어요'**
  String get sessionEndHoldEarly;

  /// No description provided for @sessionStop.
  ///
  /// In ko, this message translates to:
  /// **'중단'**
  String get sessionStop;

  /// No description provided for @sessionFinished.
  ///
  /// In ko, this message translates to:
  /// **'세션 완료!'**
  String get sessionFinished;

  /// No description provided for @sessionStopped.
  ///
  /// In ko, this message translates to:
  /// **'세션을 중단했어요'**
  String get sessionStopped;

  /// No description provided for @sessionResultRound.
  ///
  /// In ko, this message translates to:
  /// **'라운드 {number}: {holdSec}초'**
  String sessionResultRound(int number, int holdSec);

  /// No description provided for @sessionResultContractions.
  ///
  /// In ko, this message translates to:
  /// **'컨트랙션 {count}회'**
  String sessionResultContractions(int count);

  /// No description provided for @sessionBackHome.
  ///
  /// In ko, this message translates to:
  /// **'홈으로'**
  String get sessionBackHome;

  /// No description provided for @sessionStart.
  ///
  /// In ko, this message translates to:
  /// **'세션 시작'**
  String get sessionStart;

  /// No description provided for @voiceHoldStart.
  ///
  /// In ko, this message translates to:
  /// **'숨을 참으세요'**
  String get voiceHoldStart;

  /// No description provided for @voiceBreathe.
  ///
  /// In ko, this message translates to:
  /// **'숨을 쉬세요'**
  String get voiceBreathe;

  /// No description provided for @voiceSessionFinished.
  ///
  /// In ko, this message translates to:
  /// **'세션 완료. 수고했어요'**
  String get voiceSessionFinished;

  /// No description provided for @onboardingTitle.
  ///
  /// In ko, this message translates to:
  /// **'시작하기 전에,\n저와 약속 하나만 해요'**
  String get onboardingTitle;

  /// No description provided for @onboardingIntro.
  ///
  /// In ko, this message translates to:
  /// **'저도 매번 지키는 네 가지예요. 함께 지켜야 훈련을 시작할 수 있어요.'**
  String get onboardingIntro;

  /// No description provided for @onboardingDryOnly.
  ///
  /// In ko, this message translates to:
  /// **'물 밖에서만 훈련할게요'**
  String get onboardingDryOnly;

  /// No description provided for @onboardingDryOnlyDetail.
  ///
  /// In ko, this message translates to:
  /// **'이 앱은 드라이(물 밖) 전용이에요. 저도 물속 연습은 꼭 교육받고 버디와 함께해요.'**
  String get onboardingDryOnlyDetail;

  /// No description provided for @onboardingNoHyperventilation.
  ///
  /// In ko, this message translates to:
  /// **'몰아쉬기(과호흡)는 하지 않을게요'**
  String get onboardingNoHyperventilation;

  /// No description provided for @onboardingNoHyperventilationDetail.
  ///
  /// In ko, this message translates to:
  /// **'저도 급하게 몰아쉬던 시절이 있었는데, 편안한 호흡이 더 오래 더 안전하게 가더라고요.'**
  String get onboardingNoHyperventilationDetail;

  /// No description provided for @onboardingSeatedOnLand.
  ///
  /// In ko, this message translates to:
  /// **'앉거나 누워서, 땅 위에서만 할게요'**
  String get onboardingSeatedOnLand;

  /// No description provided for @onboardingSeatedOnLandDetail.
  ///
  /// In ko, this message translates to:
  /// **'저도 항상 소파에 앉아서 해요. 서서 하다 어지러우면 크게 다칠 수 있거든요.'**
  String get onboardingSeatedOnLandDetail;

  /// No description provided for @onboardingStopWhenDizzy.
  ///
  /// In ko, this message translates to:
  /// **'조금이라도 어지러우면 바로 멈출게요'**
  String get onboardingStopWhenDizzy;

  /// No description provided for @onboardingStopWhenDizzyDetail.
  ///
  /// In ko, this message translates to:
  /// **'기록보다 몸이 먼저예요. 저도 이상하다 싶으면 그날 훈련은 접어요.'**
  String get onboardingStopWhenDizzyDetail;

  /// No description provided for @onboardingAgreeButton.
  ///
  /// In ko, this message translates to:
  /// **'네, 약속할게요'**
  String get onboardingAgreeButton;

  /// No description provided for @safetyReminder1.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 앉아서, 물 밖에서 해요. 저도 소파에서 하고 있어요.'**
  String get safetyReminder1;

  /// No description provided for @safetyReminder2.
  ///
  /// In ko, this message translates to:
  /// **'시작 전 몰아쉬기 금지예요. 편안한 호흡 몇 번이면 충분해요.'**
  String get safetyReminder2;

  /// No description provided for @safetyReminder3.
  ///
  /// In ko, this message translates to:
  /// **'어지러우면 바로 중단 버튼이에요. 기록은 다음에 또 세우면 돼요.'**
  String get safetyReminder3;

  /// No description provided for @safetyReminder4.
  ///
  /// In ko, this message translates to:
  /// **'숨참기는 절대 물속에서 연습하지 않아요. 저도 바다는 버디랑만 가요.'**
  String get safetyReminder4;

  /// No description provided for @historyTitle.
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아직 기록이 없어요.\n첫 세션을 마치면 여기에 쌓여요.'**
  String get historyEmpty;

  /// No description provided for @historyMaxHold.
  ///
  /// In ko, this message translates to:
  /// **'최고 {sec}초'**
  String historyMaxHold(int sec);

  /// No description provided for @historyRounds.
  ///
  /// In ko, this message translates to:
  /// **'{done}/{total}라운드'**
  String historyRounds(int done, int total);

  /// No description provided for @historyStoppedBadge.
  ///
  /// In ko, this message translates to:
  /// **'중단'**
  String get historyStoppedBadge;

  /// No description provided for @historyPbChartTitle.
  ///
  /// In ko, this message translates to:
  /// **'세션별 최고 홀드 추이'**
  String get historyPbChartTitle;

  /// No description provided for @homeHistory.
  ///
  /// In ko, this message translates to:
  /// **'기록 보기'**
  String get homeHistory;

  /// No description provided for @backupExport.
  ///
  /// In ko, this message translates to:
  /// **'기록 내보내기'**
  String get backupExport;

  /// No description provided for @backupImport.
  ///
  /// In ko, this message translates to:
  /// **'기록 가져오기'**
  String get backupImport;

  /// No description provided for @backupImportDone.
  ///
  /// In ko, this message translates to:
  /// **'기록을 가져왔어요'**
  String get backupImportDone;

  /// No description provided for @backupImportFailed.
  ///
  /// In ko, this message translates to:
  /// **'백업 파일을 읽지 못했어요. 파일을 확인해주세요'**
  String get backupImportFailed;

  /// No description provided for @tableDetailStart.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get tableDetailStart;

  /// No description provided for @sessionPause.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get sessionPause;

  /// No description provided for @sessionResume.
  ///
  /// In ko, this message translates to:
  /// **'재개'**
  String get sessionResume;

  /// No description provided for @sessionPausedLabel.
  ///
  /// In ko, this message translates to:
  /// **'일시정지됨'**
  String get sessionPausedLabel;

  /// No description provided for @homeGreeting.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요, 오늘도\n천천히 내려가볼까요'**
  String get homeGreeting;

  /// No description provided for @homePbLabel.
  ///
  /// In ko, this message translates to:
  /// **'최고 기록 · PB'**
  String get homePbLabel;

  /// No description provided for @homePbDate.
  ///
  /// In ko, this message translates to:
  /// **'{date} 기록'**
  String homePbDate(String date);

  /// No description provided for @homePbEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아직 기록이 없어요'**
  String get homePbEmpty;

  /// No description provided for @homeSuggestionLabel.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 훈련 제안'**
  String get homeSuggestionLabel;

  /// No description provided for @homeSuggestionFirst.
  ///
  /// In ko, this message translates to:
  /// **'처음이시죠? CO2 입문 테이블로 가볍게 시작해볼까요'**
  String get homeSuggestionFirst;

  /// No description provided for @homeSuggestionAlternate.
  ///
  /// In ko, this message translates to:
  /// **'지난번엔 {type} 테이블이었으니, 이번엔 {suggested} 테이블로 균형을 맞춰봐요'**
  String homeSuggestionAlternate(String type, String suggested);

  /// No description provided for @homeSuggestionDetail.
  ///
  /// In ko, this message translates to:
  /// **'자세히 보기 →'**
  String get homeSuggestionDetail;

  /// No description provided for @homeCta.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 훈련 보러가기'**
  String get homeCta;

  /// No description provided for @tabHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get tabHome;

  /// No description provided for @tabTables.
  ///
  /// In ko, this message translates to:
  /// **'테이블'**
  String get tabTables;

  /// No description provided for @tabHistory.
  ///
  /// In ko, this message translates to:
  /// **'히스토리'**
  String get tabHistory;

  /// No description provided for @tableListIntro.
  ///
  /// In ko, this message translates to:
  /// **'CO2 테이블은 회복호흡을 줄이고, O2 테이블은 숨참기를 늘려요'**
  String get tableListIntro;

  /// No description provided for @tableListSectionCo2.
  ///
  /// In ko, this message translates to:
  /// **'CO2 테이블'**
  String get tableListSectionCo2;

  /// No description provided for @tableListSectionO2.
  ///
  /// In ko, this message translates to:
  /// **'O2 테이블'**
  String get tableListSectionO2;

  /// No description provided for @tableListSectionCustom.
  ///
  /// In ko, this message translates to:
  /// **'커스텀'**
  String get tableListSectionCustom;

  /// No description provided for @tableListCreateCustom.
  ///
  /// In ko, this message translates to:
  /// **'+ 나만의 테이블 만들기'**
  String get tableListCreateCustom;

  /// No description provided for @tableListMinutes.
  ///
  /// In ko, this message translates to:
  /// **'{min}분'**
  String tableListMinutes(int min);

  /// No description provided for @detailBack.
  ///
  /// In ko, this message translates to:
  /// **'← 테이블'**
  String get detailBack;

  /// No description provided for @detailProfileLabel.
  ///
  /// In ko, this message translates to:
  /// **'다이브 프로파일'**
  String get detailProfileLabel;

  /// No description provided for @detailStatTotal.
  ///
  /// In ko, this message translates to:
  /// **'총 훈련 시간'**
  String get detailStatTotal;

  /// No description provided for @detailStatRounds.
  ///
  /// In ko, this message translates to:
  /// **'라운드'**
  String get detailStatRounds;

  /// No description provided for @detailStatRoundsValue.
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String detailStatRoundsValue(int count);

  /// No description provided for @detailColRound.
  ///
  /// In ko, this message translates to:
  /// **'라운드 {n}'**
  String detailColRound(int n);

  /// No description provided for @detailColHold.
  ///
  /// In ko, this message translates to:
  /// **'숨참기 {time}'**
  String detailColHold(String time);

  /// No description provided for @detailColBreath.
  ///
  /// In ko, this message translates to:
  /// **'호흡 {time}'**
  String detailColBreath(String time);

  /// No description provided for @sessionExit.
  ///
  /// In ko, this message translates to:
  /// **'✕ 중단'**
  String get sessionExit;

  /// No description provided for @sessionHeader.
  ///
  /// In ko, this message translates to:
  /// **'{table} · 라운드 {n}/{total}'**
  String sessionHeader(String table, int n, int total);

  /// No description provided for @sessionPhaseRecovery.
  ///
  /// In ko, this message translates to:
  /// **'회복호흡'**
  String get sessionPhaseRecovery;

  /// No description provided for @sessionContractionCount.
  ///
  /// In ko, this message translates to:
  /// **'컨트랙션 탭'**
  String get sessionContractionCount;

  /// No description provided for @sessionStartRecovery.
  ///
  /// In ko, this message translates to:
  /// **'회복호흡 시작'**
  String get sessionStartRecovery;

  /// No description provided for @historyStatSessions.
  ///
  /// In ko, this message translates to:
  /// **'총 세션'**
  String get historyStatSessions;

  /// No description provided for @historyStatSessionsValue.
  ///
  /// In ko, this message translates to:
  /// **'{count}회'**
  String historyStatSessionsValue(int count);

  /// No description provided for @historyStatPb.
  ///
  /// In ko, this message translates to:
  /// **'최고 기록'**
  String get historyStatPb;

  /// No description provided for @historyStatWeek.
  ///
  /// In ko, this message translates to:
  /// **'이번주'**
  String get historyStatWeek;

  /// No description provided for @historyStatWeekValue.
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String historyStatWeekValue(int days);

  /// No description provided for @historyPbTrend.
  ///
  /// In ko, this message translates to:
  /// **'PB 추이'**
  String get historyPbTrend;

  /// No description provided for @tabSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get tabSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @settingsInstagram.
  ///
  /// In ko, this message translates to:
  /// **'인스타그램'**
  String get settingsInstagram;

  /// No description provided for @settingsInstagramHandle.
  ///
  /// In ko, this message translates to:
  /// **'@divebrew.soo'**
  String get settingsInstagramHandle;

  /// No description provided for @settingsDataSection.
  ///
  /// In ko, this message translates to:
  /// **'데이터 관리'**
  String get settingsDataSection;

  /// No description provided for @settingsICloud.
  ///
  /// In ko, this message translates to:
  /// **'iCloud 동기화'**
  String get settingsICloud;

  /// No description provided for @settingsICloudStatus.
  ///
  /// In ko, this message translates to:
  /// **'이 기기에만 저장'**
  String get settingsICloudStatus;

  /// No description provided for @settingsRestoreDefaults.
  ///
  /// In ko, this message translates to:
  /// **'기본 루틴 복원'**
  String get settingsRestoreDefaults;

  /// No description provided for @settingsRestoreDefaultsConfirm.
  ///
  /// In ko, this message translates to:
  /// **'기본 CO2/O2 루틴을 처음 상태로 되돌릴까요? 직접 만든 커스텀 테이블은 그대로 남아요.'**
  String get settingsRestoreDefaultsConfirm;

  /// No description provided for @settingsRestoreDefaultsDone.
  ///
  /// In ko, this message translates to:
  /// **'기본 루틴을 복원했어요'**
  String get settingsRestoreDefaultsDone;

  /// No description provided for @settingsClearHistory.
  ///
  /// In ko, this message translates to:
  /// **'훈련 기록 전체 삭제'**
  String get settingsClearHistory;

  /// No description provided for @settingsClearHistoryConfirm.
  ///
  /// In ko, this message translates to:
  /// **'지금까지의 훈련 기록과 최고 기록이 모두 지워져요. 테이블은 그대로 남아요. 되돌릴 수 없어요.'**
  String get settingsClearHistoryConfirm;

  /// No description provided for @settingsClearHistoryDone.
  ///
  /// In ko, this message translates to:
  /// **'훈련 기록을 삭제했어요'**
  String get settingsClearHistoryDone;

  /// No description provided for @settingsResetAll.
  ///
  /// In ko, this message translates to:
  /// **'루틴 + 기록 초기화'**
  String get settingsResetAll;

  /// No description provided for @settingsResetAllConfirm.
  ///
  /// In ko, this message translates to:
  /// **'테이블과 훈련 기록을 모두 지우고 기본 상태로 되돌려요. 되돌릴 수 없어요.'**
  String get settingsResetAllConfirm;

  /// No description provided for @settingsResetAllDone.
  ///
  /// In ko, this message translates to:
  /// **'모두 초기화했어요'**
  String get settingsResetAllDone;

  /// No description provided for @settingsInfoSection.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get settingsInfoSection;

  /// No description provided for @settingsVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get settingsVersion;

  /// No description provided for @settingsContact.
  ///
  /// In ko, this message translates to:
  /// **'문의'**
  String get settingsContact;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get settingsTerms;

  /// No description provided for @settingsLicenses.
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스'**
  String get settingsLicenses;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @commonDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get commonDelete;

  /// No description provided for @commonRestore.
  ///
  /// In ko, this message translates to:
  /// **'복원'**
  String get commonRestore;

  /// No description provided for @privacyBody.
  ///
  /// In ko, this message translates to:
  /// **'다이브로 트레이너는 훈련 기록을 이 기기 안에만 저장해요. 계정도, 서버도 없어요.\n\n심박·수심 같은 건강 데이터는 이 웹 버전에서 수집하지 않아요. 훈련 시간과 컨트랙션 기록은 브라우저 로컬 저장소(IndexedDB)에만 남고, 브라우저 데이터를 지우면 함께 사라져요. 기록을 지키고 싶으면 설정이 아닌 히스토리 화면에서 JSON으로 내보내 두세요.\n\n제3자에게 어떤 데이터도 전송하지 않아요.'**
  String get privacyBody;

  /// No description provided for @termsBody.
  ///
  /// In ko, this message translates to:
  /// **'다이브로 트레이너는 프리다이빙 스태틱(숨참기)을 물 밖(드라이)에서 연습하기 위한 훈련 보조 도구예요.\n\n이 앱은 의료 기기가 아니고, 안전을 보장하지 않아요. 숨참기 훈련에는 블랙아웃 위험이 있어요. 저도 항상 앉아서, 물 밖에서, 무리하지 않고 해요. 어지럽거나 이상하면 바로 멈춰주세요.\n\n물속·욕조에서는 절대 사용하지 마세요. 이 앱을 사용해 발생한 결과에 대한 책임은 사용자 본인에게 있어요.'**
  String get termsBody;

  /// No description provided for @tabGuideEntry.
  ///
  /// In ko, this message translates to:
  /// **'초보자 가이드'**
  String get tabGuideEntry;

  /// No description provided for @guideTitle.
  ///
  /// In ko, this message translates to:
  /// **'훈련 가이드'**
  String get guideTitle;

  /// No description provided for @homeGuideCard.
  ///
  /// In ko, this message translates to:
  /// **'프리다이빙 스태틱이 처음이라면'**
  String get homeGuideCard;

  /// No description provided for @homeGuideCardSub.
  ///
  /// In ko, this message translates to:
  /// **'CO2·O2 테이블이 뭔지, 왜 숨참기가 느는지 3분이면 이해돼요'**
  String get homeGuideCardSub;

  /// No description provided for @settingsGuide.
  ///
  /// In ko, this message translates to:
  /// **'훈련 가이드'**
  String get settingsGuide;

  /// No description provided for @guideIntroTitle.
  ///
  /// In ko, this message translates to:
  /// **'스태틱 훈련이 뭐예요?'**
  String get guideIntroTitle;

  /// No description provided for @guideIntroBody.
  ///
  /// In ko, this message translates to:
  /// **'스태틱(STA)은 움직이지 않고 숨을 참는 프리다이빙 종목이에요. 이 앱은 물 밖에서(드라이) 편하게 앉아 숨참기를 연습하는 훈련 도구예요.\n\n숨을 참다 보면 답답한 느낌과 함께 배가 꿀렁이는 횡격막 수축이 와요. 이건 산소가 바닥나서가 아니라, 몸에 이산화탄소(CO2)가 쌓이면서 \'숨 쉬어!\' 하고 보내는 신호예요. 훈련은 이 신호를 견디고 몸을 이완하는 연습이에요.\n\n저도 왕초보 때는 1분도 버거웠어요. 매일 조금씩, 무리하지 않고 쌓으면 늘어요.'**
  String get guideIntroBody;

  /// No description provided for @guideCo2Title.
  ///
  /// In ko, this message translates to:
  /// **'CO2 테이블이란?'**
  String get guideCo2Title;

  /// No description provided for @guideCo2Body.
  ///
  /// In ko, this message translates to:
  /// **'숨참기 시간은 그대로 두고, 사이사이 회복 호흡 시간을 점점 줄여가는 훈련이에요.\n\n회복이 짧아질수록 몸에 CO2가 덜 빠진 채로 다음 숨참기에 들어가요. 그래서 \'숨 쉬고 싶은 충동\'을 점점 더 일찍, 더 세게 느끼게 되고, 이걸 반복하면 그 답답함에 대한 내성이 길러져요.\n\n한마디로 \'답답함을 견디는 힘\'을 키우는 훈련이에요. 초반에 충동이 빨리 오는 분에게 특히 좋아요.'**
  String get guideCo2Body;

  /// No description provided for @guideO2Title.
  ///
  /// In ko, this message translates to:
  /// **'O2 테이블이란?'**
  String get guideO2Title;

  /// No description provided for @guideO2Body.
  ///
  /// In ko, this message translates to:
  /// **'회복 호흡은 넉넉하게 고정하고, 숨참기 시간을 라운드마다 점점 늘려가는 훈련이에요.\n\n충분히 회복한 상태에서 점점 더 오래 참기 때문에, 몸이 낮은 산소 농도에 적응해가요. 실제로 오래 참는 능력 자체를 넓히는 훈련이에요.\n\n보통 CO2 테이블로 충동 내성을 먼저 기른 뒤, O2 테이블로 최대 시간을 늘려가요. 회복이 넉넉해서 CO2 테이블보다 덜 답답해요.'**
  String get guideO2Body;

  /// No description provided for @guideWhyTitle.
  ///
  /// In ko, this message translates to:
  /// **'왜 훈련하면 숨참기가 늘어요?'**
  String get guideWhyTitle;

  /// No description provided for @guideWhyBody.
  ///
  /// In ko, this message translates to:
  /// **'세 가지가 함께 작용해요.\n\n1. CO2 내성 — 숨 쉬고 싶은 충동은 대부분 CO2 때문이에요. 훈련으로 이 충동을 견디는 여유가 생기면, 예전 같으면 포기했을 지점을 지나갈 수 있어요.\n\n2. 이완 — 긴장하면 산소를 더 빨리 써요. 몸에 힘 빼는 법을 익히면 같은 산소로 더 오래 버텨요. \'힘을 빼야 뜬다\'는 말이 여기에도 통해요.\n\n3. 저산소 적응 — O2 훈련으로 몸이 낮은 산소에 조금씩 익숙해져요.\n\n폐를 크게 만드는 게 아니라, 몸과 마음이 \'적응\'하는 거예요. 그래서 꾸준함이 재능을 이겨요.'**
  String get guideWhyBody;

  /// No description provided for @guideSafetyTitle.
  ///
  /// In ko, this message translates to:
  /// **'딱 하나, 꼭 기억해요'**
  String get guideSafetyTitle;

  /// No description provided for @guideSafetyBody.
  ///
  /// In ko, this message translates to:
  /// **'빠르게 몰아쉬는 과호흡은 절대 하지 마세요. 과호흡은 CO2를 억지로 날려서 충동을 늦출 뿐, 산소를 늘려주지 않아요. 그래서 \'괜찮은 줄 알았는데 갑자기 정신을 잃는\' 블랙아웃 위험이 커져요.\n\n저는 항상 편안한 호흡 몇 번만 하고, 앉아서, 물 밖에서, 어지러우면 바로 멈춰요. 기록보다 안전이 먼저예요.'**
  String get guideSafetyBody;

  /// No description provided for @homeStaticSection.
  ///
  /// In ko, this message translates to:
  /// **'단발 스테틱'**
  String get homeStaticSection;

  /// No description provided for @homeStaticTitle.
  ///
  /// In ko, this message translates to:
  /// **'스테틱 한 번 해볼까요'**
  String get homeStaticTitle;

  /// No description provided for @homeStaticSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 나의 PB를 갱신해보세요'**
  String get homeStaticSubtitle;

  /// No description provided for @homeBrowseTables.
  ///
  /// In ko, this message translates to:
  /// **'훈련 테이블 둘러보기'**
  String get homeBrowseTables;

  /// No description provided for @countdownReady.
  ///
  /// In ko, this message translates to:
  /// **'준비하세요'**
  String get countdownReady;

  /// No description provided for @staticDone.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get staticDone;

  /// No description provided for @staticResultLabel.
  ///
  /// In ko, this message translates to:
  /// **'이번 기록'**
  String get staticResultLabel;

  /// No description provided for @staticNewPb.
  ///
  /// In ko, this message translates to:
  /// **'새 최고 기록을 세웠어요'**
  String get staticNewPb;

  /// No description provided for @staticPrevPb.
  ///
  /// In ko, this message translates to:
  /// **'이전 최고 {time}'**
  String staticPrevPb(String time);

  /// No description provided for @licenseTitle.
  ///
  /// In ko, this message translates to:
  /// **'내 자격증'**
  String get licenseTitle;

  /// No description provided for @licenseHomeTooltip.
  ///
  /// In ko, this message translates to:
  /// **'내 자격증'**
  String get licenseHomeTooltip;

  /// No description provided for @licenseEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'자격증 사진을 올려두세요'**
  String get licenseEmptyTitle;

  /// No description provided for @licenseEmptyBody.
  ///
  /// In ko, this message translates to:
  /// **'다이빙 센터나 버디에게 자격증을 바로 보여줄 수 있어요. 사진은 이 기기에만 저장돼요.'**
  String get licenseEmptyBody;

  /// No description provided for @licenseUpload.
  ///
  /// In ko, this message translates to:
  /// **'사진 올리기'**
  String get licenseUpload;

  /// No description provided for @licenseReplace.
  ///
  /// In ko, this message translates to:
  /// **'사진 교체'**
  String get licenseReplace;

  /// No description provided for @licenseDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get licenseDelete;

  /// No description provided for @licenseDeleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'저장된 자격증 사진을 삭제할까요?'**
  String get licenseDeleteConfirm;

  /// No description provided for @licenseSaved.
  ///
  /// In ko, this message translates to:
  /// **'자격증 사진을 저장했어요'**
  String get licenseSaved;

  /// No description provided for @licenseDeleted.
  ///
  /// In ko, this message translates to:
  /// **'자격증 사진을 삭제했어요'**
  String get licenseDeleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
