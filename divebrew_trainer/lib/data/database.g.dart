// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TrainingTablesTable extends TrainingTables
    with TableInfo<$TrainingTablesTable, TrainingTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingTablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TableType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TableType>($TrainingTablesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<List<Round>, String> rounds =
      GeneratedColumn<String>(
        'rounds',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Round>>($TrainingTablesTable.$converterrounds);
  static const VerificationMeta _isPresetMeta = const VerificationMeta(
    'isPreset',
  );
  @override
  late final GeneratedColumn<bool> isPreset = GeneratedColumn<bool>(
    'is_preset',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_preset" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, type, rounds, isPreset];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_tables';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_preset')) {
      context.handle(
        _isPresetMeta,
        isPreset.isAcceptableOrUnknown(data['is_preset']!, _isPresetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $TrainingTablesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      rounds: $TrainingTablesTable.$converterrounds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rounds'],
        )!,
      ),
      isPreset: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_preset'],
      )!,
    );
  }

  @override
  $TrainingTablesTable createAlias(String alias) {
    return $TrainingTablesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TableType, String, String> $convertertype =
      const EnumNameConverter<TableType>(TableType.values);
  static TypeConverter<List<Round>, String> $converterrounds =
      const RoundsConverter();
}

class TrainingTable extends DataClass implements Insertable<TrainingTable> {
  final int id;
  final String name;
  final TableType type;
  final List<Round> rounds;

