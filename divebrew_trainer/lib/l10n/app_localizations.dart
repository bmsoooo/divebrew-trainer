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
