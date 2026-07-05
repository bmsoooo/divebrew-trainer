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
