// drift 테이블 정의 — 훈련 테이블, 세션, 개인 최고 기록 (M1 웹 범위)
import 'dart:convert';
import 'package:drift/drift.dart';

import 'models.dart';

/// 라운드 구성 리스트 ↔ JSON 문자열 변환기.
class RoundsConverter extends TypeConverter<List<Round>, String> {
  const RoundsConverter();

  @override
  List<Round> fromSql(String fromDb) => decodeRounds(fromDb);

  @override
  String toSql(List<Round> value) => encodeRounds(value);
}

/// 라운드 결과 리스트 ↔ JSON 문자열 변환기.
class RoundResultsConverter extends TypeConverter<List<RoundResult>, String> {
  const RoundResultsConverter();

  @override
  List<RoundResult> fromSql(String fromDb) => decodeRoundResults(fromDb);

  @override
  String toSql(List<RoundResult> value) => encodeRoundResults(value);
}

/// 훈련 테이블 (CO2/O2/스태틱/커스텀).
class TrainingTables extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<TableType>()();
  TextColumn get rounds => text().map(const RoundsConverter())();
  /// 프리셋 여부 — 프리셋은 편집 화면에서 원본 수정 불가.
  BoolColumn get isPreset => boolean().withDefault(const Constant(false))();
}

/// 훈련 세션 기록.
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tableId => integer().references(TrainingTables, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get results => text().map(const RoundResultsConverter())();
  TextColumn get note => text().nullable()();
}

/// 앱 설정 key-value 저장소 (안전 동의 여부 등).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// 종류별 개인 최고 기록 (PB).
class PersonalBests extends Table {
  TextColumn get type => textEnum<TableType>()();
  IntColumn get valueSec => integer()();
  DateTimeColumn get achievedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {type};
}

// Logbook Type Converters
class ConditionConverter extends TypeConverter<DiveCondition, String> {
  const ConditionConverter();
  @override
  DiveCondition fromSql(String fromDb) => DiveCondition.fromJson(jsonDecode(fromDb));
  @override
  String toSql(DiveCondition value) => jsonEncode(value.toJson());
}

class GearConverter extends TypeConverter<DiveGear, String> {
  const GearConverter();
  @override
  DiveGear fromSql(String fromDb) => DiveGear.fromJson(jsonDecode(fromDb));
  @override
  String toSql(DiveGear value) => jsonEncode(value.toJson());
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) => (jsonDecode(fromDb) as List).cast<String>();
  @override
  String toSql(List<String> value) => jsonEncode(value);
}

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();
  @override
  List<int> fromSql(String fromDb) => (jsonDecode(fromDb) as List).cast<int>();
  @override
  String toSql(List<int> value) => jsonEncode(value);
}

// Logbook Tables
class DiveSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get siteType => textEnum<SiteType>()();
  IntColumn get siteId => integer().nullable()();
  TextColumn get siteName => text()();
  RealColumn get lat => real().nullable()();
  RealColumn get lon => real().nullable()();
  TextColumn get purposeTag => textEnum<PurposeTag>()();
  TextColumn get condition => text().map(const ConditionConverter())();
  IntColumn get gearPresetId => integer().nullable()();
  TextColumn get gear => text().map(const GearConverter())();
  TextColumn get buddyIds => text().map(const IntListConverter())();
  TextColumn get leaderName => text().nullable()();
  IntColumn get overallRating => integer().nullable()();
  TextColumn get photoPaths => text().map(const StringListConverter())();
  TextColumn get note => text().nullable()();
  IntColumn get linkedTrainingSessionId => integer().nullable()();
}

class DiveReps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(DiveSessions, #id)();
  IntColumn get sequence => integer()();
  TextColumn get discipline => textEnum<Discipline>()();
  RealColumn get performanceValue => real()();
  TextColumn get performanceUnit => textEnum<PerformanceUnit>()();
  RealColumn get targetValue => real().nullable()();
  IntColumn get surfaceRestBeforeSec => integer().nullable()();
  IntColumn get msstRecommendedSec => integer().nullable()();
  TextColumn get incident => textEnum<IncidentType>()();
  TextColumn get recoveryNote => text().nullable()();
  BoolColumn get isMergedFromAutoSplit => boolean().withDefault(const Constant(false))();
}

class DiveSites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  IntColumn get visitCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastVisitedAt => dateTime().nullable()();
}

class DiveBuddies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get note => text().nullable()();
}

class GearPresets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get suitThicknessMm => real().nullable()();
  TextColumn get finType => textEnum<FinType>().nullable()();
}

class MedicalDocs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get issuedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  TextColumn get filePath => text()();
  TextColumn get note => text().nullable()();
}
