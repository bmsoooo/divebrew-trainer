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

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiveSessionsTable extends DiveSessions
    with TableInfo<$DiveSessionsTable, DiveSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiveSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SiteType, String> siteType =
      GeneratedColumn<String>(
        'site_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SiteType>($DiveSessionsTable.$convertersiteType);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _siteNameMeta = const VerificationMeta(
    'siteName',
  );
  @override
  late final GeneratedColumn<String> siteName = GeneratedColumn<String>(
    'site_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PurposeTag, String> purposeTag =
      GeneratedColumn<String>(
        'purpose_tag',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PurposeTag>($DiveSessionsTable.$converterpurposeTag);
  @override
  late final GeneratedColumnWithTypeConverter<DiveCondition, String> condition =
      GeneratedColumn<String>(
        'condition',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DiveCondition>($DiveSessionsTable.$convertercondition);
  static const VerificationMeta _gearPresetIdMeta = const VerificationMeta(
    'gearPresetId',
  );
  @override
  late final GeneratedColumn<int> gearPresetId = GeneratedColumn<int>(
    'gear_preset_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DiveGear, String> gear =
      GeneratedColumn<String>(
        'gear',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DiveGear>($DiveSessionsTable.$convertergear);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> buddyIds =
      GeneratedColumn<String>(
        'buddy_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<int>>($DiveSessionsTable.$converterbuddyIds);
  static const VerificationMeta _leaderNameMeta = const VerificationMeta(
    'leaderName',
  );
  @override
  late final GeneratedColumn<String> leaderName = GeneratedColumn<String>(
    'leader_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overallRatingMeta = const VerificationMeta(
    'overallRating',
  );
  @override
  late final GeneratedColumn<int> overallRating = GeneratedColumn<int>(
    'overall_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> photoPaths =
      GeneratedColumn<String>(
        'photo_paths',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($DiveSessionsTable.$converterphotoPaths);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedTrainingSessionIdMeta =
      const VerificationMeta('linkedTrainingSessionId');
  @override
  late final GeneratedColumn<int> linkedTrainingSessionId =
      GeneratedColumn<int>(
        'linked_training_session_id',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    siteType,
    siteId,
    siteName,
    lat,
    lon,
    purposeTag,
    condition,
    gearPresetId,
    gear,
    buddyIds,
    leaderName,
    overallRating,
    photoPaths,
    note,
    linkedTrainingSessionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dive_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiveSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    }
    if (data.containsKey('site_name')) {
      context.handle(
        _siteNameMeta,
        siteName.isAcceptableOrUnknown(data['site_name']!, _siteNameMeta),
      );
    } else if (isInserting) {
      context.missing(_siteNameMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    }
    if (data.containsKey('gear_preset_id')) {
      context.handle(
        _gearPresetIdMeta,
        gearPresetId.isAcceptableOrUnknown(
          data['gear_preset_id']!,
          _gearPresetIdMeta,
        ),
      );
    }
    if (data.containsKey('leader_name')) {
      context.handle(
        _leaderNameMeta,
        leaderName.isAcceptableOrUnknown(data['leader_name']!, _leaderNameMeta),
      );
    }
    if (data.containsKey('overall_rating')) {
      context.handle(
        _overallRatingMeta,
        overallRating.isAcceptableOrUnknown(
          data['overall_rating']!,
          _overallRatingMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('linked_training_session_id')) {
      context.handle(
        _linkedTrainingSessionIdMeta,
        linkedTrainingSessionId.isAcceptableOrUnknown(
          data['linked_training_session_id']!,
          _linkedTrainingSessionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiveSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiveSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      siteType: $DiveSessionsTable.$convertersiteType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}site_type'],
        )!,
      ),
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
      siteName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_name'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      ),
      purposeTag: $DiveSessionsTable.$converterpurposeTag.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}purpose_tag'],
        )!,
      ),
      condition: $DiveSessionsTable.$convertercondition.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}condition'],
        )!,
      ),
      gearPresetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gear_preset_id'],
      ),
      gear: $DiveSessionsTable.$convertergear.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}gear'],
        )!,
      ),
      buddyIds: $DiveSessionsTable.$converterbuddyIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}buddy_ids'],
        )!,
      ),
      leaderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leader_name'],
      ),
      overallRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overall_rating'],
      ),
      photoPaths: $DiveSessionsTable.$converterphotoPaths.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}photo_paths'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      linkedTrainingSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked_training_session_id'],
      ),
    );
  }

  @override
  $DiveSessionsTable createAlias(String alias) {
    return $DiveSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SiteType, String, String> $convertersiteType =
      const EnumNameConverter<SiteType>(SiteType.values);
  static JsonTypeConverter2<PurposeTag, String, String> $converterpurposeTag =
      const EnumNameConverter<PurposeTag>(PurposeTag.values);
  static TypeConverter<DiveCondition, String> $convertercondition =
      const ConditionConverter();
  static TypeConverter<DiveGear, String> $convertergear = const GearConverter();
  static TypeConverter<List<int>, String> $converterbuddyIds =
      const IntListConverter();
  static TypeConverter<List<String>, String> $converterphotoPaths =
      const StringListConverter();
}

class DiveSession extends DataClass implements Insertable<DiveSession> {
  final int id;
  final DateTime date;
  final SiteType siteType;
  final int? siteId;
  final String siteName;
  final double? lat;
  final double? lon;
  final PurposeTag purposeTag;
  final DiveCondition condition;
  final int? gearPresetId;
  final DiveGear gear;
  final List<int> buddyIds;
  final String? leaderName;
  final int? overallRating;
  final List<String> photoPaths;
  final String? note;
  final int? linkedTrainingSessionId;
  const DiveSession({
    required this.id,
    required this.date,
    required this.siteType,
    this.siteId,
    required this.siteName,
    this.lat,
    this.lon,
    required this.purposeTag,
    required this.condition,
    this.gearPresetId,
    required this.gear,
    required this.buddyIds,
    this.leaderName,
    this.overallRating,
    required this.photoPaths,
    this.note,
    this.linkedTrainingSessionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    {
      map['site_type'] = Variable<String>(
        $DiveSessionsTable.$convertersiteType.toSql(siteType),
      );
    }
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    map['site_name'] = Variable<String>(siteName);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lon != null) {
      map['lon'] = Variable<double>(lon);
    }
    {
      map['purpose_tag'] = Variable<String>(
        $DiveSessionsTable.$converterpurposeTag.toSql(purposeTag),
      );
    }
    {
      map['condition'] = Variable<String>(
        $DiveSessionsTable.$convertercondition.toSql(condition),
      );
    }
    if (!nullToAbsent || gearPresetId != null) {
      map['gear_preset_id'] = Variable<int>(gearPresetId);
    }
    {
      map['gear'] = Variable<String>(
        $DiveSessionsTable.$convertergear.toSql(gear),
      );
    }
    {
      map['buddy_ids'] = Variable<String>(
        $DiveSessionsTable.$converterbuddyIds.toSql(buddyIds),
      );
    }
    if (!nullToAbsent || leaderName != null) {
      map['leader_name'] = Variable<String>(leaderName);
    }
    if (!nullToAbsent || overallRating != null) {
      map['overall_rating'] = Variable<int>(overallRating);
    }
    {
      map['photo_paths'] = Variable<String>(
        $DiveSessionsTable.$converterphotoPaths.toSql(photoPaths),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || linkedTrainingSessionId != null) {
      map['linked_training_session_id'] = Variable<int>(
        linkedTrainingSessionId,
      );
    }
    return map;
  }

  DiveSessionsCompanion toCompanion(bool nullToAbsent) {
    return DiveSessionsCompanion(
      id: Value(id),
      date: Value(date),
      siteType: Value(siteType),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
      siteName: Value(siteName),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lon: lon == null && nullToAbsent ? const Value.absent() : Value(lon),
      purposeTag: Value(purposeTag),
      condition: Value(condition),
      gearPresetId: gearPresetId == null && nullToAbsent
          ? const Value.absent()
          : Value(gearPresetId),
      gear: Value(gear),
      buddyIds: Value(buddyIds),
      leaderName: leaderName == null && nullToAbsent
          ? const Value.absent()
          : Value(leaderName),
      overallRating: overallRating == null && nullToAbsent
          ? const Value.absent()
          : Value(overallRating),
      photoPaths: Value(photoPaths),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      linkedTrainingSessionId: linkedTrainingSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTrainingSessionId),
    );
  }

