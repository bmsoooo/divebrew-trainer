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
}
