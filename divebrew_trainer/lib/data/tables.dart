// drift 테이블 정의 — 훈련 테이블, 세션, 개인 최고 기록 (M1 웹 범위)
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