  factory DiveSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiveSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      siteType: $DiveSessionsTable.$convertersiteType.fromJson(
        serializer.fromJson<String>(json['siteType']),
      ),
      siteId: serializer.fromJson<int?>(json['siteId']),
      siteName: serializer.fromJson<String>(json['siteName']),
      lat: serializer.fromJson<double?>(json['lat']),
      lon: serializer.fromJson<double?>(json['lon']),
      purposeTag: $DiveSessionsTable.$converterpurposeTag.fromJson(
        serializer.fromJson<String>(json['purposeTag']),
      ),
      condition: serializer.fromJson<DiveCondition>(json['condition']),
      gearPresetId: serializer.fromJson<int?>(json['gearPresetId']),
      gear: serializer.fromJson<DiveGear>(json['gear']),
      buddyIds: serializer.fromJson<List<int>>(json['buddyIds']),
      leaderName: serializer.fromJson<String?>(json['leaderName']),
      overallRating: serializer.fromJson<int?>(json['overallRating']),
      photoPaths: serializer.fromJson<List<String>>(json['photoPaths']),
      note: serializer.fromJson<String?>(json['note']),
      linkedTrainingSessionId: serializer.fromJson<int?>(
        json['linkedTrainingSessionId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'siteType': serializer.toJson<String>(
        $DiveSessionsTable.$convertersiteType.toJson(siteType),
      ),
      'siteId': serializer.toJson<int?>(siteId),
      'siteName': serializer.toJson<String>(siteName),
      'lat': serializer.toJson<double?>(lat),
      'lon': serializer.toJson<double?>(lon),
      'purposeTag': serializer.toJson<String>(
        $DiveSessionsTable.$converterpurposeTag.toJson(purposeTag),
      ),
      'condition': serializer.toJson<DiveCondition>(condition),
      'gearPresetId': serializer.toJson<int?>(gearPresetId),
      'gear': serializer.toJson<DiveGear>(gear),
      'buddyIds': serializer.toJson<List<int>>(buddyIds),
      'leaderName': serializer.toJson<String?>(leaderName),
      'overallRating': serializer.toJson<int?>(overallRating),
      'photoPaths': serializer.toJson<List<String>>(photoPaths),
      'note': serializer.toJson<String?>(note),
      'linkedTrainingSessionId': serializer.toJson<int?>(
        linkedTrainingSessionId,
      ),
    };
  }

  DiveSession copyWith({
    int? id,
    DateTime? date,
    SiteType? siteType,
    Value<int?> siteId = const Value.absent(),
    String? siteName,
    Value<double?> lat = const Value.absent(),
    Value<double?> lon = const Value.absent(),
    PurposeTag? purposeTag,
    DiveCondition? condition,
    Value<int?> gearPresetId = const Value.absent(),
    DiveGear? gear,
    List<int>? buddyIds,
    Value<String?> leaderName = const Value.absent(),
    Value<int?> overallRating = const Value.absent(),
    List<String>? photoPaths,
    Value<String?> note = const Value.absent(),
    Value<int?> linkedTrainingSessionId = const Value.absent(),
  }) => DiveSession(
    id: id ?? this.id,
    date: date ?? this.date,
    siteType: siteType ?? this.siteType,
    siteId: siteId.present ? siteId.value : this.siteId,
    siteName: siteName ?? this.siteName,
    lat: lat.present ? lat.value : this.lat,
    lon: lon.present ? lon.value : this.lon,
    purposeTag: purposeTag ?? this.purposeTag,
    condition: condition ?? this.condition,
    gearPresetId: gearPresetId.present ? gearPresetId.value : this.gearPresetId,
    gear: gear ?? this.gear,
    buddyIds: buddyIds ?? this.buddyIds,
    leaderName: leaderName.present ? leaderName.value : this.leaderName,
    overallRating: overallRating.present
        ? overallRating.value
        : this.overallRating,
    photoPaths: photoPaths ?? this.photoPaths,
    note: note.present ? note.value : this.note,
    linkedTrainingSessionId: linkedTrainingSessionId.present
        ? linkedTrainingSessionId.value
        : this.linkedTrainingSessionId,
  );
  DiveSession copyWithCompanion(DiveSessionsCompanion data) {
    return DiveSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      siteType: data.siteType.present ? data.siteType.value : this.siteType,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      siteName: data.siteName.present ? data.siteName.value : this.siteName,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      purposeTag: data.purposeTag.present
          ? data.purposeTag.value
          : this.purposeTag,
      condition: data.condition.present ? data.condition.value : this.condition,
      gearPresetId: data.gearPresetId.present
          ? data.gearPresetId.value
          : this.gearPresetId,
      gear: data.gear.present ? data.gear.value : this.gear,
      buddyIds: data.buddyIds.present ? data.buddyIds.value : this.buddyIds,
      leaderName: data.leaderName.present
          ? data.leaderName.value
          : this.leaderName,
      overallRating: data.overallRating.present
          ? data.overallRating.value
          : this.overallRating,
      photoPaths: data.photoPaths.present
          ? data.photoPaths.value
          : this.photoPaths,
      note: data.note.present ? data.note.value : this.note,
      linkedTrainingSessionId: data.linkedTrainingSessionId.present
          ? data.linkedTrainingSessionId.value
          : this.linkedTrainingSessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiveSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('siteType: $siteType, ')
          ..write('siteId: $siteId, ')
          ..write('siteName: $siteName, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('purposeTag: $purposeTag, ')
          ..write('condition: $condition, ')
          ..write('gearPresetId: $gearPresetId, ')
          ..write('gear: $gear, ')
          ..write('buddyIds: $buddyIds, ')
          ..write('leaderName: $leaderName, ')
          ..write('overallRating: $overallRating, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('note: $note, ')
          ..write('linkedTrainingSessionId: $linkedTrainingSessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    siteType,
    siteId,
    siteName,
    lat,
    lon,
    purposeTag,
    condition,
    gearPresetId,
    gear,
    buddyIds,
    leaderName,
    overallRating,
    photoPaths,
    note,
    linkedTrainingSessionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiveSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.siteType == this.siteType &&
          other.siteId == this.siteId &&
          other.siteName == this.siteName &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.purposeTag == this.purposeTag &&
          other.condition == this.condition &&
          other.gearPresetId == this.gearPresetId &&
          other.gear == this.gear &&
          other.buddyIds == this.buddyIds &&
          other.leaderName == this.leaderName &&
          other.overallRating == this.overallRating &&
          other.photoPaths == this.photoPaths &&
          other.note == this.note &&
          other.linkedTrainingSessionId == this.linkedTrainingSessionId);
}

class DiveSessionsCompanion extends UpdateCompanion<DiveSession> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<SiteType> siteType;
  final Value<int?> siteId;
  final Value<String> siteName;
  final Value<double?> lat;
  final Value<double?> lon;
  final Value<PurposeTag> purposeTag;
  final Value<DiveCondition> condition;
  final Value<int?> gearPresetId;
  final Value<DiveGear> gear;
  final Value<List<int>> buddyIds;
  final Value<String?> leaderName;
  final Value<int?> overallRating;
  final Value<List<String>> photoPaths;
  final Value<String?> note;
  final Value<int?> linkedTrainingSessionId;
  const DiveSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.siteType = const Value.absent(),
    this.siteId = const Value.absent(),
    this.siteName = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.purposeTag = const Value.absent(),
    this.condition = const Value.absent(),
    this.gearPresetId = const Value.absent(),
    this.gear = const Value.absent(),
    this.buddyIds = const Value.absent(),
    this.leaderName = const Value.absent(),
    this.overallRating = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.note = const Value.absent(),
    this.linkedTrainingSessionId = const Value.absent(),
  });
  DiveSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required SiteType siteType,
    this.siteId = const Value.absent(),
    required String siteName,
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    required PurposeTag purposeTag,
    required DiveCondition condition,
    this.gearPresetId = const Value.absent(),
    required DiveGear gear,
    required List<int> buddyIds,
    this.leaderName = const Value.absent(),
    this.overallRating = const Value.absent(),
    required List<String> photoPaths,
    this.note = const Value.absent(),
    this.linkedTrainingSessionId = const Value.absent(),
  }) : date = Value(date),
       siteType = Value(siteType),
       siteName = Value(siteName),
       purposeTag = Value(purposeTag),
       condition = Value(condition),
       gear = Value(gear),
       buddyIds = Value(buddyIds),
       photoPaths = Value(photoPaths);
  static Insertable<DiveSession> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? siteType,
    Expression<int>? siteId,
    Expression<String>? siteName,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? purposeTag,
    Expression<String>? condition,
    Expression<int>? gearPresetId,
    Expression<String>? gear,
    Expression<String>? buddyIds,
    Expression<String>? leaderName,
    Expression<int>? overallRating,
    Expression<String>? photoPaths,
    Expression<String>? note,
    Expression<int>? linkedTrainingSessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (siteType != null) 'site_type': siteType,
      if (siteId != null) 'site_id': siteId,
      if (siteName != null) 'site_name': siteName,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (purposeTag != null) 'purpose_tag': purposeTag,
      if (condition != null) 'condition': condition,
      if (gearPresetId != null) 'gear_preset_id': gearPresetId,
      if (gear != null) 'gear': gear,
      if (buddyIds != null) 'buddy_ids': buddyIds,
      if (leaderName != null) 'leader_name': leaderName,
      if (overallRating != null) 'overall_rating': overallRating,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (note != null) 'note': note,
      if (linkedTrainingSessionId != null)
        'linked_training_session_id': linkedTrainingSessionId,
    });
  }

  DiveSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<SiteType>? siteType,
    Value<int?>? siteId,
    Value<String>? siteName,
    Value<double?>? lat,
    Value<double?>? lon,
    Value<PurposeTag>? purposeTag,
    Value<DiveCondition>? condition,
    Value<int?>? gearPresetId,
    Value<DiveGear>? gear,
    Value<List<int>>? buddyIds,
    Value<String?>? leaderName,
    Value<int?>? overallRating,
    Value<List<String>>? photoPaths,
    Value<String?>? note,
    Value<int?>? linkedTrainingSessionId,
  }) {
    return DiveSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      siteType: siteType ?? this.siteType,
      siteId: siteId ?? this.siteId,
      siteName: siteName ?? this.siteName,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      purposeTag: purposeTag ?? this.purposeTag,
      condition: condition ?? this.condition,
      gearPresetId: gearPresetId ?? this.gearPresetId,
      gear: gear ?? this.gear,
      buddyIds: buddyIds ?? this.buddyIds,
      leaderName: leaderName ?? this.leaderName,
      overallRating: overallRating ?? this.overallRating,
      photoPaths: photoPaths ?? this.photoPaths,
      note: note ?? this.note,
      linkedTrainingSessionId:
          linkedTrainingSessionId ?? this.linkedTrainingSessionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (siteType.present) {
      map['site_type'] = Variable<String>(
        $DiveSessionsTable.$convertersiteType.toSql(siteType.value),
      );
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (siteName.present) {
      map['site_name'] = Variable<String>(siteName.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (purposeTag.present) {
      map['purpose_tag'] = Variable<String>(
        $DiveSessionsTable.$converterpurposeTag.toSql(purposeTag.value),
      );
    }
    if (condition.present) {
      map['condition'] = Variable<String>(
        $DiveSessionsTable.$convertercondition.toSql(condition.value),
      );
    }
    if (gearPresetId.present) {
      map['gear_preset_id'] = Variable<int>(gearPresetId.value);
    }
    if (gear.present) {
      map['gear'] = Variable<String>(
        $DiveSessionsTable.$convertergear.toSql(gear.value),
      );
    }
    if (buddyIds.present) {
      map['buddy_ids'] = Variable<String>(
        $DiveSessionsTable.$converterbuddyIds.toSql(buddyIds.value),
      );
    }
    if (leaderName.present) {
      map['leader_name'] = Variable<String>(leaderName.value);
    }
    if (overallRating.present) {
      map['overall_rating'] = Variable<int>(overallRating.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(
        $DiveSessionsTable.$converterphotoPaths.toSql(photoPaths.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (linkedTrainingSessionId.present) {
      map['linked_training_session_id'] = Variable<int>(
        linkedTrainingSessionId.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiveSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('siteType: $siteType, ')
          ..write('siteId: $siteId, ')
          ..write('siteName: $siteName, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('purposeTag: $purposeTag, ')
          ..write('condition: $condition, ')
          ..write('gearPresetId: $gearPresetId, ')
          ..write('gear: $gear, ')
          ..write('buddyIds: $buddyIds, ')
          ..write('leaderName: $leaderName, ')
          ..write('overallRating: $overallRating, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('note: $note, ')
          ..write('linkedTrainingSessionId: $linkedTrainingSessionId')
          ..write(')'))
        .toString();
  }
}

class $DiveRepsTable extends DiveReps with TableInfo<$DiveRepsTable, DiveRep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiveRepsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dive_sessions (id)',
    ),
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Discipline, String> discipline =
      GeneratedColumn<String>(
        'discipline',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Discipline>($DiveRepsTable.$converterdiscipline);
  static const VerificationMeta _performanceValueMeta = const VerificationMeta(
    'performanceValue',
  );
  @override
  late final GeneratedColumn<double> performanceValue = GeneratedColumn<double>(
    'performance_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PerformanceUnit, String>
  performanceUnit = GeneratedColumn<String>(
    'performance_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PerformanceUnit>($DiveRepsTable.$converterperformanceUnit);
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surfaceRestBeforeSecMeta =
      const VerificationMeta('surfaceRestBeforeSec');
  @override
  late final GeneratedColumn<int> surfaceRestBeforeSec = GeneratedColumn<int>(
    'surface_rest_before_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _msstRecommendedSecMeta =
      const VerificationMeta('msstRecommendedSec');
  @override
  late final GeneratedColumn<int> msstRecommendedSec = GeneratedColumn<int>(
    'msst_recommended_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IncidentType, String> incident =
      GeneratedColumn<String>(
        'incident',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IncidentType>($DiveRepsTable.$converterincident);
  static const VerificationMeta _recoveryNoteMeta = const VerificationMeta(
    'recoveryNote',
  );
  @override
  late final GeneratedColumn<String> recoveryNote = GeneratedColumn<String>(
    'recovery_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isMergedFromAutoSplitMeta =
      const VerificationMeta('isMergedFromAutoSplit');
  @override
  late final GeneratedColumn<bool> isMergedFromAutoSplit =
      GeneratedColumn<bool>(
        'is_merged_from_auto_split',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_merged_from_auto_split" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    sequence,
    discipline,
    performanceValue,
    performanceUnit,
    targetValue,
    surfaceRestBeforeSec,
    msstRecommendedSec,
    incident,
    recoveryNote,
    isMergedFromAutoSplit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dive_reps';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiveRep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('performance_value')) {
      context.handle(
        _performanceValueMeta,
        performanceValue.isAcceptableOrUnknown(
          data['performance_value']!,
          _performanceValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performanceValueMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('surface_rest_before_sec')) {
      context.handle(
        _surfaceRestBeforeSecMeta,
        surfaceRestBeforeSec.isAcceptableOrUnknown(
          data['surface_rest_before_sec']!,
          _surfaceRestBeforeSecMeta,
        ),
      );
    }
    if (data.containsKey('msst_recommended_sec')) {
      context.handle(
        _msstRecommendedSecMeta,
        msstRecommendedSec.isAcceptableOrUnknown(
          data['msst_recommended_sec']!,
          _msstRecommendedSecMeta,
        ),
      );
    }
    if (data.containsKey('recovery_note')) {
      context.handle(
        _recoveryNoteMeta,
        recoveryNote.isAcceptableOrUnknown(
          data['recovery_note']!,
          _recoveryNoteMeta,
        ),
      );
    }
    if (data.containsKey('is_merged_from_auto_split')) {
      context.handle(
        _isMergedFromAutoSplitMeta,
        isMergedFromAutoSplit.isAcceptableOrUnknown(
          data['is_merged_from_auto_split']!,
          _isMergedFromAutoSplitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiveRep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiveRep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      discipline: $DiveRepsTable.$converterdiscipline.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}discipline'],
        )!,
      ),
      performanceValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}performance_value'],
      )!,
      performanceUnit: $DiveRepsTable.$converterperformanceUnit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}performance_unit'],
        )!,
      ),
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      ),
      surfaceRestBeforeSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surface_rest_before_sec'],
      ),
      msstRecommendedSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}msst_recommended_sec'],
      ),
      incident: $DiveRepsTable.$converterincident.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}incident'],
        )!,
      ),
      recoveryNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recovery_note'],
      ),
      isMergedFromAutoSplit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_merged_from_auto_split'],
      )!,
    );
  }

  @override
  $DiveRepsTable createAlias(String alias) {
    return $DiveRepsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Discipline, String, String> $converterdiscipline =
      const EnumNameConverter<Discipline>(Discipline.values);
  static JsonTypeConverter2<PerformanceUnit, String, String>
  $converterperformanceUnit = const EnumNameConverter<PerformanceUnit>(
    PerformanceUnit.values,
  );
  static JsonTypeConverter2<IncidentType, String, String> $converterincident =
      const EnumNameConverter<IncidentType>(IncidentType.values);
}

class DiveRep extends DataClass implements Insertable<DiveRep> {
  final int id;
  final int sessionId;
  final int sequence;
  final Discipline discipline;
  final double performanceValue;
  final PerformanceUnit performanceUnit;
  final double? targetValue;
  final int? surfaceRestBeforeSec;
  final int? msstRecommendedSec;
  final IncidentType incident;
  final String? recoveryNote;
  final bool isMergedFromAutoSplit;
  const DiveRep({
    required this.id,
    required this.sessionId,
    required this.sequence,
    required this.discipline,
    required this.performanceValue,
    required this.performanceUnit,
    this.targetValue,
    this.surfaceRestBeforeSec,
    this.msstRecommendedSec,
    required this.incident,
    this.recoveryNote,
    required this.isMergedFromAutoSplit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['sequence'] = Variable<int>(sequence);
    {
      map['discipline'] = Variable<String>(
        $DiveRepsTable.$converterdiscipline.toSql(discipline),
      );
    }
    map['performance_value'] = Variable<double>(performanceValue);
    {
      map['performance_unit'] = Variable<String>(
        $DiveRepsTable.$converterperformanceUnit.toSql(performanceUnit),
      );
    }
    if (!nullToAbsent || targetValue != null) {
      map['target_value'] = Variable<double>(targetValue);
    }
    if (!nullToAbsent || surfaceRestBeforeSec != null) {
      map['surface_rest_before_sec'] = Variable<int>(surfaceRestBeforeSec);
    }
    if (!nullToAbsent || msstRecommendedSec != null) {
      map['msst_recommended_sec'] = Variable<int>(msstRecommendedSec);
    }
    {
      map['incident'] = Variable<String>(
        $DiveRepsTable.$converterincident.toSql(incident),
      );
    }
    if (!nullToAbsent || recoveryNote != null) {
      map['recovery_note'] = Variable<String>(recoveryNote);
    }
    map['is_merged_from_auto_split'] = Variable<bool>(isMergedFromAutoSplit);
    return map;
  }

  DiveRepsCompanion toCompanion(bool nullToAbsent) {
    return DiveRepsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      sequence: Value(sequence),
      discipline: Value(discipline),
      performanceValue: Value(performanceValue),
      performanceUnit: Value(performanceUnit),
      targetValue: targetValue == null && nullToAbsent
          ? const Value.absent()
          : Value(targetValue),
      surfaceRestBeforeSec: surfaceRestBeforeSec == null && nullToAbsent
          ? const Value.absent()
          : Value(surfaceRestBeforeSec),
      msstRecommendedSec: msstRecommendedSec == null && nullToAbsent
          ? const Value.absent()
          : Value(msstRecommendedSec),
      incident: Value(incident),
      recoveryNote: recoveryNote == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveryNote),
      isMergedFromAutoSplit: Value(isMergedFromAutoSplit),
    );
  }

  factory DiveRep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiveRep(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      discipline: $DiveRepsTable.$converterdiscipline.fromJson(
        serializer.fromJson<String>(json['discipline']),
      ),
      performanceValue: serializer.fromJson<double>(json['performanceValue']),
      performanceUnit: $DiveRepsTable.$converterperformanceUnit.fromJson(
        serializer.fromJson<String>(json['performanceUnit']),
      ),
      targetValue: serializer.fromJson<double?>(json['targetValue']),
      surfaceRestBeforeSec: serializer.fromJson<int?>(
        json['surfaceRestBeforeSec'],
      ),
      msstRecommendedSec: serializer.fromJson<int?>(json['msstRecommendedSec']),
      incident: $DiveRepsTable.$converterincident.fromJson(
        serializer.fromJson<String>(json['incident']),
      ),
      recoveryNote: serializer.fromJson<String?>(json['recoveryNote']),
      isMergedFromAutoSplit: serializer.fromJson<bool>(
        json['isMergedFromAutoSplit'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'sequence': serializer.toJson<int>(sequence),
      'discipline': serializer.toJson<String>(
        $DiveRepsTable.$converterdiscipline.toJson(discipline),
      ),
      'performanceValue': serializer.toJson<double>(performanceValue),
      'performanceUnit': serializer.toJson<String>(
        $DiveRepsTable.$converterperformanceUnit.toJson(performanceUnit),
      ),
      'targetValue': serializer.toJson<double?>(targetValue),
      'surfaceRestBeforeSec': serializer.toJson<int?>(surfaceRestBeforeSec),
      'msstRecommendedSec': serializer.toJson<int?>(msstRecommendedSec),
      'incident': serializer.toJson<String>(
        $DiveRepsTable.$converterincident.toJson(incident),
      ),
      'recoveryNote': serializer.toJson<String?>(recoveryNote),
      'isMergedFromAutoSplit': serializer.toJson<bool>(isMergedFromAutoSplit),
    };
  }

  DiveRep copyWith({
    int? id,
    int? sessionId,
    int? sequence,
    Discipline? discipline,
    double? performanceValue,
    PerformanceUnit? performanceUnit,
    Value<double?> targetValue = const Value.absent(),
    Value<int?> surfaceRestBeforeSec = const Value.absent(),
    Value<int?> msstRecommendedSec = const Value.absent(),
    IncidentType? incident,
    Value<String?> recoveryNote = const Value.absent(),
    bool? isMergedFromAutoSplit,
  }) => DiveRep(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    sequence: sequence ?? this.sequence,
    discipline: discipline ?? this.discipline,
    performanceValue: performanceValue ?? this.performanceValue,
    performanceUnit: performanceUnit ?? this.performanceUnit,
    targetValue: targetValue.present ? targetValue.value : this.targetValue,
    surfaceRestBeforeSec: surfaceRestBeforeSec.present
        ? surfaceRestBeforeSec.value
        : this.surfaceRestBeforeSec,
    msstRecommendedSec: msstRecommendedSec.present
        ? msstRecommendedSec.value
        : this.msstRecommendedSec,
    incident: incident ?? this.incident,
    recoveryNote: recoveryNote.present ? recoveryNote.value : this.recoveryNote,
    isMergedFromAutoSplit: isMergedFromAutoSplit ?? this.isMergedFromAutoSplit,
  );
  DiveRep copyWithCompanion(DiveRepsCompanion data) {
    return DiveRep(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      discipline: data.discipline.present
          ? data.discipline.value
          : this.discipline,
      performanceValue: data.performanceValue.present
          ? data.performanceValue.value
          : this.performanceValue,
      performanceUnit: data.performanceUnit.present
          ? data.performanceUnit.value
          : this.performanceUnit,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      surfaceRestBeforeSec: data.surfaceRestBeforeSec.present
          ? data.surfaceRestBeforeSec.value
          : this.surfaceRestBeforeSec,
      msstRecommendedSec: data.msstRecommendedSec.present
          ? data.msstRecommendedSec.value
          : this.msstRecommendedSec,
      incident: data.incident.present ? data.incident.value : this.incident,
      recoveryNote: data.recoveryNote.present
          ? data.recoveryNote.value
          : this.recoveryNote,
      isMergedFromAutoSplit: data.isMergedFromAutoSplit.present
          ? data.isMergedFromAutoSplit.value
          : this.isMergedFromAutoSplit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiveRep(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sequence: $sequence, ')
          ..write('discipline: $discipline, ')
          ..write('performanceValue: $performanceValue, ')
          ..write('performanceUnit: $performanceUnit, ')
          ..write('targetValue: $targetValue, ')
          ..write('surfaceRestBeforeSec: $surfaceRestBeforeSec, ')
          ..write('msstRecommendedSec: $msstRecommendedSec, ')
          ..write('incident: $incident, ')
          ..write('recoveryNote: $recoveryNote, ')
          ..write('isMergedFromAutoSplit: $isMergedFromAutoSplit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    sequence,
    discipline,
    performanceValue,
    performanceUnit,
    targetValue,
    surfaceRestBeforeSec,
    msstRecommendedSec,
    incident,
    recoveryNote,
    isMergedFromAutoSplit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiveRep &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.sequence == this.sequence &&
          other.discipline == this.discipline &&
          other.performanceValue == this.performanceValue &&
          other.performanceUnit == this.performanceUnit &&
          other.targetValue == this.targetValue &&
          other.surfaceRestBeforeSec == this.surfaceRestBeforeSec &&
          other.msstRecommendedSec == this.msstRecommendedSec &&
          other.incident == this.incident &&
          other.recoveryNote == this.recoveryNote &&
          other.isMergedFromAutoSplit == this.isMergedFromAutoSplit);
}

class DiveRepsCompanion extends UpdateCompanion<DiveRep> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> sequence;
  final Value<Discipline> discipline;
  final Value<double> performanceValue;
  final Value<PerformanceUnit> performanceUnit;
  final Value<double?> targetValue;
  final Value<int?> surfaceRestBeforeSec;
  final Value<int?> msstRecommendedSec;
  final Value<IncidentType> incident;
  final Value<String?> recoveryNote;
  final Value<bool> isMergedFromAutoSplit;
  const DiveRepsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.discipline = const Value.absent(),
    this.performanceValue = const Value.absent(),
    this.performanceUnit = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.surfaceRestBeforeSec = const Value.absent(),
    this.msstRecommendedSec = const Value.absent(),
    this.incident = const Value.absent(),
    this.recoveryNote = const Value.absent(),
    this.isMergedFromAutoSplit = const Value.absent(),
  });
  DiveRepsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int sequence,
    required Discipline discipline,
    required double performanceValue,
    required PerformanceUnit performanceUnit,
    this.targetValue = const Value.absent(),
    this.surfaceRestBeforeSec = const Value.absent(),
    this.msstRecommendedSec = const Value.absent(),
    required IncidentType incident,
    this.recoveryNote = const Value.absent(),
    this.isMergedFromAutoSplit = const Value.absent(),
  }) : sessionId = Value(sessionId),
       sequence = Value(sequence),
       discipline = Value(discipline),
       performanceValue = Value(performanceValue),
       performanceUnit = Value(performanceUnit),
       incident = Value(incident);
  static Insertable<DiveRep> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? sequence,
    Expression<String>? discipline,
    Expression<double>? performanceValue,
    Expression<String>? performanceUnit,
    Expression<double>? targetValue,
    Expression<int>? surfaceRestBeforeSec,
    Expression<int>? msstRecommendedSec,
    Expression<String>? incident,
    Expression<String>? recoveryNote,
    Expression<bool>? isMergedFromAutoSplit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (sequence != null) 'sequence': sequence,
      if (discipline != null) 'discipline': discipline,
      if (performanceValue != null) 'performance_value': performanceValue,
      if (performanceUnit != null) 'performance_unit': performanceUnit,
      if (targetValue != null) 'target_value': targetValue,
      if (surfaceRestBeforeSec != null)
        'surface_rest_before_sec': surfaceRestBeforeSec,
      if (msstRecommendedSec != null)
        'msst_recommended_sec': msstRecommendedSec,
      if (incident != null) 'incident': incident,
      if (recoveryNote != null) 'recovery_note': recoveryNote,
      if (isMergedFromAutoSplit != null)
        'is_merged_from_auto_split': isMergedFromAutoSplit,
    });
  }

  DiveRepsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? sequence,
    Value<Discipline>? discipline,
    Value<double>? performanceValue,
    Value<PerformanceUnit>? performanceUnit,
    Value<double?>? targetValue,
    Value<int?>? surfaceRestBeforeSec,
    Value<int?>? msstRecommendedSec,
    Value<IncidentType>? incident,
    Value<String?>? recoveryNote,
    Value<bool>? isMergedFromAutoSplit,
  }) {
    return DiveRepsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sequence: sequence ?? this.sequence,
      discipline: discipline ?? this.discipline,
      performanceValue: performanceValue ?? this.performanceValue,
      performanceUnit: performanceUnit ?? this.performanceUnit,
      targetValue: targetValue ?? this.targetValue,
      surfaceRestBeforeSec: surfaceRestBeforeSec ?? this.surfaceRestBeforeSec,
      msstRecommendedSec: msstRecommendedSec ?? this.msstRecommendedSec,
      incident: incident ?? this.incident,
      recoveryNote: recoveryNote ?? this.recoveryNote,
      isMergedFromAutoSplit:
          isMergedFromAutoSplit ?? this.isMergedFromAutoSplit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (discipline.present) {
      map['discipline'] = Variable<String>(
        $DiveRepsTable.$converterdiscipline.toSql(discipline.value),
      );
    }
    if (performanceValue.present) {
      map['performance_value'] = Variable<double>(performanceValue.value);
    }
    if (performanceUnit.present) {
      map['performance_unit'] = Variable<String>(
        $DiveRepsTable.$converterperformanceUnit.toSql(performanceUnit.value),
      );
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (surfaceRestBeforeSec.present) {
      map['surface_rest_before_sec'] = Variable<int>(
        surfaceRestBeforeSec.value,
      );
    }
    if (msstRecommendedSec.present) {
      map['msst_recommended_sec'] = Variable<int>(msstRecommendedSec.value);
    }
    if (incident.present) {
      map['incident'] = Variable<String>(
        $DiveRepsTable.$converterincident.toSql(incident.value),
      );
    }
    if (recoveryNote.present) {
      map['recovery_note'] = Variable<String>(recoveryNote.value);
    }
    if (isMergedFromAutoSplit.present) {
      map['is_merged_from_auto_split'] = Variable<bool>(
        isMergedFromAutoSplit.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiveRepsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sequence: $sequence, ')
          ..write('discipline: $discipline, ')
          ..write('performanceValue: $performanceValue, ')
          ..write('performanceUnit: $performanceUnit, ')
          ..write('targetValue: $targetValue, ')
          ..write('surfaceRestBeforeSec: $surfaceRestBeforeSec, ')
          ..write('msstRecommendedSec: $msstRecommendedSec, ')
          ..write('incident: $incident, ')
          ..write('recoveryNote: $recoveryNote, ')
          ..write('isMergedFromAutoSplit: $isMergedFromAutoSplit')
          ..write(')'))
        .toString();
  }
}

class $DiveSitesTable extends DiveSites
    with TableInfo<$DiveSitesTable, DiveSite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiveSitesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitCountMeta = const VerificationMeta(
    'visitCount',
  );
  @override
  late final GeneratedColumn<int> visitCount = GeneratedColumn<int>(
    'visit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastVisitedAtMeta = const VerificationMeta(
    'lastVisitedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastVisitedAt =
      GeneratedColumn<DateTime>(
        'last_visited_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    lat,
    lon,
    visitCount,
    lastVisitedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dive_sites';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiveSite> instance, {
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
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('visit_count')) {
      context.handle(
        _visitCountMeta,
        visitCount.isAcceptableOrUnknown(data['visit_count']!, _visitCountMeta),
      );
    }
    if (data.containsKey('last_visited_at')) {
      context.handle(
        _lastVisitedAtMeta,
        lastVisitedAt.isAcceptableOrUnknown(
          data['last_visited_at']!,
          _lastVisitedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiveSite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiveSite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      visitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_count'],
      )!,
      lastVisitedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_visited_at'],
      ),
    );
  }

  @override
  $DiveSitesTable createAlias(String alias) {
    return $DiveSitesTable(attachedDatabase, alias);
  }
}

