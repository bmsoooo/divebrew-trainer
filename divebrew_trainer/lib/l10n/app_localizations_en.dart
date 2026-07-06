// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'divebrew trainer';

  @override
  String get homeQuickStart => 'Quick start';

  @override
  String get homeTables => 'Training tables';

  @override
  String get tableListTitle => 'Training tables';

  @override
  String get tableListNewCustom => 'Create custom table';

  @override
  String get tableTypeCo2 => 'CO2';

  @override
  String get tableTypeO2 => 'O2';

  @override
  String get tableTypeStatic => 'Static';

  @override
  String get tableTypeCustom => 'Custom';

  @override
  String get tableEditTitleNew => 'New custom table';

  @override
  String get tableEditTitleEdit => 'Edit table';

  @override
  String get tableEditName => 'Table name';

  @override
  String get tableEditNameHint => 'e.g. My CO2 table';

  @override
  String tableEditRound(int number) {
    return 'Round $number';
  }

  @override
  String get tableEditBreathSec => 'Breathe (sec)';

  @override
  String get tableEditHoldSec => 'Hold (sec)';

  @override
  String get tableEditAddRound => 'Add round';

  @override
  String get tableEditRemoveRound => 'Remove round';

  @override
  String get tableEditSave => 'Save';

  @override
  String tableEditTotalDuration(String duration) {
    return 'Total duration: $duration';
  }

  @override
  String get tableEditNeedName => 'Please enter a table name';

  @override
  String get tableEditNeedRound => 'Please add at least one round';

  @override
  String tableRoundsSummary(int count, String duration) {
    return '$count rounds · $duration';
  }

  @override
  String sessionRoundProgress(int current, int total) {
    return 'Round $current/$total';
  }

  @override
  String get sessionPhasePreparing => 'Breathe';

  @override
  String get sessionPhaseHolding => 'Hold';

  @override
  String get sessionContractionTap => 'Contraction';

  @override
  String get sessionEndHoldEarly => 'I breathed';

  @override
  String get sessionStop => 'Stop';

  @override
  String get sessionFinished => 'Session complete!';

  @override
  String get sessionStopped => 'Session stopped';

  @override
  String sessionResultRound(int number, int holdSec) {
    return 'Round $number: ${holdSec}s';
  }

  @override
  String sessionResultContractions(int count) {
    return '$count contractions';
  }

  @override
  String get sessionBackHome => 'Home';

  @override
  String get sessionStart => 'Start session';

  @override
  String get voiceHoldStart => 'Hold your breath';

  @override
  String get voiceBreathe => 'Breathe';

  @override
  String get voiceSessionFinished => 'Session complete. Well done';

  @override
  String get onboardingTitle => 'Before we start,\nlet\'s make a promise';

  @override
  String get onboardingIntro =>
      'Four things I keep every single session. We both need to keep them to train.';

  @override
  String get onboardingDryOnly => 'I\'ll only train out of the water';

  @override
  String get onboardingDryOnlyDetail =>
      'This app is dry-training only. Even I only practice in water with proper training and a buddy.';

  @override
  String get onboardingNoHyperventilation => 'I won\'t hyperventilate';

  @override
  String get onboardingNoHyperventilationDetail =>
      'I used to over-breathe too — relaxed breathing takes you further, safely.';

  @override
  String get onboardingSeatedOnLand => 'I\'ll sit or lie down, on land only';

  @override
  String get onboardingSeatedOnLandDetail =>
      'I always do this on my couch. Standing up and getting dizzy can hurt you badly.';

  @override
  String get onboardingStopWhenDizzy => 'I\'ll stop the moment I feel dizzy';

  @override
  String get onboardingStopWhenDizzyDetail =>
      'Your body comes before any record. When something feels off, I call it a day.';

  @override
  String get onboardingAgreeButton => 'Yes, I promise';

  @override
  String get safetyReminder1 =>
      'Seated, out of the water — that\'s how I\'m doing it today too.';

  @override
  String get safetyReminder2 =>
      'No heavy over-breathing before we start. A few relaxed breaths are enough.';

  @override
  String get safetyReminder3 =>
      'Feeling dizzy? That\'s what the stop button is for. Records can wait.';

  @override
  String get safetyReminder4 =>
      'Never practice breath-holds in water. Even I only go with a buddy.';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty =>
      'No sessions yet.\nFinish your first one and it shows up here.';

  @override
  String historyMaxHold(int sec) {
    return 'Best ${sec}s';
  }

  @override
  String historyRounds(int done, int total) {
    return '$done/$total rounds';
  }

  @override
  String get historyStoppedBadge => 'Stopped';

  @override
  String get historyPbChartTitle => 'Best hold per session';

  @override
  String get homeHistory => 'History';

  @override
  String get backupExport => 'Export data';

  @override
  String get backupImport => 'Import data';

  @override
  String get backupImportDone => 'Data imported';

  @override
  String get backupImportFailed =>
      'Couldn\'t read that backup file. Please check it';

  @override
  String get tableDetailStart => 'Start';

  @override
  String get sessionPause => 'Pause';

  @override
  String get sessionResume => 'Resume';

  @override
  String get sessionPausedLabel => 'Paused';

  @override
  String get homeGreeting => 'Hello — shall we\ndescend slowly today?';

  @override
  String get homePbLabel => 'Personal best · PB';

  @override
  String homePbDate(String date) {
    return 'Set on $date';
  }

  @override
  String get homePbEmpty => 'No record yet';

  @override
  String get homeSuggestionLabel => 'Today\'s training';

  @override
  String get homeSuggestionFirst =>
      'First time? Let\'s ease in with the CO2 beginner table';

  @override
  String homeSuggestionAlternate(String type, String suggested) {
    return 'Last time was a $type table — let\'s balance it with $suggested today';
  }

  @override
  String get homeSuggestionDetail => 'View details →';

  @override
  String get homeCta => 'See today\'s training';

  @override
  String get tabHome => 'Home';

  @override
  String get tabTables => 'Tables';

  @override
  String get tabHistory => 'History';

  @override
  String get tableListIntro =>
      'CO2 tables shrink recovery breathing; O2 tables extend the hold';

  @override
  String get tableListSectionCo2 => 'CO2 tables';

  @override
  String get tableListSectionO2 => 'O2 tables';

  @override
  String get tableListSectionCustom => 'Custom';

  @override
  String get tableListCreateCustom => '+ Create your own table';

  @override
  String tableListMinutes(int min) {
    return '$min min';
  }

  @override
  String get detailBack => '← Tables';

  @override
  String get detailProfileLabel => 'Dive profile';

  @override
  String get detailStatTotal => 'Total duration';

  @override
  String get detailStatRounds => 'Rounds';

  @override
  String detailStatRoundsValue(int count) {
    return '$count';
  }

  @override
  String detailColRound(int n) {
    return 'Round $n';
  }

  @override
  String detailColHold(String time) {
    return 'Hold $time';
  }

  @override
  String detailColBreath(String time) {
    return 'Breathe $time';
  }

  @override
  String get sessionExit => '✕ Stop';

  @override
  String sessionHeader(String table, int n, int total) {
    return '$table · Round $n/$total';
  }

  @override
  String get sessionPhaseRecovery => 'Recovery breathing';

  @override
  String get sessionContractionCount => 'Contraction tap';

  @override
  String get sessionStartRecovery => 'Start recovery';

  @override
  String get historyStatSessions => 'Sessions';

  @override
  String historyStatSessionsValue(int count) {
    return '$count';
  }

  @override
  String get historyStatPb => 'Personal best';

  @override
  String get historyStatWeek => 'This week';

  @override
  String historyStatWeekValue(int days) {
    return '${days}d';
  }

  @override
  String get historyPbTrend => 'PB trend';

  @override
  String get tabSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsInstagram => 'Instagram';

  @override
  String get settingsInstagramHandle => '@divebrew.soo';

  @override
  String get settingsDataSection => 'Data management';

  @override
  String get settingsICloud => 'iCloud sync';

  @override
  String get settingsICloudStatus => 'Stored on this device only';

  @override
  String get settingsRestoreDefaults => 'Restore default routines';

  @override
  String get settingsRestoreDefaultsConfirm =>
      'Reset the built-in CO2/O2 routines to their original state? Your custom tables stay untouched.';

  @override
  String get settingsRestoreDefaultsDone => 'Default routines restored';

  @override
  String get settingsClearHistory => 'Delete all training history';

  @override
  String get settingsClearHistoryConfirm =>
      'This erases all your session history and personal bests. Tables stay. This can\'t be undone.';

  @override
  String get settingsClearHistoryDone => 'Training history deleted';

  @override
  String get settingsResetAll => 'Reset routines + history';

  @override
  String get settingsResetAllConfirm =>
      'This clears all tables and history and returns to the default state. This can\'t be undone.';

  @override
  String get settingsResetAllDone => 'Everything reset';

  @override
  String get settingsInfoSection => 'App info';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsContact => 'Contact';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsLicenses => 'Open source licenses';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRestore => 'Restore';

  @override
  String get privacyBody =>
      'divebrew trainer stores your training records only on this device. No account, no server.\n\nHealth data like heart rate or depth is not collected in this web version. Training times and contraction logs live only in your browser\'s local storage (IndexedDB) and disappear if you clear browser data. To keep your records, export them as JSON from the History screen.\n\nNo data is ever sent to any third party.';

  @override
  String get termsBody =>
      'divebrew trainer is a training aid for practicing freediving static apnea (breath-holding) out of the water (dry).\n\nThis is not a medical device and guarantees no safety. Breath-hold training carries a real risk of blackout. I always do it seated, out of the water, without pushing. Stop immediately if you feel dizzy or unwell.\n\nNever use it in water or a bathtub. You are responsible for any outcome of using this app.';

  @override
  String get tabGuideEntry => 'Beginner guide';

  @override
  String get guideTitle => 'Training guide';

  @override
  String get homeGuideCard => 'New to freediving static?';

  @override
  String get homeGuideCardSub =>
      'What CO2/O2 tables are, and why your breath-hold grows — in 3 minutes';

  @override
  String get settingsGuide => 'Training guide';

  @override
  String get guideIntroTitle => 'What is static training?';

  @override
  String get guideIntroBody =>
      'Static (STA) is the freediving discipline of holding your breath without moving. This app is a tool for practicing that out of the water (dry), sitting comfortably.\n\nAs you hold, you feel discomfort and your belly twitches with diaphragm contractions. That\'s not your oxygen running out — it\'s carbon dioxide (CO2) building up and signaling \'breathe!\'. Training is practice at tolerating that signal and relaxing your body.\n\nI could barely last a minute as a total beginner. Build it up a little each day, without pushing, and it grows.';

  @override
  String get guideCo2Title => 'What is a CO2 table?';

  @override
  String get guideCo2Body =>
      'Hold time stays the same while the recovery breathing between holds gets shorter each round.\n\nAs recovery shrinks, you start each hold with more CO2 still in your body. So the urge to breathe hits earlier and harder — and repeating that builds your tolerance to that discomfort.\n\nIn short, it trains your ability to endure the urge. Especially good if the urge hits you early.';

  @override
  String get guideO2Title => 'What is an O2 table?';

  @override
  String get guideO2Body =>
      'Recovery breathing stays generous and fixed, while hold time grows each round.\n\nBecause you hold longer and longer from a well-recovered state, your body adapts to lower oxygen levels. It expands your actual capacity to hold.\n\nUsually you build urge tolerance with CO2 tables first, then extend your max with O2 tables. With generous recovery, it feels less uncomfortable than a CO2 table.';

  @override
  String get guideWhyTitle => 'Why does training grow your hold?';

  @override
  String get guideWhyBody =>
      'Three things work together.\n\n1. CO2 tolerance — the urge to breathe is mostly from CO2. When training gives you room to endure it, you can pass the point where you\'d have quit before.\n\n2. Relaxation — tension burns oxygen faster. Learning to let go lets you last longer on the same oxygen. \'You only rise once you stop straining\' applies here too.\n\n3. Low-oxygen adaptation — O2 training gradually accustoms your body to lower oxygen.\n\nIt\'s not about bigger lungs — it\'s your body and mind adapting. That\'s why consistency beats talent.';

  @override
  String get guideSafetyTitle => 'One thing, always remember';

  @override
  String get guideSafetyBody =>
      'Never hyperventilate with fast, heavy breathing. It only flushes out CO2 to delay the urge — it does not add oxygen. That raises the risk of blackout, where you \'feel fine and then suddenly pass out.\'\n\nI always take just a few relaxed breaths, sit down, stay out of the water, and stop the moment I feel dizzy. Safety before any record.';

  @override
  String get homeStaticSection => 'Single static';

  @override
  String get homeStaticTitle => 'Try one static hold';

  @override
  String get homeStaticSubtitle => 'Beat your personal best today';

  @override
  String get homeBrowseTables => 'Browse training tables';

  @override
  String get countdownReady => 'Get ready';

  @override
  String get staticDone => 'Done';

  @override
  String get staticResultLabel => 'This hold';

  @override
  String get staticNewPb => 'New personal best!';

  @override
  String staticPrevPb(String time) {
    return 'Previous best $time';
  }

  @override
  String get licenseTitle => 'My certification';

  @override
  String get licenseHomeTooltip => 'My certification';

  @override
  String get licenseEmptyTitle => 'Save your certification card';

  @override
  String get licenseEmptyBody =>
      'Show your certification to a dive center or buddy instantly. The photo is stored on this device only.';

  @override
  String get licenseUpload => 'Upload photo';

  @override
  String get licenseReplace => 'Replace photo';

  @override
  String get licenseDelete => 'Delete';

  @override
  String get licenseDeleteConfirm => 'Delete the saved certification photo?';

  @override
  String get licenseSaved => 'Certification photo saved';

  @override
  String get licenseDeleted => 'Certification photo deleted';
}