  /// 프리셋 여부 — 프리셋은 편집 화면에서 원본 수정 불가.
  final bool isPreset;
  const TrainingTable({
    required this.id,
    required this.name,
    required this.type,
    required this.rounds,
    required this.isPreset,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $TrainingTablesTable.$convertertype.toSql(type),
      );
    }
    {
      map['rounds'] = Variable<String>(
        $TrainingTablesTable.$converterrounds.toSql(rounds),
      );
    }
    map['is_preset'] = Variable<bool>(isPreset);
    return map;
  }

  TrainingTablesCompanion toCompanion(bool nullToAbsent) {
    return TrainingTablesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      rounds: Value(rounds),
      isPreset: Value(isPreset),
    );
  }

  factory TrainingTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingTable(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $TrainingTablesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      rounds: serializer.fromJson<List<Round>>(json['rounds']),
      isPreset: serializer.fromJson<bool>(json['isPreset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $TrainingTablesTable.$convertertype.toJson(type),
      ),
      'rounds': serializer.toJson<List<Round>>(rounds),
      'isPreset': serializer.toJson<bool>(isPreset),
    };
  }

  TrainingTable copyWith({
    int? id,
    String? name,
    TableType? type,
    List<Round>? rounds,
    bool? isPreset,
  }) => TrainingTable(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    rounds: rounds ?? this.rounds,
    isPreset: isPreset ?? this.isPreset,
  );
  TrainingTable copyWithCompanion(TrainingTablesCompanion data) {
    return TrainingTable(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      rounds: data.rounds.present ? data.rounds.value : this.rounds,
      isPreset: data.isPreset.present ? data.isPreset.value : this.isPreset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingTable(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('rounds: $rounds, ')
          ..write('isPreset: $isPreset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, rounds, isPreset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingTable &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.rounds == this.rounds &&
          other.isPreset == this.isPreset);
}

class TrainingTablesCompanion extends UpdateCompanion<TrainingTable> {
  final Value<int> id;
  final Value<String> name;
  final Value<TableType> type;
  final Value<List<Round>> rounds;
  final Value<bool> isPreset;
  const TrainingTablesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.rounds = const Value.absent(),
    this.isPreset = const Value.absent(),
  });
  TrainingTablesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required TableType type,
    required List<Round> rounds,
    this.isPreset = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       rounds = Value(rounds);
  static Insertable<TrainingTable> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? rounds,
    Expression<bool>? isPreset,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (rounds != null) 'rounds': rounds,
      if (isPreset != null) 'is_preset': isPreset,
    });
  }

  TrainingTablesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<TableType>? type,
    Value<List<Round>>? rounds,
    Value<bool>? isPreset,
  }) {
    return TrainingTablesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rounds: rounds ?? this.rounds,
      isPreset: isPreset ?? this.isPreset,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TrainingTablesTable.$convertertype.toSql(type.value),
      );
    }
    if (rounds.present) {
      map['rounds'] = Variable<String>(
        $TrainingTablesTable.$converterrounds.toSql(rounds.value),
      );
    }
    if (isPreset.present) {
      map['is_preset'] = Variable<bool>(isPreset.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingTablesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('rounds: $rounds, ')
          ..write('isPreset: $isPreset')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tableIdMeta = const VerificationMeta(
    'tableId',
  );
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
    'table_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES training_tables (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<RoundResult>, String>
  results = GeneratedColumn<String>(
    'results',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<RoundResult>>($SessionsTable.$converterresults);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableId,
    startedAt,
    completedAt,
    results,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_id')) {
      context.handle(
        _tableIdMeta,
        tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tableIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tableId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      results: $SessionsTable.$converterresults.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}results'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<RoundResult>, String> $converterresults =
      const RoundResultsConverter();
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int tableId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<RoundResult> results;
  final String? note;
  const Session({
    required this.id,
    required this.tableId,
    required this.startedAt,
    this.completedAt,
    required this.results,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_id'] = Variable<int>(tableId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    {
      map['results'] = Variable<String>(
        $SessionsTable.$converterresults.toSql(results),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      tableId: Value(tableId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      results: Value(results),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      tableId: serializer.fromJson<int>(json['tableId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      results: serializer.fromJson<List<RoundResult>>(json['results']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableId': serializer.toJson<int>(tableId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'results': serializer.toJson<List<RoundResult>>(results),
      'note': serializer.toJson<String?>(note),
    };
  }

  Session copyWith({
    int? id,
    int? tableId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    List<RoundResult>? results,
    Value<String?> note = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    tableId: tableId ?? this.tableId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    results: results ?? this.results,
    note: note.present ? note.value : this.note,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      results: data.results.present ? data.results.value : this.results,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('results: $results, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tableId, startedAt, completedAt, results, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.tableId == this.tableId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.results == this.results &&
          other.note == this.note);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> tableId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<List<RoundResult>> results;
  final Value<String?> note;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.tableId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.results = const Value.absent(),
    this.note = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int tableId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required List<RoundResult> results,
    this.note = const Value.absent(),
  }) : tableId = Value(tableId),
       startedAt = Value(startedAt),
       results = Value(results);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? tableId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? results,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableId != null) 'table_id': tableId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (results != null) 'results': results,
      if (note != null) 'note': note,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? tableId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<List<RoundResult>>? results,
    Value<String?>? note,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      results: results ?? this.results,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (results.present) {
      map['results'] = Variable<String>(
        $SessionsTable.$converterresults.toSql(results.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('results: $results, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $PersonalBestsTable extends PersonalBests
    with TableInfo<$PersonalBestsTable, PersonalBest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalBestsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<TableType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TableType>($PersonalBestsTable.$convertertype);
  static const VerificationMeta _valueSecMeta = const VerificationMeta(
    'valueSec',
  );
  @override
  late final GeneratedColumn<int> valueSec = GeneratedColumn<int>(
    'value_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [type, valueSec, achievedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_bests';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalBest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('value_sec')) {
      context.handle(
        _valueSecMeta,
        valueSec.isAcceptableOrUnknown(data['value_sec']!, _valueSecMeta),
      );
    } else if (isInserting) {
      context.missing(_valueSecMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type};
  @override
  PersonalBest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalBest(
      type: $PersonalBestsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      valueSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_sec'],
      )!,
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
    );
  }

  @override
  $PersonalBestsTable createAlias(String alias) {
    return $PersonalBestsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TableType, String, String> $convertertype =
      const EnumNameConverter<TableType>(TableType.values);
}

class PersonalBest extends DataClass implements Insertable<PersonalBest> {
  final TableType type;
  final int valueSec;
  final DateTime achievedAt;
  const PersonalBest({
    required this.type,
    required this.valueSec,
    required this.achievedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['type'] = Variable<String>(
        $PersonalBestsTable.$convertertype.toSql(type),
      );
    }
    map['value_sec'] = Variable<int>(valueSec);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    return map;
  }

  PersonalBestsCompanion toCompanion(bool nullToAbsent) {
    return PersonalBestsCompanion(
      type: Value(type),
      valueSec: Value(valueSec),
      achievedAt: Value(achievedAt),
    );
  }

  factory PersonalBest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalBest(
      type: $PersonalBestsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      valueSec: serializer.fromJson<int>(json['valueSec']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<String>(
        $PersonalBestsTable.$convertertype.toJson(type),
      ),
      'valueSec': serializer.toJson<int>(valueSec),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
    };
  }

  PersonalBest copyWith({
    TableType? type,
    int? valueSec,
    DateTime? achievedAt,
  }) => PersonalBest(
    type: type ?? this.type,
    valueSec: valueSec ?? this.valueSec,
    achievedAt: achievedAt ?? this.achievedAt,
  );
  PersonalBest copyWithCompanion(PersonalBestsCompanion data) {
    return PersonalBest(
      type: data.type.present ? data.type.value : this.type,
      valueSec: data.valueSec.present ? data.valueSec.value : this.valueSec,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalBest(')
          ..write('type: $type, ')
          ..write('valueSec: $valueSec, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(type, valueSec, achievedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalBest &&
          other.type == this.type &&
          other.valueSec == this.valueSec &&
          other.achievedAt == this.achievedAt);
}

class PersonalBestsCompanion extends UpdateCompanion<PersonalBest> {
  final Value<TableType> type;
  final Value<int> valueSec;
  final Value<DateTime> achievedAt;
  final Value<int> rowid;
  const PersonalBestsCompanion({
    this.type = const Value.absent(),
    this.valueSec = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalBestsCompanion.insert({
    required TableType type,
    required int valueSec,
    required DateTime achievedAt,
    this.rowid = const Value.absent(),
  }) : type = Value(type),
       valueSec = Value(valueSec),
       achievedAt = Value(achievedAt);
  static Insertable<PersonalBest> custom({
    Expression<String>? type,
    Expression<int>? valueSec,
    Expression<DateTime>? achievedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (valueSec != null) 'value_sec': valueSec,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalBestsCompanion copyWith({
    Value<TableType>? type,
    Value<int>? valueSec,
    Value<DateTime>? achievedAt,
    Value<int>? rowid,
  }) {
    return PersonalBestsCompanion(
      type: type ?? this.type,
      valueSec: valueSec ?? this.valueSec,
      achievedAt: achievedAt ?? this.achievedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<String>(
        $PersonalBestsTable.$convertertype.toSql(type.value),
      );
    }
    if (valueSec.present) {
      map['value_sec'] = Variable<int>(valueSec.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalBestsCompanion(')
          ..write('type: $type, ')
          ..write('valueSec: $valueSec, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrainingTablesTable trainingTables = $TrainingTablesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $PersonalBestsTable personalBests = $PersonalBestsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trainingTables,
    sessions,
    personalBests,
  ];
}

typedef $$TrainingTablesTableCreateCompanionBuilder =
    TrainingTablesCompanion Function({
      Value<int> id,
      required String name,
      required TableType type,
      required List<Round> rounds,
      Value<bool> isPreset,
    });
typedef $$TrainingTablesTableUpdateCompanionBuilder =
    TrainingTablesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<TableType> type,
      Value<List<Round>> rounds,
      Value<bool> isPreset,
    });

final class $$TrainingTablesTableReferences
    extends BaseReferences<_$AppDatabase, $TrainingTablesTable, TrainingTable> {
  $$TrainingTablesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'training_tables__id__sessions__table_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.tableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrainingTablesTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingTablesTable> {
  $$TrainingTablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TableType, TableType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<Round>, List<Round>, String> get rounds =>
      $composableBuilder(
        column: $table.rounds,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isPreset => $composableBuilder(
    column: $table.isPreset,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingTablesTable> {
  $$TrainingTablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rounds => $composableBuilder(
    column: $table.rounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPreset => $composableBuilder(
    column: $table.isPreset,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrainingTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingTablesTable> {
  $$TrainingTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TableType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Round>, String> get rounds =>
      $composableBuilder(column: $table.rounds, builder: (column) => column);

  GeneratedColumn<bool> get isPreset =>
      $composableBuilder(column: $table.isPreset, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingTablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingTablesTable,
          TrainingTable,
          $$TrainingTablesTableFilterComposer,
          $$TrainingTablesTableOrderingComposer,
          $$TrainingTablesTableAnnotationComposer,
          $$TrainingTablesTableCreateCompanionBuilder,
          $$TrainingTablesTableUpdateCompanionBuilder,
          (TrainingTable, $$TrainingTablesTableReferences),
          TrainingTable,
          PrefetchHooks Function({bool sessionsRefs})
        > {
  $$TrainingTablesTableTableManager(
    _$AppDatabase db,
    $TrainingTablesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<TableType> type = const Value.absent(),
                Value<List<Round>> rounds = const Value.absent(),
                Value<bool> isPreset = const Value.absent(),
              }) => TrainingTablesCompanion(
                id: id,
                name: name,
                type: type,
                rounds: rounds,
                isPreset: isPreset,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required TableType type,
                required List<Round> rounds,
                Value<bool> isPreset = const Value.absent(),
              }) => TrainingTablesCompanion.insert(
                id: id,
                name: name,
                type: type,
                rounds: rounds,
                isPreset: isPreset,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrainingTablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<
                      TrainingTable,
                      $TrainingTablesTable,
                      Session
                    >(
                      currentTable: table,
                      referencedTable: $$TrainingTablesTableReferences
                          ._sessionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TrainingTablesTableReferences(
                            db,
                            table,
                            p0,
                          ).sessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tableId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TrainingTablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingTablesTable,
      TrainingTable,
      $$TrainingTablesTableFilterComposer,
      $$TrainingTablesTableOrderingComposer,
      $$TrainingTablesTableAnnotationComposer,
      $$TrainingTablesTableCreateCompanionBuilder,
      $$TrainingTablesTableUpdateCompanionBuilder,
      (TrainingTable, $$TrainingTablesTableReferences),
      TrainingTable,
      PrefetchHooks Function({bool sessionsRefs})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required int tableId,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      required List<RoundResult> results,
      Value<String?> note,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<int> tableId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<List<RoundResult>> results,
      Value<String?> note,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrainingTablesTable _tableIdTable(_$AppDatabase db) =>
      db.trainingTables.createAlias('sessions__table_id__training_tables__id');

  $$TrainingTablesTableProcessedTableManager get tableId {
    final $_column = $_itemColumn<int>('table_id')!;

    final manager = $$TrainingTablesTableTableManager(
      $_db,
      $_db.trainingTables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<RoundResult>, List<RoundResult>, String>
  get results => $composableBuilder(
    column: $table.results,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$TrainingTablesTableFilterComposer get tableId {
    final $$TrainingTablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.trainingTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingTablesTableFilterComposer(
            $db: $db,
            $table: $db.trainingTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get results => $composableBuilder(
    column: $table.results,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrainingTablesTableOrderingComposer get tableId {
    final $$TrainingTablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.trainingTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingTablesTableOrderingComposer(
            $db: $db,
            $table: $db.trainingTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<RoundResult>, String> get results =>
      $composableBuilder(column: $table.results, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$TrainingTablesTableAnnotationComposer get tableId {
    final $$TrainingTablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.trainingTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingTablesTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({bool tableId})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tableId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<List<RoundResult>> results = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                tableId: tableId,
                startedAt: startedAt,
                completedAt: completedAt,
                results: results,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tableId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                required List<RoundResult> results,
                Value<String?> note = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                tableId: tableId,
                startedAt: startedAt,
                completedAt: completedAt,
                results: results,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tableId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tableId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tableId,
                                referencedTable: $$SessionsTableReferences
                                    ._tableIdTable(db),
                                referencedColumn: $$SessionsTableReferences
                                    ._tableIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool tableId})
    >;
typedef $$PersonalBestsTableCreateCompanionBuilder =
    PersonalBestsCompanion Function({
      required TableType type,
      required int valueSec,
      required DateTime achievedAt,
      Value<int> rowid,
    });
typedef $$PersonalBestsTableUpdateCompanionBuilder =
    PersonalBestsCompanion Function({
      Value<TableType> type,
      Value<int> valueSec,
      Value<DateTime> achievedAt,
      Value<int> rowid,
    });

class $$PersonalBestsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalBestsTable> {
  $$PersonalBestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<TableType, TableType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get valueSec => $composableBuilder(
    column: $table.valueSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalBestsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalBestsTable> {
  $$PersonalBestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueSec => $composableBuilder(
    column: $table.valueSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalBestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalBestsTable> {
  $$PersonalBestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<TableType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get valueSec =>
      $composableBuilder(column: $table.valueSec, builder: (column) => column);

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );
}

class $$PersonalBestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalBestsTable,
          PersonalBest,
          $$PersonalBestsTableFilterComposer,
          $$PersonalBestsTableOrderingComposer,
          $$PersonalBestsTableAnnotationComposer,
          $$PersonalBestsTableCreateCompanionBuilder,
          $$PersonalBestsTableUpdateCompanionBuilder,
          (
            PersonalBest,
            BaseReferences<_$AppDatabase, $PersonalBestsTable, PersonalBest>,
          ),
          PersonalBest,
          PrefetchHooks Function()
        > {
  $$PersonalBestsTableTableManager(_$AppDatabase db, $PersonalBestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalBestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalBestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalBestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<TableType> type = const Value.absent(),
                Value<int> valueSec = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalBestsCompanion(
                type: type,
                valueSec: valueSec,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required TableType type,
                required int valueSec,
                required DateTime achievedAt,
                Value<int> rowid = const Value.absent(),
              }) => PersonalBestsCompanion.insert(
                type: type,
                valueSec: valueSec,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalBestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalBestsTable,
      PersonalBest,
      $$PersonalBestsTableFilterComposer,
      $$PersonalBestsTableOrderingComposer,
      $$PersonalBestsTableAnnotationComposer,
      $$PersonalBestsTableCreateCompanionBuilder,
      $$PersonalBestsTableUpdateCompanionBuilder,
      (
        PersonalBest,
        BaseReferences<_$AppDatabase, $PersonalBestsTable, PersonalBest>,
      ),
      PersonalBest,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrainingTablesTableTableManager get trainingTables =>
      $$TrainingTablesTableTableManager(_db, _db.trainingTables);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$PersonalBestsTableTableManager get personalBests =>
      $$PersonalBestsTableTableManager(_db, _db.personalBests);
}