class DiveSite extends DataClass implements Insertable<DiveSite> {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final int visitCount;
  final DateTime? lastVisitedAt;
  const DiveSite({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.visitCount,
    this.lastVisitedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    map['visit_count'] = Variable<int>(visitCount);
    if (!nullToAbsent || lastVisitedAt != null) {
      map['last_visited_at'] = Variable<DateTime>(lastVisitedAt);
    }
    return map;
  }

  DiveSitesCompanion toCompanion(bool nullToAbsent) {
    return DiveSitesCompanion(
      id: Value(id),
      name: Value(name),
      lat: Value(lat),
      lon: Value(lon),
      visitCount: Value(visitCount),
      lastVisitedAt: lastVisitedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisitedAt),
    );
  }

  factory DiveSite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiveSite(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      visitCount: serializer.fromJson<int>(json['visitCount']),
      lastVisitedAt: serializer.fromJson<DateTime?>(json['lastVisitedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'visitCount': serializer.toJson<int>(visitCount),
      'lastVisitedAt': serializer.toJson<DateTime?>(lastVisitedAt),
    };
  }

  DiveSite copyWith({
    int? id,
    String? name,
    double? lat,
    double? lon,
    int? visitCount,
    Value<DateTime?> lastVisitedAt = const Value.absent(),
  }) => DiveSite(
    id: id ?? this.id,
    name: name ?? this.name,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    visitCount: visitCount ?? this.visitCount,
    lastVisitedAt: lastVisitedAt.present
        ? lastVisitedAt.value
        : this.lastVisitedAt,
  );
  DiveSite copyWithCompanion(DiveSitesCompanion data) {
    return DiveSite(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      visitCount: data.visitCount.present
          ? data.visitCount.value
          : this.visitCount,
      lastVisitedAt: data.lastVisitedAt.present
          ? data.lastVisitedAt.value
          : this.lastVisitedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiveSite(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('visitCount: $visitCount, ')
          ..write('lastVisitedAt: $lastVisitedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, lat, lon, visitCount, lastVisitedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiveSite &&
          other.id == this.id &&
          other.name == this.name &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.visitCount == this.visitCount &&
          other.lastVisitedAt == this.lastVisitedAt);
}

class DiveSitesCompanion extends UpdateCompanion<DiveSite> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> lat;
  final Value<double> lon;
  final Value<int> visitCount;
  final Value<DateTime?> lastVisitedAt;
  const DiveSitesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.lastVisitedAt = const Value.absent(),
  });
  DiveSitesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double lat,
    required double lon,
    this.visitCount = const Value.absent(),
    this.lastVisitedAt = const Value.absent(),
  }) : name = Value(name),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<DiveSite> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<int>? visitCount,
    Expression<DateTime>? lastVisitedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (visitCount != null) 'visit_count': visitCount,
      if (lastVisitedAt != null) 'last_visited_at': lastVisitedAt,
    });
  }

  DiveSitesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? lat,
    Value<double>? lon,
    Value<int>? visitCount,
    Value<DateTime?>? lastVisitedAt,
  }) {
    return DiveSitesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      visitCount: visitCount ?? this.visitCount,
      lastVisitedAt: lastVisitedAt ?? this.lastVisitedAt,
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
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (visitCount.present) {
      map['visit_count'] = Variable<int>(visitCount.value);
    }
    if (lastVisitedAt.present) {
      map['last_visited_at'] = Variable<DateTime>(lastVisitedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiveSitesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('visitCount: $visitCount, ')
          ..write('lastVisitedAt: $lastVisitedAt')
          ..write(')'))
        .toString();
  }
}

