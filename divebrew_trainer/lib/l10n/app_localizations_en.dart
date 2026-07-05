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
}