class $DiveBuddiesTable extends DiveBuddies
    with TableInfo<$DiveBuddiesTable, DiveBuddy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiveBuddiesTable(this.attachedDatabase, [this._alias]);
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
  List<GeneratedColumn> get $columns => [id, name, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dive_buddies';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiveBuddy> instance, {
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
  DiveBuddy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiveBuddy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $DiveBuddiesTable createAlias(String alias) {
    return $DiveBuddiesTable(attachedDatabase, alias);
  }
}

class DiveBuddy extends DataClass implements Insertable<DiveBuddy> {
  final int id;
  final String name;
  final String? note;
  const DiveBuddy({required this.id, required this.name, this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DiveBuddiesCompanion toCompanion(bool nullToAbsent) {
    return DiveBuddiesCompanion(
      id: Value(id),
      name: Value(name),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DiveBuddy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiveBuddy(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'note': serializer.toJson<String?>(note),
    };
  }

  DiveBuddy copyWith({
    int? id,
    String? name,
    Value<String?> note = const Value.absent(),
  }) => DiveBuddy(
    id: id ?? this.id,
    name: name ?? this.name,
    note: note.present ? note.value : this.note,
  );
  DiveBuddy copyWithCompanion(DiveBuddiesCompanion data) {
    return DiveBuddy(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiveBuddy(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiveBuddy &&
          other.id == this.id &&
          other.name == this.name &&
          other.note == this.note);
}

class DiveBuddiesCompanion extends UpdateCompanion<DiveBuddy> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> note;
  const DiveBuddiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
  });
  DiveBuddiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.note = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DiveBuddy> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
    });
  }

  DiveBuddiesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? note,
  }) {
    return DiveBuddiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
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
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiveBuddiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $GearPresetsTable extends GearPresets
    with TableInfo<$GearPresetsTable, GearPreset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GearPresetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suitThicknessMmMeta = const VerificationMeta(
    'suitThicknessMm',
  );
  @override
  late final GeneratedColumn<double> suitThicknessMm = GeneratedColumn<double>(
    'suit_thickness_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FinType?, String> finType =
      GeneratedColumn<String>(
        'fin_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<FinType?>($GearPresetsTable.$converterfinTypen);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    weightKg,
    suitThicknessMm,
    finType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gear_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<GearPreset> instance, {
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
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('suit_thickness_mm')) {
      context.handle(
        _suitThicknessMmMeta,
        suitThicknessMm.isAcceptableOrUnknown(
          data['suit_thickness_mm']!,
          _suitThicknessMmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GearPreset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GearPreset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      suitThicknessMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}suit_thickness_mm'],
      ),
      finType: $GearPresetsTable.$converterfinTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fin_type'],
        ),
      ),
    );
  }

  @override
  $GearPresetsTable createAlias(String alias) {
    return $GearPresetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FinType, String, String> $converterfinType =
      const EnumNameConverter<FinType>(FinType.values);
  static JsonTypeConverter2<FinType?, String?, String?> $converterfinTypen =
      JsonTypeConverter2.asNullable($converterfinType);
}

class GearPreset extends DataClass implements Insertable<GearPreset> {
  final int id;
  final String name;
  final double? weightKg;
  final double? suitThicknessMm;
  final FinType? finType;
  const GearPreset({
    required this.id,
    required this.name,
    this.weightKg,
    this.suitThicknessMm,
    this.finType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || suitThicknessMm != null) {
      map['suit_thickness_mm'] = Variable<double>(suitThicknessMm);
    }
    if (!nullToAbsent || finType != null) {
      map['fin_type'] = Variable<String>(
        $GearPresetsTable.$converterfinTypen.toSql(finType),
      );
    }
    return map;
  }

  GearPresetsCompanion toCompanion(bool nullToAbsent) {
    return GearPresetsCompanion(
      id: Value(id),
      name: Value(name),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      suitThicknessMm: suitThicknessMm == null && nullToAbsent
          ? const Value.absent()
          : Value(suitThicknessMm),
      finType: finType == null && nullToAbsent
          ? const Value.absent()
          : Value(finType),
    );
  }

  factory GearPreset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GearPreset(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      suitThicknessMm: serializer.fromJson<double?>(json['suitThicknessMm']),
      finType: $GearPresetsTable.$converterfinTypen.fromJson(
        serializer.fromJson<String?>(json['finType']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'weightKg': serializer.toJson<double?>(weightKg),
      'suitThicknessMm': serializer.toJson<double?>(suitThicknessMm),
      'finType': serializer.toJson<String?>(
        $GearPresetsTable.$converterfinTypen.toJson(finType),
      ),
    };
  }

  GearPreset copyWith({
    int? id,
    String? name,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> suitThicknessMm = const Value.absent(),
    Value<FinType?> finType = const Value.absent(),
  }) => GearPreset(
    id: id ?? this.id,
    name: name ?? this.name,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    suitThicknessMm: suitThicknessMm.present
        ? suitThicknessMm.value
        : this.suitThicknessMm,
    finType: finType.present ? finType.value : this.finType,
  );
  GearPreset copyWithCompanion(GearPresetsCompanion data) {
    return GearPreset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      suitThicknessMm: data.suitThicknessMm.present
          ? data.suitThicknessMm.value
          : this.suitThicknessMm,
      finType: data.finType.present ? data.finType.value : this.finType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GearPreset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weightKg: $weightKg, ')
          ..write('suitThicknessMm: $suitThicknessMm, ')
          ..write('finType: $finType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, weightKg, suitThicknessMm, finType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GearPreset &&
          other.id == this.id &&
          other.name == this.name &&
          other.weightKg == this.weightKg &&
          other.suitThicknessMm == this.suitThicknessMm &&
          other.finType == this.finType);
}

class GearPresetsCompanion extends UpdateCompanion<GearPreset> {
  final Value<int> id;
  final Value<String> name;
  final Value<double?> weightKg;
  final Value<double?> suitThicknessMm;
  final Value<FinType?> finType;
  const GearPresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.suitThicknessMm = const Value.absent(),
    this.finType = const Value.absent(),
  });
  GearPresetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.weightKg = const Value.absent(),
    this.suitThicknessMm = const Value.absent(),
    this.finType = const Value.absent(),
  }) : name = Value(name);
  static Insertable<GearPreset> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? weightKg,
    Expression<double>? suitThicknessMm,
    Expression<String>? finType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (weightKg != null) 'weight_kg': weightKg,
      if (suitThicknessMm != null) 'suit_thickness_mm': suitThicknessMm,
      if (finType != null) 'fin_type': finType,
    });
  }

  GearPresetsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double?>? weightKg,
    Value<double?>? suitThicknessMm,
    Value<FinType?>? finType,
  }) {
    return GearPresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      weightKg: weightKg ?? this.weightKg,
      suitThicknessMm: suitThicknessMm ?? this.suitThicknessMm,
      finType: finType ?? this.finType,
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
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (suitThicknessMm.present) {
      map['suit_thickness_mm'] = Variable<double>(suitThicknessMm.value);
    }
    if (finType.present) {
      map['fin_type'] = Variable<String>(
        $GearPresetsTable.$converterfinTypen.toSql(finType.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GearPresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weightKg: $weightKg, ')
          ..write('suitThicknessMm: $suitThicknessMm, ')
          ..write('finType: $finType')
          ..write(')'))
        .toString();
  }
}

class $MedicalDocsTable extends MedicalDocs
    with TableInfo<$MedicalDocsTable, MedicalDoc> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalDocsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _issuedAtMeta = const VerificationMeta(
    'issuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> issuedAt = GeneratedColumn<DateTime>(
    'issued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
    issuedAt,
    expiresAt,
    filePath,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_docs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalDoc> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('issued_at')) {
      context.handle(
        _issuedAtMeta,
        issuedAt.isAcceptableOrUnknown(data['issued_at']!, _issuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_issuedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
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
  MedicalDoc map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalDoc(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      issuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issued_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MedicalDocsTable createAlias(String alias) {
    return $MedicalDocsTable(attachedDatabase, alias);
  }
}

class MedicalDoc extends DataClass implements Insertable<MedicalDoc> {
  final int id;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final String filePath;
  final String? note;
  const MedicalDoc({
    required this.id,
    required this.issuedAt,
    this.expiresAt,
    required this.filePath,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['issued_at'] = Variable<DateTime>(issuedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MedicalDocsCompanion toCompanion(bool nullToAbsent) {
    return MedicalDocsCompanion(
      id: Value(id),
      issuedAt: Value(issuedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      filePath: Value(filePath),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MedicalDoc.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalDoc(
      id: serializer.fromJson<int>(json['id']),
      issuedAt: serializer.fromJson<DateTime>(json['issuedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      filePath: serializer.fromJson<String>(json['filePath']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'issuedAt': serializer.toJson<DateTime>(issuedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'filePath': serializer.toJson<String>(filePath),
      'note': serializer.toJson<String?>(note),
    };
  }

  MedicalDoc copyWith({
    int? id,
    DateTime? issuedAt,
    Value<DateTime?> expiresAt = const Value.absent(),
    String? filePath,
    Value<String?> note = const Value.absent(),
  }) => MedicalDoc(
    id: id ?? this.id,
    issuedAt: issuedAt ?? this.issuedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    filePath: filePath ?? this.filePath,
    note: note.present ? note.value : this.note,
  );
  MedicalDoc copyWithCompanion(MedicalDocsCompanion data) {
    return MedicalDoc(
      id: data.id.present ? data.id.value : this.id,
      issuedAt: data.issuedAt.present ? data.issuedAt.value : this.issuedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalDoc(')
          ..write('id: $id, ')
          ..write('issuedAt: $issuedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('filePath: $filePath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, issuedAt, expiresAt, filePath, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalDoc &&
          other.id == this.id &&
          other.issuedAt == this.issuedAt &&
          other.expiresAt == this.expiresAt &&
          other.filePath == this.filePath &&
          other.note == this.note);
}

class MedicalDocsCompanion extends UpdateCompanion<MedicalDoc> {
  final Value<int> id;
  final Value<DateTime> issuedAt;
  final Value<DateTime?> expiresAt;
  final Value<String> filePath;
  final Value<String?> note;
  const MedicalDocsCompanion({
    this.id = const Value.absent(),
    this.issuedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.filePath = const Value.absent(),
    this.note = const Value.absent(),
  });
  MedicalDocsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime issuedAt,
    this.expiresAt = const Value.absent(),
    required String filePath,
    this.note = const Value.absent(),
  }) : issuedAt = Value(issuedAt),
       filePath = Value(filePath);
  static Insertable<MedicalDoc> custom({
    Expression<int>? id,
    Expression<DateTime>? issuedAt,
    Expression<DateTime>? expiresAt,
    Expression<String>? filePath,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (issuedAt != null) 'issued_at': issuedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (filePath != null) 'file_path': filePath,
      if (note != null) 'note': note,
    });
  }

  MedicalDocsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? issuedAt,
    Value<DateTime?>? expiresAt,
    Value<String>? filePath,
    Value<String?>? note,
  }) {
    return MedicalDocsCompanion(
      id: id ?? this.id,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      filePath: filePath ?? this.filePath,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (issuedAt.present) {
      map['issued_at'] = Variable<DateTime>(issuedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalDocsCompanion(')
          ..write('id: $id, ')
          ..write('issuedAt: $issuedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('filePath: $filePath, ')
          ..write('note: $note')
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
  late final $SettingsTable settings = $SettingsTable(this);
  late final $DiveSessionsTable diveSessions = $DiveSessionsTable(this);
  late final $DiveRepsTable diveReps = $DiveRepsTable(this);
  late final $DiveSitesTable diveSites = $DiveSitesTable(this);
  late final $DiveBuddiesTable diveBuddies = $DiveBuddiesTable(this);
  late final $GearPresetsTable gearPresets = $GearPresetsTable(this);
  late final $MedicalDocsTable medicalDocs = $MedicalDocsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trainingTables,
    sessions,
    personalBests,
    settings,
    diveSessions,
    diveReps,
    diveSites,
    diveBuddies,
    gearPresets,
    medicalDocs,
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
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$DiveSessionsTableCreateCompanionBuilder =
    DiveSessionsCompanion Function({
      Value<int> id,
      required DateTime date,
      required SiteType siteType,
      Value<int?> siteId,
      required String siteName,
      Value<double?> lat,
      Value<double?> lon,
      required PurposeTag purposeTag,
      required DiveCondition condition,
      Value<int?> gearPresetId,
      required DiveGear gear,
      required List<int> buddyIds,
      Value<String?> leaderName,
      Value<int?> overallRating,
      required List<String> photoPaths,
      Value<String?> note,
      Value<int?> linkedTrainingSessionId,
    });
typedef $$DiveSessionsTableUpdateCompanionBuilder =
    DiveSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<SiteType> siteType,
      Value<int?> siteId,
      Value<String> siteName,
      Value<double?> lat,
      Value<double?> lon,
      Value<PurposeTag> purposeTag,
      Value<DiveCondition> condition,
      Value<int?> gearPresetId,
      Value<DiveGear> gear,
      Value<List<int>> buddyIds,
      Value<String?> leaderName,
      Value<int?> overallRating,
      Value<List<String>> photoPaths,
      Value<String?> note,
      Value<int?> linkedTrainingSessionId,
    });

final class $$DiveSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $DiveSessionsTable, DiveSession> {
  $$DiveSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DiveRepsTable, List<DiveRep>> _diveRepsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.diveReps,
    aliasName: 'dive_sessions__id__dive_reps__session_id',
  );

  $$DiveRepsTableProcessedTableManager get diveRepsRefs {
    final manager = $$DiveRepsTableTableManager(
      $_db,
      $_db.diveReps,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_diveRepsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiveSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $DiveSessionsTable> {
  $$DiveSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SiteType, SiteType, String> get siteType =>
      $composableBuilder(
        column: $table.siteType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteName => $composableBuilder(
    column: $table.siteName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PurposeTag, PurposeTag, String>
  get purposeTag => $composableBuilder(
    column: $table.purposeTag,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DiveCondition, DiveCondition, String>
  get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get gearPresetId => $composableBuilder(
    column: $table.gearPresetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DiveGear, DiveGear, String> get gear =>
      $composableBuilder(
        column: $table.gear,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get buddyIds =>
      $composableBuilder(
        column: $table.buddyIds,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get leaderName => $composableBuilder(
    column: $table.leaderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overallRating => $composableBuilder(
    column: $table.overallRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linkedTrainingSessionId => $composableBuilder(
    column: $table.linkedTrainingSessionId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> diveRepsRefs(
    Expression<bool> Function($$DiveRepsTableFilterComposer f) f,
  ) {
    final $$DiveRepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diveReps,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiveRepsTableFilterComposer(
            $db: $db,
            $table: $db.diveReps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiveSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiveSessionsTable> {
  $$DiveSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteType => $composableBuilder(
    column: $table.siteType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteName => $composableBuilder(
    column: $table.siteName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purposeTag => $composableBuilder(
    column: $table.purposeTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gearPresetId => $composableBuilder(
    column: $table.gearPresetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gear => $composableBuilder(
    column: $table.gear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buddyIds => $composableBuilder(
    column: $table.buddyIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaderName => $composableBuilder(
    column: $table.leaderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overallRating => $composableBuilder(
    column: $table.overallRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linkedTrainingSessionId => $composableBuilder(
    column: $table.linkedTrainingSessionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiveSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiveSessionsTable> {
  $$DiveSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SiteType, String> get siteType =>
      $composableBuilder(column: $table.siteType, builder: (column) => column);

  GeneratedColumn<int> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get siteName =>
      $composableBuilder(column: $table.siteName, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PurposeTag, String> get purposeTag =>
      $composableBuilder(
        column: $table.purposeTag,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DiveCondition, String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<int> get gearPresetId => $composableBuilder(
    column: $table.gearPresetId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DiveGear, String> get gear =>
      $composableBuilder(column: $table.gear, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get buddyIds =>
      $composableBuilder(column: $table.buddyIds, builder: (column) => column);

  GeneratedColumn<String> get leaderName => $composableBuilder(
    column: $table.leaderName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overallRating => $composableBuilder(
    column: $table.overallRating,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get photoPaths =>
      $composableBuilder(
        column: $table.photoPaths,
        builder: (column) => column,
      );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get linkedTrainingSessionId => $composableBuilder(
    column: $table.linkedTrainingSessionId,
    builder: (column) => column,
  );

  Expression<T> diveRepsRefs<T extends Object>(
    Expression<T> Function($$DiveRepsTableAnnotationComposer a) f,
  ) {
    final $$DiveRepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diveReps,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiveRepsTableAnnotationComposer(
            $db: $db,
            $table: $db.diveReps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiveSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiveSessionsTable,
          DiveSession,
          $$DiveSessionsTableFilterComposer,
          $$DiveSessionsTableOrderingComposer,
          $$DiveSessionsTableAnnotationComposer,
          $$DiveSessionsTableCreateCompanionBuilder,
          $$DiveSessionsTableUpdateCompanionBuilder,
          (DiveSession, $$DiveSessionsTableReferences),
          DiveSession,
          PrefetchHooks Function({bool diveRepsRefs})
        > {
  $$DiveSessionsTableTableManager(_$AppDatabase db, $DiveSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiveSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiveSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiveSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<SiteType> siteType = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
                Value<String> siteName = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                Value<PurposeTag> purposeTag = const Value.absent(),
                Value<DiveCondition> condition = const Value.absent(),
                Value<int?> gearPresetId = const Value.absent(),
                Value<DiveGear> gear = const Value.absent(),
                Value<List<int>> buddyIds = const Value.absent(),
                Value<String?> leaderName = const Value.absent(),
                Value<int?> overallRating = const Value.absent(),
                Value<List<String>> photoPaths = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> linkedTrainingSessionId = const Value.absent(),
              }) => DiveSessionsCompanion(
                id: id,
                date: date,
                siteType: siteType,
                siteId: siteId,
                siteName: siteName,
                lat: lat,
                lon: lon,
                purposeTag: purposeTag,
                condition: condition,
                gearPresetId: gearPresetId,
                gear: gear,
                buddyIds: buddyIds,
                leaderName: leaderName,
                overallRating: overallRating,
                photoPaths: photoPaths,
                note: note,
                linkedTrainingSessionId: linkedTrainingSessionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required SiteType siteType,
                Value<int?> siteId = const Value.absent(),
                required String siteName,
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                required PurposeTag purposeTag,
                required DiveCondition condition,
                Value<int?> gearPresetId = const Value.absent(),
                required DiveGear gear,
                required List<int> buddyIds,
                Value<String?> leaderName = const Value.absent(),
                Value<int?> overallRating = const Value.absent(),
                required List<String> photoPaths,
                Value<String?> note = const Value.absent(),
                Value<int?> linkedTrainingSessionId = const Value.absent(),
              }) => DiveSessionsCompanion.insert(
                id: id,
                date: date,
                siteType: siteType,
                siteId: siteId,
                siteName: siteName,
                lat: lat,
                lon: lon,
                purposeTag: purposeTag,
                condition: condition,
                gearPresetId: gearPresetId,
                gear: gear,
                buddyIds: buddyIds,
                leaderName: leaderName,
                overallRating: overallRating,
                photoPaths: photoPaths,
                note: note,
                linkedTrainingSessionId: linkedTrainingSessionId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiveSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diveRepsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (diveRepsRefs) db.diveReps],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (diveRepsRefs)
                    await $_getPrefetchedData<
                      DiveSession,
                      $DiveSessionsTable,
                      DiveRep
                    >(
                      currentTable: table,
                      referencedTable: $$DiveSessionsTableReferences
                          ._diveRepsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DiveSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).diveRepsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DiveSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiveSessionsTable,
      DiveSession,
      $$DiveSessionsTableFilterComposer,
      $$DiveSessionsTableOrderingComposer,
      $$DiveSessionsTableAnnotationComposer,
      $$DiveSessionsTableCreateCompanionBuilder,
      $$DiveSessionsTableUpdateCompanionBuilder,
      (DiveSession, $$DiveSessionsTableReferences),
      DiveSession,
      PrefetchHooks Function({bool diveRepsRefs})
    >;
typedef $$DiveRepsTableCreateCompanionBuilder =
    DiveRepsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int sequence,
      required Discipline discipline,
      required double performanceValue,
      required PerformanceUnit performanceUnit,
      Value<double?> targetValue,
      Value<int?> surfaceRestBeforeSec,
      Value<int?> msstRecommendedSec,
      required IncidentType incident,
      Value<String?> recoveryNote,
      Value<bool> isMergedFromAutoSplit,
    });
typedef $$DiveRepsTableUpdateCompanionBuilder =
    DiveRepsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> sequence,
      Value<Discipline> discipline,
      Value<double> performanceValue,
      Value<PerformanceUnit> performanceUnit,
      Value<double?> targetValue,
      Value<int?> surfaceRestBeforeSec,
      Value<int?> msstRecommendedSec,
      Value<IncidentType> incident,
      Value<String?> recoveryNote,
      Value<bool> isMergedFromAutoSplit,
    });

final class $$DiveRepsTableReferences
    extends BaseReferences<_$AppDatabase, $DiveRepsTable, DiveRep> {
  $$DiveRepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiveSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.diveSessions.createAlias('dive_reps__session_id__dive_sessions__id');

  $$DiveSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$DiveSessionsTableTableManager(
      $_db,
      $_db.diveSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiveRepsTableFilterComposer
    extends Composer<_$AppDatabase, $DiveRepsTable> {
  $$DiveRepsTableFilterComposer({
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

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Discipline, Discipline, String>
  get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get performanceValue => $composableBuilder(
    column: $table.performanceValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PerformanceUnit, PerformanceUnit, String>
  get performanceUnit => $composableBuilder(
    column: $table.performanceUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surfaceRestBeforeSec => $composableBuilder(
    column: $table.surfaceRestBeforeSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get msstRecommendedSec => $composableBuilder(
    column: $table.msstRecommendedSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IncidentType, IncidentType, String>
  get incident => $composableBuilder(
    column: $table.incident,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get recoveryNote => $composableBuilder(
    column: $table.recoveryNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMergedFromAutoSplit => $composableBuilder(
    column: $table.isMergedFromAutoSplit,
    builder: (column) => ColumnFilters(column),
  );

  $$DiveSessionsTableFilterComposer get sessionId {
    final $$DiveSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.diveSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiveSessionsTableFilterComposer(
            $db: $db,
            $table: $db.diveSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiveRepsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiveRepsTable> {
  $$DiveRepsTableOrderingComposer({
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

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get performanceValue => $composableBuilder(
    column: $table.performanceValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performanceUnit => $composableBuilder(
    column: $table.performanceUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surfaceRestBeforeSec => $composableBuilder(
    column: $table.surfaceRestBeforeSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get msstRecommendedSec => $composableBuilder(
    column: $table.msstRecommendedSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incident => $composableBuilder(
    column: $table.incident,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recoveryNote => $composableBuilder(
    column: $table.recoveryNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMergedFromAutoSplit => $composableBuilder(
    column: $table.isMergedFromAutoSplit,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiveSessionsTableOrderingComposer get sessionId {
    final $$DiveSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.diveSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiveSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.diveSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiveRepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiveRepsTable> {
  $$DiveRepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Discipline, String> get discipline =>
      $composableBuilder(
        column: $table.discipline,
        builder: (column) => column,
      );

  GeneratedColumn<double> get performanceValue => $composableBuilder(
    column: $table.performanceValue,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PerformanceUnit, String>
  get performanceUnit => $composableBuilder(
    column: $table.performanceUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get surfaceRestBeforeSec => $composableBuilder(
    column: $table.surfaceRestBeforeSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get msstRecommendedSec => $composableBuilder(
    column: $table.msstRecommendedSec,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IncidentType, String> get incident =>
      $composableBuilder(column: $table.incident, builder: (column) => column);

  GeneratedColumn<String> get recoveryNote => $composableBuilder(
    column: $table.recoveryNote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMergedFromAutoSplit => $composableBuilder(
    column: $table.isMergedFromAutoSplit,
    builder: (column) => column,
  );

  $$DiveSessionsTableAnnotationComposer get sessionId {
    final $$DiveSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.diveSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiveSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.diveSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiveRepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiveRepsTable,
          DiveRep,
          $$DiveRepsTableFilterComposer,
          $$DiveRepsTableOrderingComposer,
          $$DiveRepsTableAnnotationComposer,
          $$DiveRepsTableCreateCompanionBuilder,
          $$DiveRepsTableUpdateCompanionBuilder,
          (DiveRep, $$DiveRepsTableReferences),
          DiveRep,
          PrefetchHooks Function({bool sessionId})
        > {
  $$DiveRepsTableTableManager(_$AppDatabase db, $DiveRepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiveRepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiveRepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiveRepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<Discipline> discipline = const Value.absent(),
                Value<double> performanceValue = const Value.absent(),
                Value<PerformanceUnit> performanceUnit = const Value.absent(),
                Value<double?> targetValue = const Value.absent(),
                Value<int?> surfaceRestBeforeSec = const Value.absent(),
                Value<int?> msstRecommendedSec = const Value.absent(),
                Value<IncidentType> incident = const Value.absent(),
                Value<String?> recoveryNote = const Value.absent(),
                Value<bool> isMergedFromAutoSplit = const Value.absent(),
              }) => DiveRepsCompanion(
                id: id,
                sessionId: sessionId,
                sequence: sequence,
                discipline: discipline,
                performanceValue: performanceValue,
                performanceUnit: performanceUnit,
                targetValue: targetValue,
                surfaceRestBeforeSec: surfaceRestBeforeSec,
                msstRecommendedSec: msstRecommendedSec,
                incident: incident,
                recoveryNote: recoveryNote,
                isMergedFromAutoSplit: isMergedFromAutoSplit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int sequence,
                required Discipline discipline,
                required double performanceValue,
                required PerformanceUnit performanceUnit,
                Value<double?> targetValue = const Value.absent(),
                Value<int?> surfaceRestBeforeSec = const Value.absent(),
                Value<int?> msstRecommendedSec = const Value.absent(),
                required IncidentType incident,
                Value<String?> recoveryNote = const Value.absent(),
                Value<bool> isMergedFromAutoSplit = const Value.absent(),
              }) => DiveRepsCompanion.insert(
                id: id,
                sessionId: sessionId,
                sequence: sequence,
                discipline: discipline,
                performanceValue: performanceValue,
                performanceUnit: performanceUnit,
                targetValue: targetValue,
                surfaceRestBeforeSec: surfaceRestBeforeSec,
                msstRecommendedSec: msstRecommendedSec,
                incident: incident,
                recoveryNote: recoveryNote,
                isMergedFromAutoSplit: isMergedFromAutoSplit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiveRepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$DiveRepsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$DiveRepsTableReferences
                                    ._sessionIdTable(db)
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

typedef $$DiveRepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiveRepsTable,
      DiveRep,
      $$DiveRepsTableFilterComposer,
      $$DiveRepsTableOrderingComposer,
      $$DiveRepsTableAnnotationComposer,
      $$DiveRepsTableCreateCompanionBuilder,
      $$DiveRepsTableUpdateCompanionBuilder,
      (DiveRep, $$DiveRepsTableReferences),
      DiveRep,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$DiveSitesTableCreateCompanionBuilder =
    DiveSitesCompanion Function({
      Value<int> id,
      required String name,
      required double lat,
      required double lon,
      Value<int> visitCount,
      Value<DateTime?> lastVisitedAt,
    });
typedef $$DiveSitesTableUpdateCompanionBuilder =
    DiveSitesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> lat,
      Value<double> lon,
      Value<int> visitCount,
      Value<DateTime?> lastVisitedAt,
    });

class $$DiveSitesTableFilterComposer
    extends Composer<_$AppDatabase, $DiveSitesTable> {
  $$DiveSitesTableFilterComposer({
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

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVisitedAt => $composableBuilder(
    column: $table.lastVisitedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiveSitesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiveSitesTable> {
  $$DiveSitesTableOrderingComposer({
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

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVisitedAt => $composableBuilder(
    column: $table.lastVisitedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiveSitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiveSitesTable> {
  $$DiveSitesTableAnnotationComposer({
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

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVisitedAt => $composableBuilder(
    column: $table.lastVisitedAt,
    builder: (column) => column,
  );
}

class $$DiveSitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiveSitesTable,
          DiveSite,
          $$DiveSitesTableFilterComposer,
          $$DiveSitesTableOrderingComposer,
          $$DiveSitesTableAnnotationComposer,
          $$DiveSitesTableCreateCompanionBuilder,
          $$DiveSitesTableUpdateCompanionBuilder,
          (DiveSite, BaseReferences<_$AppDatabase, $DiveSitesTable, DiveSite>),
          DiveSite,
          PrefetchHooks Function()
        > {
  $$DiveSitesTableTableManager(_$AppDatabase db, $DiveSitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiveSitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiveSitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiveSitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<int> visitCount = const Value.absent(),
                Value<DateTime?> lastVisitedAt = const Value.absent(),
              }) => DiveSitesCompanion(
                id: id,
                name: name,
                lat: lat,
                lon: lon,
                visitCount: visitCount,
                lastVisitedAt: lastVisitedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double lat,
                required double lon,
                Value<int> visitCount = const Value.absent(),
                Value<DateTime?> lastVisitedAt = const Value.absent(),
              }) => DiveSitesCompanion.insert(
                id: id,
                name: name,
                lat: lat,
                lon: lon,
                visitCount: visitCount,
                lastVisitedAt: lastVisitedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiveSitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiveSitesTable,
      DiveSite,
      $$DiveSitesTableFilterComposer,
      $$DiveSitesTableOrderingComposer,
      $$DiveSitesTableAnnotationComposer,
      $$DiveSitesTableCreateCompanionBuilder,
      $$DiveSitesTableUpdateCompanionBuilder,
      (DiveSite, BaseReferences<_$AppDatabase, $DiveSitesTable, DiveSite>),
      DiveSite,
      PrefetchHooks Function()
    >;
typedef $$DiveBuddiesTableCreateCompanionBuilder =
    DiveBuddiesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> note,
    });
typedef $$DiveBuddiesTableUpdateCompanionBuilder =
    DiveBuddiesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> note,
    });

class $$DiveBuddiesTableFilterComposer
    extends Composer<_$AppDatabase, $DiveBuddiesTable> {
  $$DiveBuddiesTableFilterComposer({
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiveBuddiesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiveBuddiesTable> {
  $$DiveBuddiesTableOrderingComposer({
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiveBuddiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiveBuddiesTable> {
  $$DiveBuddiesTableAnnotationComposer({
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

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$DiveBuddiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiveBuddiesTable,
          DiveBuddy,
          $$DiveBuddiesTableFilterComposer,
          $$DiveBuddiesTableOrderingComposer,
          $$DiveBuddiesTableAnnotationComposer,
          $$DiveBuddiesTableCreateCompanionBuilder,
          $$DiveBuddiesTableUpdateCompanionBuilder,
          (
            DiveBuddy,
            BaseReferences<_$AppDatabase, $DiveBuddiesTable, DiveBuddy>,
          ),
          DiveBuddy,
          PrefetchHooks Function()
        > {
  $$DiveBuddiesTableTableManager(_$AppDatabase db, $DiveBuddiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiveBuddiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiveBuddiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiveBuddiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => DiveBuddiesCompanion(id: id, name: name, note: note),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> note = const Value.absent(),
              }) => DiveBuddiesCompanion.insert(id: id, name: name, note: note),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiveBuddiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiveBuddiesTable,
      DiveBuddy,
      $$DiveBuddiesTableFilterComposer,
      $$DiveBuddiesTableOrderingComposer,
      $$DiveBuddiesTableAnnotationComposer,
      $$DiveBuddiesTableCreateCompanionBuilder,
      $$DiveBuddiesTableUpdateCompanionBuilder,
      (DiveBuddy, BaseReferences<_$AppDatabase, $DiveBuddiesTable, DiveBuddy>),
      DiveBuddy,
      PrefetchHooks Function()
    >;
typedef $$GearPresetsTableCreateCompanionBuilder =
    GearPresetsCompanion Function({
      Value<int> id,
      required String name,
      Value<double?> weightKg,
      Value<double?> suitThicknessMm,
      Value<FinType?> finType,
    });
typedef $$GearPresetsTableUpdateCompanionBuilder =
    GearPresetsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double?> weightKg,
      Value<double?> suitThicknessMm,
      Value<FinType?> finType,
    });

class $$GearPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $GearPresetsTable> {
  $$GearPresetsTableFilterComposer({
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

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get suitThicknessMm => $composableBuilder(
    column: $table.suitThicknessMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FinType?, FinType, String> get finType =>
      $composableBuilder(
        column: $table.finType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$GearPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $GearPresetsTable> {
  $$GearPresetsTableOrderingComposer({
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

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get suitThicknessMm => $composableBuilder(
    column: $table.suitThicknessMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finType => $composableBuilder(
    column: $table.finType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GearPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GearPresetsTable> {
  $$GearPresetsTableAnnotationComposer({
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

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get suitThicknessMm => $composableBuilder(
    column: $table.suitThicknessMm,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FinType?, String> get finType =>
      $composableBuilder(column: $table.finType, builder: (column) => column);
}

class $$GearPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GearPresetsTable,
          GearPreset,
          $$GearPresetsTableFilterComposer,
          $$GearPresetsTableOrderingComposer,
          $$GearPresetsTableAnnotationComposer,
          $$GearPresetsTableCreateCompanionBuilder,
          $$GearPresetsTableUpdateCompanionBuilder,
          (
            GearPreset,
            BaseReferences<_$AppDatabase, $GearPresetsTable, GearPreset>,
          ),
          GearPreset,
          PrefetchHooks Function()
        > {
  $$GearPresetsTableTableManager(_$AppDatabase db, $GearPresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GearPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GearPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GearPresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> suitThicknessMm = const Value.absent(),
                Value<FinType?> finType = const Value.absent(),
              }) => GearPresetsCompanion(
                id: id,
                name: name,
                weightKg: weightKg,
                suitThicknessMm: suitThicknessMm,
                finType: finType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<double?> weightKg = const Value.absent(),
                Value<double?> suitThicknessMm = const Value.absent(),
                Value<FinType?> finType = const Value.absent(),
              }) => GearPresetsCompanion.insert(
                id: id,
                name: name,
                weightKg: weightKg,
                suitThicknessMm: suitThicknessMm,
                finType: finType,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GearPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GearPresetsTable,
      GearPreset,
      $$GearPresetsTableFilterComposer,
      $$GearPresetsTableOrderingComposer,
      $$GearPresetsTableAnnotationComposer,
      $$GearPresetsTableCreateCompanionBuilder,
      $$GearPresetsTableUpdateCompanionBuilder,
      (
        GearPreset,
        BaseReferences<_$AppDatabase, $GearPresetsTable, GearPreset>,
      ),
      GearPreset,
      PrefetchHooks Function()
    >;
typedef $$MedicalDocsTableCreateCompanionBuilder =
    MedicalDocsCompanion Function({
      Value<int> id,
      required DateTime issuedAt,
      Value<DateTime?> expiresAt,
      required String filePath,
      Value<String?> note,
    });
typedef $$MedicalDocsTableUpdateCompanionBuilder =
    MedicalDocsCompanion Function({
      Value<int> id,
      Value<DateTime> issuedAt,
      Value<DateTime?> expiresAt,
      Value<String> filePath,
      Value<String?> note,
    });

class $$MedicalDocsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalDocsTable> {
  $$MedicalDocsTableFilterComposer({
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

  ColumnFilters<DateTime> get issuedAt => $composableBuilder(
    column: $table.issuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicalDocsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalDocsTable> {
  $$MedicalDocsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get issuedAt => $composableBuilder(
    column: $table.issuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicalDocsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalDocsTable> {
  $$MedicalDocsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get issuedAt =>
      $composableBuilder(column: $table.issuedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MedicalDocsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalDocsTable,
          MedicalDoc,
          $$MedicalDocsTableFilterComposer,
          $$MedicalDocsTableOrderingComposer,
          $$MedicalDocsTableAnnotationComposer,
          $$MedicalDocsTableCreateCompanionBuilder,
          $$MedicalDocsTableUpdateCompanionBuilder,
          (
            MedicalDoc,
            BaseReferences<_$AppDatabase, $MedicalDocsTable, MedicalDoc>,
          ),
          MedicalDoc,
          PrefetchHooks Function()
        > {
  $$MedicalDocsTableTableManager(_$AppDatabase db, $MedicalDocsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalDocsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalDocsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalDocsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> issuedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => MedicalDocsCompanion(
                id: id,
                issuedAt: issuedAt,
                expiresAt: expiresAt,
                filePath: filePath,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime issuedAt,
                Value<DateTime?> expiresAt = const Value.absent(),
                required String filePath,
                Value<String?> note = const Value.absent(),
              }) => MedicalDocsCompanion.insert(
                id: id,
                issuedAt: issuedAt,
                expiresAt: expiresAt,
                filePath: filePath,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicalDocsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalDocsTable,
      MedicalDoc,
      $$MedicalDocsTableFilterComposer,
      $$MedicalDocsTableOrderingComposer,
      $$MedicalDocsTableAnnotationComposer,
      $$MedicalDocsTableCreateCompanionBuilder,
      $$MedicalDocsTableUpdateCompanionBuilder,
      (
        MedicalDoc,
        BaseReferences<_$AppDatabase, $MedicalDocsTable, MedicalDoc>,
      ),
      MedicalDoc,
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
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$DiveSessionsTableTableManager get diveSessions =>
      $$DiveSessionsTableTableManager(_db, _db.diveSessions);
  $$DiveRepsTableTableManager get diveReps =>
      $$DiveRepsTableTableManager(_db, _db.diveReps);
  $$DiveSitesTableTableManager get diveSites =>
      $$DiveSitesTableTableManager(_db, _db.diveSites);
  $$DiveBuddiesTableTableManager get diveBuddies =>
      $$DiveBuddiesTableTableManager(_db, _db.diveBuddies);
  $$GearPresetsTableTableManager get gearPresets =>
      $$GearPresetsTableTableManager(_db, _db.gearPresets);
  $$MedicalDocsTableTableManager get medicalDocs =>
      $$MedicalDocsTableTableManager(_db, _db.medicalDocs);
}
