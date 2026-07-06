// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PersonalityTraitsTable extends PersonalityTraits
    with TableInfo<$PersonalityTraitsTable, PersonalityTrait> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalityTraitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _traitNameMeta =
      const VerificationMeta('traitName');
  @override
  late final GeneratedColumn<String> traitName = GeneratedColumn<String>(
      'trait_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chemistryModifierMeta =
      const VerificationMeta('chemistryModifier');
  @override
  late final GeneratedColumn<int> chemistryModifier = GeneratedColumn<int>(
      'chemistry_modifier', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _moodDecayRateMeta =
      const VerificationMeta('moodDecayRate');
  @override
  late final GeneratedColumn<double> moodDecayRate = GeneratedColumn<double>(
      'mood_decay_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _scandalChanceModifierMeta =
      const VerificationMeta('scandalChanceModifier');
  @override
  late final GeneratedColumn<double> scandalChanceModifier =
      GeneratedColumn<double>('scandal_chance_modifier', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(1.0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        traitName,
        description,
        chemistryModifier,
        moodDecayRate,
        scandalChanceModifier
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personality_traits';
  @override
  VerificationContext validateIntegrity(Insertable<PersonalityTrait> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trait_name')) {
      context.handle(_traitNameMeta,
          traitName.isAcceptableOrUnknown(data['trait_name']!, _traitNameMeta));
    } else if (isInserting) {
      context.missing(_traitNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('chemistry_modifier')) {
      context.handle(
          _chemistryModifierMeta,
          chemistryModifier.isAcceptableOrUnknown(
              data['chemistry_modifier']!, _chemistryModifierMeta));
    }
    if (data.containsKey('mood_decay_rate')) {
      context.handle(
          _moodDecayRateMeta,
          moodDecayRate.isAcceptableOrUnknown(
              data['mood_decay_rate']!, _moodDecayRateMeta));
    }
    if (data.containsKey('scandal_chance_modifier')) {
      context.handle(
          _scandalChanceModifierMeta,
          scandalChanceModifier.isAcceptableOrUnknown(
              data['scandal_chance_modifier']!, _scandalChanceModifierMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalityTrait map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalityTrait(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      traitName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trait_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      chemistryModifier: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}chemistry_modifier'])!,
      moodDecayRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}mood_decay_rate'])!,
      scandalChanceModifier: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}scandal_chance_modifier'])!,
    );
  }

  @override
  $PersonalityTraitsTable createAlias(String alias) {
    return $PersonalityTraitsTable(attachedDatabase, alias);
  }
}

class PersonalityTrait extends DataClass
    implements Insertable<PersonalityTrait> {
  final int id;
  final String traitName;
  final String? description;
  final int chemistryModifier;
  final double moodDecayRate;
  final double scandalChanceModifier;
  const PersonalityTrait(
      {required this.id,
      required this.traitName,
      this.description,
      required this.chemistryModifier,
      required this.moodDecayRate,
      required this.scandalChanceModifier});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trait_name'] = Variable<String>(traitName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['chemistry_modifier'] = Variable<int>(chemistryModifier);
    map['mood_decay_rate'] = Variable<double>(moodDecayRate);
    map['scandal_chance_modifier'] = Variable<double>(scandalChanceModifier);
    return map;
  }

  PersonalityTraitsCompanion toCompanion(bool nullToAbsent) {
    return PersonalityTraitsCompanion(
      id: Value(id),
      traitName: Value(traitName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      chemistryModifier: Value(chemistryModifier),
      moodDecayRate: Value(moodDecayRate),
      scandalChanceModifier: Value(scandalChanceModifier),
    );
  }

  factory PersonalityTrait.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalityTrait(
      id: serializer.fromJson<int>(json['id']),
      traitName: serializer.fromJson<String>(json['traitName']),
      description: serializer.fromJson<String?>(json['description']),
      chemistryModifier: serializer.fromJson<int>(json['chemistryModifier']),
      moodDecayRate: serializer.fromJson<double>(json['moodDecayRate']),
      scandalChanceModifier:
          serializer.fromJson<double>(json['scandalChanceModifier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'traitName': serializer.toJson<String>(traitName),
      'description': serializer.toJson<String?>(description),
      'chemistryModifier': serializer.toJson<int>(chemistryModifier),
      'moodDecayRate': serializer.toJson<double>(moodDecayRate),
      'scandalChanceModifier': serializer.toJson<double>(scandalChanceModifier),
    };
  }

  PersonalityTrait copyWith(
          {int? id,
          String? traitName,
          Value<String?> description = const Value.absent(),
          int? chemistryModifier,
          double? moodDecayRate,
          double? scandalChanceModifier}) =>
      PersonalityTrait(
        id: id ?? this.id,
        traitName: traitName ?? this.traitName,
        description: description.present ? description.value : this.description,
        chemistryModifier: chemistryModifier ?? this.chemistryModifier,
        moodDecayRate: moodDecayRate ?? this.moodDecayRate,
        scandalChanceModifier:
            scandalChanceModifier ?? this.scandalChanceModifier,
      );
  PersonalityTrait copyWithCompanion(PersonalityTraitsCompanion data) {
    return PersonalityTrait(
      id: data.id.present ? data.id.value : this.id,
      traitName: data.traitName.present ? data.traitName.value : this.traitName,
      description:
          data.description.present ? data.description.value : this.description,
      chemistryModifier: data.chemistryModifier.present
          ? data.chemistryModifier.value
          : this.chemistryModifier,
      moodDecayRate: data.moodDecayRate.present
          ? data.moodDecayRate.value
          : this.moodDecayRate,
      scandalChanceModifier: data.scandalChanceModifier.present
          ? data.scandalChanceModifier.value
          : this.scandalChanceModifier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalityTrait(')
          ..write('id: $id, ')
          ..write('traitName: $traitName, ')
          ..write('description: $description, ')
          ..write('chemistryModifier: $chemistryModifier, ')
          ..write('moodDecayRate: $moodDecayRate, ')
          ..write('scandalChanceModifier: $scandalChanceModifier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, traitName, description, chemistryModifier,
      moodDecayRate, scandalChanceModifier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalityTrait &&
          other.id == this.id &&
          other.traitName == this.traitName &&
          other.description == this.description &&
          other.chemistryModifier == this.chemistryModifier &&
          other.moodDecayRate == this.moodDecayRate &&
          other.scandalChanceModifier == this.scandalChanceModifier);
}

class PersonalityTraitsCompanion extends UpdateCompanion<PersonalityTrait> {
  final Value<int> id;
  final Value<String> traitName;
  final Value<String?> description;
  final Value<int> chemistryModifier;
  final Value<double> moodDecayRate;
  final Value<double> scandalChanceModifier;
  const PersonalityTraitsCompanion({
    this.id = const Value.absent(),
    this.traitName = const Value.absent(),
    this.description = const Value.absent(),
    this.chemistryModifier = const Value.absent(),
    this.moodDecayRate = const Value.absent(),
    this.scandalChanceModifier = const Value.absent(),
  });
  PersonalityTraitsCompanion.insert({
    this.id = const Value.absent(),
    required String traitName,
    this.description = const Value.absent(),
    this.chemistryModifier = const Value.absent(),
    this.moodDecayRate = const Value.absent(),
    this.scandalChanceModifier = const Value.absent(),
  }) : traitName = Value(traitName);
  static Insertable<PersonalityTrait> custom({
    Expression<int>? id,
    Expression<String>? traitName,
    Expression<String>? description,
    Expression<int>? chemistryModifier,
    Expression<double>? moodDecayRate,
    Expression<double>? scandalChanceModifier,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (traitName != null) 'trait_name': traitName,
      if (description != null) 'description': description,
      if (chemistryModifier != null) 'chemistry_modifier': chemistryModifier,
      if (moodDecayRate != null) 'mood_decay_rate': moodDecayRate,
      if (scandalChanceModifier != null)
        'scandal_chance_modifier': scandalChanceModifier,
    });
  }

  PersonalityTraitsCompanion copyWith(
      {Value<int>? id,
      Value<String>? traitName,
      Value<String?>? description,
      Value<int>? chemistryModifier,
      Value<double>? moodDecayRate,
      Value<double>? scandalChanceModifier}) {
    return PersonalityTraitsCompanion(
      id: id ?? this.id,
      traitName: traitName ?? this.traitName,
      description: description ?? this.description,
      chemistryModifier: chemistryModifier ?? this.chemistryModifier,
      moodDecayRate: moodDecayRate ?? this.moodDecayRate,
      scandalChanceModifier:
          scandalChanceModifier ?? this.scandalChanceModifier,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (traitName.present) {
      map['trait_name'] = Variable<String>(traitName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (chemistryModifier.present) {
      map['chemistry_modifier'] = Variable<int>(chemistryModifier.value);
    }
    if (moodDecayRate.present) {
      map['mood_decay_rate'] = Variable<double>(moodDecayRate.value);
    }
    if (scandalChanceModifier.present) {
      map['scandal_chance_modifier'] =
          Variable<double>(scandalChanceModifier.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalityTraitsCompanion(')
          ..write('id: $id, ')
          ..write('traitName: $traitName, ')
          ..write('description: $description, ')
          ..write('chemistryModifier: $chemistryModifier, ')
          ..write('moodDecayRate: $moodDecayRate, ')
          ..write('scandalChanceModifier: $scandalChanceModifier')
          ..write(')'))
        .toString();
  }
}

class $NamePoolTable extends NamePool
    with TableInfo<$NamePoolTable, NamePoolData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NamePoolTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'name_pool';
  @override
  VerificationContext validateIntegrity(Insertable<NamePoolData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NamePoolData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NamePoolData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $NamePoolTable createAlias(String alias) {
    return $NamePoolTable(attachedDatabase, alias);
  }
}

class NamePoolData extends DataClass implements Insertable<NamePoolData> {
  final int id;
  final String name;
  const NamePoolData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  NamePoolCompanion toCompanion(bool nullToAbsent) {
    return NamePoolCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory NamePoolData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NamePoolData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  NamePoolData copyWith({int? id, String? name}) => NamePoolData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  NamePoolData copyWithCompanion(NamePoolCompanion data) {
    return NamePoolData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NamePoolData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NamePoolData && other.id == this.id && other.name == this.name);
}

class NamePoolCompanion extends UpdateCompanion<NamePoolData> {
  final Value<int> id;
  final Value<String> name;
  const NamePoolCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  NamePoolCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<NamePoolData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  NamePoolCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return NamePoolCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NamePoolCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $TagPoolTable extends TagPool with TableInfo<$TagPoolTable, TagPoolData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagPoolTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, category, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_pool';
  @override
  VerificationContext validateIntegrity(Insertable<TagPoolData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagPoolData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagPoolData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $TagPoolTable createAlias(String alias) {
    return $TagPoolTable(attachedDatabase, alias);
  }
}

class TagPoolData extends DataClass implements Insertable<TagPoolData> {
  final int id;
  final String category;
  final String value;
  const TagPoolData(
      {required this.id, required this.category, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['value'] = Variable<String>(value);
    return map;
  }

  TagPoolCompanion toCompanion(bool nullToAbsent) {
    return TagPoolCompanion(
      id: Value(id),
      category: Value(category),
      value: Value(value),
    );
  }

  factory TagPoolData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagPoolData(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'value': serializer.toJson<String>(value),
    };
  }

  TagPoolData copyWith({int? id, String? category, String? value}) =>
      TagPoolData(
        id: id ?? this.id,
        category: category ?? this.category,
        value: value ?? this.value,
      );
  TagPoolData copyWithCompanion(TagPoolCompanion data) {
    return TagPoolData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagPoolData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagPoolData &&
          other.id == this.id &&
          other.category == this.category &&
          other.value == this.value);
}

class TagPoolCompanion extends UpdateCompanion<TagPoolData> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> value;
  const TagPoolCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.value = const Value.absent(),
  });
  TagPoolCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String value,
  })  : category = Value(category),
        value = Value(value);
  static Insertable<TagPoolData> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (value != null) 'value': value,
    });
  }

  TagPoolCompanion copyWith(
      {Value<int>? id, Value<String>? category, Value<String>? value}) {
    return TagPoolCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagPoolCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $RarityTiersTable extends RarityTiers
    with TableInfo<$RarityTiersTable, RarityTier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RarityTiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rarityNameMeta =
      const VerificationMeta('rarityName');
  @override
  late final GeneratedColumn<String> rarityName = GeneratedColumn<String>(
      'rarity_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _statMinMeta =
      const VerificationMeta('statMin');
  @override
  late final GeneratedColumn<int> statMin = GeneratedColumn<int>(
      'stat_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statMaxMeta =
      const VerificationMeta('statMax');
  @override
  late final GeneratedColumn<int> statMax = GeneratedColumn<int>(
      'stat_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _poolWeightMeta =
      const VerificationMeta('poolWeight');
  @override
  late final GeneratedColumn<double> poolWeight = GeneratedColumn<double>(
      'pool_weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, rarityName, statMin, statMax, poolWeight];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rarity_tiers';
  @override
  VerificationContext validateIntegrity(Insertable<RarityTier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rarity_name')) {
      context.handle(
          _rarityNameMeta,
          rarityName.isAcceptableOrUnknown(
              data['rarity_name']!, _rarityNameMeta));
    } else if (isInserting) {
      context.missing(_rarityNameMeta);
    }
    if (data.containsKey('stat_min')) {
      context.handle(_statMinMeta,
          statMin.isAcceptableOrUnknown(data['stat_min']!, _statMinMeta));
    } else if (isInserting) {
      context.missing(_statMinMeta);
    }
    if (data.containsKey('stat_max')) {
      context.handle(_statMaxMeta,
          statMax.isAcceptableOrUnknown(data['stat_max']!, _statMaxMeta));
    } else if (isInserting) {
      context.missing(_statMaxMeta);
    }
    if (data.containsKey('pool_weight')) {
      context.handle(
          _poolWeightMeta,
          poolWeight.isAcceptableOrUnknown(
              data['pool_weight']!, _poolWeightMeta));
    } else if (isInserting) {
      context.missing(_poolWeightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RarityTier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RarityTier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      rarityName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity_name'])!,
      statMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stat_min'])!,
      statMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stat_max'])!,
      poolWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pool_weight'])!,
    );
  }

  @override
  $RarityTiersTable createAlias(String alias) {
    return $RarityTiersTable(attachedDatabase, alias);
  }
}

class RarityTier extends DataClass implements Insertable<RarityTier> {
  final int id;
  final String rarityName;
  final int statMin;
  final int statMax;
  final double poolWeight;
  const RarityTier(
      {required this.id,
      required this.rarityName,
      required this.statMin,
      required this.statMax,
      required this.poolWeight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rarity_name'] = Variable<String>(rarityName);
    map['stat_min'] = Variable<int>(statMin);
    map['stat_max'] = Variable<int>(statMax);
    map['pool_weight'] = Variable<double>(poolWeight);
    return map;
  }

  RarityTiersCompanion toCompanion(bool nullToAbsent) {
    return RarityTiersCompanion(
      id: Value(id),
      rarityName: Value(rarityName),
      statMin: Value(statMin),
      statMax: Value(statMax),
      poolWeight: Value(poolWeight),
    );
  }

  factory RarityTier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RarityTier(
      id: serializer.fromJson<int>(json['id']),
      rarityName: serializer.fromJson<String>(json['rarityName']),
      statMin: serializer.fromJson<int>(json['statMin']),
      statMax: serializer.fromJson<int>(json['statMax']),
      poolWeight: serializer.fromJson<double>(json['poolWeight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rarityName': serializer.toJson<String>(rarityName),
      'statMin': serializer.toJson<int>(statMin),
      'statMax': serializer.toJson<int>(statMax),
      'poolWeight': serializer.toJson<double>(poolWeight),
    };
  }

  RarityTier copyWith(
          {int? id,
          String? rarityName,
          int? statMin,
          int? statMax,
          double? poolWeight}) =>
      RarityTier(
        id: id ?? this.id,
        rarityName: rarityName ?? this.rarityName,
        statMin: statMin ?? this.statMin,
        statMax: statMax ?? this.statMax,
        poolWeight: poolWeight ?? this.poolWeight,
      );
  RarityTier copyWithCompanion(RarityTiersCompanion data) {
    return RarityTier(
      id: data.id.present ? data.id.value : this.id,
      rarityName:
          data.rarityName.present ? data.rarityName.value : this.rarityName,
      statMin: data.statMin.present ? data.statMin.value : this.statMin,
      statMax: data.statMax.present ? data.statMax.value : this.statMax,
      poolWeight:
          data.poolWeight.present ? data.poolWeight.value : this.poolWeight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RarityTier(')
          ..write('id: $id, ')
          ..write('rarityName: $rarityName, ')
          ..write('statMin: $statMin, ')
          ..write('statMax: $statMax, ')
          ..write('poolWeight: $poolWeight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rarityName, statMin, statMax, poolWeight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RarityTier &&
          other.id == this.id &&
          other.rarityName == this.rarityName &&
          other.statMin == this.statMin &&
          other.statMax == this.statMax &&
          other.poolWeight == this.poolWeight);
}

class RarityTiersCompanion extends UpdateCompanion<RarityTier> {
  final Value<int> id;
  final Value<String> rarityName;
  final Value<int> statMin;
  final Value<int> statMax;
  final Value<double> poolWeight;
  const RarityTiersCompanion({
    this.id = const Value.absent(),
    this.rarityName = const Value.absent(),
    this.statMin = const Value.absent(),
    this.statMax = const Value.absent(),
    this.poolWeight = const Value.absent(),
  });
  RarityTiersCompanion.insert({
    this.id = const Value.absent(),
    required String rarityName,
    required int statMin,
    required int statMax,
    required double poolWeight,
  })  : rarityName = Value(rarityName),
        statMin = Value(statMin),
        statMax = Value(statMax),
        poolWeight = Value(poolWeight);
  static Insertable<RarityTier> custom({
    Expression<int>? id,
    Expression<String>? rarityName,
    Expression<int>? statMin,
    Expression<int>? statMax,
    Expression<double>? poolWeight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rarityName != null) 'rarity_name': rarityName,
      if (statMin != null) 'stat_min': statMin,
      if (statMax != null) 'stat_max': statMax,
      if (poolWeight != null) 'pool_weight': poolWeight,
    });
  }

  RarityTiersCompanion copyWith(
      {Value<int>? id,
      Value<String>? rarityName,
      Value<int>? statMin,
      Value<int>? statMax,
      Value<double>? poolWeight}) {
    return RarityTiersCompanion(
      id: id ?? this.id,
      rarityName: rarityName ?? this.rarityName,
      statMin: statMin ?? this.statMin,
      statMax: statMax ?? this.statMax,
      poolWeight: poolWeight ?? this.poolWeight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rarityName.present) {
      map['rarity_name'] = Variable<String>(rarityName.value);
    }
    if (statMin.present) {
      map['stat_min'] = Variable<int>(statMin.value);
    }
    if (statMax.present) {
      map['stat_max'] = Variable<int>(statMax.value);
    }
    if (poolWeight.present) {
      map['pool_weight'] = Variable<double>(poolWeight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RarityTiersCompanion(')
          ..write('id: $id, ')
          ..write('rarityName: $rarityName, ')
          ..write('statMin: $statMin, ')
          ..write('statMax: $statMax, ')
          ..write('poolWeight: $poolWeight')
          ..write(')'))
        .toString();
  }
}

class $PlayerCareersTable extends PlayerCareers
    with TableInfo<$PlayerCareersTable, PlayerCareer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerCareersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerNumberMeta =
      const VerificationMeta('careerNumber');
  @override
  late final GeneratedColumn<int> careerNumber = GeneratedColumn<int>(
      'career_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _agencyNameMeta =
      const VerificationMeta('agencyName');
  @override
  late final GeneratedColumn<String> agencyName = GeneratedColumn<String>(
      'agency_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Yıldız Ajans'));
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
      'phase', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('recruiting'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _currentWeekMeta =
      const VerificationMeta('currentWeek');
  @override
  late final GeneratedColumn<int> currentWeek = GeneratedColumn<int>(
      'current_week', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currentMonthMeta =
      const VerificationMeta('currentMonth');
  @override
  late final GeneratedColumn<int> currentMonth = GeneratedColumn<int>(
      'current_month', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currentYearMeta =
      const VerificationMeta('currentYear');
  @override
  late final GeneratedColumn<int> currentYear = GeneratedColumn<int>(
      'current_year', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _finalScoreMeta =
      const VerificationMeta('finalScore');
  @override
  late final GeneratedColumn<int> finalScore = GeneratedColumn<int>(
      'final_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _awardsWonMeta =
      const VerificationMeta('awardsWon');
  @override
  late final GeneratedColumn<int> awardsWon = GeneratedColumn<int>(
      'awards_won', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _legacyBonusAppliedMeta =
      const VerificationMeta('legacyBonusApplied');
  @override
  late final GeneratedColumn<String> legacyBonusApplied =
      GeneratedColumn<String>('legacy_bonus_applied', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('medium'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerNumber,
        agencyName,
        phase,
        startedAt,
        currentWeek,
        currentMonth,
        currentYear,
        status,
        finalScore,
        awardsWon,
        legacyBonusApplied,
        difficulty
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_careers';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerCareer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_number')) {
      context.handle(
          _careerNumberMeta,
          careerNumber.isAcceptableOrUnknown(
              data['career_number']!, _careerNumberMeta));
    } else if (isInserting) {
      context.missing(_careerNumberMeta);
    }
    if (data.containsKey('agency_name')) {
      context.handle(
          _agencyNameMeta,
          agencyName.isAcceptableOrUnknown(
              data['agency_name']!, _agencyNameMeta));
    }
    if (data.containsKey('phase')) {
      context.handle(
          _phaseMeta, phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('current_week')) {
      context.handle(
          _currentWeekMeta,
          currentWeek.isAcceptableOrUnknown(
              data['current_week']!, _currentWeekMeta));
    }
    if (data.containsKey('current_month')) {
      context.handle(
          _currentMonthMeta,
          currentMonth.isAcceptableOrUnknown(
              data['current_month']!, _currentMonthMeta));
    }
    if (data.containsKey('current_year')) {
      context.handle(
          _currentYearMeta,
          currentYear.isAcceptableOrUnknown(
              data['current_year']!, _currentYearMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('final_score')) {
      context.handle(
          _finalScoreMeta,
          finalScore.isAcceptableOrUnknown(
              data['final_score']!, _finalScoreMeta));
    }
    if (data.containsKey('awards_won')) {
      context.handle(_awardsWonMeta,
          awardsWon.isAcceptableOrUnknown(data['awards_won']!, _awardsWonMeta));
    }
    if (data.containsKey('legacy_bonus_applied')) {
      context.handle(
          _legacyBonusAppliedMeta,
          legacyBonusApplied.isAcceptableOrUnknown(
              data['legacy_bonus_applied']!, _legacyBonusAppliedMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerCareer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerCareer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_number'])!,
      agencyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agency_name'])!,
      phase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phase'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      currentWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_week'])!,
      currentMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_month'])!,
      currentYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_year'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      finalScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}final_score']),
      awardsWon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}awards_won'])!,
      legacyBonusApplied: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}legacy_bonus_applied']),
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
    );
  }

  @override
  $PlayerCareersTable createAlias(String alias) {
    return $PlayerCareersTable(attachedDatabase, alias);
  }
}

class PlayerCareer extends DataClass implements Insertable<PlayerCareer> {
  final int id;
  final int careerNumber;
  final String agencyName;
  final String phase;
  final DateTime startedAt;
  final int currentWeek;
  final int currentMonth;
  final int currentYear;
  final String status;
  final int? finalScore;
  final int awardsWon;
  final String? legacyBonusApplied;
  final String difficulty;
  const PlayerCareer(
      {required this.id,
      required this.careerNumber,
      required this.agencyName,
      required this.phase,
      required this.startedAt,
      required this.currentWeek,
      required this.currentMonth,
      required this.currentYear,
      required this.status,
      this.finalScore,
      required this.awardsWon,
      this.legacyBonusApplied,
      required this.difficulty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_number'] = Variable<int>(careerNumber);
    map['agency_name'] = Variable<String>(agencyName);
    map['phase'] = Variable<String>(phase);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['current_week'] = Variable<int>(currentWeek);
    map['current_month'] = Variable<int>(currentMonth);
    map['current_year'] = Variable<int>(currentYear);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || finalScore != null) {
      map['final_score'] = Variable<int>(finalScore);
    }
    map['awards_won'] = Variable<int>(awardsWon);
    if (!nullToAbsent || legacyBonusApplied != null) {
      map['legacy_bonus_applied'] = Variable<String>(legacyBonusApplied);
    }
    map['difficulty'] = Variable<String>(difficulty);
    return map;
  }

  PlayerCareersCompanion toCompanion(bool nullToAbsent) {
    return PlayerCareersCompanion(
      id: Value(id),
      careerNumber: Value(careerNumber),
      agencyName: Value(agencyName),
      phase: Value(phase),
      startedAt: Value(startedAt),
      currentWeek: Value(currentWeek),
      currentMonth: Value(currentMonth),
      currentYear: Value(currentYear),
      status: Value(status),
      finalScore: finalScore == null && nullToAbsent
          ? const Value.absent()
          : Value(finalScore),
      awardsWon: Value(awardsWon),
      legacyBonusApplied: legacyBonusApplied == null && nullToAbsent
          ? const Value.absent()
          : Value(legacyBonusApplied),
      difficulty: Value(difficulty),
    );
  }

  factory PlayerCareer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerCareer(
      id: serializer.fromJson<int>(json['id']),
      careerNumber: serializer.fromJson<int>(json['careerNumber']),
      agencyName: serializer.fromJson<String>(json['agencyName']),
      phase: serializer.fromJson<String>(json['phase']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      currentWeek: serializer.fromJson<int>(json['currentWeek']),
      currentMonth: serializer.fromJson<int>(json['currentMonth']),
      currentYear: serializer.fromJson<int>(json['currentYear']),
      status: serializer.fromJson<String>(json['status']),
      finalScore: serializer.fromJson<int?>(json['finalScore']),
      awardsWon: serializer.fromJson<int>(json['awardsWon']),
      legacyBonusApplied:
          serializer.fromJson<String?>(json['legacyBonusApplied']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerNumber': serializer.toJson<int>(careerNumber),
      'agencyName': serializer.toJson<String>(agencyName),
      'phase': serializer.toJson<String>(phase),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'currentWeek': serializer.toJson<int>(currentWeek),
      'currentMonth': serializer.toJson<int>(currentMonth),
      'currentYear': serializer.toJson<int>(currentYear),
      'status': serializer.toJson<String>(status),
      'finalScore': serializer.toJson<int?>(finalScore),
      'awardsWon': serializer.toJson<int>(awardsWon),
      'legacyBonusApplied': serializer.toJson<String?>(legacyBonusApplied),
      'difficulty': serializer.toJson<String>(difficulty),
    };
  }

  PlayerCareer copyWith(
          {int? id,
          int? careerNumber,
          String? agencyName,
          String? phase,
          DateTime? startedAt,
          int? currentWeek,
          int? currentMonth,
          int? currentYear,
          String? status,
          Value<int?> finalScore = const Value.absent(),
          int? awardsWon,
          Value<String?> legacyBonusApplied = const Value.absent(),
          String? difficulty}) =>
      PlayerCareer(
        id: id ?? this.id,
        careerNumber: careerNumber ?? this.careerNumber,
        agencyName: agencyName ?? this.agencyName,
        phase: phase ?? this.phase,
        startedAt: startedAt ?? this.startedAt,
        currentWeek: currentWeek ?? this.currentWeek,
        currentMonth: currentMonth ?? this.currentMonth,
        currentYear: currentYear ?? this.currentYear,
        status: status ?? this.status,
        finalScore: finalScore.present ? finalScore.value : this.finalScore,
        awardsWon: awardsWon ?? this.awardsWon,
        legacyBonusApplied: legacyBonusApplied.present
            ? legacyBonusApplied.value
            : this.legacyBonusApplied,
        difficulty: difficulty ?? this.difficulty,
      );
  PlayerCareer copyWithCompanion(PlayerCareersCompanion data) {
    return PlayerCareer(
      id: data.id.present ? data.id.value : this.id,
      careerNumber: data.careerNumber.present
          ? data.careerNumber.value
          : this.careerNumber,
      agencyName:
          data.agencyName.present ? data.agencyName.value : this.agencyName,
      phase: data.phase.present ? data.phase.value : this.phase,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      currentWeek:
          data.currentWeek.present ? data.currentWeek.value : this.currentWeek,
      currentMonth: data.currentMonth.present
          ? data.currentMonth.value
          : this.currentMonth,
      currentYear:
          data.currentYear.present ? data.currentYear.value : this.currentYear,
      status: data.status.present ? data.status.value : this.status,
      finalScore:
          data.finalScore.present ? data.finalScore.value : this.finalScore,
      awardsWon: data.awardsWon.present ? data.awardsWon.value : this.awardsWon,
      legacyBonusApplied: data.legacyBonusApplied.present
          ? data.legacyBonusApplied.value
          : this.legacyBonusApplied,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerCareer(')
          ..write('id: $id, ')
          ..write('careerNumber: $careerNumber, ')
          ..write('agencyName: $agencyName, ')
          ..write('phase: $phase, ')
          ..write('startedAt: $startedAt, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentMonth: $currentMonth, ')
          ..write('currentYear: $currentYear, ')
          ..write('status: $status, ')
          ..write('finalScore: $finalScore, ')
          ..write('awardsWon: $awardsWon, ')
          ..write('legacyBonusApplied: $legacyBonusApplied, ')
          ..write('difficulty: $difficulty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      careerNumber,
      agencyName,
      phase,
      startedAt,
      currentWeek,
      currentMonth,
      currentYear,
      status,
      finalScore,
      awardsWon,
      legacyBonusApplied,
      difficulty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerCareer &&
          other.id == this.id &&
          other.careerNumber == this.careerNumber &&
          other.agencyName == this.agencyName &&
          other.phase == this.phase &&
          other.startedAt == this.startedAt &&
          other.currentWeek == this.currentWeek &&
          other.currentMonth == this.currentMonth &&
          other.currentYear == this.currentYear &&
          other.status == this.status &&
          other.finalScore == this.finalScore &&
          other.awardsWon == this.awardsWon &&
          other.legacyBonusApplied == this.legacyBonusApplied &&
          other.difficulty == this.difficulty);
}

class PlayerCareersCompanion extends UpdateCompanion<PlayerCareer> {
  final Value<int> id;
  final Value<int> careerNumber;
  final Value<String> agencyName;
  final Value<String> phase;
  final Value<DateTime> startedAt;
  final Value<int> currentWeek;
  final Value<int> currentMonth;
  final Value<int> currentYear;
  final Value<String> status;
  final Value<int?> finalScore;
  final Value<int> awardsWon;
  final Value<String?> legacyBonusApplied;
  final Value<String> difficulty;
  const PlayerCareersCompanion({
    this.id = const Value.absent(),
    this.careerNumber = const Value.absent(),
    this.agencyName = const Value.absent(),
    this.phase = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.currentWeek = const Value.absent(),
    this.currentMonth = const Value.absent(),
    this.currentYear = const Value.absent(),
    this.status = const Value.absent(),
    this.finalScore = const Value.absent(),
    this.awardsWon = const Value.absent(),
    this.legacyBonusApplied = const Value.absent(),
    this.difficulty = const Value.absent(),
  });
  PlayerCareersCompanion.insert({
    this.id = const Value.absent(),
    required int careerNumber,
    this.agencyName = const Value.absent(),
    this.phase = const Value.absent(),
    required DateTime startedAt,
    this.currentWeek = const Value.absent(),
    this.currentMonth = const Value.absent(),
    this.currentYear = const Value.absent(),
    this.status = const Value.absent(),
    this.finalScore = const Value.absent(),
    this.awardsWon = const Value.absent(),
    this.legacyBonusApplied = const Value.absent(),
    this.difficulty = const Value.absent(),
  })  : careerNumber = Value(careerNumber),
        startedAt = Value(startedAt);
  static Insertable<PlayerCareer> custom({
    Expression<int>? id,
    Expression<int>? careerNumber,
    Expression<String>? agencyName,
    Expression<String>? phase,
    Expression<DateTime>? startedAt,
    Expression<int>? currentWeek,
    Expression<int>? currentMonth,
    Expression<int>? currentYear,
    Expression<String>? status,
    Expression<int>? finalScore,
    Expression<int>? awardsWon,
    Expression<String>? legacyBonusApplied,
    Expression<String>? difficulty,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerNumber != null) 'career_number': careerNumber,
      if (agencyName != null) 'agency_name': agencyName,
      if (phase != null) 'phase': phase,
      if (startedAt != null) 'started_at': startedAt,
      if (currentWeek != null) 'current_week': currentWeek,
      if (currentMonth != null) 'current_month': currentMonth,
      if (currentYear != null) 'current_year': currentYear,
      if (status != null) 'status': status,
      if (finalScore != null) 'final_score': finalScore,
      if (awardsWon != null) 'awards_won': awardsWon,
      if (legacyBonusApplied != null)
        'legacy_bonus_applied': legacyBonusApplied,
      if (difficulty != null) 'difficulty': difficulty,
    });
  }

  PlayerCareersCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerNumber,
      Value<String>? agencyName,
      Value<String>? phase,
      Value<DateTime>? startedAt,
      Value<int>? currentWeek,
      Value<int>? currentMonth,
      Value<int>? currentYear,
      Value<String>? status,
      Value<int?>? finalScore,
      Value<int>? awardsWon,
      Value<String?>? legacyBonusApplied,
      Value<String>? difficulty}) {
    return PlayerCareersCompanion(
      id: id ?? this.id,
      careerNumber: careerNumber ?? this.careerNumber,
      agencyName: agencyName ?? this.agencyName,
      phase: phase ?? this.phase,
      startedAt: startedAt ?? this.startedAt,
      currentWeek: currentWeek ?? this.currentWeek,
      currentMonth: currentMonth ?? this.currentMonth,
      currentYear: currentYear ?? this.currentYear,
      status: status ?? this.status,
      finalScore: finalScore ?? this.finalScore,
      awardsWon: awardsWon ?? this.awardsWon,
      legacyBonusApplied: legacyBonusApplied ?? this.legacyBonusApplied,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerNumber.present) {
      map['career_number'] = Variable<int>(careerNumber.value);
    }
    if (agencyName.present) {
      map['agency_name'] = Variable<String>(agencyName.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (currentWeek.present) {
      map['current_week'] = Variable<int>(currentWeek.value);
    }
    if (currentMonth.present) {
      map['current_month'] = Variable<int>(currentMonth.value);
    }
    if (currentYear.present) {
      map['current_year'] = Variable<int>(currentYear.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (finalScore.present) {
      map['final_score'] = Variable<int>(finalScore.value);
    }
    if (awardsWon.present) {
      map['awards_won'] = Variable<int>(awardsWon.value);
    }
    if (legacyBonusApplied.present) {
      map['legacy_bonus_applied'] = Variable<String>(legacyBonusApplied.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerCareersCompanion(')
          ..write('id: $id, ')
          ..write('careerNumber: $careerNumber, ')
          ..write('agencyName: $agencyName, ')
          ..write('phase: $phase, ')
          ..write('startedAt: $startedAt, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentMonth: $currentMonth, ')
          ..write('currentYear: $currentYear, ')
          ..write('status: $status, ')
          ..write('finalScore: $finalScore, ')
          ..write('awardsWon: $awardsWon, ')
          ..write('legacyBonusApplied: $legacyBonusApplied, ')
          ..write('difficulty: $difficulty')
          ..write(')'))
        .toString();
  }
}

class $GeneratedCharactersTable extends GeneratedCharacters
    with TableInfo<$GeneratedCharactersTable, GeneratedCharacter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneratedCharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cohortMonthMeta =
      const VerificationMeta('cohortMonth');
  @override
  late final GeneratedColumn<int> cohortMonth = GeneratedColumn<int>(
      'cohort_month', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _vocalSkillMeta =
      const VerificationMeta('vocalSkill');
  @override
  late final GeneratedColumn<int> vocalSkill = GeneratedColumn<int>(
      'vocal_skill', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _danceSkillMeta =
      const VerificationMeta('danceSkill');
  @override
  late final GeneratedColumn<int> danceSkill = GeneratedColumn<int>(
      'dance_skill', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rapSkillMeta =
      const VerificationMeta('rapSkill');
  @override
  late final GeneratedColumn<int> rapSkill = GeneratedColumn<int>(
      'rap_skill', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vocalPotentialMeta =
      const VerificationMeta('vocalPotential');
  @override
  late final GeneratedColumn<int> vocalPotential = GeneratedColumn<int>(
      'vocal_potential', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _dancePotentialMeta =
      const VerificationMeta('dancePotential');
  @override
  late final GeneratedColumn<int> dancePotential = GeneratedColumn<int>(
      'dance_potential', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _rapPotentialMeta =
      const VerificationMeta('rapPotential');
  @override
  late final GeneratedColumn<int> rapPotential = GeneratedColumn<int>(
      'rap_potential', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _primaryDisciplineMeta =
      const VerificationMeta('primaryDiscipline');
  @override
  late final GeneratedColumn<String> primaryDiscipline =
      GeneratedColumn<String>('primary_discipline', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('vocal'));
  static const VerificationMeta _auditionScoreMeta =
      const VerificationMeta('auditionScore');
  @override
  late final GeneratedColumn<int> auditionScore = GeneratedColumn<int>(
      'audition_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _visualScoreMeta =
      const VerificationMeta('visualScore');
  @override
  late final GeneratedColumn<int> visualScore = GeneratedColumn<int>(
      'visual_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _charismaMeta =
      const VerificationMeta('charisma');
  @override
  late final GeneratedColumn<int> charisma = GeneratedColumn<int>(
      'charisma', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _staminaBaseMeta =
      const VerificationMeta('staminaBase');
  @override
  late final GeneratedColumn<int> staminaBase = GeneratedColumn<int>(
      'stamina_base', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _personalityIdMeta =
      const VerificationMeta('personalityId');
  @override
  late final GeneratedColumn<int> personalityId = GeneratedColumn<int>(
      'personality_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES personality_traits (id)'));
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
      'rarity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _specialTraitMeta =
      const VerificationMeta('specialTrait');
  @override
  late final GeneratedColumn<String> specialTrait = GeneratedColumn<String>(
      'special_trait', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voiceTypeMeta =
      const VerificationMeta('voiceType');
  @override
  late final GeneratedColumn<String> voiceType = GeneratedColumn<String>(
      'voice_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _opennessMeta =
      const VerificationMeta('openness');
  @override
  late final GeneratedColumn<int> openness = GeneratedColumn<int>(
      'openness', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _conscientiousnessMeta =
      const VerificationMeta('conscientiousness');
  @override
  late final GeneratedColumn<int> conscientiousness = GeneratedColumn<int>(
      'conscientiousness', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _extraversionMeta =
      const VerificationMeta('extraversion');
  @override
  late final GeneratedColumn<int> extraversion = GeneratedColumn<int>(
      'extraversion', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _agreeablenessMeta =
      const VerificationMeta('agreeableness');
  @override
  late final GeneratedColumn<int> agreeableness = GeneratedColumn<int>(
      'agreeableness', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _neuroticismMeta =
      const VerificationMeta('neuroticism');
  @override
  late final GeneratedColumn<int> neuroticism = GeneratedColumn<int>(
      'neuroticism', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _startingFameMeta =
      const VerificationMeta('startingFame');
  @override
  late final GeneratedColumn<int> startingFame = GeneratedColumn<int>(
      'starting_fame', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _recruitStatusMeta =
      const VerificationMeta('recruitStatus');
  @override
  late final GeneratedColumn<String> recruitStatus = GeneratedColumn<String>(
      'recruit_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('available'));
  static const VerificationMeta _claimedRoleMeta =
      const VerificationMeta('claimedRole');
  @override
  late final GeneratedColumn<String> claimedRole = GeneratedColumn<String>(
      'claimed_role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Bilinmiyor'));
  static const VerificationMeta _bioSnippetMeta =
      const VerificationMeta('bioSnippet');
  @override
  late final GeneratedColumn<String> bioSnippet = GeneratedColumn<String>(
      'bio_snippet', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isVocalRevealedMeta =
      const VerificationMeta('isVocalRevealed');
  @override
  late final GeneratedColumn<bool> isVocalRevealed = GeneratedColumn<bool>(
      'is_vocal_revealed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_vocal_revealed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDanceRevealedMeta =
      const VerificationMeta('isDanceRevealed');
  @override
  late final GeneratedColumn<bool> isDanceRevealed = GeneratedColumn<bool>(
      'is_dance_revealed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_dance_revealed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isRapRevealedMeta =
      const VerificationMeta('isRapRevealed');
  @override
  late final GeneratedColumn<bool> isRapRevealed = GeneratedColumn<bool>(
      'is_rap_revealed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_rap_revealed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerId,
        name,
        imagePath,
        cohortMonth,
        vocalSkill,
        danceSkill,
        rapSkill,
        vocalPotential,
        dancePotential,
        rapPotential,
        primaryDiscipline,
        auditionScore,
        visualScore,
        charisma,
        staminaBase,
        personalityId,
        rarity,
        specialTrait,
        voiceType,
        openness,
        conscientiousness,
        extraversion,
        agreeableness,
        neuroticism,
        startingFame,
        recruitStatus,
        claimedRole,
        bioSnippet,
        isVocalRevealed,
        isDanceRevealed,
        isRapRevealed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'generated_characters';
  @override
  VerificationContext validateIntegrity(Insertable<GeneratedCharacter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('cohort_month')) {
      context.handle(
          _cohortMonthMeta,
          cohortMonth.isAcceptableOrUnknown(
              data['cohort_month']!, _cohortMonthMeta));
    }
    if (data.containsKey('vocal_skill')) {
      context.handle(
          _vocalSkillMeta,
          vocalSkill.isAcceptableOrUnknown(
              data['vocal_skill']!, _vocalSkillMeta));
    } else if (isInserting) {
      context.missing(_vocalSkillMeta);
    }
    if (data.containsKey('dance_skill')) {
      context.handle(
          _danceSkillMeta,
          danceSkill.isAcceptableOrUnknown(
              data['dance_skill']!, _danceSkillMeta));
    } else if (isInserting) {
      context.missing(_danceSkillMeta);
    }
    if (data.containsKey('rap_skill')) {
      context.handle(_rapSkillMeta,
          rapSkill.isAcceptableOrUnknown(data['rap_skill']!, _rapSkillMeta));
    } else if (isInserting) {
      context.missing(_rapSkillMeta);
    }
    if (data.containsKey('vocal_potential')) {
      context.handle(
          _vocalPotentialMeta,
          vocalPotential.isAcceptableOrUnknown(
              data['vocal_potential']!, _vocalPotentialMeta));
    }
    if (data.containsKey('dance_potential')) {
      context.handle(
          _dancePotentialMeta,
          dancePotential.isAcceptableOrUnknown(
              data['dance_potential']!, _dancePotentialMeta));
    }
    if (data.containsKey('rap_potential')) {
      context.handle(
          _rapPotentialMeta,
          rapPotential.isAcceptableOrUnknown(
              data['rap_potential']!, _rapPotentialMeta));
    }
    if (data.containsKey('primary_discipline')) {
      context.handle(
          _primaryDisciplineMeta,
          primaryDiscipline.isAcceptableOrUnknown(
              data['primary_discipline']!, _primaryDisciplineMeta));
    }
    if (data.containsKey('audition_score')) {
      context.handle(
          _auditionScoreMeta,
          auditionScore.isAcceptableOrUnknown(
              data['audition_score']!, _auditionScoreMeta));
    }
    if (data.containsKey('visual_score')) {
      context.handle(
          _visualScoreMeta,
          visualScore.isAcceptableOrUnknown(
              data['visual_score']!, _visualScoreMeta));
    } else if (isInserting) {
      context.missing(_visualScoreMeta);
    }
    if (data.containsKey('charisma')) {
      context.handle(_charismaMeta,
          charisma.isAcceptableOrUnknown(data['charisma']!, _charismaMeta));
    } else if (isInserting) {
      context.missing(_charismaMeta);
    }
    if (data.containsKey('stamina_base')) {
      context.handle(
          _staminaBaseMeta,
          staminaBase.isAcceptableOrUnknown(
              data['stamina_base']!, _staminaBaseMeta));
    } else if (isInserting) {
      context.missing(_staminaBaseMeta);
    }
    if (data.containsKey('personality_id')) {
      context.handle(
          _personalityIdMeta,
          personalityId.isAcceptableOrUnknown(
              data['personality_id']!, _personalityIdMeta));
    } else if (isInserting) {
      context.missing(_personalityIdMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(_rarityMeta,
          rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta));
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('special_trait')) {
      context.handle(
          _specialTraitMeta,
          specialTrait.isAcceptableOrUnknown(
              data['special_trait']!, _specialTraitMeta));
    }
    if (data.containsKey('voice_type')) {
      context.handle(_voiceTypeMeta,
          voiceType.isAcceptableOrUnknown(data['voice_type']!, _voiceTypeMeta));
    }
    if (data.containsKey('openness')) {
      context.handle(_opennessMeta,
          openness.isAcceptableOrUnknown(data['openness']!, _opennessMeta));
    }
    if (data.containsKey('conscientiousness')) {
      context.handle(
          _conscientiousnessMeta,
          conscientiousness.isAcceptableOrUnknown(
              data['conscientiousness']!, _conscientiousnessMeta));
    }
    if (data.containsKey('extraversion')) {
      context.handle(
          _extraversionMeta,
          extraversion.isAcceptableOrUnknown(
              data['extraversion']!, _extraversionMeta));
    }
    if (data.containsKey('agreeableness')) {
      context.handle(
          _agreeablenessMeta,
          agreeableness.isAcceptableOrUnknown(
              data['agreeableness']!, _agreeablenessMeta));
    }
    if (data.containsKey('neuroticism')) {
      context.handle(
          _neuroticismMeta,
          neuroticism.isAcceptableOrUnknown(
              data['neuroticism']!, _neuroticismMeta));
    }
    if (data.containsKey('starting_fame')) {
      context.handle(
          _startingFameMeta,
          startingFame.isAcceptableOrUnknown(
              data['starting_fame']!, _startingFameMeta));
    }
    if (data.containsKey('recruit_status')) {
      context.handle(
          _recruitStatusMeta,
          recruitStatus.isAcceptableOrUnknown(
              data['recruit_status']!, _recruitStatusMeta));
    }
    if (data.containsKey('claimed_role')) {
      context.handle(
          _claimedRoleMeta,
          claimedRole.isAcceptableOrUnknown(
              data['claimed_role']!, _claimedRoleMeta));
    }
    if (data.containsKey('bio_snippet')) {
      context.handle(
          _bioSnippetMeta,
          bioSnippet.isAcceptableOrUnknown(
              data['bio_snippet']!, _bioSnippetMeta));
    }
    if (data.containsKey('is_vocal_revealed')) {
      context.handle(
          _isVocalRevealedMeta,
          isVocalRevealed.isAcceptableOrUnknown(
              data['is_vocal_revealed']!, _isVocalRevealedMeta));
    }
    if (data.containsKey('is_dance_revealed')) {
      context.handle(
          _isDanceRevealedMeta,
          isDanceRevealed.isAcceptableOrUnknown(
              data['is_dance_revealed']!, _isDanceRevealedMeta));
    }
    if (data.containsKey('is_rap_revealed')) {
      context.handle(
          _isRapRevealedMeta,
          isRapRevealed.isAcceptableOrUnknown(
              data['is_rap_revealed']!, _isRapRevealedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeneratedCharacter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneratedCharacter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      cohortMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cohort_month'])!,
      vocalSkill: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocal_skill'])!,
      danceSkill: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dance_skill'])!,
      rapSkill: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rap_skill'])!,
      vocalPotential: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocal_potential'])!,
      dancePotential: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dance_potential'])!,
      rapPotential: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rap_potential'])!,
      primaryDiscipline: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_discipline'])!,
      auditionScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}audition_score'])!,
      visualScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visual_score'])!,
      charisma: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}charisma'])!,
      staminaBase: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stamina_base'])!,
      personalityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}personality_id'])!,
      rarity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity'])!,
      specialTrait: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}special_trait']),
      voiceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voice_type']),
      openness: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}openness'])!,
      conscientiousness: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}conscientiousness'])!,
      extraversion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}extraversion'])!,
      agreeableness: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}agreeableness'])!,
      neuroticism: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}neuroticism'])!,
      startingFame: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}starting_fame'])!,
      recruitStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recruit_status'])!,
      claimedRole: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}claimed_role'])!,
      bioSnippet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio_snippet']),
      isVocalRevealed: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_vocal_revealed'])!,
      isDanceRevealed: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_dance_revealed'])!,
      isRapRevealed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_rap_revealed'])!,
    );
  }

  @override
  $GeneratedCharactersTable createAlias(String alias) {
    return $GeneratedCharactersTable(attachedDatabase, alias);
  }
}

class GeneratedCharacter extends DataClass
    implements Insertable<GeneratedCharacter> {
  final int id;
  final int careerId;
  final String name;
  final String? imagePath;
  final int cohortMonth;
  final int vocalSkill;
  final int danceSkill;
  final int rapSkill;
  final int vocalPotential;
  final int dancePotential;
  final int rapPotential;
  final String primaryDiscipline;
  final int auditionScore;
  final int visualScore;
  final int charisma;
  final int staminaBase;
  final int personalityId;
  final String rarity;
  final String? specialTrait;
  final String? voiceType;
  final int openness;
  final int conscientiousness;
  final int extraversion;
  final int agreeableness;
  final int neuroticism;
  final int startingFame;
  final String recruitStatus;
  final String claimedRole;
  final String? bioSnippet;
  final bool isVocalRevealed;
  final bool isDanceRevealed;
  final bool isRapRevealed;
  const GeneratedCharacter(
      {required this.id,
      required this.careerId,
      required this.name,
      this.imagePath,
      required this.cohortMonth,
      required this.vocalSkill,
      required this.danceSkill,
      required this.rapSkill,
      required this.vocalPotential,
      required this.dancePotential,
      required this.rapPotential,
      required this.primaryDiscipline,
      required this.auditionScore,
      required this.visualScore,
      required this.charisma,
      required this.staminaBase,
      required this.personalityId,
      required this.rarity,
      this.specialTrait,
      this.voiceType,
      required this.openness,
      required this.conscientiousness,
      required this.extraversion,
      required this.agreeableness,
      required this.neuroticism,
      required this.startingFame,
      required this.recruitStatus,
      required this.claimedRole,
      this.bioSnippet,
      required this.isVocalRevealed,
      required this.isDanceRevealed,
      required this.isRapRevealed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['cohort_month'] = Variable<int>(cohortMonth);
    map['vocal_skill'] = Variable<int>(vocalSkill);
    map['dance_skill'] = Variable<int>(danceSkill);
    map['rap_skill'] = Variable<int>(rapSkill);
    map['vocal_potential'] = Variable<int>(vocalPotential);
    map['dance_potential'] = Variable<int>(dancePotential);
    map['rap_potential'] = Variable<int>(rapPotential);
    map['primary_discipline'] = Variable<String>(primaryDiscipline);
    map['audition_score'] = Variable<int>(auditionScore);
    map['visual_score'] = Variable<int>(visualScore);
    map['charisma'] = Variable<int>(charisma);
    map['stamina_base'] = Variable<int>(staminaBase);
    map['personality_id'] = Variable<int>(personalityId);
    map['rarity'] = Variable<String>(rarity);
    if (!nullToAbsent || specialTrait != null) {
      map['special_trait'] = Variable<String>(specialTrait);
    }
    if (!nullToAbsent || voiceType != null) {
      map['voice_type'] = Variable<String>(voiceType);
    }
    map['openness'] = Variable<int>(openness);
    map['conscientiousness'] = Variable<int>(conscientiousness);
    map['extraversion'] = Variable<int>(extraversion);
    map['agreeableness'] = Variable<int>(agreeableness);
    map['neuroticism'] = Variable<int>(neuroticism);
    map['starting_fame'] = Variable<int>(startingFame);
    map['recruit_status'] = Variable<String>(recruitStatus);
    map['claimed_role'] = Variable<String>(claimedRole);
    if (!nullToAbsent || bioSnippet != null) {
      map['bio_snippet'] = Variable<String>(bioSnippet);
    }
    map['is_vocal_revealed'] = Variable<bool>(isVocalRevealed);
    map['is_dance_revealed'] = Variable<bool>(isDanceRevealed);
    map['is_rap_revealed'] = Variable<bool>(isRapRevealed);
    return map;
  }

  GeneratedCharactersCompanion toCompanion(bool nullToAbsent) {
    return GeneratedCharactersCompanion(
      id: Value(id),
      careerId: Value(careerId),
      name: Value(name),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      cohortMonth: Value(cohortMonth),
      vocalSkill: Value(vocalSkill),
      danceSkill: Value(danceSkill),
      rapSkill: Value(rapSkill),
      vocalPotential: Value(vocalPotential),
      dancePotential: Value(dancePotential),
      rapPotential: Value(rapPotential),
      primaryDiscipline: Value(primaryDiscipline),
      auditionScore: Value(auditionScore),
      visualScore: Value(visualScore),
      charisma: Value(charisma),
      staminaBase: Value(staminaBase),
      personalityId: Value(personalityId),
      rarity: Value(rarity),
      specialTrait: specialTrait == null && nullToAbsent
          ? const Value.absent()
          : Value(specialTrait),
      voiceType: voiceType == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceType),
      openness: Value(openness),
      conscientiousness: Value(conscientiousness),
      extraversion: Value(extraversion),
      agreeableness: Value(agreeableness),
      neuroticism: Value(neuroticism),
      startingFame: Value(startingFame),
      recruitStatus: Value(recruitStatus),
      claimedRole: Value(claimedRole),
      bioSnippet: bioSnippet == null && nullToAbsent
          ? const Value.absent()
          : Value(bioSnippet),
      isVocalRevealed: Value(isVocalRevealed),
      isDanceRevealed: Value(isDanceRevealed),
      isRapRevealed: Value(isRapRevealed),
    );
  }

  factory GeneratedCharacter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneratedCharacter(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      name: serializer.fromJson<String>(json['name']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      cohortMonth: serializer.fromJson<int>(json['cohortMonth']),
      vocalSkill: serializer.fromJson<int>(json['vocalSkill']),
      danceSkill: serializer.fromJson<int>(json['danceSkill']),
      rapSkill: serializer.fromJson<int>(json['rapSkill']),
      vocalPotential: serializer.fromJson<int>(json['vocalPotential']),
      dancePotential: serializer.fromJson<int>(json['dancePotential']),
      rapPotential: serializer.fromJson<int>(json['rapPotential']),
      primaryDiscipline: serializer.fromJson<String>(json['primaryDiscipline']),
      auditionScore: serializer.fromJson<int>(json['auditionScore']),
      visualScore: serializer.fromJson<int>(json['visualScore']),
      charisma: serializer.fromJson<int>(json['charisma']),
      staminaBase: serializer.fromJson<int>(json['staminaBase']),
      personalityId: serializer.fromJson<int>(json['personalityId']),
      rarity: serializer.fromJson<String>(json['rarity']),
      specialTrait: serializer.fromJson<String?>(json['specialTrait']),
      voiceType: serializer.fromJson<String?>(json['voiceType']),
      openness: serializer.fromJson<int>(json['openness']),
      conscientiousness: serializer.fromJson<int>(json['conscientiousness']),
      extraversion: serializer.fromJson<int>(json['extraversion']),
      agreeableness: serializer.fromJson<int>(json['agreeableness']),
      neuroticism: serializer.fromJson<int>(json['neuroticism']),
      startingFame: serializer.fromJson<int>(json['startingFame']),
      recruitStatus: serializer.fromJson<String>(json['recruitStatus']),
      claimedRole: serializer.fromJson<String>(json['claimedRole']),
      bioSnippet: serializer.fromJson<String?>(json['bioSnippet']),
      isVocalRevealed: serializer.fromJson<bool>(json['isVocalRevealed']),
      isDanceRevealed: serializer.fromJson<bool>(json['isDanceRevealed']),
      isRapRevealed: serializer.fromJson<bool>(json['isRapRevealed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'name': serializer.toJson<String>(name),
      'imagePath': serializer.toJson<String?>(imagePath),
      'cohortMonth': serializer.toJson<int>(cohortMonth),
      'vocalSkill': serializer.toJson<int>(vocalSkill),
      'danceSkill': serializer.toJson<int>(danceSkill),
      'rapSkill': serializer.toJson<int>(rapSkill),
      'vocalPotential': serializer.toJson<int>(vocalPotential),
      'dancePotential': serializer.toJson<int>(dancePotential),
      'rapPotential': serializer.toJson<int>(rapPotential),
      'primaryDiscipline': serializer.toJson<String>(primaryDiscipline),
      'auditionScore': serializer.toJson<int>(auditionScore),
      'visualScore': serializer.toJson<int>(visualScore),
      'charisma': serializer.toJson<int>(charisma),
      'staminaBase': serializer.toJson<int>(staminaBase),
      'personalityId': serializer.toJson<int>(personalityId),
      'rarity': serializer.toJson<String>(rarity),
      'specialTrait': serializer.toJson<String?>(specialTrait),
      'voiceType': serializer.toJson<String?>(voiceType),
      'openness': serializer.toJson<int>(openness),
      'conscientiousness': serializer.toJson<int>(conscientiousness),
      'extraversion': serializer.toJson<int>(extraversion),
      'agreeableness': serializer.toJson<int>(agreeableness),
      'neuroticism': serializer.toJson<int>(neuroticism),
      'startingFame': serializer.toJson<int>(startingFame),
      'recruitStatus': serializer.toJson<String>(recruitStatus),
      'claimedRole': serializer.toJson<String>(claimedRole),
      'bioSnippet': serializer.toJson<String?>(bioSnippet),
      'isVocalRevealed': serializer.toJson<bool>(isVocalRevealed),
      'isDanceRevealed': serializer.toJson<bool>(isDanceRevealed),
      'isRapRevealed': serializer.toJson<bool>(isRapRevealed),
    };
  }

  GeneratedCharacter copyWith(
          {int? id,
          int? careerId,
          String? name,
          Value<String?> imagePath = const Value.absent(),
          int? cohortMonth,
          int? vocalSkill,
          int? danceSkill,
          int? rapSkill,
          int? vocalPotential,
          int? dancePotential,
          int? rapPotential,
          String? primaryDiscipline,
          int? auditionScore,
          int? visualScore,
          int? charisma,
          int? staminaBase,
          int? personalityId,
          String? rarity,
          Value<String?> specialTrait = const Value.absent(),
          Value<String?> voiceType = const Value.absent(),
          int? openness,
          int? conscientiousness,
          int? extraversion,
          int? agreeableness,
          int? neuroticism,
          int? startingFame,
          String? recruitStatus,
          String? claimedRole,
          Value<String?> bioSnippet = const Value.absent(),
          bool? isVocalRevealed,
          bool? isDanceRevealed,
          bool? isRapRevealed}) =>
      GeneratedCharacter(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        name: name ?? this.name,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        cohortMonth: cohortMonth ?? this.cohortMonth,
        vocalSkill: vocalSkill ?? this.vocalSkill,
        danceSkill: danceSkill ?? this.danceSkill,
        rapSkill: rapSkill ?? this.rapSkill,
        vocalPotential: vocalPotential ?? this.vocalPotential,
        dancePotential: dancePotential ?? this.dancePotential,
        rapPotential: rapPotential ?? this.rapPotential,
        primaryDiscipline: primaryDiscipline ?? this.primaryDiscipline,
        auditionScore: auditionScore ?? this.auditionScore,
        visualScore: visualScore ?? this.visualScore,
        charisma: charisma ?? this.charisma,
        staminaBase: staminaBase ?? this.staminaBase,
        personalityId: personalityId ?? this.personalityId,
        rarity: rarity ?? this.rarity,
        specialTrait:
            specialTrait.present ? specialTrait.value : this.specialTrait,
        voiceType: voiceType.present ? voiceType.value : this.voiceType,
        openness: openness ?? this.openness,
        conscientiousness: conscientiousness ?? this.conscientiousness,
        extraversion: extraversion ?? this.extraversion,
        agreeableness: agreeableness ?? this.agreeableness,
        neuroticism: neuroticism ?? this.neuroticism,
        startingFame: startingFame ?? this.startingFame,
        recruitStatus: recruitStatus ?? this.recruitStatus,
        claimedRole: claimedRole ?? this.claimedRole,
        bioSnippet: bioSnippet.present ? bioSnippet.value : this.bioSnippet,
        isVocalRevealed: isVocalRevealed ?? this.isVocalRevealed,
        isDanceRevealed: isDanceRevealed ?? this.isDanceRevealed,
        isRapRevealed: isRapRevealed ?? this.isRapRevealed,
      );
  GeneratedCharacter copyWithCompanion(GeneratedCharactersCompanion data) {
    return GeneratedCharacter(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      cohortMonth:
          data.cohortMonth.present ? data.cohortMonth.value : this.cohortMonth,
      vocalSkill:
          data.vocalSkill.present ? data.vocalSkill.value : this.vocalSkill,
      danceSkill:
          data.danceSkill.present ? data.danceSkill.value : this.danceSkill,
      rapSkill: data.rapSkill.present ? data.rapSkill.value : this.rapSkill,
      vocalPotential: data.vocalPotential.present
          ? data.vocalPotential.value
          : this.vocalPotential,
      dancePotential: data.dancePotential.present
          ? data.dancePotential.value
          : this.dancePotential,
      rapPotential: data.rapPotential.present
          ? data.rapPotential.value
          : this.rapPotential,
      primaryDiscipline: data.primaryDiscipline.present
          ? data.primaryDiscipline.value
          : this.primaryDiscipline,
      auditionScore: data.auditionScore.present
          ? data.auditionScore.value
          : this.auditionScore,
      visualScore:
          data.visualScore.present ? data.visualScore.value : this.visualScore,
      charisma: data.charisma.present ? data.charisma.value : this.charisma,
      staminaBase:
          data.staminaBase.present ? data.staminaBase.value : this.staminaBase,
      personalityId: data.personalityId.present
          ? data.personalityId.value
          : this.personalityId,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      specialTrait: data.specialTrait.present
          ? data.specialTrait.value
          : this.specialTrait,
      voiceType: data.voiceType.present ? data.voiceType.value : this.voiceType,
      openness: data.openness.present ? data.openness.value : this.openness,
      conscientiousness: data.conscientiousness.present
          ? data.conscientiousness.value
          : this.conscientiousness,
      extraversion: data.extraversion.present
          ? data.extraversion.value
          : this.extraversion,
      agreeableness: data.agreeableness.present
          ? data.agreeableness.value
          : this.agreeableness,
      neuroticism:
          data.neuroticism.present ? data.neuroticism.value : this.neuroticism,
      startingFame: data.startingFame.present
          ? data.startingFame.value
          : this.startingFame,
      recruitStatus: data.recruitStatus.present
          ? data.recruitStatus.value
          : this.recruitStatus,
      claimedRole:
          data.claimedRole.present ? data.claimedRole.value : this.claimedRole,
      bioSnippet:
          data.bioSnippet.present ? data.bioSnippet.value : this.bioSnippet,
      isVocalRevealed: data.isVocalRevealed.present
          ? data.isVocalRevealed.value
          : this.isVocalRevealed,
      isDanceRevealed: data.isDanceRevealed.present
          ? data.isDanceRevealed.value
          : this.isDanceRevealed,
      isRapRevealed: data.isRapRevealed.present
          ? data.isRapRevealed.value
          : this.isRapRevealed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedCharacter(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('cohortMonth: $cohortMonth, ')
          ..write('vocalSkill: $vocalSkill, ')
          ..write('danceSkill: $danceSkill, ')
          ..write('rapSkill: $rapSkill, ')
          ..write('vocalPotential: $vocalPotential, ')
          ..write('dancePotential: $dancePotential, ')
          ..write('rapPotential: $rapPotential, ')
          ..write('primaryDiscipline: $primaryDiscipline, ')
          ..write('auditionScore: $auditionScore, ')
          ..write('visualScore: $visualScore, ')
          ..write('charisma: $charisma, ')
          ..write('staminaBase: $staminaBase, ')
          ..write('personalityId: $personalityId, ')
          ..write('rarity: $rarity, ')
          ..write('specialTrait: $specialTrait, ')
          ..write('voiceType: $voiceType, ')
          ..write('openness: $openness, ')
          ..write('conscientiousness: $conscientiousness, ')
          ..write('extraversion: $extraversion, ')
          ..write('agreeableness: $agreeableness, ')
          ..write('neuroticism: $neuroticism, ')
          ..write('startingFame: $startingFame, ')
          ..write('recruitStatus: $recruitStatus, ')
          ..write('claimedRole: $claimedRole, ')
          ..write('bioSnippet: $bioSnippet, ')
          ..write('isVocalRevealed: $isVocalRevealed, ')
          ..write('isDanceRevealed: $isDanceRevealed, ')
          ..write('isRapRevealed: $isRapRevealed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        careerId,
        name,
        imagePath,
        cohortMonth,
        vocalSkill,
        danceSkill,
        rapSkill,
        vocalPotential,
        dancePotential,
        rapPotential,
        primaryDiscipline,
        auditionScore,
        visualScore,
        charisma,
        staminaBase,
        personalityId,
        rarity,
        specialTrait,
        voiceType,
        openness,
        conscientiousness,
        extraversion,
        agreeableness,
        neuroticism,
        startingFame,
        recruitStatus,
        claimedRole,
        bioSnippet,
        isVocalRevealed,
        isDanceRevealed,
        isRapRevealed
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneratedCharacter &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.name == this.name &&
          other.imagePath == this.imagePath &&
          other.cohortMonth == this.cohortMonth &&
          other.vocalSkill == this.vocalSkill &&
          other.danceSkill == this.danceSkill &&
          other.rapSkill == this.rapSkill &&
          other.vocalPotential == this.vocalPotential &&
          other.dancePotential == this.dancePotential &&
          other.rapPotential == this.rapPotential &&
          other.primaryDiscipline == this.primaryDiscipline &&
          other.auditionScore == this.auditionScore &&
          other.visualScore == this.visualScore &&
          other.charisma == this.charisma &&
          other.staminaBase == this.staminaBase &&
          other.personalityId == this.personalityId &&
          other.rarity == this.rarity &&
          other.specialTrait == this.specialTrait &&
          other.voiceType == this.voiceType &&
          other.openness == this.openness &&
          other.conscientiousness == this.conscientiousness &&
          other.extraversion == this.extraversion &&
          other.agreeableness == this.agreeableness &&
          other.neuroticism == this.neuroticism &&
          other.startingFame == this.startingFame &&
          other.recruitStatus == this.recruitStatus &&
          other.claimedRole == this.claimedRole &&
          other.bioSnippet == this.bioSnippet &&
          other.isVocalRevealed == this.isVocalRevealed &&
          other.isDanceRevealed == this.isDanceRevealed &&
          other.isRapRevealed == this.isRapRevealed);
}

class GeneratedCharactersCompanion extends UpdateCompanion<GeneratedCharacter> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<String> name;
  final Value<String?> imagePath;
  final Value<int> cohortMonth;
  final Value<int> vocalSkill;
  final Value<int> danceSkill;
  final Value<int> rapSkill;
  final Value<int> vocalPotential;
  final Value<int> dancePotential;
  final Value<int> rapPotential;
  final Value<String> primaryDiscipline;
  final Value<int> auditionScore;
  final Value<int> visualScore;
  final Value<int> charisma;
  final Value<int> staminaBase;
  final Value<int> personalityId;
  final Value<String> rarity;
  final Value<String?> specialTrait;
  final Value<String?> voiceType;
  final Value<int> openness;
  final Value<int> conscientiousness;
  final Value<int> extraversion;
  final Value<int> agreeableness;
  final Value<int> neuroticism;
  final Value<int> startingFame;
  final Value<String> recruitStatus;
  final Value<String> claimedRole;
  final Value<String?> bioSnippet;
  final Value<bool> isVocalRevealed;
  final Value<bool> isDanceRevealed;
  final Value<bool> isRapRevealed;
  const GeneratedCharactersCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.cohortMonth = const Value.absent(),
    this.vocalSkill = const Value.absent(),
    this.danceSkill = const Value.absent(),
    this.rapSkill = const Value.absent(),
    this.vocalPotential = const Value.absent(),
    this.dancePotential = const Value.absent(),
    this.rapPotential = const Value.absent(),
    this.primaryDiscipline = const Value.absent(),
    this.auditionScore = const Value.absent(),
    this.visualScore = const Value.absent(),
    this.charisma = const Value.absent(),
    this.staminaBase = const Value.absent(),
    this.personalityId = const Value.absent(),
    this.rarity = const Value.absent(),
    this.specialTrait = const Value.absent(),
    this.voiceType = const Value.absent(),
    this.openness = const Value.absent(),
    this.conscientiousness = const Value.absent(),
    this.extraversion = const Value.absent(),
    this.agreeableness = const Value.absent(),
    this.neuroticism = const Value.absent(),
    this.startingFame = const Value.absent(),
    this.recruitStatus = const Value.absent(),
    this.claimedRole = const Value.absent(),
    this.bioSnippet = const Value.absent(),
    this.isVocalRevealed = const Value.absent(),
    this.isDanceRevealed = const Value.absent(),
    this.isRapRevealed = const Value.absent(),
  });
  GeneratedCharactersCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required String name,
    this.imagePath = const Value.absent(),
    this.cohortMonth = const Value.absent(),
    required int vocalSkill,
    required int danceSkill,
    required int rapSkill,
    this.vocalPotential = const Value.absent(),
    this.dancePotential = const Value.absent(),
    this.rapPotential = const Value.absent(),
    this.primaryDiscipline = const Value.absent(),
    this.auditionScore = const Value.absent(),
    required int visualScore,
    required int charisma,
    required int staminaBase,
    required int personalityId,
    required String rarity,
    this.specialTrait = const Value.absent(),
    this.voiceType = const Value.absent(),
    this.openness = const Value.absent(),
    this.conscientiousness = const Value.absent(),
    this.extraversion = const Value.absent(),
    this.agreeableness = const Value.absent(),
    this.neuroticism = const Value.absent(),
    this.startingFame = const Value.absent(),
    this.recruitStatus = const Value.absent(),
    this.claimedRole = const Value.absent(),
    this.bioSnippet = const Value.absent(),
    this.isVocalRevealed = const Value.absent(),
    this.isDanceRevealed = const Value.absent(),
    this.isRapRevealed = const Value.absent(),
  })  : careerId = Value(careerId),
        name = Value(name),
        vocalSkill = Value(vocalSkill),
        danceSkill = Value(danceSkill),
        rapSkill = Value(rapSkill),
        visualScore = Value(visualScore),
        charisma = Value(charisma),
        staminaBase = Value(staminaBase),
        personalityId = Value(personalityId),
        rarity = Value(rarity);
  static Insertable<GeneratedCharacter> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<int>? cohortMonth,
    Expression<int>? vocalSkill,
    Expression<int>? danceSkill,
    Expression<int>? rapSkill,
    Expression<int>? vocalPotential,
    Expression<int>? dancePotential,
    Expression<int>? rapPotential,
    Expression<String>? primaryDiscipline,
    Expression<int>? auditionScore,
    Expression<int>? visualScore,
    Expression<int>? charisma,
    Expression<int>? staminaBase,
    Expression<int>? personalityId,
    Expression<String>? rarity,
    Expression<String>? specialTrait,
    Expression<String>? voiceType,
    Expression<int>? openness,
    Expression<int>? conscientiousness,
    Expression<int>? extraversion,
    Expression<int>? agreeableness,
    Expression<int>? neuroticism,
    Expression<int>? startingFame,
    Expression<String>? recruitStatus,
    Expression<String>? claimedRole,
    Expression<String>? bioSnippet,
    Expression<bool>? isVocalRevealed,
    Expression<bool>? isDanceRevealed,
    Expression<bool>? isRapRevealed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (cohortMonth != null) 'cohort_month': cohortMonth,
      if (vocalSkill != null) 'vocal_skill': vocalSkill,
      if (danceSkill != null) 'dance_skill': danceSkill,
      if (rapSkill != null) 'rap_skill': rapSkill,
      if (vocalPotential != null) 'vocal_potential': vocalPotential,
      if (dancePotential != null) 'dance_potential': dancePotential,
      if (rapPotential != null) 'rap_potential': rapPotential,
      if (primaryDiscipline != null) 'primary_discipline': primaryDiscipline,
      if (auditionScore != null) 'audition_score': auditionScore,
      if (visualScore != null) 'visual_score': visualScore,
      if (charisma != null) 'charisma': charisma,
      if (staminaBase != null) 'stamina_base': staminaBase,
      if (personalityId != null) 'personality_id': personalityId,
      if (rarity != null) 'rarity': rarity,
      if (specialTrait != null) 'special_trait': specialTrait,
      if (voiceType != null) 'voice_type': voiceType,
      if (openness != null) 'openness': openness,
      if (conscientiousness != null) 'conscientiousness': conscientiousness,
      if (extraversion != null) 'extraversion': extraversion,
      if (agreeableness != null) 'agreeableness': agreeableness,
      if (neuroticism != null) 'neuroticism': neuroticism,
      if (startingFame != null) 'starting_fame': startingFame,
      if (recruitStatus != null) 'recruit_status': recruitStatus,
      if (claimedRole != null) 'claimed_role': claimedRole,
      if (bioSnippet != null) 'bio_snippet': bioSnippet,
      if (isVocalRevealed != null) 'is_vocal_revealed': isVocalRevealed,
      if (isDanceRevealed != null) 'is_dance_revealed': isDanceRevealed,
      if (isRapRevealed != null) 'is_rap_revealed': isRapRevealed,
    });
  }

  GeneratedCharactersCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<String>? name,
      Value<String?>? imagePath,
      Value<int>? cohortMonth,
      Value<int>? vocalSkill,
      Value<int>? danceSkill,
      Value<int>? rapSkill,
      Value<int>? vocalPotential,
      Value<int>? dancePotential,
      Value<int>? rapPotential,
      Value<String>? primaryDiscipline,
      Value<int>? auditionScore,
      Value<int>? visualScore,
      Value<int>? charisma,
      Value<int>? staminaBase,
      Value<int>? personalityId,
      Value<String>? rarity,
      Value<String?>? specialTrait,
      Value<String?>? voiceType,
      Value<int>? openness,
      Value<int>? conscientiousness,
      Value<int>? extraversion,
      Value<int>? agreeableness,
      Value<int>? neuroticism,
      Value<int>? startingFame,
      Value<String>? recruitStatus,
      Value<String>? claimedRole,
      Value<String?>? bioSnippet,
      Value<bool>? isVocalRevealed,
      Value<bool>? isDanceRevealed,
      Value<bool>? isRapRevealed}) {
    return GeneratedCharactersCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      cohortMonth: cohortMonth ?? this.cohortMonth,
      vocalSkill: vocalSkill ?? this.vocalSkill,
      danceSkill: danceSkill ?? this.danceSkill,
      rapSkill: rapSkill ?? this.rapSkill,
      vocalPotential: vocalPotential ?? this.vocalPotential,
      dancePotential: dancePotential ?? this.dancePotential,
      rapPotential: rapPotential ?? this.rapPotential,
      primaryDiscipline: primaryDiscipline ?? this.primaryDiscipline,
      auditionScore: auditionScore ?? this.auditionScore,
      visualScore: visualScore ?? this.visualScore,
      charisma: charisma ?? this.charisma,
      staminaBase: staminaBase ?? this.staminaBase,
      personalityId: personalityId ?? this.personalityId,
      rarity: rarity ?? this.rarity,
      specialTrait: specialTrait ?? this.specialTrait,
      voiceType: voiceType ?? this.voiceType,
      openness: openness ?? this.openness,
      conscientiousness: conscientiousness ?? this.conscientiousness,
      extraversion: extraversion ?? this.extraversion,
      agreeableness: agreeableness ?? this.agreeableness,
      neuroticism: neuroticism ?? this.neuroticism,
      startingFame: startingFame ?? this.startingFame,
      recruitStatus: recruitStatus ?? this.recruitStatus,
      claimedRole: claimedRole ?? this.claimedRole,
      bioSnippet: bioSnippet ?? this.bioSnippet,
      isVocalRevealed: isVocalRevealed ?? this.isVocalRevealed,
      isDanceRevealed: isDanceRevealed ?? this.isDanceRevealed,
      isRapRevealed: isRapRevealed ?? this.isRapRevealed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (cohortMonth.present) {
      map['cohort_month'] = Variable<int>(cohortMonth.value);
    }
    if (vocalSkill.present) {
      map['vocal_skill'] = Variable<int>(vocalSkill.value);
    }
    if (danceSkill.present) {
      map['dance_skill'] = Variable<int>(danceSkill.value);
    }
    if (rapSkill.present) {
      map['rap_skill'] = Variable<int>(rapSkill.value);
    }
    if (vocalPotential.present) {
      map['vocal_potential'] = Variable<int>(vocalPotential.value);
    }
    if (dancePotential.present) {
      map['dance_potential'] = Variable<int>(dancePotential.value);
    }
    if (rapPotential.present) {
      map['rap_potential'] = Variable<int>(rapPotential.value);
    }
    if (primaryDiscipline.present) {
      map['primary_discipline'] = Variable<String>(primaryDiscipline.value);
    }
    if (auditionScore.present) {
      map['audition_score'] = Variable<int>(auditionScore.value);
    }
    if (visualScore.present) {
      map['visual_score'] = Variable<int>(visualScore.value);
    }
    if (charisma.present) {
      map['charisma'] = Variable<int>(charisma.value);
    }
    if (staminaBase.present) {
      map['stamina_base'] = Variable<int>(staminaBase.value);
    }
    if (personalityId.present) {
      map['personality_id'] = Variable<int>(personalityId.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (specialTrait.present) {
      map['special_trait'] = Variable<String>(specialTrait.value);
    }
    if (voiceType.present) {
      map['voice_type'] = Variable<String>(voiceType.value);
    }
    if (openness.present) {
      map['openness'] = Variable<int>(openness.value);
    }
    if (conscientiousness.present) {
      map['conscientiousness'] = Variable<int>(conscientiousness.value);
    }
    if (extraversion.present) {
      map['extraversion'] = Variable<int>(extraversion.value);
    }
    if (agreeableness.present) {
      map['agreeableness'] = Variable<int>(agreeableness.value);
    }
    if (neuroticism.present) {
      map['neuroticism'] = Variable<int>(neuroticism.value);
    }
    if (startingFame.present) {
      map['starting_fame'] = Variable<int>(startingFame.value);
    }
    if (recruitStatus.present) {
      map['recruit_status'] = Variable<String>(recruitStatus.value);
    }
    if (claimedRole.present) {
      map['claimed_role'] = Variable<String>(claimedRole.value);
    }
    if (bioSnippet.present) {
      map['bio_snippet'] = Variable<String>(bioSnippet.value);
    }
    if (isVocalRevealed.present) {
      map['is_vocal_revealed'] = Variable<bool>(isVocalRevealed.value);
    }
    if (isDanceRevealed.present) {
      map['is_dance_revealed'] = Variable<bool>(isDanceRevealed.value);
    }
    if (isRapRevealed.present) {
      map['is_rap_revealed'] = Variable<bool>(isRapRevealed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedCharactersCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('cohortMonth: $cohortMonth, ')
          ..write('vocalSkill: $vocalSkill, ')
          ..write('danceSkill: $danceSkill, ')
          ..write('rapSkill: $rapSkill, ')
          ..write('vocalPotential: $vocalPotential, ')
          ..write('dancePotential: $dancePotential, ')
          ..write('rapPotential: $rapPotential, ')
          ..write('primaryDiscipline: $primaryDiscipline, ')
          ..write('auditionScore: $auditionScore, ')
          ..write('visualScore: $visualScore, ')
          ..write('charisma: $charisma, ')
          ..write('staminaBase: $staminaBase, ')
          ..write('personalityId: $personalityId, ')
          ..write('rarity: $rarity, ')
          ..write('specialTrait: $specialTrait, ')
          ..write('voiceType: $voiceType, ')
          ..write('openness: $openness, ')
          ..write('conscientiousness: $conscientiousness, ')
          ..write('extraversion: $extraversion, ')
          ..write('agreeableness: $agreeableness, ')
          ..write('neuroticism: $neuroticism, ')
          ..write('startingFame: $startingFame, ')
          ..write('recruitStatus: $recruitStatus, ')
          ..write('claimedRole: $claimedRole, ')
          ..write('bioSnippet: $bioSnippet, ')
          ..write('isVocalRevealed: $isVocalRevealed, ')
          ..write('isDanceRevealed: $isDanceRevealed, ')
          ..write('isRapRevealed: $isRapRevealed')
          ..write(')'))
        .toString();
  }
}

class $CurrencyWalletsTable extends CurrencyWallets
    with TableInfo<$CurrencyWalletsTable, CurrencyWallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyWalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _fanPointsMeta =
      const VerificationMeta('fanPoints');
  @override
  late final GeneratedColumn<int> fanPoints = GeneratedColumn<int>(
      'fan_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _premiumGemsMeta =
      const VerificationMeta('premiumGems');
  @override
  late final GeneratedColumn<int> premiumGems = GeneratedColumn<int>(
      'premium_gems', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, careerId, fanPoints, premiumGems];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_wallets';
  @override
  VerificationContext validateIntegrity(Insertable<CurrencyWallet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('fan_points')) {
      context.handle(_fanPointsMeta,
          fanPoints.isAcceptableOrUnknown(data['fan_points']!, _fanPointsMeta));
    }
    if (data.containsKey('premium_gems')) {
      context.handle(
          _premiumGemsMeta,
          premiumGems.isAcceptableOrUnknown(
              data['premium_gems']!, _premiumGemsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {careerId},
      ];
  @override
  CurrencyWallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyWallet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      fanPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fan_points'])!,
      premiumGems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}premium_gems'])!,
    );
  }

  @override
  $CurrencyWalletsTable createAlias(String alias) {
    return $CurrencyWalletsTable(attachedDatabase, alias);
  }
}

class CurrencyWallet extends DataClass implements Insertable<CurrencyWallet> {
  final int id;
  final int careerId;
  final int fanPoints;
  final int premiumGems;
  const CurrencyWallet(
      {required this.id,
      required this.careerId,
      required this.fanPoints,
      required this.premiumGems});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['fan_points'] = Variable<int>(fanPoints);
    map['premium_gems'] = Variable<int>(premiumGems);
    return map;
  }

  CurrencyWalletsCompanion toCompanion(bool nullToAbsent) {
    return CurrencyWalletsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      fanPoints: Value(fanPoints),
      premiumGems: Value(premiumGems),
    );
  }

  factory CurrencyWallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyWallet(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      fanPoints: serializer.fromJson<int>(json['fanPoints']),
      premiumGems: serializer.fromJson<int>(json['premiumGems']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'fanPoints': serializer.toJson<int>(fanPoints),
      'premiumGems': serializer.toJson<int>(premiumGems),
    };
  }

  CurrencyWallet copyWith(
          {int? id, int? careerId, int? fanPoints, int? premiumGems}) =>
      CurrencyWallet(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        fanPoints: fanPoints ?? this.fanPoints,
        premiumGems: premiumGems ?? this.premiumGems,
      );
  CurrencyWallet copyWithCompanion(CurrencyWalletsCompanion data) {
    return CurrencyWallet(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      fanPoints: data.fanPoints.present ? data.fanPoints.value : this.fanPoints,
      premiumGems:
          data.premiumGems.present ? data.premiumGems.value : this.premiumGems,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyWallet(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('fanPoints: $fanPoints, ')
          ..write('premiumGems: $premiumGems')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, careerId, fanPoints, premiumGems);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyWallet &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.fanPoints == this.fanPoints &&
          other.premiumGems == this.premiumGems);
}

class CurrencyWalletsCompanion extends UpdateCompanion<CurrencyWallet> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> fanPoints;
  final Value<int> premiumGems;
  const CurrencyWalletsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.fanPoints = const Value.absent(),
    this.premiumGems = const Value.absent(),
  });
  CurrencyWalletsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    this.fanPoints = const Value.absent(),
    this.premiumGems = const Value.absent(),
  }) : careerId = Value(careerId);
  static Insertable<CurrencyWallet> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? fanPoints,
    Expression<int>? premiumGems,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (fanPoints != null) 'fan_points': fanPoints,
      if (premiumGems != null) 'premium_gems': premiumGems,
    });
  }

  CurrencyWalletsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<int>? fanPoints,
      Value<int>? premiumGems}) {
    return CurrencyWalletsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      fanPoints: fanPoints ?? this.fanPoints,
      premiumGems: premiumGems ?? this.premiumGems,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (fanPoints.present) {
      map['fan_points'] = Variable<int>(fanPoints.value);
    }
    if (premiumGems.present) {
      map['premium_gems'] = Variable<int>(premiumGems.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyWalletsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('fanPoints: $fanPoints, ')
          ..write('premiumGems: $premiumGems')
          ..write(')'))
        .toString();
  }
}

class $CareerHistoriesTable extends CareerHistories
    with TableInfo<$CareerHistoriesTable, CareerHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareerHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _careerNumberMeta =
      const VerificationMeta('careerNumber');
  @override
  late final GeneratedColumn<int> careerNumber = GeneratedColumn<int>(
      'career_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _groupNameMeta =
      const VerificationMeta('groupName');
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
      'group_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _finalPopularityMeta =
      const VerificationMeta('finalPopularity');
  @override
  late final GeneratedColumn<int> finalPopularity = GeneratedColumn<int>(
      'final_popularity', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _monthsPlayedMeta =
      const VerificationMeta('monthsPlayed');
  @override
  late final GeneratedColumn<int> monthsPlayed = GeneratedColumn<int>(
      'months_played', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _peakChartPositionMeta =
      const VerificationMeta('peakChartPosition');
  @override
  late final GeneratedColumn<int> peakChartPosition = GeneratedColumn<int>(
      'peak_chart_position', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _finalScoreMeta =
      const VerificationMeta('finalScore');
  @override
  late final GeneratedColumn<int> finalScore = GeneratedColumn<int>(
      'final_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _awardsWonMeta =
      const VerificationMeta('awardsWon');
  @override
  late final GeneratedColumn<int> awardsWon = GeneratedColumn<int>(
      'awards_won', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _agencyNameMeta =
      const VerificationMeta('agencyName');
  @override
  late final GeneratedColumn<String> agencyName = GeneratedColumn<String>(
      'agency_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unlockedLegacyBonusMeta =
      const VerificationMeta('unlockedLegacyBonus');
  @override
  late final GeneratedColumn<String> unlockedLegacyBonus =
      GeneratedColumn<String>('unlocked_legacy_bonus', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerId,
        careerNumber,
        groupName,
        finalPopularity,
        monthsPlayed,
        peakChartPosition,
        finalScore,
        awardsWon,
        agencyName,
        unlockedLegacyBonus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'career_histories';
  @override
  VerificationContext validateIntegrity(Insertable<CareerHistory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('career_number')) {
      context.handle(
          _careerNumberMeta,
          careerNumber.isAcceptableOrUnknown(
              data['career_number']!, _careerNumberMeta));
    } else if (isInserting) {
      context.missing(_careerNumberMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(_groupNameMeta,
          groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta));
    }
    if (data.containsKey('final_popularity')) {
      context.handle(
          _finalPopularityMeta,
          finalPopularity.isAcceptableOrUnknown(
              data['final_popularity']!, _finalPopularityMeta));
    }
    if (data.containsKey('months_played')) {
      context.handle(
          _monthsPlayedMeta,
          monthsPlayed.isAcceptableOrUnknown(
              data['months_played']!, _monthsPlayedMeta));
    }
    if (data.containsKey('peak_chart_position')) {
      context.handle(
          _peakChartPositionMeta,
          peakChartPosition.isAcceptableOrUnknown(
              data['peak_chart_position']!, _peakChartPositionMeta));
    }
    if (data.containsKey('final_score')) {
      context.handle(
          _finalScoreMeta,
          finalScore.isAcceptableOrUnknown(
              data['final_score']!, _finalScoreMeta));
    }
    if (data.containsKey('awards_won')) {
      context.handle(_awardsWonMeta,
          awardsWon.isAcceptableOrUnknown(data['awards_won']!, _awardsWonMeta));
    }
    if (data.containsKey('agency_name')) {
      context.handle(
          _agencyNameMeta,
          agencyName.isAcceptableOrUnknown(
              data['agency_name']!, _agencyNameMeta));
    }
    if (data.containsKey('unlocked_legacy_bonus')) {
      context.handle(
          _unlockedLegacyBonusMeta,
          unlockedLegacyBonus.isAcceptableOrUnknown(
              data['unlocked_legacy_bonus']!, _unlockedLegacyBonusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {careerId},
      ];
  @override
  CareerHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareerHistory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      careerNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_number'])!,
      groupName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_name']),
      finalPopularity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}final_popularity']),
      monthsPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}months_played']),
      peakChartPosition: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}peak_chart_position']),
      finalScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}final_score']),
      awardsWon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}awards_won'])!,
      agencyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agency_name']),
      unlockedLegacyBonus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unlocked_legacy_bonus']),
    );
  }

  @override
  $CareerHistoriesTable createAlias(String alias) {
    return $CareerHistoriesTable(attachedDatabase, alias);
  }
}

class CareerHistory extends DataClass implements Insertable<CareerHistory> {
  final int id;
  final int careerId;
  final int careerNumber;
  final String? groupName;
  final int? finalPopularity;
  final int? monthsPlayed;
  final int? peakChartPosition;
  final int? finalScore;
  final int awardsWon;
  final String? agencyName;
  final String? unlockedLegacyBonus;
  const CareerHistory(
      {required this.id,
      required this.careerId,
      required this.careerNumber,
      this.groupName,
      this.finalPopularity,
      this.monthsPlayed,
      this.peakChartPosition,
      this.finalScore,
      required this.awardsWon,
      this.agencyName,
      this.unlockedLegacyBonus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['career_number'] = Variable<int>(careerNumber);
    if (!nullToAbsent || groupName != null) {
      map['group_name'] = Variable<String>(groupName);
    }
    if (!nullToAbsent || finalPopularity != null) {
      map['final_popularity'] = Variable<int>(finalPopularity);
    }
    if (!nullToAbsent || monthsPlayed != null) {
      map['months_played'] = Variable<int>(monthsPlayed);
    }
    if (!nullToAbsent || peakChartPosition != null) {
      map['peak_chart_position'] = Variable<int>(peakChartPosition);
    }
    if (!nullToAbsent || finalScore != null) {
      map['final_score'] = Variable<int>(finalScore);
    }
    map['awards_won'] = Variable<int>(awardsWon);
    if (!nullToAbsent || agencyName != null) {
      map['agency_name'] = Variable<String>(agencyName);
    }
    if (!nullToAbsent || unlockedLegacyBonus != null) {
      map['unlocked_legacy_bonus'] = Variable<String>(unlockedLegacyBonus);
    }
    return map;
  }

  CareerHistoriesCompanion toCompanion(bool nullToAbsent) {
    return CareerHistoriesCompanion(
      id: Value(id),
      careerId: Value(careerId),
      careerNumber: Value(careerNumber),
      groupName: groupName == null && nullToAbsent
          ? const Value.absent()
          : Value(groupName),
      finalPopularity: finalPopularity == null && nullToAbsent
          ? const Value.absent()
          : Value(finalPopularity),
      monthsPlayed: monthsPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(monthsPlayed),
      peakChartPosition: peakChartPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(peakChartPosition),
      finalScore: finalScore == null && nullToAbsent
          ? const Value.absent()
          : Value(finalScore),
      awardsWon: Value(awardsWon),
      agencyName: agencyName == null && nullToAbsent
          ? const Value.absent()
          : Value(agencyName),
      unlockedLegacyBonus: unlockedLegacyBonus == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedLegacyBonus),
    );
  }

  factory CareerHistory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareerHistory(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      careerNumber: serializer.fromJson<int>(json['careerNumber']),
      groupName: serializer.fromJson<String?>(json['groupName']),
      finalPopularity: serializer.fromJson<int?>(json['finalPopularity']),
      monthsPlayed: serializer.fromJson<int?>(json['monthsPlayed']),
      peakChartPosition: serializer.fromJson<int?>(json['peakChartPosition']),
      finalScore: serializer.fromJson<int?>(json['finalScore']),
      awardsWon: serializer.fromJson<int>(json['awardsWon']),
      agencyName: serializer.fromJson<String?>(json['agencyName']),
      unlockedLegacyBonus:
          serializer.fromJson<String?>(json['unlockedLegacyBonus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'careerNumber': serializer.toJson<int>(careerNumber),
      'groupName': serializer.toJson<String?>(groupName),
      'finalPopularity': serializer.toJson<int?>(finalPopularity),
      'monthsPlayed': serializer.toJson<int?>(monthsPlayed),
      'peakChartPosition': serializer.toJson<int?>(peakChartPosition),
      'finalScore': serializer.toJson<int?>(finalScore),
      'awardsWon': serializer.toJson<int>(awardsWon),
      'agencyName': serializer.toJson<String?>(agencyName),
      'unlockedLegacyBonus': serializer.toJson<String?>(unlockedLegacyBonus),
    };
  }

  CareerHistory copyWith(
          {int? id,
          int? careerId,
          int? careerNumber,
          Value<String?> groupName = const Value.absent(),
          Value<int?> finalPopularity = const Value.absent(),
          Value<int?> monthsPlayed = const Value.absent(),
          Value<int?> peakChartPosition = const Value.absent(),
          Value<int?> finalScore = const Value.absent(),
          int? awardsWon,
          Value<String?> agencyName = const Value.absent(),
          Value<String?> unlockedLegacyBonus = const Value.absent()}) =>
      CareerHistory(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        careerNumber: careerNumber ?? this.careerNumber,
        groupName: groupName.present ? groupName.value : this.groupName,
        finalPopularity: finalPopularity.present
            ? finalPopularity.value
            : this.finalPopularity,
        monthsPlayed:
            monthsPlayed.present ? monthsPlayed.value : this.monthsPlayed,
        peakChartPosition: peakChartPosition.present
            ? peakChartPosition.value
            : this.peakChartPosition,
        finalScore: finalScore.present ? finalScore.value : this.finalScore,
        awardsWon: awardsWon ?? this.awardsWon,
        agencyName: agencyName.present ? agencyName.value : this.agencyName,
        unlockedLegacyBonus: unlockedLegacyBonus.present
            ? unlockedLegacyBonus.value
            : this.unlockedLegacyBonus,
      );
  CareerHistory copyWithCompanion(CareerHistoriesCompanion data) {
    return CareerHistory(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      careerNumber: data.careerNumber.present
          ? data.careerNumber.value
          : this.careerNumber,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      finalPopularity: data.finalPopularity.present
          ? data.finalPopularity.value
          : this.finalPopularity,
      monthsPlayed: data.monthsPlayed.present
          ? data.monthsPlayed.value
          : this.monthsPlayed,
      peakChartPosition: data.peakChartPosition.present
          ? data.peakChartPosition.value
          : this.peakChartPosition,
      finalScore:
          data.finalScore.present ? data.finalScore.value : this.finalScore,
      awardsWon: data.awardsWon.present ? data.awardsWon.value : this.awardsWon,
      agencyName:
          data.agencyName.present ? data.agencyName.value : this.agencyName,
      unlockedLegacyBonus: data.unlockedLegacyBonus.present
          ? data.unlockedLegacyBonus.value
          : this.unlockedLegacyBonus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareerHistory(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('careerNumber: $careerNumber, ')
          ..write('groupName: $groupName, ')
          ..write('finalPopularity: $finalPopularity, ')
          ..write('monthsPlayed: $monthsPlayed, ')
          ..write('peakChartPosition: $peakChartPosition, ')
          ..write('finalScore: $finalScore, ')
          ..write('awardsWon: $awardsWon, ')
          ..write('agencyName: $agencyName, ')
          ..write('unlockedLegacyBonus: $unlockedLegacyBonus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      careerId,
      careerNumber,
      groupName,
      finalPopularity,
      monthsPlayed,
      peakChartPosition,
      finalScore,
      awardsWon,
      agencyName,
      unlockedLegacyBonus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareerHistory &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.careerNumber == this.careerNumber &&
          other.groupName == this.groupName &&
          other.finalPopularity == this.finalPopularity &&
          other.monthsPlayed == this.monthsPlayed &&
          other.peakChartPosition == this.peakChartPosition &&
          other.finalScore == this.finalScore &&
          other.awardsWon == this.awardsWon &&
          other.agencyName == this.agencyName &&
          other.unlockedLegacyBonus == this.unlockedLegacyBonus);
}

class CareerHistoriesCompanion extends UpdateCompanion<CareerHistory> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> careerNumber;
  final Value<String?> groupName;
  final Value<int?> finalPopularity;
  final Value<int?> monthsPlayed;
  final Value<int?> peakChartPosition;
  final Value<int?> finalScore;
  final Value<int> awardsWon;
  final Value<String?> agencyName;
  final Value<String?> unlockedLegacyBonus;
  const CareerHistoriesCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.careerNumber = const Value.absent(),
    this.groupName = const Value.absent(),
    this.finalPopularity = const Value.absent(),
    this.monthsPlayed = const Value.absent(),
    this.peakChartPosition = const Value.absent(),
    this.finalScore = const Value.absent(),
    this.awardsWon = const Value.absent(),
    this.agencyName = const Value.absent(),
    this.unlockedLegacyBonus = const Value.absent(),
  });
  CareerHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int careerNumber,
    this.groupName = const Value.absent(),
    this.finalPopularity = const Value.absent(),
    this.monthsPlayed = const Value.absent(),
    this.peakChartPosition = const Value.absent(),
    this.finalScore = const Value.absent(),
    this.awardsWon = const Value.absent(),
    this.agencyName = const Value.absent(),
    this.unlockedLegacyBonus = const Value.absent(),
  })  : careerId = Value(careerId),
        careerNumber = Value(careerNumber);
  static Insertable<CareerHistory> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? careerNumber,
    Expression<String>? groupName,
    Expression<int>? finalPopularity,
    Expression<int>? monthsPlayed,
    Expression<int>? peakChartPosition,
    Expression<int>? finalScore,
    Expression<int>? awardsWon,
    Expression<String>? agencyName,
    Expression<String>? unlockedLegacyBonus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (careerNumber != null) 'career_number': careerNumber,
      if (groupName != null) 'group_name': groupName,
      if (finalPopularity != null) 'final_popularity': finalPopularity,
      if (monthsPlayed != null) 'months_played': monthsPlayed,
      if (peakChartPosition != null) 'peak_chart_position': peakChartPosition,
      if (finalScore != null) 'final_score': finalScore,
      if (awardsWon != null) 'awards_won': awardsWon,
      if (agencyName != null) 'agency_name': agencyName,
      if (unlockedLegacyBonus != null)
        'unlocked_legacy_bonus': unlockedLegacyBonus,
    });
  }

  CareerHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<int>? careerNumber,
      Value<String?>? groupName,
      Value<int?>? finalPopularity,
      Value<int?>? monthsPlayed,
      Value<int?>? peakChartPosition,
      Value<int?>? finalScore,
      Value<int>? awardsWon,
      Value<String?>? agencyName,
      Value<String?>? unlockedLegacyBonus}) {
    return CareerHistoriesCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      careerNumber: careerNumber ?? this.careerNumber,
      groupName: groupName ?? this.groupName,
      finalPopularity: finalPopularity ?? this.finalPopularity,
      monthsPlayed: monthsPlayed ?? this.monthsPlayed,
      peakChartPosition: peakChartPosition ?? this.peakChartPosition,
      finalScore: finalScore ?? this.finalScore,
      awardsWon: awardsWon ?? this.awardsWon,
      agencyName: agencyName ?? this.agencyName,
      unlockedLegacyBonus: unlockedLegacyBonus ?? this.unlockedLegacyBonus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (careerNumber.present) {
      map['career_number'] = Variable<int>(careerNumber.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (finalPopularity.present) {
      map['final_popularity'] = Variable<int>(finalPopularity.value);
    }
    if (monthsPlayed.present) {
      map['months_played'] = Variable<int>(monthsPlayed.value);
    }
    if (peakChartPosition.present) {
      map['peak_chart_position'] = Variable<int>(peakChartPosition.value);
    }
    if (finalScore.present) {
      map['final_score'] = Variable<int>(finalScore.value);
    }
    if (awardsWon.present) {
      map['awards_won'] = Variable<int>(awardsWon.value);
    }
    if (agencyName.present) {
      map['agency_name'] = Variable<String>(agencyName.value);
    }
    if (unlockedLegacyBonus.present) {
      map['unlocked_legacy_bonus'] =
          Variable<String>(unlockedLegacyBonus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareerHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('careerNumber: $careerNumber, ')
          ..write('groupName: $groupName, ')
          ..write('finalPopularity: $finalPopularity, ')
          ..write('monthsPlayed: $monthsPlayed, ')
          ..write('peakChartPosition: $peakChartPosition, ')
          ..write('finalScore: $finalScore, ')
          ..write('awardsWon: $awardsWon, ')
          ..write('agencyName: $agencyName, ')
          ..write('unlockedLegacyBonus: $unlockedLegacyBonus')
          ..write(')'))
        .toString();
  }
}

class $PlayerIdolsTable extends PlayerIdols
    with TableInfo<$PlayerIdolsTable, PlayerIdol> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerIdolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
      'character_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES generated_characters (id)'));
  static const VerificationMeta _recruitedMonthMeta =
      const VerificationMeta('recruitedMonth');
  @override
  late final GeneratedColumn<int> recruitedMonth = GeneratedColumn<int>(
      'recruited_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentLevelMeta =
      const VerificationMeta('currentLevel');
  @override
  late final GeneratedColumn<int> currentLevel = GeneratedColumn<int>(
      'current_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _vocalBonusMeta =
      const VerificationMeta('vocalBonus');
  @override
  late final GeneratedColumn<int> vocalBonus = GeneratedColumn<int>(
      'vocal_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _danceBonusMeta =
      const VerificationMeta('danceBonus');
  @override
  late final GeneratedColumn<int> danceBonus = GeneratedColumn<int>(
      'dance_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _rapBonusMeta =
      const VerificationMeta('rapBonus');
  @override
  late final GeneratedColumn<int> rapBonus = GeneratedColumn<int>(
      'rap_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _visualBonusMeta =
      const VerificationMeta('visualBonus');
  @override
  late final GeneratedColumn<int> visualBonus = GeneratedColumn<int>(
      'visual_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _charismaBonusMeta =
      const VerificationMeta('charismaBonus');
  @override
  late final GeneratedColumn<int> charismaBonus = GeneratedColumn<int>(
      'charisma_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _fatigueMeta =
      const VerificationMeta('fatigue');
  @override
  late final GeneratedColumn<int> fatigue = GeneratedColumn<int>(
      'fatigue', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
      'mood', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(70));
  static const VerificationMeta _loyaltyMeta =
      const VerificationMeta('loyalty');
  @override
  late final GeneratedColumn<int> loyalty = GeneratedColumn<int>(
      'loyalty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(70));
  static const VerificationMeta _popularityBonusMeta =
      const VerificationMeta('popularityBonus');
  @override
  late final GeneratedColumn<int> popularityBonus = GeneratedColumn<int>(
      'popularity_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _salaryBonusMeta =
      const VerificationMeta('salaryBonus');
  @override
  late final GeneratedColumn<int> salaryBonus = GeneratedColumn<int>(
      'salary_bonus', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerId,
        characterId,
        recruitedMonth,
        currentLevel,
        vocalBonus,
        danceBonus,
        rapBonus,
        visualBonus,
        charismaBonus,
        fatigue,
        mood,
        loyalty,
        popularityBonus,
        salaryBonus,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_idols';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerIdol> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('recruited_month')) {
      context.handle(
          _recruitedMonthMeta,
          recruitedMonth.isAcceptableOrUnknown(
              data['recruited_month']!, _recruitedMonthMeta));
    } else if (isInserting) {
      context.missing(_recruitedMonthMeta);
    }
    if (data.containsKey('current_level')) {
      context.handle(
          _currentLevelMeta,
          currentLevel.isAcceptableOrUnknown(
              data['current_level']!, _currentLevelMeta));
    }
    if (data.containsKey('vocal_bonus')) {
      context.handle(
          _vocalBonusMeta,
          vocalBonus.isAcceptableOrUnknown(
              data['vocal_bonus']!, _vocalBonusMeta));
    }
    if (data.containsKey('dance_bonus')) {
      context.handle(
          _danceBonusMeta,
          danceBonus.isAcceptableOrUnknown(
              data['dance_bonus']!, _danceBonusMeta));
    }
    if (data.containsKey('rap_bonus')) {
      context.handle(_rapBonusMeta,
          rapBonus.isAcceptableOrUnknown(data['rap_bonus']!, _rapBonusMeta));
    }
    if (data.containsKey('visual_bonus')) {
      context.handle(
          _visualBonusMeta,
          visualBonus.isAcceptableOrUnknown(
              data['visual_bonus']!, _visualBonusMeta));
    }
    if (data.containsKey('charisma_bonus')) {
      context.handle(
          _charismaBonusMeta,
          charismaBonus.isAcceptableOrUnknown(
              data['charisma_bonus']!, _charismaBonusMeta));
    }
    if (data.containsKey('fatigue')) {
      context.handle(_fatigueMeta,
          fatigue.isAcceptableOrUnknown(data['fatigue']!, _fatigueMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('loyalty')) {
      context.handle(_loyaltyMeta,
          loyalty.isAcceptableOrUnknown(data['loyalty']!, _loyaltyMeta));
    }
    if (data.containsKey('popularity_bonus')) {
      context.handle(
          _popularityBonusMeta,
          popularityBonus.isAcceptableOrUnknown(
              data['popularity_bonus']!, _popularityBonusMeta));
    }
    if (data.containsKey('salary_bonus')) {
      context.handle(
          _salaryBonusMeta,
          salaryBonus.isAcceptableOrUnknown(
              data['salary_bonus']!, _salaryBonusMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerIdol map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerIdol(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}character_id'])!,
      recruitedMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recruited_month'])!,
      currentLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_level'])!,
      vocalBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocal_bonus'])!,
      danceBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dance_bonus'])!,
      rapBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rap_bonus'])!,
      visualBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visual_bonus'])!,
      charismaBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}charisma_bonus'])!,
      fatigue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fatigue'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood'])!,
      loyalty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}loyalty'])!,
      popularityBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}popularity_bonus'])!,
      salaryBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}salary_bonus'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $PlayerIdolsTable createAlias(String alias) {
    return $PlayerIdolsTable(attachedDatabase, alias);
  }
}

class PlayerIdol extends DataClass implements Insertable<PlayerIdol> {
  final int id;
  final int careerId;
  final int characterId;
  final int recruitedMonth;
  final int currentLevel;
  final int vocalBonus;
  final int danceBonus;
  final int rapBonus;
  final int visualBonus;
  final int charismaBonus;
  final int fatigue;
  final int mood;
  final int loyalty;
  final int popularityBonus;
  final int salaryBonus;
  final String status;
  const PlayerIdol(
      {required this.id,
      required this.careerId,
      required this.characterId,
      required this.recruitedMonth,
      required this.currentLevel,
      required this.vocalBonus,
      required this.danceBonus,
      required this.rapBonus,
      required this.visualBonus,
      required this.charismaBonus,
      required this.fatigue,
      required this.mood,
      required this.loyalty,
      required this.popularityBonus,
      required this.salaryBonus,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['character_id'] = Variable<int>(characterId);
    map['recruited_month'] = Variable<int>(recruitedMonth);
    map['current_level'] = Variable<int>(currentLevel);
    map['vocal_bonus'] = Variable<int>(vocalBonus);
    map['dance_bonus'] = Variable<int>(danceBonus);
    map['rap_bonus'] = Variable<int>(rapBonus);
    map['visual_bonus'] = Variable<int>(visualBonus);
    map['charisma_bonus'] = Variable<int>(charismaBonus);
    map['fatigue'] = Variable<int>(fatigue);
    map['mood'] = Variable<int>(mood);
    map['loyalty'] = Variable<int>(loyalty);
    map['popularity_bonus'] = Variable<int>(popularityBonus);
    map['salary_bonus'] = Variable<int>(salaryBonus);
    map['status'] = Variable<String>(status);
    return map;
  }

  PlayerIdolsCompanion toCompanion(bool nullToAbsent) {
    return PlayerIdolsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      characterId: Value(characterId),
      recruitedMonth: Value(recruitedMonth),
      currentLevel: Value(currentLevel),
      vocalBonus: Value(vocalBonus),
      danceBonus: Value(danceBonus),
      rapBonus: Value(rapBonus),
      visualBonus: Value(visualBonus),
      charismaBonus: Value(charismaBonus),
      fatigue: Value(fatigue),
      mood: Value(mood),
      loyalty: Value(loyalty),
      popularityBonus: Value(popularityBonus),
      salaryBonus: Value(salaryBonus),
      status: Value(status),
    );
  }

  factory PlayerIdol.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerIdol(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      characterId: serializer.fromJson<int>(json['characterId']),
      recruitedMonth: serializer.fromJson<int>(json['recruitedMonth']),
      currentLevel: serializer.fromJson<int>(json['currentLevel']),
      vocalBonus: serializer.fromJson<int>(json['vocalBonus']),
      danceBonus: serializer.fromJson<int>(json['danceBonus']),
      rapBonus: serializer.fromJson<int>(json['rapBonus']),
      visualBonus: serializer.fromJson<int>(json['visualBonus']),
      charismaBonus: serializer.fromJson<int>(json['charismaBonus']),
      fatigue: serializer.fromJson<int>(json['fatigue']),
      mood: serializer.fromJson<int>(json['mood']),
      loyalty: serializer.fromJson<int>(json['loyalty']),
      popularityBonus: serializer.fromJson<int>(json['popularityBonus']),
      salaryBonus: serializer.fromJson<int>(json['salaryBonus']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'characterId': serializer.toJson<int>(characterId),
      'recruitedMonth': serializer.toJson<int>(recruitedMonth),
      'currentLevel': serializer.toJson<int>(currentLevel),
      'vocalBonus': serializer.toJson<int>(vocalBonus),
      'danceBonus': serializer.toJson<int>(danceBonus),
      'rapBonus': serializer.toJson<int>(rapBonus),
      'visualBonus': serializer.toJson<int>(visualBonus),
      'charismaBonus': serializer.toJson<int>(charismaBonus),
      'fatigue': serializer.toJson<int>(fatigue),
      'mood': serializer.toJson<int>(mood),
      'loyalty': serializer.toJson<int>(loyalty),
      'popularityBonus': serializer.toJson<int>(popularityBonus),
      'salaryBonus': serializer.toJson<int>(salaryBonus),
      'status': serializer.toJson<String>(status),
    };
  }

  PlayerIdol copyWith(
          {int? id,
          int? careerId,
          int? characterId,
          int? recruitedMonth,
          int? currentLevel,
          int? vocalBonus,
          int? danceBonus,
          int? rapBonus,
          int? visualBonus,
          int? charismaBonus,
          int? fatigue,
          int? mood,
          int? loyalty,
          int? popularityBonus,
          int? salaryBonus,
          String? status}) =>
      PlayerIdol(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        characterId: characterId ?? this.characterId,
        recruitedMonth: recruitedMonth ?? this.recruitedMonth,
        currentLevel: currentLevel ?? this.currentLevel,
        vocalBonus: vocalBonus ?? this.vocalBonus,
        danceBonus: danceBonus ?? this.danceBonus,
        rapBonus: rapBonus ?? this.rapBonus,
        visualBonus: visualBonus ?? this.visualBonus,
        charismaBonus: charismaBonus ?? this.charismaBonus,
        fatigue: fatigue ?? this.fatigue,
        mood: mood ?? this.mood,
        loyalty: loyalty ?? this.loyalty,
        popularityBonus: popularityBonus ?? this.popularityBonus,
        salaryBonus: salaryBonus ?? this.salaryBonus,
        status: status ?? this.status,
      );
  PlayerIdol copyWithCompanion(PlayerIdolsCompanion data) {
    return PlayerIdol(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
      recruitedMonth: data.recruitedMonth.present
          ? data.recruitedMonth.value
          : this.recruitedMonth,
      currentLevel: data.currentLevel.present
          ? data.currentLevel.value
          : this.currentLevel,
      vocalBonus:
          data.vocalBonus.present ? data.vocalBonus.value : this.vocalBonus,
      danceBonus:
          data.danceBonus.present ? data.danceBonus.value : this.danceBonus,
      rapBonus: data.rapBonus.present ? data.rapBonus.value : this.rapBonus,
      visualBonus:
          data.visualBonus.present ? data.visualBonus.value : this.visualBonus,
      charismaBonus: data.charismaBonus.present
          ? data.charismaBonus.value
          : this.charismaBonus,
      fatigue: data.fatigue.present ? data.fatigue.value : this.fatigue,
      mood: data.mood.present ? data.mood.value : this.mood,
      loyalty: data.loyalty.present ? data.loyalty.value : this.loyalty,
      popularityBonus: data.popularityBonus.present
          ? data.popularityBonus.value
          : this.popularityBonus,
      salaryBonus:
          data.salaryBonus.present ? data.salaryBonus.value : this.salaryBonus,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerIdol(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('characterId: $characterId, ')
          ..write('recruitedMonth: $recruitedMonth, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('vocalBonus: $vocalBonus, ')
          ..write('danceBonus: $danceBonus, ')
          ..write('rapBonus: $rapBonus, ')
          ..write('visualBonus: $visualBonus, ')
          ..write('charismaBonus: $charismaBonus, ')
          ..write('fatigue: $fatigue, ')
          ..write('mood: $mood, ')
          ..write('loyalty: $loyalty, ')
          ..write('popularityBonus: $popularityBonus, ')
          ..write('salaryBonus: $salaryBonus, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      careerId,
      characterId,
      recruitedMonth,
      currentLevel,
      vocalBonus,
      danceBonus,
      rapBonus,
      visualBonus,
      charismaBonus,
      fatigue,
      mood,
      loyalty,
      popularityBonus,
      salaryBonus,
      status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerIdol &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.characterId == this.characterId &&
          other.recruitedMonth == this.recruitedMonth &&
          other.currentLevel == this.currentLevel &&
          other.vocalBonus == this.vocalBonus &&
          other.danceBonus == this.danceBonus &&
          other.rapBonus == this.rapBonus &&
          other.visualBonus == this.visualBonus &&
          other.charismaBonus == this.charismaBonus &&
          other.fatigue == this.fatigue &&
          other.mood == this.mood &&
          other.loyalty == this.loyalty &&
          other.popularityBonus == this.popularityBonus &&
          other.salaryBonus == this.salaryBonus &&
          other.status == this.status);
}

class PlayerIdolsCompanion extends UpdateCompanion<PlayerIdol> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> characterId;
  final Value<int> recruitedMonth;
  final Value<int> currentLevel;
  final Value<int> vocalBonus;
  final Value<int> danceBonus;
  final Value<int> rapBonus;
  final Value<int> visualBonus;
  final Value<int> charismaBonus;
  final Value<int> fatigue;
  final Value<int> mood;
  final Value<int> loyalty;
  final Value<int> popularityBonus;
  final Value<int> salaryBonus;
  final Value<String> status;
  const PlayerIdolsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.recruitedMonth = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.vocalBonus = const Value.absent(),
    this.danceBonus = const Value.absent(),
    this.rapBonus = const Value.absent(),
    this.visualBonus = const Value.absent(),
    this.charismaBonus = const Value.absent(),
    this.fatigue = const Value.absent(),
    this.mood = const Value.absent(),
    this.loyalty = const Value.absent(),
    this.popularityBonus = const Value.absent(),
    this.salaryBonus = const Value.absent(),
    this.status = const Value.absent(),
  });
  PlayerIdolsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int characterId,
    required int recruitedMonth,
    this.currentLevel = const Value.absent(),
    this.vocalBonus = const Value.absent(),
    this.danceBonus = const Value.absent(),
    this.rapBonus = const Value.absent(),
    this.visualBonus = const Value.absent(),
    this.charismaBonus = const Value.absent(),
    this.fatigue = const Value.absent(),
    this.mood = const Value.absent(),
    this.loyalty = const Value.absent(),
    this.popularityBonus = const Value.absent(),
    this.salaryBonus = const Value.absent(),
    this.status = const Value.absent(),
  })  : careerId = Value(careerId),
        characterId = Value(characterId),
        recruitedMonth = Value(recruitedMonth);
  static Insertable<PlayerIdol> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? characterId,
    Expression<int>? recruitedMonth,
    Expression<int>? currentLevel,
    Expression<int>? vocalBonus,
    Expression<int>? danceBonus,
    Expression<int>? rapBonus,
    Expression<int>? visualBonus,
    Expression<int>? charismaBonus,
    Expression<int>? fatigue,
    Expression<int>? mood,
    Expression<int>? loyalty,
    Expression<int>? popularityBonus,
    Expression<int>? salaryBonus,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (characterId != null) 'character_id': characterId,
      if (recruitedMonth != null) 'recruited_month': recruitedMonth,
      if (currentLevel != null) 'current_level': currentLevel,
      if (vocalBonus != null) 'vocal_bonus': vocalBonus,
      if (danceBonus != null) 'dance_bonus': danceBonus,
      if (rapBonus != null) 'rap_bonus': rapBonus,
      if (visualBonus != null) 'visual_bonus': visualBonus,
      if (charismaBonus != null) 'charisma_bonus': charismaBonus,
      if (fatigue != null) 'fatigue': fatigue,
      if (mood != null) 'mood': mood,
      if (loyalty != null) 'loyalty': loyalty,
      if (popularityBonus != null) 'popularity_bonus': popularityBonus,
      if (salaryBonus != null) 'salary_bonus': salaryBonus,
      if (status != null) 'status': status,
    });
  }

  PlayerIdolsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<int>? characterId,
      Value<int>? recruitedMonth,
      Value<int>? currentLevel,
      Value<int>? vocalBonus,
      Value<int>? danceBonus,
      Value<int>? rapBonus,
      Value<int>? visualBonus,
      Value<int>? charismaBonus,
      Value<int>? fatigue,
      Value<int>? mood,
      Value<int>? loyalty,
      Value<int>? popularityBonus,
      Value<int>? salaryBonus,
      Value<String>? status}) {
    return PlayerIdolsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      characterId: characterId ?? this.characterId,
      recruitedMonth: recruitedMonth ?? this.recruitedMonth,
      currentLevel: currentLevel ?? this.currentLevel,
      vocalBonus: vocalBonus ?? this.vocalBonus,
      danceBonus: danceBonus ?? this.danceBonus,
      rapBonus: rapBonus ?? this.rapBonus,
      visualBonus: visualBonus ?? this.visualBonus,
      charismaBonus: charismaBonus ?? this.charismaBonus,
      fatigue: fatigue ?? this.fatigue,
      mood: mood ?? this.mood,
      loyalty: loyalty ?? this.loyalty,
      popularityBonus: popularityBonus ?? this.popularityBonus,
      salaryBonus: salaryBonus ?? this.salaryBonus,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (recruitedMonth.present) {
      map['recruited_month'] = Variable<int>(recruitedMonth.value);
    }
    if (currentLevel.present) {
      map['current_level'] = Variable<int>(currentLevel.value);
    }
    if (vocalBonus.present) {
      map['vocal_bonus'] = Variable<int>(vocalBonus.value);
    }
    if (danceBonus.present) {
      map['dance_bonus'] = Variable<int>(danceBonus.value);
    }
    if (rapBonus.present) {
      map['rap_bonus'] = Variable<int>(rapBonus.value);
    }
    if (visualBonus.present) {
      map['visual_bonus'] = Variable<int>(visualBonus.value);
    }
    if (charismaBonus.present) {
      map['charisma_bonus'] = Variable<int>(charismaBonus.value);
    }
    if (fatigue.present) {
      map['fatigue'] = Variable<int>(fatigue.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (loyalty.present) {
      map['loyalty'] = Variable<int>(loyalty.value);
    }
    if (popularityBonus.present) {
      map['popularity_bonus'] = Variable<int>(popularityBonus.value);
    }
    if (salaryBonus.present) {
      map['salary_bonus'] = Variable<int>(salaryBonus.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerIdolsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('characterId: $characterId, ')
          ..write('recruitedMonth: $recruitedMonth, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('vocalBonus: $vocalBonus, ')
          ..write('danceBonus: $danceBonus, ')
          ..write('rapBonus: $rapBonus, ')
          ..write('visualBonus: $visualBonus, ')
          ..write('charismaBonus: $charismaBonus, ')
          ..write('fatigue: $fatigue, ')
          ..write('mood: $mood, ')
          ..write('loyalty: $loyalty, ')
          ..write('popularityBonus: $popularityBonus, ')
          ..write('salaryBonus: $salaryBonus, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $ChemistryRelationsTable extends ChemistryRelations
    with TableInfo<$ChemistryRelationsTable, ChemistryRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChemistryRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idolAIdMeta =
      const VerificationMeta('idolAId');
  @override
  late final GeneratedColumn<int> idolAId = GeneratedColumn<int>(
      'idol_a_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_idols (id)'));
  static const VerificationMeta _idolBIdMeta =
      const VerificationMeta('idolBId');
  @override
  late final GeneratedColumn<int> idolBId = GeneratedColumn<int>(
      'idol_b_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_idols (id)'));
  static const VerificationMeta _chemistryScoreMeta =
      const VerificationMeta('chemistryScore');
  @override
  late final GeneratedColumn<int> chemistryScore = GeneratedColumn<int>(
      'chemistry_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _relationshipTypeMeta =
      const VerificationMeta('relationshipType');
  @override
  late final GeneratedColumn<String> relationshipType = GeneratedColumn<String>(
      'relationship_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('neutral'));
  static const VerificationMeta _lastUpdatedMonthMeta =
      const VerificationMeta('lastUpdatedMonth');
  @override
  late final GeneratedColumn<int> lastUpdatedMonth = GeneratedColumn<int>(
      'last_updated_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        idolAId,
        idolBId,
        chemistryScore,
        relationshipType,
        lastUpdatedMonth
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chemistry_relations';
  @override
  VerificationContext validateIntegrity(Insertable<ChemistryRelation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idol_a_id')) {
      context.handle(_idolAIdMeta,
          idolAId.isAcceptableOrUnknown(data['idol_a_id']!, _idolAIdMeta));
    } else if (isInserting) {
      context.missing(_idolAIdMeta);
    }
    if (data.containsKey('idol_b_id')) {
      context.handle(_idolBIdMeta,
          idolBId.isAcceptableOrUnknown(data['idol_b_id']!, _idolBIdMeta));
    } else if (isInserting) {
      context.missing(_idolBIdMeta);
    }
    if (data.containsKey('chemistry_score')) {
      context.handle(
          _chemistryScoreMeta,
          chemistryScore.isAcceptableOrUnknown(
              data['chemistry_score']!, _chemistryScoreMeta));
    }
    if (data.containsKey('relationship_type')) {
      context.handle(
          _relationshipTypeMeta,
          relationshipType.isAcceptableOrUnknown(
              data['relationship_type']!, _relationshipTypeMeta));
    }
    if (data.containsKey('last_updated_month')) {
      context.handle(
          _lastUpdatedMonthMeta,
          lastUpdatedMonth.isAcceptableOrUnknown(
              data['last_updated_month']!, _lastUpdatedMonthMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMonthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {idolAId, idolBId},
      ];
  @override
  ChemistryRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChemistryRelation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idolAId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idol_a_id'])!,
      idolBId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idol_b_id'])!,
      chemistryScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chemistry_score'])!,
      relationshipType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}relationship_type'])!,
      lastUpdatedMonth: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_month'])!,
    );
  }

  @override
  $ChemistryRelationsTable createAlias(String alias) {
    return $ChemistryRelationsTable(attachedDatabase, alias);
  }
}

class ChemistryRelation extends DataClass
    implements Insertable<ChemistryRelation> {
  final int id;
  final int idolAId;
  final int idolBId;
  final int chemistryScore;
  final String relationshipType;
  final int lastUpdatedMonth;
  const ChemistryRelation(
      {required this.id,
      required this.idolAId,
      required this.idolBId,
      required this.chemistryScore,
      required this.relationshipType,
      required this.lastUpdatedMonth});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idol_a_id'] = Variable<int>(idolAId);
    map['idol_b_id'] = Variable<int>(idolBId);
    map['chemistry_score'] = Variable<int>(chemistryScore);
    map['relationship_type'] = Variable<String>(relationshipType);
    map['last_updated_month'] = Variable<int>(lastUpdatedMonth);
    return map;
  }

  ChemistryRelationsCompanion toCompanion(bool nullToAbsent) {
    return ChemistryRelationsCompanion(
      id: Value(id),
      idolAId: Value(idolAId),
      idolBId: Value(idolBId),
      chemistryScore: Value(chemistryScore),
      relationshipType: Value(relationshipType),
      lastUpdatedMonth: Value(lastUpdatedMonth),
    );
  }

  factory ChemistryRelation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChemistryRelation(
      id: serializer.fromJson<int>(json['id']),
      idolAId: serializer.fromJson<int>(json['idolAId']),
      idolBId: serializer.fromJson<int>(json['idolBId']),
      chemistryScore: serializer.fromJson<int>(json['chemistryScore']),
      relationshipType: serializer.fromJson<String>(json['relationshipType']),
      lastUpdatedMonth: serializer.fromJson<int>(json['lastUpdatedMonth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idolAId': serializer.toJson<int>(idolAId),
      'idolBId': serializer.toJson<int>(idolBId),
      'chemistryScore': serializer.toJson<int>(chemistryScore),
      'relationshipType': serializer.toJson<String>(relationshipType),
      'lastUpdatedMonth': serializer.toJson<int>(lastUpdatedMonth),
    };
  }

  ChemistryRelation copyWith(
          {int? id,
          int? idolAId,
          int? idolBId,
          int? chemistryScore,
          String? relationshipType,
          int? lastUpdatedMonth}) =>
      ChemistryRelation(
        id: id ?? this.id,
        idolAId: idolAId ?? this.idolAId,
        idolBId: idolBId ?? this.idolBId,
        chemistryScore: chemistryScore ?? this.chemistryScore,
        relationshipType: relationshipType ?? this.relationshipType,
        lastUpdatedMonth: lastUpdatedMonth ?? this.lastUpdatedMonth,
      );
  ChemistryRelation copyWithCompanion(ChemistryRelationsCompanion data) {
    return ChemistryRelation(
      id: data.id.present ? data.id.value : this.id,
      idolAId: data.idolAId.present ? data.idolAId.value : this.idolAId,
      idolBId: data.idolBId.present ? data.idolBId.value : this.idolBId,
      chemistryScore: data.chemistryScore.present
          ? data.chemistryScore.value
          : this.chemistryScore,
      relationshipType: data.relationshipType.present
          ? data.relationshipType.value
          : this.relationshipType,
      lastUpdatedMonth: data.lastUpdatedMonth.present
          ? data.lastUpdatedMonth.value
          : this.lastUpdatedMonth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChemistryRelation(')
          ..write('id: $id, ')
          ..write('idolAId: $idolAId, ')
          ..write('idolBId: $idolBId, ')
          ..write('chemistryScore: $chemistryScore, ')
          ..write('relationshipType: $relationshipType, ')
          ..write('lastUpdatedMonth: $lastUpdatedMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, idolAId, idolBId, chemistryScore, relationshipType, lastUpdatedMonth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChemistryRelation &&
          other.id == this.id &&
          other.idolAId == this.idolAId &&
          other.idolBId == this.idolBId &&
          other.chemistryScore == this.chemistryScore &&
          other.relationshipType == this.relationshipType &&
          other.lastUpdatedMonth == this.lastUpdatedMonth);
}

class ChemistryRelationsCompanion extends UpdateCompanion<ChemistryRelation> {
  final Value<int> id;
  final Value<int> idolAId;
  final Value<int> idolBId;
  final Value<int> chemistryScore;
  final Value<String> relationshipType;
  final Value<int> lastUpdatedMonth;
  const ChemistryRelationsCompanion({
    this.id = const Value.absent(),
    this.idolAId = const Value.absent(),
    this.idolBId = const Value.absent(),
    this.chemistryScore = const Value.absent(),
    this.relationshipType = const Value.absent(),
    this.lastUpdatedMonth = const Value.absent(),
  });
  ChemistryRelationsCompanion.insert({
    this.id = const Value.absent(),
    required int idolAId,
    required int idolBId,
    this.chemistryScore = const Value.absent(),
    this.relationshipType = const Value.absent(),
    required int lastUpdatedMonth,
  })  : idolAId = Value(idolAId),
        idolBId = Value(idolBId),
        lastUpdatedMonth = Value(lastUpdatedMonth);
  static Insertable<ChemistryRelation> custom({
    Expression<int>? id,
    Expression<int>? idolAId,
    Expression<int>? idolBId,
    Expression<int>? chemistryScore,
    Expression<String>? relationshipType,
    Expression<int>? lastUpdatedMonth,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idolAId != null) 'idol_a_id': idolAId,
      if (idolBId != null) 'idol_b_id': idolBId,
      if (chemistryScore != null) 'chemistry_score': chemistryScore,
      if (relationshipType != null) 'relationship_type': relationshipType,
      if (lastUpdatedMonth != null) 'last_updated_month': lastUpdatedMonth,
    });
  }

  ChemistryRelationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? idolAId,
      Value<int>? idolBId,
      Value<int>? chemistryScore,
      Value<String>? relationshipType,
      Value<int>? lastUpdatedMonth}) {
    return ChemistryRelationsCompanion(
      id: id ?? this.id,
      idolAId: idolAId ?? this.idolAId,
      idolBId: idolBId ?? this.idolBId,
      chemistryScore: chemistryScore ?? this.chemistryScore,
      relationshipType: relationshipType ?? this.relationshipType,
      lastUpdatedMonth: lastUpdatedMonth ?? this.lastUpdatedMonth,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idolAId.present) {
      map['idol_a_id'] = Variable<int>(idolAId.value);
    }
    if (idolBId.present) {
      map['idol_b_id'] = Variable<int>(idolBId.value);
    }
    if (chemistryScore.present) {
      map['chemistry_score'] = Variable<int>(chemistryScore.value);
    }
    if (relationshipType.present) {
      map['relationship_type'] = Variable<String>(relationshipType.value);
    }
    if (lastUpdatedMonth.present) {
      map['last_updated_month'] = Variable<int>(lastUpdatedMonth.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChemistryRelationsCompanion(')
          ..write('id: $id, ')
          ..write('idolAId: $idolAId, ')
          ..write('idolBId: $idolBId, ')
          ..write('chemistryScore: $chemistryScore, ')
          ..write('relationshipType: $relationshipType, ')
          ..write('lastUpdatedMonth: $lastUpdatedMonth')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _groupNameMeta =
      const VerificationMeta('groupName');
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
      'group_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formationMonthMeta =
      const VerificationMeta('formationMonth');
  @override
  late final GeneratedColumn<int> formationMonth = GeneratedColumn<int>(
      'formation_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalPopularityMeta =
      const VerificationMeta('totalPopularity');
  @override
  late final GeneratedColumn<int> totalPopularity = GeneratedColumn<int>(
      'total_popularity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _fanbaseSizeMeta =
      const VerificationMeta('fanbaseSize');
  @override
  late final GeneratedColumn<int> fanbaseSize = GeneratedColumn<int>(
      'fanbase_size', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _reputationMeta =
      const VerificationMeta('reputation');
  @override
  late final GeneratedColumn<int> reputation = GeneratedColumn<int>(
      'reputation', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _socialFollowersMeta =
      const VerificationMeta('socialFollowers');
  @override
  late final GeneratedColumn<int> socialFollowers = GeneratedColumn<int>(
      'social_followers', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5000));
  static const VerificationMeta _scandalHeatMeta =
      const VerificationMeta('scandalHeat');
  @override
  late final GeneratedColumn<int> scandalHeat = GeneratedColumn<int>(
      'scandal_heat', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastConcertMonthMeta =
      const VerificationMeta('lastConcertMonth');
  @override
  late final GeneratedColumn<int> lastConcertMonth = GeneratedColumn<int>(
      'last_concert_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastTourMonthMeta =
      const VerificationMeta('lastTourMonth');
  @override
  late final GeneratedColumn<int> lastTourMonth = GeneratedColumn<int>(
      'last_tour_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastReleaseMonthMeta =
      const VerificationMeta('lastReleaseMonth');
  @override
  late final GeneratedColumn<int> lastReleaseMonth = GeneratedColumn<int>(
      'last_release_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sponsorNameMeta =
      const VerificationMeta('sponsorName');
  @override
  late final GeneratedColumn<String> sponsorName = GeneratedColumn<String>(
      'sponsor_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sponsorIncomeMeta =
      const VerificationMeta('sponsorIncome');
  @override
  late final GeneratedColumn<int> sponsorIncome = GeneratedColumn<int>(
      'sponsor_income', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sponsorMonthsLeftMeta =
      const VerificationMeta('sponsorMonthsLeft');
  @override
  late final GeneratedColumn<int> sponsorMonthsLeft = GeneratedColumn<int>(
      'sponsor_months_left', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _fandomNameMeta =
      const VerificationMeta('fandomName');
  @override
  late final GeneratedColumn<String> fandomName = GeneratedColumn<String>(
      'fandom_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fandomLoyaltyMeta =
      const VerificationMeta('fandomLoyalty');
  @override
  late final GeneratedColumn<int> fandomLoyalty = GeneratedColumn<int>(
      'fandom_loyalty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _lastFollowerDeltaMeta =
      const VerificationMeta('lastFollowerDelta');
  @override
  late final GeneratedColumn<int> lastFollowerDelta = GeneratedColumn<int>(
      'last_follower_delta', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _rodezFeudMeta =
      const VerificationMeta('rodezFeud');
  @override
  late final GeneratedColumn<int> rodezFeud = GeneratedColumn<int>(
      'rodez_feud', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastRodezMonthMeta =
      const VerificationMeta('lastRodezMonth');
  @override
  late final GeneratedColumn<int> lastRodezMonth = GeneratedColumn<int>(
      'last_rodez_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerId,
        groupName,
        formationMonth,
        totalPopularity,
        fanbaseSize,
        logoPath,
        status,
        reputation,
        socialFollowers,
        scandalHeat,
        lastConcertMonth,
        lastTourMonth,
        lastReleaseMonth,
        sponsorName,
        sponsorIncome,
        sponsorMonthsLeft,
        fandomName,
        fandomLoyalty,
        lastFollowerDelta,
        rodezFeud,
        lastRodezMonth
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(_groupNameMeta,
          groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta));
    } else if (isInserting) {
      context.missing(_groupNameMeta);
    }
    if (data.containsKey('formation_month')) {
      context.handle(
          _formationMonthMeta,
          formationMonth.isAcceptableOrUnknown(
              data['formation_month']!, _formationMonthMeta));
    } else if (isInserting) {
      context.missing(_formationMonthMeta);
    }
    if (data.containsKey('total_popularity')) {
      context.handle(
          _totalPopularityMeta,
          totalPopularity.isAcceptableOrUnknown(
              data['total_popularity']!, _totalPopularityMeta));
    }
    if (data.containsKey('fanbase_size')) {
      context.handle(
          _fanbaseSizeMeta,
          fanbaseSize.isAcceptableOrUnknown(
              data['fanbase_size']!, _fanbaseSizeMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('reputation')) {
      context.handle(
          _reputationMeta,
          reputation.isAcceptableOrUnknown(
              data['reputation']!, _reputationMeta));
    }
    if (data.containsKey('social_followers')) {
      context.handle(
          _socialFollowersMeta,
          socialFollowers.isAcceptableOrUnknown(
              data['social_followers']!, _socialFollowersMeta));
    }
    if (data.containsKey('scandal_heat')) {
      context.handle(
          _scandalHeatMeta,
          scandalHeat.isAcceptableOrUnknown(
              data['scandal_heat']!, _scandalHeatMeta));
    }
    if (data.containsKey('last_concert_month')) {
      context.handle(
          _lastConcertMonthMeta,
          lastConcertMonth.isAcceptableOrUnknown(
              data['last_concert_month']!, _lastConcertMonthMeta));
    }
    if (data.containsKey('last_tour_month')) {
      context.handle(
          _lastTourMonthMeta,
          lastTourMonth.isAcceptableOrUnknown(
              data['last_tour_month']!, _lastTourMonthMeta));
    }
    if (data.containsKey('last_release_month')) {
      context.handle(
          _lastReleaseMonthMeta,
          lastReleaseMonth.isAcceptableOrUnknown(
              data['last_release_month']!, _lastReleaseMonthMeta));
    }
    if (data.containsKey('sponsor_name')) {
      context.handle(
          _sponsorNameMeta,
          sponsorName.isAcceptableOrUnknown(
              data['sponsor_name']!, _sponsorNameMeta));
    }
    if (data.containsKey('sponsor_income')) {
      context.handle(
          _sponsorIncomeMeta,
          sponsorIncome.isAcceptableOrUnknown(
              data['sponsor_income']!, _sponsorIncomeMeta));
    }
    if (data.containsKey('sponsor_months_left')) {
      context.handle(
          _sponsorMonthsLeftMeta,
          sponsorMonthsLeft.isAcceptableOrUnknown(
              data['sponsor_months_left']!, _sponsorMonthsLeftMeta));
    }
    if (data.containsKey('fandom_name')) {
      context.handle(
          _fandomNameMeta,
          fandomName.isAcceptableOrUnknown(
              data['fandom_name']!, _fandomNameMeta));
    }
    if (data.containsKey('fandom_loyalty')) {
      context.handle(
          _fandomLoyaltyMeta,
          fandomLoyalty.isAcceptableOrUnknown(
              data['fandom_loyalty']!, _fandomLoyaltyMeta));
    }
    if (data.containsKey('last_follower_delta')) {
      context.handle(
          _lastFollowerDeltaMeta,
          lastFollowerDelta.isAcceptableOrUnknown(
              data['last_follower_delta']!, _lastFollowerDeltaMeta));
    }
    if (data.containsKey('rodez_feud')) {
      context.handle(_rodezFeudMeta,
          rodezFeud.isAcceptableOrUnknown(data['rodez_feud']!, _rodezFeudMeta));
    }
    if (data.containsKey('last_rodez_month')) {
      context.handle(
          _lastRodezMonthMeta,
          lastRodezMonth.isAcceptableOrUnknown(
              data['last_rodez_month']!, _lastRodezMonthMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      groupName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_name'])!,
      formationMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}formation_month'])!,
      totalPopularity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_popularity'])!,
      fanbaseSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fanbase_size'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      reputation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reputation'])!,
      socialFollowers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}social_followers'])!,
      scandalHeat: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scandal_heat'])!,
      lastConcertMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_concert_month']),
      lastTourMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_tour_month']),
      lastReleaseMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_release_month']),
      sponsorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sponsor_name']),
      sponsorIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sponsor_income'])!,
      sponsorMonthsLeft: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}sponsor_months_left'])!,
      fandomName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fandom_name']),
      fandomLoyalty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fandom_loyalty'])!,
      lastFollowerDelta: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_follower_delta'])!,
      rodezFeud: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rodez_feud'])!,
      lastRodezMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_rodez_month']),
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final int careerId;
  final String groupName;
  final int formationMonth;
  final int totalPopularity;
  final int fanbaseSize;
  final String? logoPath;
  final String status;
  final int reputation;
  final int socialFollowers;
  final int scandalHeat;
  final int? lastConcertMonth;
  final int? lastTourMonth;
  final int? lastReleaseMonth;
  final String? sponsorName;
  final int sponsorIncome;
  final int sponsorMonthsLeft;
  final String? fandomName;
  final int fandomLoyalty;
  final int lastFollowerDelta;
  final int rodezFeud;
  final int? lastRodezMonth;
  const Group(
      {required this.id,
      required this.careerId,
      required this.groupName,
      required this.formationMonth,
      required this.totalPopularity,
      required this.fanbaseSize,
      this.logoPath,
      required this.status,
      required this.reputation,
      required this.socialFollowers,
      required this.scandalHeat,
      this.lastConcertMonth,
      this.lastTourMonth,
      this.lastReleaseMonth,
      this.sponsorName,
      required this.sponsorIncome,
      required this.sponsorMonthsLeft,
      this.fandomName,
      required this.fandomLoyalty,
      required this.lastFollowerDelta,
      required this.rodezFeud,
      this.lastRodezMonth});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['group_name'] = Variable<String>(groupName);
    map['formation_month'] = Variable<int>(formationMonth);
    map['total_popularity'] = Variable<int>(totalPopularity);
    map['fanbase_size'] = Variable<int>(fanbaseSize);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['status'] = Variable<String>(status);
    map['reputation'] = Variable<int>(reputation);
    map['social_followers'] = Variable<int>(socialFollowers);
    map['scandal_heat'] = Variable<int>(scandalHeat);
    if (!nullToAbsent || lastConcertMonth != null) {
      map['last_concert_month'] = Variable<int>(lastConcertMonth);
    }
    if (!nullToAbsent || lastTourMonth != null) {
      map['last_tour_month'] = Variable<int>(lastTourMonth);
    }
    if (!nullToAbsent || lastReleaseMonth != null) {
      map['last_release_month'] = Variable<int>(lastReleaseMonth);
    }
    if (!nullToAbsent || sponsorName != null) {
      map['sponsor_name'] = Variable<String>(sponsorName);
    }
    map['sponsor_income'] = Variable<int>(sponsorIncome);
    map['sponsor_months_left'] = Variable<int>(sponsorMonthsLeft);
    if (!nullToAbsent || fandomName != null) {
      map['fandom_name'] = Variable<String>(fandomName);
    }
    map['fandom_loyalty'] = Variable<int>(fandomLoyalty);
    map['last_follower_delta'] = Variable<int>(lastFollowerDelta);
    map['rodez_feud'] = Variable<int>(rodezFeud);
    if (!nullToAbsent || lastRodezMonth != null) {
      map['last_rodez_month'] = Variable<int>(lastRodezMonth);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      groupName: Value(groupName),
      formationMonth: Value(formationMonth),
      totalPopularity: Value(totalPopularity),
      fanbaseSize: Value(fanbaseSize),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      status: Value(status),
      reputation: Value(reputation),
      socialFollowers: Value(socialFollowers),
      scandalHeat: Value(scandalHeat),
      lastConcertMonth: lastConcertMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConcertMonth),
      lastTourMonth: lastTourMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTourMonth),
      lastReleaseMonth: lastReleaseMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReleaseMonth),
      sponsorName: sponsorName == null && nullToAbsent
          ? const Value.absent()
          : Value(sponsorName),
      sponsorIncome: Value(sponsorIncome),
      sponsorMonthsLeft: Value(sponsorMonthsLeft),
      fandomName: fandomName == null && nullToAbsent
          ? const Value.absent()
          : Value(fandomName),
      fandomLoyalty: Value(fandomLoyalty),
      lastFollowerDelta: Value(lastFollowerDelta),
      rodezFeud: Value(rodezFeud),
      lastRodezMonth: lastRodezMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRodezMonth),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      groupName: serializer.fromJson<String>(json['groupName']),
      formationMonth: serializer.fromJson<int>(json['formationMonth']),
      totalPopularity: serializer.fromJson<int>(json['totalPopularity']),
      fanbaseSize: serializer.fromJson<int>(json['fanbaseSize']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      status: serializer.fromJson<String>(json['status']),
      reputation: serializer.fromJson<int>(json['reputation']),
      socialFollowers: serializer.fromJson<int>(json['socialFollowers']),
      scandalHeat: serializer.fromJson<int>(json['scandalHeat']),
      lastConcertMonth: serializer.fromJson<int?>(json['lastConcertMonth']),
      lastTourMonth: serializer.fromJson<int?>(json['lastTourMonth']),
      lastReleaseMonth: serializer.fromJson<int?>(json['lastReleaseMonth']),
      sponsorName: serializer.fromJson<String?>(json['sponsorName']),
      sponsorIncome: serializer.fromJson<int>(json['sponsorIncome']),
      sponsorMonthsLeft: serializer.fromJson<int>(json['sponsorMonthsLeft']),
      fandomName: serializer.fromJson<String?>(json['fandomName']),
      fandomLoyalty: serializer.fromJson<int>(json['fandomLoyalty']),
      lastFollowerDelta: serializer.fromJson<int>(json['lastFollowerDelta']),
      rodezFeud: serializer.fromJson<int>(json['rodezFeud']),
      lastRodezMonth: serializer.fromJson<int?>(json['lastRodezMonth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'groupName': serializer.toJson<String>(groupName),
      'formationMonth': serializer.toJson<int>(formationMonth),
      'totalPopularity': serializer.toJson<int>(totalPopularity),
      'fanbaseSize': serializer.toJson<int>(fanbaseSize),
      'logoPath': serializer.toJson<String?>(logoPath),
      'status': serializer.toJson<String>(status),
      'reputation': serializer.toJson<int>(reputation),
      'socialFollowers': serializer.toJson<int>(socialFollowers),
      'scandalHeat': serializer.toJson<int>(scandalHeat),
      'lastConcertMonth': serializer.toJson<int?>(lastConcertMonth),
      'lastTourMonth': serializer.toJson<int?>(lastTourMonth),
      'lastReleaseMonth': serializer.toJson<int?>(lastReleaseMonth),
      'sponsorName': serializer.toJson<String?>(sponsorName),
      'sponsorIncome': serializer.toJson<int>(sponsorIncome),
      'sponsorMonthsLeft': serializer.toJson<int>(sponsorMonthsLeft),
      'fandomName': serializer.toJson<String?>(fandomName),
      'fandomLoyalty': serializer.toJson<int>(fandomLoyalty),
      'lastFollowerDelta': serializer.toJson<int>(lastFollowerDelta),
      'rodezFeud': serializer.toJson<int>(rodezFeud),
      'lastRodezMonth': serializer.toJson<int?>(lastRodezMonth),
    };
  }

  Group copyWith(
          {int? id,
          int? careerId,
          String? groupName,
          int? formationMonth,
          int? totalPopularity,
          int? fanbaseSize,
          Value<String?> logoPath = const Value.absent(),
          String? status,
          int? reputation,
          int? socialFollowers,
          int? scandalHeat,
          Value<int?> lastConcertMonth = const Value.absent(),
          Value<int?> lastTourMonth = const Value.absent(),
          Value<int?> lastReleaseMonth = const Value.absent(),
          Value<String?> sponsorName = const Value.absent(),
          int? sponsorIncome,
          int? sponsorMonthsLeft,
          Value<String?> fandomName = const Value.absent(),
          int? fandomLoyalty,
          int? lastFollowerDelta,
          int? rodezFeud,
          Value<int?> lastRodezMonth = const Value.absent()}) =>
      Group(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        groupName: groupName ?? this.groupName,
        formationMonth: formationMonth ?? this.formationMonth,
        totalPopularity: totalPopularity ?? this.totalPopularity,
        fanbaseSize: fanbaseSize ?? this.fanbaseSize,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        status: status ?? this.status,
        reputation: reputation ?? this.reputation,
        socialFollowers: socialFollowers ?? this.socialFollowers,
        scandalHeat: scandalHeat ?? this.scandalHeat,
        lastConcertMonth: lastConcertMonth.present
            ? lastConcertMonth.value
            : this.lastConcertMonth,
        lastTourMonth:
            lastTourMonth.present ? lastTourMonth.value : this.lastTourMonth,
        lastReleaseMonth: lastReleaseMonth.present
            ? lastReleaseMonth.value
            : this.lastReleaseMonth,
        sponsorName: sponsorName.present ? sponsorName.value : this.sponsorName,
        sponsorIncome: sponsorIncome ?? this.sponsorIncome,
        sponsorMonthsLeft: sponsorMonthsLeft ?? this.sponsorMonthsLeft,
        fandomName: fandomName.present ? fandomName.value : this.fandomName,
        fandomLoyalty: fandomLoyalty ?? this.fandomLoyalty,
        lastFollowerDelta: lastFollowerDelta ?? this.lastFollowerDelta,
        rodezFeud: rodezFeud ?? this.rodezFeud,
        lastRodezMonth:
            lastRodezMonth.present ? lastRodezMonth.value : this.lastRodezMonth,
      );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      formationMonth: data.formationMonth.present
          ? data.formationMonth.value
          : this.formationMonth,
      totalPopularity: data.totalPopularity.present
          ? data.totalPopularity.value
          : this.totalPopularity,
      fanbaseSize:
          data.fanbaseSize.present ? data.fanbaseSize.value : this.fanbaseSize,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      status: data.status.present ? data.status.value : this.status,
      reputation:
          data.reputation.present ? data.reputation.value : this.reputation,
      socialFollowers: data.socialFollowers.present
          ? data.socialFollowers.value
          : this.socialFollowers,
      scandalHeat:
          data.scandalHeat.present ? data.scandalHeat.value : this.scandalHeat,
      lastConcertMonth: data.lastConcertMonth.present
          ? data.lastConcertMonth.value
          : this.lastConcertMonth,
      lastTourMonth: data.lastTourMonth.present
          ? data.lastTourMonth.value
          : this.lastTourMonth,
      lastReleaseMonth: data.lastReleaseMonth.present
          ? data.lastReleaseMonth.value
          : this.lastReleaseMonth,
      sponsorName:
          data.sponsorName.present ? data.sponsorName.value : this.sponsorName,
      sponsorIncome: data.sponsorIncome.present
          ? data.sponsorIncome.value
          : this.sponsorIncome,
      sponsorMonthsLeft: data.sponsorMonthsLeft.present
          ? data.sponsorMonthsLeft.value
          : this.sponsorMonthsLeft,
      fandomName:
          data.fandomName.present ? data.fandomName.value : this.fandomName,
      fandomLoyalty: data.fandomLoyalty.present
          ? data.fandomLoyalty.value
          : this.fandomLoyalty,
      lastFollowerDelta: data.lastFollowerDelta.present
          ? data.lastFollowerDelta.value
          : this.lastFollowerDelta,
      rodezFeud: data.rodezFeud.present ? data.rodezFeud.value : this.rodezFeud,
      lastRodezMonth: data.lastRodezMonth.present
          ? data.lastRodezMonth.value
          : this.lastRodezMonth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('groupName: $groupName, ')
          ..write('formationMonth: $formationMonth, ')
          ..write('totalPopularity: $totalPopularity, ')
          ..write('fanbaseSize: $fanbaseSize, ')
          ..write('logoPath: $logoPath, ')
          ..write('status: $status, ')
          ..write('reputation: $reputation, ')
          ..write('socialFollowers: $socialFollowers, ')
          ..write('scandalHeat: $scandalHeat, ')
          ..write('lastConcertMonth: $lastConcertMonth, ')
          ..write('lastTourMonth: $lastTourMonth, ')
          ..write('lastReleaseMonth: $lastReleaseMonth, ')
          ..write('sponsorName: $sponsorName, ')
          ..write('sponsorIncome: $sponsorIncome, ')
          ..write('sponsorMonthsLeft: $sponsorMonthsLeft, ')
          ..write('fandomName: $fandomName, ')
          ..write('fandomLoyalty: $fandomLoyalty, ')
          ..write('lastFollowerDelta: $lastFollowerDelta, ')
          ..write('rodezFeud: $rodezFeud, ')
          ..write('lastRodezMonth: $lastRodezMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        careerId,
        groupName,
        formationMonth,
        totalPopularity,
        fanbaseSize,
        logoPath,
        status,
        reputation,
        socialFollowers,
        scandalHeat,
        lastConcertMonth,
        lastTourMonth,
        lastReleaseMonth,
        sponsorName,
        sponsorIncome,
        sponsorMonthsLeft,
        fandomName,
        fandomLoyalty,
        lastFollowerDelta,
        rodezFeud,
        lastRodezMonth
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.groupName == this.groupName &&
          other.formationMonth == this.formationMonth &&
          other.totalPopularity == this.totalPopularity &&
          other.fanbaseSize == this.fanbaseSize &&
          other.logoPath == this.logoPath &&
          other.status == this.status &&
          other.reputation == this.reputation &&
          other.socialFollowers == this.socialFollowers &&
          other.scandalHeat == this.scandalHeat &&
          other.lastConcertMonth == this.lastConcertMonth &&
          other.lastTourMonth == this.lastTourMonth &&
          other.lastReleaseMonth == this.lastReleaseMonth &&
          other.sponsorName == this.sponsorName &&
          other.sponsorIncome == this.sponsorIncome &&
          other.sponsorMonthsLeft == this.sponsorMonthsLeft &&
          other.fandomName == this.fandomName &&
          other.fandomLoyalty == this.fandomLoyalty &&
          other.lastFollowerDelta == this.lastFollowerDelta &&
          other.rodezFeud == this.rodezFeud &&
          other.lastRodezMonth == this.lastRodezMonth);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<String> groupName;
  final Value<int> formationMonth;
  final Value<int> totalPopularity;
  final Value<int> fanbaseSize;
  final Value<String?> logoPath;
  final Value<String> status;
  final Value<int> reputation;
  final Value<int> socialFollowers;
  final Value<int> scandalHeat;
  final Value<int?> lastConcertMonth;
  final Value<int?> lastTourMonth;
  final Value<int?> lastReleaseMonth;
  final Value<String?> sponsorName;
  final Value<int> sponsorIncome;
  final Value<int> sponsorMonthsLeft;
  final Value<String?> fandomName;
  final Value<int> fandomLoyalty;
  final Value<int> lastFollowerDelta;
  final Value<int> rodezFeud;
  final Value<int?> lastRodezMonth;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.groupName = const Value.absent(),
    this.formationMonth = const Value.absent(),
    this.totalPopularity = const Value.absent(),
    this.fanbaseSize = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.status = const Value.absent(),
    this.reputation = const Value.absent(),
    this.socialFollowers = const Value.absent(),
    this.scandalHeat = const Value.absent(),
    this.lastConcertMonth = const Value.absent(),
    this.lastTourMonth = const Value.absent(),
    this.lastReleaseMonth = const Value.absent(),
    this.sponsorName = const Value.absent(),
    this.sponsorIncome = const Value.absent(),
    this.sponsorMonthsLeft = const Value.absent(),
    this.fandomName = const Value.absent(),
    this.fandomLoyalty = const Value.absent(),
    this.lastFollowerDelta = const Value.absent(),
    this.rodezFeud = const Value.absent(),
    this.lastRodezMonth = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required String groupName,
    required int formationMonth,
    this.totalPopularity = const Value.absent(),
    this.fanbaseSize = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.status = const Value.absent(),
    this.reputation = const Value.absent(),
    this.socialFollowers = const Value.absent(),
    this.scandalHeat = const Value.absent(),
    this.lastConcertMonth = const Value.absent(),
    this.lastTourMonth = const Value.absent(),
    this.lastReleaseMonth = const Value.absent(),
    this.sponsorName = const Value.absent(),
    this.sponsorIncome = const Value.absent(),
    this.sponsorMonthsLeft = const Value.absent(),
    this.fandomName = const Value.absent(),
    this.fandomLoyalty = const Value.absent(),
    this.lastFollowerDelta = const Value.absent(),
    this.rodezFeud = const Value.absent(),
    this.lastRodezMonth = const Value.absent(),
  })  : careerId = Value(careerId),
        groupName = Value(groupName),
        formationMonth = Value(formationMonth);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<String>? groupName,
    Expression<int>? formationMonth,
    Expression<int>? totalPopularity,
    Expression<int>? fanbaseSize,
    Expression<String>? logoPath,
    Expression<String>? status,
    Expression<int>? reputation,
    Expression<int>? socialFollowers,
    Expression<int>? scandalHeat,
    Expression<int>? lastConcertMonth,
    Expression<int>? lastTourMonth,
    Expression<int>? lastReleaseMonth,
    Expression<String>? sponsorName,
    Expression<int>? sponsorIncome,
    Expression<int>? sponsorMonthsLeft,
    Expression<String>? fandomName,
    Expression<int>? fandomLoyalty,
    Expression<int>? lastFollowerDelta,
    Expression<int>? rodezFeud,
    Expression<int>? lastRodezMonth,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (groupName != null) 'group_name': groupName,
      if (formationMonth != null) 'formation_month': formationMonth,
      if (totalPopularity != null) 'total_popularity': totalPopularity,
      if (fanbaseSize != null) 'fanbase_size': fanbaseSize,
      if (logoPath != null) 'logo_path': logoPath,
      if (status != null) 'status': status,
      if (reputation != null) 'reputation': reputation,
      if (socialFollowers != null) 'social_followers': socialFollowers,
      if (scandalHeat != null) 'scandal_heat': scandalHeat,
      if (lastConcertMonth != null) 'last_concert_month': lastConcertMonth,
      if (lastTourMonth != null) 'last_tour_month': lastTourMonth,
      if (lastReleaseMonth != null) 'last_release_month': lastReleaseMonth,
      if (sponsorName != null) 'sponsor_name': sponsorName,
      if (sponsorIncome != null) 'sponsor_income': sponsorIncome,
      if (sponsorMonthsLeft != null) 'sponsor_months_left': sponsorMonthsLeft,
      if (fandomName != null) 'fandom_name': fandomName,
      if (fandomLoyalty != null) 'fandom_loyalty': fandomLoyalty,
      if (lastFollowerDelta != null) 'last_follower_delta': lastFollowerDelta,
      if (rodezFeud != null) 'rodez_feud': rodezFeud,
      if (lastRodezMonth != null) 'last_rodez_month': lastRodezMonth,
    });
  }

  GroupsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<String>? groupName,
      Value<int>? formationMonth,
      Value<int>? totalPopularity,
      Value<int>? fanbaseSize,
      Value<String?>? logoPath,
      Value<String>? status,
      Value<int>? reputation,
      Value<int>? socialFollowers,
      Value<int>? scandalHeat,
      Value<int?>? lastConcertMonth,
      Value<int?>? lastTourMonth,
      Value<int?>? lastReleaseMonth,
      Value<String?>? sponsorName,
      Value<int>? sponsorIncome,
      Value<int>? sponsorMonthsLeft,
      Value<String?>? fandomName,
      Value<int>? fandomLoyalty,
      Value<int>? lastFollowerDelta,
      Value<int>? rodezFeud,
      Value<int?>? lastRodezMonth}) {
    return GroupsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      groupName: groupName ?? this.groupName,
      formationMonth: formationMonth ?? this.formationMonth,
      totalPopularity: totalPopularity ?? this.totalPopularity,
      fanbaseSize: fanbaseSize ?? this.fanbaseSize,
      logoPath: logoPath ?? this.logoPath,
      status: status ?? this.status,
      reputation: reputation ?? this.reputation,
      socialFollowers: socialFollowers ?? this.socialFollowers,
      scandalHeat: scandalHeat ?? this.scandalHeat,
      lastConcertMonth: lastConcertMonth ?? this.lastConcertMonth,
      lastTourMonth: lastTourMonth ?? this.lastTourMonth,
      lastReleaseMonth: lastReleaseMonth ?? this.lastReleaseMonth,
      sponsorName: sponsorName ?? this.sponsorName,
      sponsorIncome: sponsorIncome ?? this.sponsorIncome,
      sponsorMonthsLeft: sponsorMonthsLeft ?? this.sponsorMonthsLeft,
      fandomName: fandomName ?? this.fandomName,
      fandomLoyalty: fandomLoyalty ?? this.fandomLoyalty,
      lastFollowerDelta: lastFollowerDelta ?? this.lastFollowerDelta,
      rodezFeud: rodezFeud ?? this.rodezFeud,
      lastRodezMonth: lastRodezMonth ?? this.lastRodezMonth,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (formationMonth.present) {
      map['formation_month'] = Variable<int>(formationMonth.value);
    }
    if (totalPopularity.present) {
      map['total_popularity'] = Variable<int>(totalPopularity.value);
    }
    if (fanbaseSize.present) {
      map['fanbase_size'] = Variable<int>(fanbaseSize.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reputation.present) {
      map['reputation'] = Variable<int>(reputation.value);
    }
    if (socialFollowers.present) {
      map['social_followers'] = Variable<int>(socialFollowers.value);
    }
    if (scandalHeat.present) {
      map['scandal_heat'] = Variable<int>(scandalHeat.value);
    }
    if (lastConcertMonth.present) {
      map['last_concert_month'] = Variable<int>(lastConcertMonth.value);
    }
    if (lastTourMonth.present) {
      map['last_tour_month'] = Variable<int>(lastTourMonth.value);
    }
    if (lastReleaseMonth.present) {
      map['last_release_month'] = Variable<int>(lastReleaseMonth.value);
    }
    if (sponsorName.present) {
      map['sponsor_name'] = Variable<String>(sponsorName.value);
    }
    if (sponsorIncome.present) {
      map['sponsor_income'] = Variable<int>(sponsorIncome.value);
    }
    if (sponsorMonthsLeft.present) {
      map['sponsor_months_left'] = Variable<int>(sponsorMonthsLeft.value);
    }
    if (fandomName.present) {
      map['fandom_name'] = Variable<String>(fandomName.value);
    }
    if (fandomLoyalty.present) {
      map['fandom_loyalty'] = Variable<int>(fandomLoyalty.value);
    }
    if (lastFollowerDelta.present) {
      map['last_follower_delta'] = Variable<int>(lastFollowerDelta.value);
    }
    if (rodezFeud.present) {
      map['rodez_feud'] = Variable<int>(rodezFeud.value);
    }
    if (lastRodezMonth.present) {
      map['last_rodez_month'] = Variable<int>(lastRodezMonth.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('groupName: $groupName, ')
          ..write('formationMonth: $formationMonth, ')
          ..write('totalPopularity: $totalPopularity, ')
          ..write('fanbaseSize: $fanbaseSize, ')
          ..write('logoPath: $logoPath, ')
          ..write('status: $status, ')
          ..write('reputation: $reputation, ')
          ..write('socialFollowers: $socialFollowers, ')
          ..write('scandalHeat: $scandalHeat, ')
          ..write('lastConcertMonth: $lastConcertMonth, ')
          ..write('lastTourMonth: $lastTourMonth, ')
          ..write('lastReleaseMonth: $lastReleaseMonth, ')
          ..write('sponsorName: $sponsorName, ')
          ..write('sponsorIncome: $sponsorIncome, ')
          ..write('sponsorMonthsLeft: $sponsorMonthsLeft, ')
          ..write('fandomName: $fandomName, ')
          ..write('fandomLoyalty: $fandomLoyalty, ')
          ..write('lastFollowerDelta: $lastFollowerDelta, ')
          ..write('rodezFeud: $rodezFeud, ')
          ..write('lastRodezMonth: $lastRodezMonth')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTable extends GroupMembers
    with TableInfo<$GroupMembersTable, GroupMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _idolIdMeta = const VerificationMeta('idolId');
  @override
  late final GeneratedColumn<int> idolId = GeneratedColumn<int>(
      'idol_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_idols (id)'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
      'position', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _joinMonthMeta =
      const VerificationMeta('joinMonth');
  @override
  late final GeneratedColumn<int> joinMonth = GeneratedColumn<int>(
      'join_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _leaveMonthMeta =
      const VerificationMeta('leaveMonth');
  @override
  late final GeneratedColumn<int> leaveMonth = GeneratedColumn<int>(
      'leave_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, idolId, position, joinMonth, leaveMonth];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(Insertable<GroupMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('idol_id')) {
      context.handle(_idolIdMeta,
          idolId.isAcceptableOrUnknown(data['idol_id']!, _idolIdMeta));
    } else if (isInserting) {
      context.missing(_idolIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('join_month')) {
      context.handle(_joinMonthMeta,
          joinMonth.isAcceptableOrUnknown(data['join_month']!, _joinMonthMeta));
    } else if (isInserting) {
      context.missing(_joinMonthMeta);
    }
    if (data.containsKey('leave_month')) {
      context.handle(
          _leaveMonthMeta,
          leaveMonth.isAcceptableOrUnknown(
              data['leave_month']!, _leaveMonthMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      idolId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idol_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}position'])!,
      joinMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}join_month'])!,
      leaveMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}leave_month']),
    );
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(attachedDatabase, alias);
  }
}

class GroupMember extends DataClass implements Insertable<GroupMember> {
  final int id;
  final int groupId;
  final int idolId;
  final String position;
  final int joinMonth;
  final int? leaveMonth;
  const GroupMember(
      {required this.id,
      required this.groupId,
      required this.idolId,
      required this.position,
      required this.joinMonth,
      this.leaveMonth});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['idol_id'] = Variable<int>(idolId);
    map['position'] = Variable<String>(position);
    map['join_month'] = Variable<int>(joinMonth);
    if (!nullToAbsent || leaveMonth != null) {
      map['leave_month'] = Variable<int>(leaveMonth);
    }
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      idolId: Value(idolId),
      position: Value(position),
      joinMonth: Value(joinMonth),
      leaveMonth: leaveMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveMonth),
    );
  }

  factory GroupMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMember(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      idolId: serializer.fromJson<int>(json['idolId']),
      position: serializer.fromJson<String>(json['position']),
      joinMonth: serializer.fromJson<int>(json['joinMonth']),
      leaveMonth: serializer.fromJson<int?>(json['leaveMonth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'idolId': serializer.toJson<int>(idolId),
      'position': serializer.toJson<String>(position),
      'joinMonth': serializer.toJson<int>(joinMonth),
      'leaveMonth': serializer.toJson<int?>(leaveMonth),
    };
  }

  GroupMember copyWith(
          {int? id,
          int? groupId,
          int? idolId,
          String? position,
          int? joinMonth,
          Value<int?> leaveMonth = const Value.absent()}) =>
      GroupMember(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        idolId: idolId ?? this.idolId,
        position: position ?? this.position,
        joinMonth: joinMonth ?? this.joinMonth,
        leaveMonth: leaveMonth.present ? leaveMonth.value : this.leaveMonth,
      );
  GroupMember copyWithCompanion(GroupMembersCompanion data) {
    return GroupMember(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      idolId: data.idolId.present ? data.idolId.value : this.idolId,
      position: data.position.present ? data.position.value : this.position,
      joinMonth: data.joinMonth.present ? data.joinMonth.value : this.joinMonth,
      leaveMonth:
          data.leaveMonth.present ? data.leaveMonth.value : this.leaveMonth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMember(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('idolId: $idolId, ')
          ..write('position: $position, ')
          ..write('joinMonth: $joinMonth, ')
          ..write('leaveMonth: $leaveMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, idolId, position, joinMonth, leaveMonth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMember &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.idolId == this.idolId &&
          other.position == this.position &&
          other.joinMonth == this.joinMonth &&
          other.leaveMonth == this.leaveMonth);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMember> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> idolId;
  final Value<String> position;
  final Value<int> joinMonth;
  final Value<int?> leaveMonth;
  const GroupMembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.idolId = const Value.absent(),
    this.position = const Value.absent(),
    this.joinMonth = const Value.absent(),
    this.leaveMonth = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int idolId,
    required String position,
    required int joinMonth,
    this.leaveMonth = const Value.absent(),
  })  : groupId = Value(groupId),
        idolId = Value(idolId),
        position = Value(position),
        joinMonth = Value(joinMonth);
  static Insertable<GroupMember> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? idolId,
    Expression<String>? position,
    Expression<int>? joinMonth,
    Expression<int>? leaveMonth,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (idolId != null) 'idol_id': idolId,
      if (position != null) 'position': position,
      if (joinMonth != null) 'join_month': joinMonth,
      if (leaveMonth != null) 'leave_month': leaveMonth,
    });
  }

  GroupMembersCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? idolId,
      Value<String>? position,
      Value<int>? joinMonth,
      Value<int?>? leaveMonth}) {
    return GroupMembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      idolId: idolId ?? this.idolId,
      position: position ?? this.position,
      joinMonth: joinMonth ?? this.joinMonth,
      leaveMonth: leaveMonth ?? this.leaveMonth,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (idolId.present) {
      map['idol_id'] = Variable<int>(idolId.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (joinMonth.present) {
      map['join_month'] = Variable<int>(joinMonth.value);
    }
    if (leaveMonth.present) {
      map['leave_month'] = Variable<int>(leaveMonth.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('idolId: $idolId, ')
          ..write('position: $position, ')
          ..write('joinMonth: $joinMonth, ')
          ..write('leaveMonth: $leaveMonth')
          ..write(')'))
        .toString();
  }
}

class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
      'genre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _releaseMonthMeta =
      const VerificationMeta('releaseMonth');
  @override
  late final GeneratedColumn<int> releaseMonth = GeneratedColumn<int>(
      'release_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _qualityScoreMeta =
      const VerificationMeta('qualityScore');
  @override
  late final GeneratedColumn<int> qualityScore = GeneratedColumn<int>(
      'quality_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _peakChartPositionMeta =
      const VerificationMeta('peakChartPosition');
  @override
  late final GeneratedColumn<int> peakChartPosition = GeneratedColumn<int>(
      'peak_chart_position', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentChartPositionMeta =
      const VerificationMeta('currentChartPosition');
  @override
  late final GeneratedColumn<int> currentChartPosition = GeneratedColumn<int>(
      'current_chart_position', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalStreamsMeta =
      const VerificationMeta('totalStreams');
  @override
  late final GeneratedColumn<int> totalStreams = GeneratedColumn<int>(
      'total_streams', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lyricProfileMeta =
      const VerificationMeta('lyricProfile');
  @override
  late final GeneratedColumn<String> lyricProfile = GeneratedColumn<String>(
      'lyric_profile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _albumIdMeta =
      const VerificationMeta('albumId');
  @override
  late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
      'album_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        title,
        genre,
        releaseMonth,
        qualityScore,
        peakChartPosition,
        currentChartPosition,
        totalStreams,
        lyricProfile,
        albumId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<Song> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('genre')) {
      context.handle(
          _genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    }
    if (data.containsKey('release_month')) {
      context.handle(
          _releaseMonthMeta,
          releaseMonth.isAcceptableOrUnknown(
              data['release_month']!, _releaseMonthMeta));
    } else if (isInserting) {
      context.missing(_releaseMonthMeta);
    }
    if (data.containsKey('quality_score')) {
      context.handle(
          _qualityScoreMeta,
          qualityScore.isAcceptableOrUnknown(
              data['quality_score']!, _qualityScoreMeta));
    }
    if (data.containsKey('peak_chart_position')) {
      context.handle(
          _peakChartPositionMeta,
          peakChartPosition.isAcceptableOrUnknown(
              data['peak_chart_position']!, _peakChartPositionMeta));
    }
    if (data.containsKey('current_chart_position')) {
      context.handle(
          _currentChartPositionMeta,
          currentChartPosition.isAcceptableOrUnknown(
              data['current_chart_position']!, _currentChartPositionMeta));
    }
    if (data.containsKey('total_streams')) {
      context.handle(
          _totalStreamsMeta,
          totalStreams.isAcceptableOrUnknown(
              data['total_streams']!, _totalStreamsMeta));
    }
    if (data.containsKey('lyric_profile')) {
      context.handle(
          _lyricProfileMeta,
          lyricProfile.isAcceptableOrUnknown(
              data['lyric_profile']!, _lyricProfileMeta));
    }
    if (data.containsKey('album_id')) {
      context.handle(_albumIdMeta,
          albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      genre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genre']),
      releaseMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}release_month'])!,
      qualityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quality_score']),
      peakChartPosition: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}peak_chart_position']),
      currentChartPosition: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_chart_position']),
      totalStreams: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_streams'])!,
      lyricProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lyric_profile']),
      albumId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album_id']),
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final int id;
  final int groupId;
  final String title;
  final String? genre;
  final int releaseMonth;
  final int? qualityScore;
  final int? peakChartPosition;
  final int? currentChartPosition;
  final int totalStreams;
  final String? lyricProfile;
  final int? albumId;
  const Song(
      {required this.id,
      required this.groupId,
      required this.title,
      this.genre,
      required this.releaseMonth,
      this.qualityScore,
      this.peakChartPosition,
      this.currentChartPosition,
      required this.totalStreams,
      this.lyricProfile,
      this.albumId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    map['release_month'] = Variable<int>(releaseMonth);
    if (!nullToAbsent || qualityScore != null) {
      map['quality_score'] = Variable<int>(qualityScore);
    }
    if (!nullToAbsent || peakChartPosition != null) {
      map['peak_chart_position'] = Variable<int>(peakChartPosition);
    }
    if (!nullToAbsent || currentChartPosition != null) {
      map['current_chart_position'] = Variable<int>(currentChartPosition);
    }
    map['total_streams'] = Variable<int>(totalStreams);
    if (!nullToAbsent || lyricProfile != null) {
      map['lyric_profile'] = Variable<String>(lyricProfile);
    }
    if (!nullToAbsent || albumId != null) {
      map['album_id'] = Variable<int>(albumId);
    }
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      title: Value(title),
      genre:
          genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      releaseMonth: Value(releaseMonth),
      qualityScore: qualityScore == null && nullToAbsent
          ? const Value.absent()
          : Value(qualityScore),
      peakChartPosition: peakChartPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(peakChartPosition),
      currentChartPosition: currentChartPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(currentChartPosition),
      totalStreams: Value(totalStreams),
      lyricProfile: lyricProfile == null && nullToAbsent
          ? const Value.absent()
          : Value(lyricProfile),
      albumId: albumId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumId),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      title: serializer.fromJson<String>(json['title']),
      genre: serializer.fromJson<String?>(json['genre']),
      releaseMonth: serializer.fromJson<int>(json['releaseMonth']),
      qualityScore: serializer.fromJson<int?>(json['qualityScore']),
      peakChartPosition: serializer.fromJson<int?>(json['peakChartPosition']),
      currentChartPosition:
          serializer.fromJson<int?>(json['currentChartPosition']),
      totalStreams: serializer.fromJson<int>(json['totalStreams']),
      lyricProfile: serializer.fromJson<String?>(json['lyricProfile']),
      albumId: serializer.fromJson<int?>(json['albumId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'title': serializer.toJson<String>(title),
      'genre': serializer.toJson<String?>(genre),
      'releaseMonth': serializer.toJson<int>(releaseMonth),
      'qualityScore': serializer.toJson<int?>(qualityScore),
      'peakChartPosition': serializer.toJson<int?>(peakChartPosition),
      'currentChartPosition': serializer.toJson<int?>(currentChartPosition),
      'totalStreams': serializer.toJson<int>(totalStreams),
      'lyricProfile': serializer.toJson<String?>(lyricProfile),
      'albumId': serializer.toJson<int?>(albumId),
    };
  }

  Song copyWith(
          {int? id,
          int? groupId,
          String? title,
          Value<String?> genre = const Value.absent(),
          int? releaseMonth,
          Value<int?> qualityScore = const Value.absent(),
          Value<int?> peakChartPosition = const Value.absent(),
          Value<int?> currentChartPosition = const Value.absent(),
          int? totalStreams,
          Value<String?> lyricProfile = const Value.absent(),
          Value<int?> albumId = const Value.absent()}) =>
      Song(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        title: title ?? this.title,
        genre: genre.present ? genre.value : this.genre,
        releaseMonth: releaseMonth ?? this.releaseMonth,
        qualityScore:
            qualityScore.present ? qualityScore.value : this.qualityScore,
        peakChartPosition: peakChartPosition.present
            ? peakChartPosition.value
            : this.peakChartPosition,
        currentChartPosition: currentChartPosition.present
            ? currentChartPosition.value
            : this.currentChartPosition,
        totalStreams: totalStreams ?? this.totalStreams,
        lyricProfile:
            lyricProfile.present ? lyricProfile.value : this.lyricProfile,
        albumId: albumId.present ? albumId.value : this.albumId,
      );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      title: data.title.present ? data.title.value : this.title,
      genre: data.genre.present ? data.genre.value : this.genre,
      releaseMonth: data.releaseMonth.present
          ? data.releaseMonth.value
          : this.releaseMonth,
      qualityScore: data.qualityScore.present
          ? data.qualityScore.value
          : this.qualityScore,
      peakChartPosition: data.peakChartPosition.present
          ? data.peakChartPosition.value
          : this.peakChartPosition,
      currentChartPosition: data.currentChartPosition.present
          ? data.currentChartPosition.value
          : this.currentChartPosition,
      totalStreams: data.totalStreams.present
          ? data.totalStreams.value
          : this.totalStreams,
      lyricProfile: data.lyricProfile.present
          ? data.lyricProfile.value
          : this.lyricProfile,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('genre: $genre, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('qualityScore: $qualityScore, ')
          ..write('peakChartPosition: $peakChartPosition, ')
          ..write('currentChartPosition: $currentChartPosition, ')
          ..write('totalStreams: $totalStreams, ')
          ..write('lyricProfile: $lyricProfile, ')
          ..write('albumId: $albumId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      groupId,
      title,
      genre,
      releaseMonth,
      qualityScore,
      peakChartPosition,
      currentChartPosition,
      totalStreams,
      lyricProfile,
      albumId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.title == this.title &&
          other.genre == this.genre &&
          other.releaseMonth == this.releaseMonth &&
          other.qualityScore == this.qualityScore &&
          other.peakChartPosition == this.peakChartPosition &&
          other.currentChartPosition == this.currentChartPosition &&
          other.totalStreams == this.totalStreams &&
          other.lyricProfile == this.lyricProfile &&
          other.albumId == this.albumId);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> title;
  final Value<String?> genre;
  final Value<int> releaseMonth;
  final Value<int?> qualityScore;
  final Value<int?> peakChartPosition;
  final Value<int?> currentChartPosition;
  final Value<int> totalStreams;
  final Value<String?> lyricProfile;
  final Value<int?> albumId;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.title = const Value.absent(),
    this.genre = const Value.absent(),
    this.releaseMonth = const Value.absent(),
    this.qualityScore = const Value.absent(),
    this.peakChartPosition = const Value.absent(),
    this.currentChartPosition = const Value.absent(),
    this.totalStreams = const Value.absent(),
    this.lyricProfile = const Value.absent(),
    this.albumId = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String title,
    this.genre = const Value.absent(),
    required int releaseMonth,
    this.qualityScore = const Value.absent(),
    this.peakChartPosition = const Value.absent(),
    this.currentChartPosition = const Value.absent(),
    this.totalStreams = const Value.absent(),
    this.lyricProfile = const Value.absent(),
    this.albumId = const Value.absent(),
  })  : groupId = Value(groupId),
        title = Value(title),
        releaseMonth = Value(releaseMonth);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? title,
    Expression<String>? genre,
    Expression<int>? releaseMonth,
    Expression<int>? qualityScore,
    Expression<int>? peakChartPosition,
    Expression<int>? currentChartPosition,
    Expression<int>? totalStreams,
    Expression<String>? lyricProfile,
    Expression<int>? albumId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (title != null) 'title': title,
      if (genre != null) 'genre': genre,
      if (releaseMonth != null) 'release_month': releaseMonth,
      if (qualityScore != null) 'quality_score': qualityScore,
      if (peakChartPosition != null) 'peak_chart_position': peakChartPosition,
      if (currentChartPosition != null)
        'current_chart_position': currentChartPosition,
      if (totalStreams != null) 'total_streams': totalStreams,
      if (lyricProfile != null) 'lyric_profile': lyricProfile,
      if (albumId != null) 'album_id': albumId,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<String>? title,
      Value<String?>? genre,
      Value<int>? releaseMonth,
      Value<int?>? qualityScore,
      Value<int?>? peakChartPosition,
      Value<int?>? currentChartPosition,
      Value<int>? totalStreams,
      Value<String?>? lyricProfile,
      Value<int?>? albumId}) {
    return SongsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      releaseMonth: releaseMonth ?? this.releaseMonth,
      qualityScore: qualityScore ?? this.qualityScore,
      peakChartPosition: peakChartPosition ?? this.peakChartPosition,
      currentChartPosition: currentChartPosition ?? this.currentChartPosition,
      totalStreams: totalStreams ?? this.totalStreams,
      lyricProfile: lyricProfile ?? this.lyricProfile,
      albumId: albumId ?? this.albumId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (releaseMonth.present) {
      map['release_month'] = Variable<int>(releaseMonth.value);
    }
    if (qualityScore.present) {
      map['quality_score'] = Variable<int>(qualityScore.value);
    }
    if (peakChartPosition.present) {
      map['peak_chart_position'] = Variable<int>(peakChartPosition.value);
    }
    if (currentChartPosition.present) {
      map['current_chart_position'] = Variable<int>(currentChartPosition.value);
    }
    if (totalStreams.present) {
      map['total_streams'] = Variable<int>(totalStreams.value);
    }
    if (lyricProfile.present) {
      map['lyric_profile'] = Variable<String>(lyricProfile.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<int>(albumId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('genre: $genre, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('qualityScore: $qualityScore, ')
          ..write('peakChartPosition: $peakChartPosition, ')
          ..write('currentChartPosition: $currentChartPosition, ')
          ..write('totalStreams: $totalStreams, ')
          ..write('lyricProfile: $lyricProfile, ')
          ..write('albumId: $albumId')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _releaseMonthMeta =
      const VerificationMeta('releaseMonth');
  @override
  late final GeneratedColumn<int> releaseMonth = GeneratedColumn<int>(
      'release_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _trackCountMeta =
      const VerificationMeta('trackCount');
  @override
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
      'track_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avgQualityMeta =
      const VerificationMeta('avgQuality');
  @override
  late final GeneratedColumn<int> avgQuality = GeneratedColumn<int>(
      'avg_quality', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _popBoostMeta =
      const VerificationMeta('popBoost');
  @override
  late final GeneratedColumn<int> popBoost = GeneratedColumn<int>(
      'pop_boost', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _conceptMeta =
      const VerificationMeta('concept');
  @override
  late final GeneratedColumn<String> concept = GeneratedColumn<String>(
      'concept', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        title,
        releaseMonth,
        trackCount,
        avgQuality,
        popBoost,
        concept
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<Album> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('release_month')) {
      context.handle(
          _releaseMonthMeta,
          releaseMonth.isAcceptableOrUnknown(
              data['release_month']!, _releaseMonthMeta));
    } else if (isInserting) {
      context.missing(_releaseMonthMeta);
    }
    if (data.containsKey('track_count')) {
      context.handle(
          _trackCountMeta,
          trackCount.isAcceptableOrUnknown(
              data['track_count']!, _trackCountMeta));
    } else if (isInserting) {
      context.missing(_trackCountMeta);
    }
    if (data.containsKey('avg_quality')) {
      context.handle(
          _avgQualityMeta,
          avgQuality.isAcceptableOrUnknown(
              data['avg_quality']!, _avgQualityMeta));
    } else if (isInserting) {
      context.missing(_avgQualityMeta);
    }
    if (data.containsKey('pop_boost')) {
      context.handle(_popBoostMeta,
          popBoost.isAcceptableOrUnknown(data['pop_boost']!, _popBoostMeta));
    }
    if (data.containsKey('concept')) {
      context.handle(_conceptMeta,
          concept.isAcceptableOrUnknown(data['concept']!, _conceptMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      releaseMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}release_month'])!,
      trackCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}track_count'])!,
      avgQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avg_quality'])!,
      popBoost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pop_boost'])!,
      concept: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}concept']),
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final int id;
  final int groupId;
  final String title;
  final int releaseMonth;
  final int trackCount;
  final int avgQuality;
  final int popBoost;
  final String? concept;
  const Album(
      {required this.id,
      required this.groupId,
      required this.title,
      required this.releaseMonth,
      required this.trackCount,
      required this.avgQuality,
      required this.popBoost,
      this.concept});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['title'] = Variable<String>(title);
    map['release_month'] = Variable<int>(releaseMonth);
    map['track_count'] = Variable<int>(trackCount);
    map['avg_quality'] = Variable<int>(avgQuality);
    map['pop_boost'] = Variable<int>(popBoost);
    if (!nullToAbsent || concept != null) {
      map['concept'] = Variable<String>(concept);
    }
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      title: Value(title),
      releaseMonth: Value(releaseMonth),
      trackCount: Value(trackCount),
      avgQuality: Value(avgQuality),
      popBoost: Value(popBoost),
      concept: concept == null && nullToAbsent
          ? const Value.absent()
          : Value(concept),
    );
  }

  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      title: serializer.fromJson<String>(json['title']),
      releaseMonth: serializer.fromJson<int>(json['releaseMonth']),
      trackCount: serializer.fromJson<int>(json['trackCount']),
      avgQuality: serializer.fromJson<int>(json['avgQuality']),
      popBoost: serializer.fromJson<int>(json['popBoost']),
      concept: serializer.fromJson<String?>(json['concept']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'title': serializer.toJson<String>(title),
      'releaseMonth': serializer.toJson<int>(releaseMonth),
      'trackCount': serializer.toJson<int>(trackCount),
      'avgQuality': serializer.toJson<int>(avgQuality),
      'popBoost': serializer.toJson<int>(popBoost),
      'concept': serializer.toJson<String?>(concept),
    };
  }

  Album copyWith(
          {int? id,
          int? groupId,
          String? title,
          int? releaseMonth,
          int? trackCount,
          int? avgQuality,
          int? popBoost,
          Value<String?> concept = const Value.absent()}) =>
      Album(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        title: title ?? this.title,
        releaseMonth: releaseMonth ?? this.releaseMonth,
        trackCount: trackCount ?? this.trackCount,
        avgQuality: avgQuality ?? this.avgQuality,
        popBoost: popBoost ?? this.popBoost,
        concept: concept.present ? concept.value : this.concept,
      );
  Album copyWithCompanion(AlbumsCompanion data) {
    return Album(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      title: data.title.present ? data.title.value : this.title,
      releaseMonth: data.releaseMonth.present
          ? data.releaseMonth.value
          : this.releaseMonth,
      trackCount:
          data.trackCount.present ? data.trackCount.value : this.trackCount,
      avgQuality:
          data.avgQuality.present ? data.avgQuality.value : this.avgQuality,
      popBoost: data.popBoost.present ? data.popBoost.value : this.popBoost,
      concept: data.concept.present ? data.concept.value : this.concept,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('trackCount: $trackCount, ')
          ..write('avgQuality: $avgQuality, ')
          ..write('popBoost: $popBoost, ')
          ..write('concept: $concept')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, title, releaseMonth, trackCount,
      avgQuality, popBoost, concept);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.title == this.title &&
          other.releaseMonth == this.releaseMonth &&
          other.trackCount == this.trackCount &&
          other.avgQuality == this.avgQuality &&
          other.popBoost == this.popBoost &&
          other.concept == this.concept);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> title;
  final Value<int> releaseMonth;
  final Value<int> trackCount;
  final Value<int> avgQuality;
  final Value<int> popBoost;
  final Value<String?> concept;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.title = const Value.absent(),
    this.releaseMonth = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.avgQuality = const Value.absent(),
    this.popBoost = const Value.absent(),
    this.concept = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String title,
    required int releaseMonth,
    required int trackCount,
    required int avgQuality,
    this.popBoost = const Value.absent(),
    this.concept = const Value.absent(),
  })  : groupId = Value(groupId),
        title = Value(title),
        releaseMonth = Value(releaseMonth),
        trackCount = Value(trackCount),
        avgQuality = Value(avgQuality);
  static Insertable<Album> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? title,
    Expression<int>? releaseMonth,
    Expression<int>? trackCount,
    Expression<int>? avgQuality,
    Expression<int>? popBoost,
    Expression<String>? concept,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (title != null) 'title': title,
      if (releaseMonth != null) 'release_month': releaseMonth,
      if (trackCount != null) 'track_count': trackCount,
      if (avgQuality != null) 'avg_quality': avgQuality,
      if (popBoost != null) 'pop_boost': popBoost,
      if (concept != null) 'concept': concept,
    });
  }

  AlbumsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<String>? title,
      Value<int>? releaseMonth,
      Value<int>? trackCount,
      Value<int>? avgQuality,
      Value<int>? popBoost,
      Value<String?>? concept}) {
    return AlbumsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      releaseMonth: releaseMonth ?? this.releaseMonth,
      trackCount: trackCount ?? this.trackCount,
      avgQuality: avgQuality ?? this.avgQuality,
      popBoost: popBoost ?? this.popBoost,
      concept: concept ?? this.concept,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (releaseMonth.present) {
      map['release_month'] = Variable<int>(releaseMonth.value);
    }
    if (trackCount.present) {
      map['track_count'] = Variable<int>(trackCount.value);
    }
    if (avgQuality.present) {
      map['avg_quality'] = Variable<int>(avgQuality.value);
    }
    if (popBoost.present) {
      map['pop_boost'] = Variable<int>(popBoost.value);
    }
    if (concept.present) {
      map['concept'] = Variable<String>(concept.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('trackCount: $trackCount, ')
          ..write('avgQuality: $avgQuality, ')
          ..write('popBoost: $popBoost, ')
          ..write('concept: $concept')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _achKeyMeta = const VerificationMeta('achKey');
  @override
  late final GeneratedColumn<String> achKey = GeneratedColumn<String>(
      'ach_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAbsMonthMeta =
      const VerificationMeta('unlockedAbsMonth');
  @override
  late final GeneratedColumn<int> unlockedAbsMonth = GeneratedColumn<int>(
      'unlocked_abs_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, careerId, achKey, title, unlockedAbsMonth];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(Insertable<Achievement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('ach_key')) {
      context.handle(_achKeyMeta,
          achKey.isAcceptableOrUnknown(data['ach_key']!, _achKeyMeta));
    } else if (isInserting) {
      context.missing(_achKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('unlocked_abs_month')) {
      context.handle(
          _unlockedAbsMonthMeta,
          unlockedAbsMonth.isAcceptableOrUnknown(
              data['unlocked_abs_month']!, _unlockedAbsMonthMeta));
    } else if (isInserting) {
      context.missing(_unlockedAbsMonthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {careerId, achKey},
      ];
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      achKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ach_key'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      unlockedAbsMonth: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unlocked_abs_month'])!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final int id;
  final int careerId;
  final String achKey;
  final String title;
  final int unlockedAbsMonth;
  const Achievement(
      {required this.id,
      required this.careerId,
      required this.achKey,
      required this.title,
      required this.unlockedAbsMonth});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['ach_key'] = Variable<String>(achKey);
    map['title'] = Variable<String>(title);
    map['unlocked_abs_month'] = Variable<int>(unlockedAbsMonth);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      achKey: Value(achKey),
      title: Value(title),
      unlockedAbsMonth: Value(unlockedAbsMonth),
    );
  }

  factory Achievement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      achKey: serializer.fromJson<String>(json['achKey']),
      title: serializer.fromJson<String>(json['title']),
      unlockedAbsMonth: serializer.fromJson<int>(json['unlockedAbsMonth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'achKey': serializer.toJson<String>(achKey),
      'title': serializer.toJson<String>(title),
      'unlockedAbsMonth': serializer.toJson<int>(unlockedAbsMonth),
    };
  }

  Achievement copyWith(
          {int? id,
          int? careerId,
          String? achKey,
          String? title,
          int? unlockedAbsMonth}) =>
      Achievement(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        achKey: achKey ?? this.achKey,
        title: title ?? this.title,
        unlockedAbsMonth: unlockedAbsMonth ?? this.unlockedAbsMonth,
      );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      achKey: data.achKey.present ? data.achKey.value : this.achKey,
      title: data.title.present ? data.title.value : this.title,
      unlockedAbsMonth: data.unlockedAbsMonth.present
          ? data.unlockedAbsMonth.value
          : this.unlockedAbsMonth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('achKey: $achKey, ')
          ..write('title: $title, ')
          ..write('unlockedAbsMonth: $unlockedAbsMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, careerId, achKey, title, unlockedAbsMonth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.achKey == this.achKey &&
          other.title == this.title &&
          other.unlockedAbsMonth == this.unlockedAbsMonth);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<String> achKey;
  final Value<String> title;
  final Value<int> unlockedAbsMonth;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.achKey = const Value.absent(),
    this.title = const Value.absent(),
    this.unlockedAbsMonth = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required String achKey,
    required String title,
    required int unlockedAbsMonth,
  })  : careerId = Value(careerId),
        achKey = Value(achKey),
        title = Value(title),
        unlockedAbsMonth = Value(unlockedAbsMonth);
  static Insertable<Achievement> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<String>? achKey,
    Expression<String>? title,
    Expression<int>? unlockedAbsMonth,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (achKey != null) 'ach_key': achKey,
      if (title != null) 'title': title,
      if (unlockedAbsMonth != null) 'unlocked_abs_month': unlockedAbsMonth,
    });
  }

  AchievementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<String>? achKey,
      Value<String>? title,
      Value<int>? unlockedAbsMonth}) {
    return AchievementsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      achKey: achKey ?? this.achKey,
      title: title ?? this.title,
      unlockedAbsMonth: unlockedAbsMonth ?? this.unlockedAbsMonth,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (achKey.present) {
      map['ach_key'] = Variable<String>(achKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (unlockedAbsMonth.present) {
      map['unlocked_abs_month'] = Variable<int>(unlockedAbsMonth.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('achKey: $achKey, ')
          ..write('title: $title, ')
          ..write('unlockedAbsMonth: $unlockedAbsMonth')
          ..write(')'))
        .toString();
  }
}

class $GlobalAchievementsTable extends GlobalAchievements
    with TableInfo<$GlobalAchievementsTable, GlobalAchievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GlobalAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _achKeyMeta = const VerificationMeta('achKey');
  @override
  late final GeneratedColumn<String> achKey = GeneratedColumn<String>(
      'ach_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedCareerNumberMeta =
      const VerificationMeta('unlockedCareerNumber');
  @override
  late final GeneratedColumn<int> unlockedCareerNumber = GeneratedColumn<int>(
      'unlocked_career_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, achKey, title, unlockedCareerNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'global_achievements';
  @override
  VerificationContext validateIntegrity(Insertable<GlobalAchievement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ach_key')) {
      context.handle(_achKeyMeta,
          achKey.isAcceptableOrUnknown(data['ach_key']!, _achKeyMeta));
    } else if (isInserting) {
      context.missing(_achKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('unlocked_career_number')) {
      context.handle(
          _unlockedCareerNumberMeta,
          unlockedCareerNumber.isAcceptableOrUnknown(
              data['unlocked_career_number']!, _unlockedCareerNumberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {achKey},
      ];
  @override
  GlobalAchievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GlobalAchievement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      achKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ach_key'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      unlockedCareerNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unlocked_career_number'])!,
    );
  }

  @override
  $GlobalAchievementsTable createAlias(String alias) {
    return $GlobalAchievementsTable(attachedDatabase, alias);
  }
}

class GlobalAchievement extends DataClass
    implements Insertable<GlobalAchievement> {
  final int id;
  final String achKey;
  final String title;
  final int unlockedCareerNumber;
  const GlobalAchievement(
      {required this.id,
      required this.achKey,
      required this.title,
      required this.unlockedCareerNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ach_key'] = Variable<String>(achKey);
    map['title'] = Variable<String>(title);
    map['unlocked_career_number'] = Variable<int>(unlockedCareerNumber);
    return map;
  }

  GlobalAchievementsCompanion toCompanion(bool nullToAbsent) {
    return GlobalAchievementsCompanion(
      id: Value(id),
      achKey: Value(achKey),
      title: Value(title),
      unlockedCareerNumber: Value(unlockedCareerNumber),
    );
  }

  factory GlobalAchievement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GlobalAchievement(
      id: serializer.fromJson<int>(json['id']),
      achKey: serializer.fromJson<String>(json['achKey']),
      title: serializer.fromJson<String>(json['title']),
      unlockedCareerNumber:
          serializer.fromJson<int>(json['unlockedCareerNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'achKey': serializer.toJson<String>(achKey),
      'title': serializer.toJson<String>(title),
      'unlockedCareerNumber': serializer.toJson<int>(unlockedCareerNumber),
    };
  }

  GlobalAchievement copyWith(
          {int? id,
          String? achKey,
          String? title,
          int? unlockedCareerNumber}) =>
      GlobalAchievement(
        id: id ?? this.id,
        achKey: achKey ?? this.achKey,
        title: title ?? this.title,
        unlockedCareerNumber: unlockedCareerNumber ?? this.unlockedCareerNumber,
      );
  GlobalAchievement copyWithCompanion(GlobalAchievementsCompanion data) {
    return GlobalAchievement(
      id: data.id.present ? data.id.value : this.id,
      achKey: data.achKey.present ? data.achKey.value : this.achKey,
      title: data.title.present ? data.title.value : this.title,
      unlockedCareerNumber: data.unlockedCareerNumber.present
          ? data.unlockedCareerNumber.value
          : this.unlockedCareerNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GlobalAchievement(')
          ..write('id: $id, ')
          ..write('achKey: $achKey, ')
          ..write('title: $title, ')
          ..write('unlockedCareerNumber: $unlockedCareerNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, achKey, title, unlockedCareerNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GlobalAchievement &&
          other.id == this.id &&
          other.achKey == this.achKey &&
          other.title == this.title &&
          other.unlockedCareerNumber == this.unlockedCareerNumber);
}

class GlobalAchievementsCompanion extends UpdateCompanion<GlobalAchievement> {
  final Value<int> id;
  final Value<String> achKey;
  final Value<String> title;
  final Value<int> unlockedCareerNumber;
  const GlobalAchievementsCompanion({
    this.id = const Value.absent(),
    this.achKey = const Value.absent(),
    this.title = const Value.absent(),
    this.unlockedCareerNumber = const Value.absent(),
  });
  GlobalAchievementsCompanion.insert({
    this.id = const Value.absent(),
    required String achKey,
    required String title,
    this.unlockedCareerNumber = const Value.absent(),
  })  : achKey = Value(achKey),
        title = Value(title);
  static Insertable<GlobalAchievement> custom({
    Expression<int>? id,
    Expression<String>? achKey,
    Expression<String>? title,
    Expression<int>? unlockedCareerNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (achKey != null) 'ach_key': achKey,
      if (title != null) 'title': title,
      if (unlockedCareerNumber != null)
        'unlocked_career_number': unlockedCareerNumber,
    });
  }

  GlobalAchievementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? achKey,
      Value<String>? title,
      Value<int>? unlockedCareerNumber}) {
    return GlobalAchievementsCompanion(
      id: id ?? this.id,
      achKey: achKey ?? this.achKey,
      title: title ?? this.title,
      unlockedCareerNumber: unlockedCareerNumber ?? this.unlockedCareerNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (achKey.present) {
      map['ach_key'] = Variable<String>(achKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (unlockedCareerNumber.present) {
      map['unlocked_career_number'] = Variable<int>(unlockedCareerNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GlobalAchievementsCompanion(')
          ..write('id: $id, ')
          ..write('achKey: $achKey, ')
          ..write('title: $title, ')
          ..write('unlockedCareerNumber: $unlockedCareerNumber')
          ..write(')'))
        .toString();
  }
}

class $SocialPostsTable extends SocialPosts
    with TableInfo<$SocialPostsTable, SocialPost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialPostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _absWeekMeta =
      const VerificationMeta('absWeek');
  @override
  late final GeneratedColumn<int> absWeek = GeneratedColumn<int>(
      'abs_week', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _postTypeMeta =
      const VerificationMeta('postType');
  @override
  late final GeneratedColumn<String> postType = GeneratedColumn<String>(
      'post_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _handleMeta = const VerificationMeta('handle');
  @override
  late final GeneratedColumn<String> handle = GeneratedColumn<String>(
      'handle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarEmojiMeta =
      const VerificationMeta('avatarEmoji');
  @override
  late final GeneratedColumn<String> avatarEmoji = GeneratedColumn<String>(
      'avatar_emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerId,
        absWeek,
        postType,
        displayName,
        handle,
        content,
        avatarEmoji
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_posts';
  @override
  VerificationContext validateIntegrity(Insertable<SocialPost> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('abs_week')) {
      context.handle(_absWeekMeta,
          absWeek.isAcceptableOrUnknown(data['abs_week']!, _absWeekMeta));
    } else if (isInserting) {
      context.missing(_absWeekMeta);
    }
    if (data.containsKey('post_type')) {
      context.handle(_postTypeMeta,
          postType.isAcceptableOrUnknown(data['post_type']!, _postTypeMeta));
    } else if (isInserting) {
      context.missing(_postTypeMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('handle')) {
      context.handle(_handleMeta,
          handle.isAcceptableOrUnknown(data['handle']!, _handleMeta));
    } else if (isInserting) {
      context.missing(_handleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('avatar_emoji')) {
      context.handle(
          _avatarEmojiMeta,
          avatarEmoji.isAcceptableOrUnknown(
              data['avatar_emoji']!, _avatarEmojiMeta));
    } else if (isInserting) {
      context.missing(_avatarEmojiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SocialPost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialPost(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      absWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}abs_week'])!,
      postType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}post_type'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      handle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}handle'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      avatarEmoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_emoji'])!,
    );
  }

  @override
  $SocialPostsTable createAlias(String alias) {
    return $SocialPostsTable(attachedDatabase, alias);
  }
}

class SocialPost extends DataClass implements Insertable<SocialPost> {
  final int id;
  final int careerId;
  final int absWeek;
  final String postType;
  final String displayName;
  final String handle;
  final String content;
  final String avatarEmoji;
  const SocialPost(
      {required this.id,
      required this.careerId,
      required this.absWeek,
      required this.postType,
      required this.displayName,
      required this.handle,
      required this.content,
      required this.avatarEmoji});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['abs_week'] = Variable<int>(absWeek);
    map['post_type'] = Variable<String>(postType);
    map['display_name'] = Variable<String>(displayName);
    map['handle'] = Variable<String>(handle);
    map['content'] = Variable<String>(content);
    map['avatar_emoji'] = Variable<String>(avatarEmoji);
    return map;
  }

  SocialPostsCompanion toCompanion(bool nullToAbsent) {
    return SocialPostsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      absWeek: Value(absWeek),
      postType: Value(postType),
      displayName: Value(displayName),
      handle: Value(handle),
      content: Value(content),
      avatarEmoji: Value(avatarEmoji),
    );
  }

  factory SocialPost.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialPost(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      absWeek: serializer.fromJson<int>(json['absWeek']),
      postType: serializer.fromJson<String>(json['postType']),
      displayName: serializer.fromJson<String>(json['displayName']),
      handle: serializer.fromJson<String>(json['handle']),
      content: serializer.fromJson<String>(json['content']),
      avatarEmoji: serializer.fromJson<String>(json['avatarEmoji']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'absWeek': serializer.toJson<int>(absWeek),
      'postType': serializer.toJson<String>(postType),
      'displayName': serializer.toJson<String>(displayName),
      'handle': serializer.toJson<String>(handle),
      'content': serializer.toJson<String>(content),
      'avatarEmoji': serializer.toJson<String>(avatarEmoji),
    };
  }

  SocialPost copyWith(
          {int? id,
          int? careerId,
          int? absWeek,
          String? postType,
          String? displayName,
          String? handle,
          String? content,
          String? avatarEmoji}) =>
      SocialPost(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        absWeek: absWeek ?? this.absWeek,
        postType: postType ?? this.postType,
        displayName: displayName ?? this.displayName,
        handle: handle ?? this.handle,
        content: content ?? this.content,
        avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      );
  SocialPost copyWithCompanion(SocialPostsCompanion data) {
    return SocialPost(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      absWeek: data.absWeek.present ? data.absWeek.value : this.absWeek,
      postType: data.postType.present ? data.postType.value : this.postType,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      handle: data.handle.present ? data.handle.value : this.handle,
      content: data.content.present ? data.content.value : this.content,
      avatarEmoji:
          data.avatarEmoji.present ? data.avatarEmoji.value : this.avatarEmoji,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialPost(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('absWeek: $absWeek, ')
          ..write('postType: $postType, ')
          ..write('displayName: $displayName, ')
          ..write('handle: $handle, ')
          ..write('content: $content, ')
          ..write('avatarEmoji: $avatarEmoji')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, careerId, absWeek, postType, displayName,
      handle, content, avatarEmoji);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialPost &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.absWeek == this.absWeek &&
          other.postType == this.postType &&
          other.displayName == this.displayName &&
          other.handle == this.handle &&
          other.content == this.content &&
          other.avatarEmoji == this.avatarEmoji);
}

class SocialPostsCompanion extends UpdateCompanion<SocialPost> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> absWeek;
  final Value<String> postType;
  final Value<String> displayName;
  final Value<String> handle;
  final Value<String> content;
  final Value<String> avatarEmoji;
  const SocialPostsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.absWeek = const Value.absent(),
    this.postType = const Value.absent(),
    this.displayName = const Value.absent(),
    this.handle = const Value.absent(),
    this.content = const Value.absent(),
    this.avatarEmoji = const Value.absent(),
  });
  SocialPostsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int absWeek,
    required String postType,
    required String displayName,
    required String handle,
    required String content,
    required String avatarEmoji,
  })  : careerId = Value(careerId),
        absWeek = Value(absWeek),
        postType = Value(postType),
        displayName = Value(displayName),
        handle = Value(handle),
        content = Value(content),
        avatarEmoji = Value(avatarEmoji);
  static Insertable<SocialPost> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? absWeek,
    Expression<String>? postType,
    Expression<String>? displayName,
    Expression<String>? handle,
    Expression<String>? content,
    Expression<String>? avatarEmoji,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (absWeek != null) 'abs_week': absWeek,
      if (postType != null) 'post_type': postType,
      if (displayName != null) 'display_name': displayName,
      if (handle != null) 'handle': handle,
      if (content != null) 'content': content,
      if (avatarEmoji != null) 'avatar_emoji': avatarEmoji,
    });
  }

  SocialPostsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<int>? absWeek,
      Value<String>? postType,
      Value<String>? displayName,
      Value<String>? handle,
      Value<String>? content,
      Value<String>? avatarEmoji}) {
    return SocialPostsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      absWeek: absWeek ?? this.absWeek,
      postType: postType ?? this.postType,
      displayName: displayName ?? this.displayName,
      handle: handle ?? this.handle,
      content: content ?? this.content,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (absWeek.present) {
      map['abs_week'] = Variable<int>(absWeek.value);
    }
    if (postType.present) {
      map['post_type'] = Variable<String>(postType.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (handle.present) {
      map['handle'] = Variable<String>(handle.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (avatarEmoji.present) {
      map['avatar_emoji'] = Variable<String>(avatarEmoji.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialPostsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('absWeek: $absWeek, ')
          ..write('postType: $postType, ')
          ..write('displayName: $displayName, ')
          ..write('handle: $handle, ')
          ..write('content: $content, ')
          ..write('avatarEmoji: $avatarEmoji')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _absMonthMeta =
      const VerificationMeta('absMonth');
  @override
  late final GeneratedColumn<int> absMonth = GeneratedColumn<int>(
      'abs_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _displayMonthMeta =
      const VerificationMeta('displayMonth');
  @override
  late final GeneratedColumn<int> displayMonth = GeneratedColumn<int>(
      'display_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, careerId, absMonth, displayMonth, year, category, label, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('abs_month')) {
      context.handle(_absMonthMeta,
          absMonth.isAcceptableOrUnknown(data['abs_month']!, _absMonthMeta));
    } else if (isInserting) {
      context.missing(_absMonthMeta);
    }
    if (data.containsKey('display_month')) {
      context.handle(
          _displayMonthMeta,
          displayMonth.isAcceptableOrUnknown(
              data['display_month']!, _displayMonthMeta));
    } else if (isInserting) {
      context.missing(_displayMonthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      absMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}abs_month'])!,
      displayMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_month'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int careerId;
  final int absMonth;
  final int displayMonth;
  final int year;
  final String category;
  final String label;
  final int amount;
  const Transaction(
      {required this.id,
      required this.careerId,
      required this.absMonth,
      required this.displayMonth,
      required this.year,
      required this.category,
      required this.label,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['abs_month'] = Variable<int>(absMonth);
    map['display_month'] = Variable<int>(displayMonth);
    map['year'] = Variable<int>(year);
    map['category'] = Variable<String>(category);
    map['label'] = Variable<String>(label);
    map['amount'] = Variable<int>(amount);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      absMonth: Value(absMonth),
      displayMonth: Value(displayMonth),
      year: Value(year),
      category: Value(category),
      label: Value(label),
      amount: Value(amount),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      absMonth: serializer.fromJson<int>(json['absMonth']),
      displayMonth: serializer.fromJson<int>(json['displayMonth']),
      year: serializer.fromJson<int>(json['year']),
      category: serializer.fromJson<String>(json['category']),
      label: serializer.fromJson<String>(json['label']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'absMonth': serializer.toJson<int>(absMonth),
      'displayMonth': serializer.toJson<int>(displayMonth),
      'year': serializer.toJson<int>(year),
      'category': serializer.toJson<String>(category),
      'label': serializer.toJson<String>(label),
      'amount': serializer.toJson<int>(amount),
    };
  }

  Transaction copyWith(
          {int? id,
          int? careerId,
          int? absMonth,
          int? displayMonth,
          int? year,
          String? category,
          String? label,
          int? amount}) =>
      Transaction(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        absMonth: absMonth ?? this.absMonth,
        displayMonth: displayMonth ?? this.displayMonth,
        year: year ?? this.year,
        category: category ?? this.category,
        label: label ?? this.label,
        amount: amount ?? this.amount,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      absMonth: data.absMonth.present ? data.absMonth.value : this.absMonth,
      displayMonth: data.displayMonth.present
          ? data.displayMonth.value
          : this.displayMonth,
      year: data.year.present ? data.year.value : this.year,
      category: data.category.present ? data.category.value : this.category,
      label: data.label.present ? data.label.value : this.label,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('absMonth: $absMonth, ')
          ..write('displayMonth: $displayMonth, ')
          ..write('year: $year, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, careerId, absMonth, displayMonth, year, category, label, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.absMonth == this.absMonth &&
          other.displayMonth == this.displayMonth &&
          other.year == this.year &&
          other.category == this.category &&
          other.label == this.label &&
          other.amount == this.amount);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> absMonth;
  final Value<int> displayMonth;
  final Value<int> year;
  final Value<String> category;
  final Value<String> label;
  final Value<int> amount;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.absMonth = const Value.absent(),
    this.displayMonth = const Value.absent(),
    this.year = const Value.absent(),
    this.category = const Value.absent(),
    this.label = const Value.absent(),
    this.amount = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int absMonth,
    required int displayMonth,
    required int year,
    required String category,
    required String label,
    required int amount,
  })  : careerId = Value(careerId),
        absMonth = Value(absMonth),
        displayMonth = Value(displayMonth),
        year = Value(year),
        category = Value(category),
        label = Value(label),
        amount = Value(amount);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? absMonth,
    Expression<int>? displayMonth,
    Expression<int>? year,
    Expression<String>? category,
    Expression<String>? label,
    Expression<int>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (absMonth != null) 'abs_month': absMonth,
      if (displayMonth != null) 'display_month': displayMonth,
      if (year != null) 'year': year,
      if (category != null) 'category': category,
      if (label != null) 'label': label,
      if (amount != null) 'amount': amount,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<int>? absMonth,
      Value<int>? displayMonth,
      Value<int>? year,
      Value<String>? category,
      Value<String>? label,
      Value<int>? amount}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      absMonth: absMonth ?? this.absMonth,
      displayMonth: displayMonth ?? this.displayMonth,
      year: year ?? this.year,
      category: category ?? this.category,
      label: label ?? this.label,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (absMonth.present) {
      map['abs_month'] = Variable<int>(absMonth.value);
    }
    if (displayMonth.present) {
      map['display_month'] = Variable<int>(displayMonth.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('absMonth: $absMonth, ')
          ..write('displayMonth: $displayMonth, ')
          ..write('year: $year, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $CardPacksTable extends CardPacks
    with TableInfo<$CardPacksTable, CardPack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _packNameMeta =
      const VerificationMeta('packName');
  @override
  late final GeneratedColumn<String> packName = GeneratedColumn<String>(
      'pack_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _packTypeMeta =
      const VerificationMeta('packType');
  @override
  late final GeneratedColumn<String> packType = GeneratedColumn<String>(
      'pack_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('basic'));
  static const VerificationMeta _unlockMonthMeta =
      const VerificationMeta('unlockMonth');
  @override
  late final GeneratedColumn<int> unlockMonth = GeneratedColumn<int>(
      'unlock_month', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
      'cost', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _guaranteedRarityMeta =
      const VerificationMeta('guaranteedRarity');
  @override
  late final GeneratedColumn<String> guaranteedRarity = GeneratedColumn<String>(
      'guaranteed_rarity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, packName, packType, unlockMonth, cost, guaranteedRarity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_packs';
  @override
  VerificationContext validateIntegrity(Insertable<CardPack> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pack_name')) {
      context.handle(_packNameMeta,
          packName.isAcceptableOrUnknown(data['pack_name']!, _packNameMeta));
    } else if (isInserting) {
      context.missing(_packNameMeta);
    }
    if (data.containsKey('pack_type')) {
      context.handle(_packTypeMeta,
          packType.isAcceptableOrUnknown(data['pack_type']!, _packTypeMeta));
    }
    if (data.containsKey('unlock_month')) {
      context.handle(
          _unlockMonthMeta,
          unlockMonth.isAcceptableOrUnknown(
              data['unlock_month']!, _unlockMonthMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    }
    if (data.containsKey('guaranteed_rarity')) {
      context.handle(
          _guaranteedRarityMeta,
          guaranteedRarity.isAcceptableOrUnknown(
              data['guaranteed_rarity']!, _guaranteedRarityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardPack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardPack(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      packName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pack_name'])!,
      packType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pack_type'])!,
      unlockMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unlock_month'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost'])!,
      guaranteedRarity: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}guaranteed_rarity']),
    );
  }

  @override
  $CardPacksTable createAlias(String alias) {
    return $CardPacksTable(attachedDatabase, alias);
  }
}

class CardPack extends DataClass implements Insertable<CardPack> {
  final int id;
  final String packName;
  final String packType;
  final int unlockMonth;
  final int cost;
  final String? guaranteedRarity;
  const CardPack(
      {required this.id,
      required this.packName,
      required this.packType,
      required this.unlockMonth,
      required this.cost,
      this.guaranteedRarity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pack_name'] = Variable<String>(packName);
    map['pack_type'] = Variable<String>(packType);
    map['unlock_month'] = Variable<int>(unlockMonth);
    map['cost'] = Variable<int>(cost);
    if (!nullToAbsent || guaranteedRarity != null) {
      map['guaranteed_rarity'] = Variable<String>(guaranteedRarity);
    }
    return map;
  }

  CardPacksCompanion toCompanion(bool nullToAbsent) {
    return CardPacksCompanion(
      id: Value(id),
      packName: Value(packName),
      packType: Value(packType),
      unlockMonth: Value(unlockMonth),
      cost: Value(cost),
      guaranteedRarity: guaranteedRarity == null && nullToAbsent
          ? const Value.absent()
          : Value(guaranteedRarity),
    );
  }

  factory CardPack.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardPack(
      id: serializer.fromJson<int>(json['id']),
      packName: serializer.fromJson<String>(json['packName']),
      packType: serializer.fromJson<String>(json['packType']),
      unlockMonth: serializer.fromJson<int>(json['unlockMonth']),
      cost: serializer.fromJson<int>(json['cost']),
      guaranteedRarity: serializer.fromJson<String?>(json['guaranteedRarity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packName': serializer.toJson<String>(packName),
      'packType': serializer.toJson<String>(packType),
      'unlockMonth': serializer.toJson<int>(unlockMonth),
      'cost': serializer.toJson<int>(cost),
      'guaranteedRarity': serializer.toJson<String?>(guaranteedRarity),
    };
  }

  CardPack copyWith(
          {int? id,
          String? packName,
          String? packType,
          int? unlockMonth,
          int? cost,
          Value<String?> guaranteedRarity = const Value.absent()}) =>
      CardPack(
        id: id ?? this.id,
        packName: packName ?? this.packName,
        packType: packType ?? this.packType,
        unlockMonth: unlockMonth ?? this.unlockMonth,
        cost: cost ?? this.cost,
        guaranteedRarity: guaranteedRarity.present
            ? guaranteedRarity.value
            : this.guaranteedRarity,
      );
  CardPack copyWithCompanion(CardPacksCompanion data) {
    return CardPack(
      id: data.id.present ? data.id.value : this.id,
      packName: data.packName.present ? data.packName.value : this.packName,
      packType: data.packType.present ? data.packType.value : this.packType,
      unlockMonth:
          data.unlockMonth.present ? data.unlockMonth.value : this.unlockMonth,
      cost: data.cost.present ? data.cost.value : this.cost,
      guaranteedRarity: data.guaranteedRarity.present
          ? data.guaranteedRarity.value
          : this.guaranteedRarity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardPack(')
          ..write('id: $id, ')
          ..write('packName: $packName, ')
          ..write('packType: $packType, ')
          ..write('unlockMonth: $unlockMonth, ')
          ..write('cost: $cost, ')
          ..write('guaranteedRarity: $guaranteedRarity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packName, packType, unlockMonth, cost, guaranteedRarity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardPack &&
          other.id == this.id &&
          other.packName == this.packName &&
          other.packType == this.packType &&
          other.unlockMonth == this.unlockMonth &&
          other.cost == this.cost &&
          other.guaranteedRarity == this.guaranteedRarity);
}

class CardPacksCompanion extends UpdateCompanion<CardPack> {
  final Value<int> id;
  final Value<String> packName;
  final Value<String> packType;
  final Value<int> unlockMonth;
  final Value<int> cost;
  final Value<String?> guaranteedRarity;
  const CardPacksCompanion({
    this.id = const Value.absent(),
    this.packName = const Value.absent(),
    this.packType = const Value.absent(),
    this.unlockMonth = const Value.absent(),
    this.cost = const Value.absent(),
    this.guaranteedRarity = const Value.absent(),
  });
  CardPacksCompanion.insert({
    this.id = const Value.absent(),
    required String packName,
    this.packType = const Value.absent(),
    this.unlockMonth = const Value.absent(),
    this.cost = const Value.absent(),
    this.guaranteedRarity = const Value.absent(),
  }) : packName = Value(packName);
  static Insertable<CardPack> custom({
    Expression<int>? id,
    Expression<String>? packName,
    Expression<String>? packType,
    Expression<int>? unlockMonth,
    Expression<int>? cost,
    Expression<String>? guaranteedRarity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packName != null) 'pack_name': packName,
      if (packType != null) 'pack_type': packType,
      if (unlockMonth != null) 'unlock_month': unlockMonth,
      if (cost != null) 'cost': cost,
      if (guaranteedRarity != null) 'guaranteed_rarity': guaranteedRarity,
    });
  }

  CardPacksCompanion copyWith(
      {Value<int>? id,
      Value<String>? packName,
      Value<String>? packType,
      Value<int>? unlockMonth,
      Value<int>? cost,
      Value<String?>? guaranteedRarity}) {
    return CardPacksCompanion(
      id: id ?? this.id,
      packName: packName ?? this.packName,
      packType: packType ?? this.packType,
      unlockMonth: unlockMonth ?? this.unlockMonth,
      cost: cost ?? this.cost,
      guaranteedRarity: guaranteedRarity ?? this.guaranteedRarity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packName.present) {
      map['pack_name'] = Variable<String>(packName.value);
    }
    if (packType.present) {
      map['pack_type'] = Variable<String>(packType.value);
    }
    if (unlockMonth.present) {
      map['unlock_month'] = Variable<int>(unlockMonth.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (guaranteedRarity.present) {
      map['guaranteed_rarity'] = Variable<String>(guaranteedRarity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardPacksCompanion(')
          ..write('id: $id, ')
          ..write('packName: $packName, ')
          ..write('packType: $packType, ')
          ..write('unlockMonth: $unlockMonth, ')
          ..write('cost: $cost, ')
          ..write('guaranteedRarity: $guaranteedRarity')
          ..write(')'))
        .toString();
  }
}

class $PackPoolItemsTable extends PackPoolItems
    with TableInfo<$PackPoolItemsTable, PackPoolItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackPoolItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<int> packId = GeneratedColumn<int>(
      'pack_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES card_packs (id)'));
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
      'character_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES generated_characters (id)'));
  static const VerificationMeta _dropRateMeta =
      const VerificationMeta('dropRate');
  @override
  late final GeneratedColumn<double> dropRate = GeneratedColumn<double>(
      'drop_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, packId, characterId, dropRate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pack_pool_items';
  @override
  VerificationContext validateIntegrity(Insertable<PackPoolItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pack_id')) {
      context.handle(_packIdMeta,
          packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta));
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('drop_rate')) {
      context.handle(_dropRateMeta,
          dropRate.isAcceptableOrUnknown(data['drop_rate']!, _dropRateMeta));
    } else if (isInserting) {
      context.missing(_dropRateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackPoolItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackPoolItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      packId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pack_id'])!,
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}character_id'])!,
      dropRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}drop_rate'])!,
    );
  }

  @override
  $PackPoolItemsTable createAlias(String alias) {
    return $PackPoolItemsTable(attachedDatabase, alias);
  }
}

class PackPoolItem extends DataClass implements Insertable<PackPoolItem> {
  final int id;
  final int packId;
  final int characterId;
  final double dropRate;
  const PackPoolItem(
      {required this.id,
      required this.packId,
      required this.characterId,
      required this.dropRate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pack_id'] = Variable<int>(packId);
    map['character_id'] = Variable<int>(characterId);
    map['drop_rate'] = Variable<double>(dropRate);
    return map;
  }

  PackPoolItemsCompanion toCompanion(bool nullToAbsent) {
    return PackPoolItemsCompanion(
      id: Value(id),
      packId: Value(packId),
      characterId: Value(characterId),
      dropRate: Value(dropRate),
    );
  }

  factory PackPoolItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackPoolItem(
      id: serializer.fromJson<int>(json['id']),
      packId: serializer.fromJson<int>(json['packId']),
      characterId: serializer.fromJson<int>(json['characterId']),
      dropRate: serializer.fromJson<double>(json['dropRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packId': serializer.toJson<int>(packId),
      'characterId': serializer.toJson<int>(characterId),
      'dropRate': serializer.toJson<double>(dropRate),
    };
  }

  PackPoolItem copyWith(
          {int? id, int? packId, int? characterId, double? dropRate}) =>
      PackPoolItem(
        id: id ?? this.id,
        packId: packId ?? this.packId,
        characterId: characterId ?? this.characterId,
        dropRate: dropRate ?? this.dropRate,
      );
  PackPoolItem copyWithCompanion(PackPoolItemsCompanion data) {
    return PackPoolItem(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
      dropRate: data.dropRate.present ? data.dropRate.value : this.dropRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackPoolItem(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('characterId: $characterId, ')
          ..write('dropRate: $dropRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, characterId, dropRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackPoolItem &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.characterId == this.characterId &&
          other.dropRate == this.dropRate);
}

class PackPoolItemsCompanion extends UpdateCompanion<PackPoolItem> {
  final Value<int> id;
  final Value<int> packId;
  final Value<int> characterId;
  final Value<double> dropRate;
  const PackPoolItemsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.dropRate = const Value.absent(),
  });
  PackPoolItemsCompanion.insert({
    this.id = const Value.absent(),
    required int packId,
    required int characterId,
    required double dropRate,
  })  : packId = Value(packId),
        characterId = Value(characterId),
        dropRate = Value(dropRate);
  static Insertable<PackPoolItem> custom({
    Expression<int>? id,
    Expression<int>? packId,
    Expression<int>? characterId,
    Expression<double>? dropRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (characterId != null) 'character_id': characterId,
      if (dropRate != null) 'drop_rate': dropRate,
    });
  }

  PackPoolItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? packId,
      Value<int>? characterId,
      Value<double>? dropRate}) {
    return PackPoolItemsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      characterId: characterId ?? this.characterId,
      dropRate: dropRate ?? this.dropRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<int>(packId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (dropRate.present) {
      map['drop_rate'] = Variable<double>(dropRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackPoolItemsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('characterId: $characterId, ')
          ..write('dropRate: $dropRate')
          ..write(')'))
        .toString();
  }
}

class $CoachesTable extends Coaches with TableInfo<$CoachesTable, Coach> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _disciplineMeta =
      const VerificationMeta('discipline');
  @override
  late final GeneratedColumn<String> discipline = GeneratedColumn<String>(
      'discipline', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qualityMeta =
      const VerificationMeta('quality');
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
      'quality', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthlySalaryMeta =
      const VerificationMeta('monthlySalary');
  @override
  late final GeneratedColumn<int> monthlySalary = GeneratedColumn<int>(
      'monthly_salary', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isHiredMeta =
      const VerificationMeta('isHired');
  @override
  late final GeneratedColumn<bool> isHired = GeneratedColumn<bool>(
      'is_hired', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_hired" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, careerId, name, discipline, quality, monthlySalary, isHired];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coaches';
  @override
  VerificationContext validateIntegrity(Insertable<Coach> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('discipline')) {
      context.handle(
          _disciplineMeta,
          discipline.isAcceptableOrUnknown(
              data['discipline']!, _disciplineMeta));
    } else if (isInserting) {
      context.missing(_disciplineMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(_qualityMeta,
          quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta));
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('monthly_salary')) {
      context.handle(
          _monthlySalaryMeta,
          monthlySalary.isAcceptableOrUnknown(
              data['monthly_salary']!, _monthlySalaryMeta));
    } else if (isInserting) {
      context.missing(_monthlySalaryMeta);
    }
    if (data.containsKey('is_hired')) {
      context.handle(_isHiredMeta,
          isHired.isAcceptableOrUnknown(data['is_hired']!, _isHiredMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Coach map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Coach(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      discipline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discipline'])!,
      quality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quality'])!,
      monthlySalary: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}monthly_salary'])!,
      isHired: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_hired'])!,
    );
  }

  @override
  $CoachesTable createAlias(String alias) {
    return $CoachesTable(attachedDatabase, alias);
  }
}

class Coach extends DataClass implements Insertable<Coach> {
  final int id;
  final int careerId;
  final String name;
  final String discipline;
  final int quality;
  final int monthlySalary;
  final bool isHired;
  const Coach(
      {required this.id,
      required this.careerId,
      required this.name,
      required this.discipline,
      required this.quality,
      required this.monthlySalary,
      required this.isHired});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['name'] = Variable<String>(name);
    map['discipline'] = Variable<String>(discipline);
    map['quality'] = Variable<int>(quality);
    map['monthly_salary'] = Variable<int>(monthlySalary);
    map['is_hired'] = Variable<bool>(isHired);
    return map;
  }

  CoachesCompanion toCompanion(bool nullToAbsent) {
    return CoachesCompanion(
      id: Value(id),
      careerId: Value(careerId),
      name: Value(name),
      discipline: Value(discipline),
      quality: Value(quality),
      monthlySalary: Value(monthlySalary),
      isHired: Value(isHired),
    );
  }

  factory Coach.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Coach(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      name: serializer.fromJson<String>(json['name']),
      discipline: serializer.fromJson<String>(json['discipline']),
      quality: serializer.fromJson<int>(json['quality']),
      monthlySalary: serializer.fromJson<int>(json['monthlySalary']),
      isHired: serializer.fromJson<bool>(json['isHired']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'name': serializer.toJson<String>(name),
      'discipline': serializer.toJson<String>(discipline),
      'quality': serializer.toJson<int>(quality),
      'monthlySalary': serializer.toJson<int>(monthlySalary),
      'isHired': serializer.toJson<bool>(isHired),
    };
  }

  Coach copyWith(
          {int? id,
          int? careerId,
          String? name,
          String? discipline,
          int? quality,
          int? monthlySalary,
          bool? isHired}) =>
      Coach(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        name: name ?? this.name,
        discipline: discipline ?? this.discipline,
        quality: quality ?? this.quality,
        monthlySalary: monthlySalary ?? this.monthlySalary,
        isHired: isHired ?? this.isHired,
      );
  Coach copyWithCompanion(CoachesCompanion data) {
    return Coach(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      name: data.name.present ? data.name.value : this.name,
      discipline:
          data.discipline.present ? data.discipline.value : this.discipline,
      quality: data.quality.present ? data.quality.value : this.quality,
      monthlySalary: data.monthlySalary.present
          ? data.monthlySalary.value
          : this.monthlySalary,
      isHired: data.isHired.present ? data.isHired.value : this.isHired,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Coach(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('name: $name, ')
          ..write('discipline: $discipline, ')
          ..write('quality: $quality, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('isHired: $isHired')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, careerId, name, discipline, quality, monthlySalary, isHired);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coach &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.name == this.name &&
          other.discipline == this.discipline &&
          other.quality == this.quality &&
          other.monthlySalary == this.monthlySalary &&
          other.isHired == this.isHired);
}

class CoachesCompanion extends UpdateCompanion<Coach> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<String> name;
  final Value<String> discipline;
  final Value<int> quality;
  final Value<int> monthlySalary;
  final Value<bool> isHired;
  const CoachesCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.name = const Value.absent(),
    this.discipline = const Value.absent(),
    this.quality = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.isHired = const Value.absent(),
  });
  CoachesCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required String name,
    required String discipline,
    required int quality,
    required int monthlySalary,
    this.isHired = const Value.absent(),
  })  : careerId = Value(careerId),
        name = Value(name),
        discipline = Value(discipline),
        quality = Value(quality),
        monthlySalary = Value(monthlySalary);
  static Insertable<Coach> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<String>? name,
    Expression<String>? discipline,
    Expression<int>? quality,
    Expression<int>? monthlySalary,
    Expression<bool>? isHired,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (name != null) 'name': name,
      if (discipline != null) 'discipline': discipline,
      if (quality != null) 'quality': quality,
      if (monthlySalary != null) 'monthly_salary': monthlySalary,
      if (isHired != null) 'is_hired': isHired,
    });
  }

  CoachesCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<String>? name,
      Value<String>? discipline,
      Value<int>? quality,
      Value<int>? monthlySalary,
      Value<bool>? isHired}) {
    return CoachesCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      name: name ?? this.name,
      discipline: discipline ?? this.discipline,
      quality: quality ?? this.quality,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      isHired: isHired ?? this.isHired,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (discipline.present) {
      map['discipline'] = Variable<String>(discipline.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (monthlySalary.present) {
      map['monthly_salary'] = Variable<int>(monthlySalary.value);
    }
    if (isHired.present) {
      map['is_hired'] = Variable<bool>(isHired.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoachesCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('name: $name, ')
          ..write('discipline: $discipline, ')
          ..write('quality: $quality, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('isHired: $isHired')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _monthOccurredMeta =
      const VerificationMeta('monthOccurred');
  @override
  late final GeneratedColumn<int> monthOccurred = GeneratedColumn<int>(
      'month_occurred', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _impactValueMeta =
      const VerificationMeta('impactValue');
  @override
  late final GeneratedColumn<int> impactValue = GeneratedColumn<int>(
      'impact_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _requiresDecisionMeta =
      const VerificationMeta('requiresDecision');
  @override
  late final GeneratedColumn<bool> requiresDecision = GeneratedColumn<bool>(
      'requires_decision', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_decision" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _resolvedMeta =
      const VerificationMeta('resolved');
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
      'resolved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("resolved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _resolutionChoiceMeta =
      const VerificationMeta('resolutionChoice');
  @override
  late final GeneratedColumn<String> resolutionChoice = GeneratedColumn<String>(
      'resolution_choice', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resolutionOutcomeMeta =
      const VerificationMeta('resolutionOutcome');
  @override
  late final GeneratedColumn<String> resolutionOutcome =
      GeneratedColumn<String>('resolution_outcome', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerId,
        groupId,
        eventType,
        category,
        title,
        description,
        monthOccurred,
        impactValue,
        requiresDecision,
        resolved,
        resolutionChoice,
        resolutionOutcome
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('month_occurred')) {
      context.handle(
          _monthOccurredMeta,
          monthOccurred.isAcceptableOrUnknown(
              data['month_occurred']!, _monthOccurredMeta));
    } else if (isInserting) {
      context.missing(_monthOccurredMeta);
    }
    if (data.containsKey('impact_value')) {
      context.handle(
          _impactValueMeta,
          impactValue.isAcceptableOrUnknown(
              data['impact_value']!, _impactValueMeta));
    }
    if (data.containsKey('requires_decision')) {
      context.handle(
          _requiresDecisionMeta,
          requiresDecision.isAcceptableOrUnknown(
              data['requires_decision']!, _requiresDecisionMeta));
    }
    if (data.containsKey('resolved')) {
      context.handle(_resolvedMeta,
          resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta));
    }
    if (data.containsKey('resolution_choice')) {
      context.handle(
          _resolutionChoiceMeta,
          resolutionChoice.isAcceptableOrUnknown(
              data['resolution_choice']!, _resolutionChoiceMeta));
    }
    if (data.containsKey('resolution_outcome')) {
      context.handle(
          _resolutionOutcomeMeta,
          resolutionOutcome.isAcceptableOrUnknown(
              data['resolution_outcome']!, _resolutionOutcomeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id']),
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      monthOccurred: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month_occurred'])!,
      impactValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}impact_value'])!,
      requiresDecision: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}requires_decision'])!,
      resolved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}resolved'])!,
      resolutionChoice: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}resolution_choice']),
      resolutionOutcome: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}resolution_outcome']),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final int careerId;
  final int? groupId;
  final String eventType;
  final String category;
  final String title;
  final String? description;
  final int monthOccurred;
  final int impactValue;
  final bool requiresDecision;
  final bool resolved;
  final String? resolutionChoice;
  final String? resolutionOutcome;
  const Event(
      {required this.id,
      required this.careerId,
      this.groupId,
      required this.eventType,
      required this.category,
      required this.title,
      this.description,
      required this.monthOccurred,
      required this.impactValue,
      required this.requiresDecision,
      required this.resolved,
      this.resolutionChoice,
      this.resolutionOutcome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    map['event_type'] = Variable<String>(eventType);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['month_occurred'] = Variable<int>(monthOccurred);
    map['impact_value'] = Variable<int>(impactValue);
    map['requires_decision'] = Variable<bool>(requiresDecision);
    map['resolved'] = Variable<bool>(resolved);
    if (!nullToAbsent || resolutionChoice != null) {
      map['resolution_choice'] = Variable<String>(resolutionChoice);
    }
    if (!nullToAbsent || resolutionOutcome != null) {
      map['resolution_outcome'] = Variable<String>(resolutionOutcome);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      eventType: Value(eventType),
      category: Value(category),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      monthOccurred: Value(monthOccurred),
      impactValue: Value(impactValue),
      requiresDecision: Value(requiresDecision),
      resolved: Value(resolved),
      resolutionChoice: resolutionChoice == null && nullToAbsent
          ? const Value.absent()
          : Value(resolutionChoice),
      resolutionOutcome: resolutionOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(resolutionOutcome),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      monthOccurred: serializer.fromJson<int>(json['monthOccurred']),
      impactValue: serializer.fromJson<int>(json['impactValue']),
      requiresDecision: serializer.fromJson<bool>(json['requiresDecision']),
      resolved: serializer.fromJson<bool>(json['resolved']),
      resolutionChoice: serializer.fromJson<String?>(json['resolutionChoice']),
      resolutionOutcome:
          serializer.fromJson<String?>(json['resolutionOutcome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'groupId': serializer.toJson<int?>(groupId),
      'eventType': serializer.toJson<String>(eventType),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'monthOccurred': serializer.toJson<int>(monthOccurred),
      'impactValue': serializer.toJson<int>(impactValue),
      'requiresDecision': serializer.toJson<bool>(requiresDecision),
      'resolved': serializer.toJson<bool>(resolved),
      'resolutionChoice': serializer.toJson<String?>(resolutionChoice),
      'resolutionOutcome': serializer.toJson<String?>(resolutionOutcome),
    };
  }

  Event copyWith(
          {int? id,
          int? careerId,
          Value<int?> groupId = const Value.absent(),
          String? eventType,
          String? category,
          String? title,
          Value<String?> description = const Value.absent(),
          int? monthOccurred,
          int? impactValue,
          bool? requiresDecision,
          bool? resolved,
          Value<String?> resolutionChoice = const Value.absent(),
          Value<String?> resolutionOutcome = const Value.absent()}) =>
      Event(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        groupId: groupId.present ? groupId.value : this.groupId,
        eventType: eventType ?? this.eventType,
        category: category ?? this.category,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        monthOccurred: monthOccurred ?? this.monthOccurred,
        impactValue: impactValue ?? this.impactValue,
        requiresDecision: requiresDecision ?? this.requiresDecision,
        resolved: resolved ?? this.resolved,
        resolutionChoice: resolutionChoice.present
            ? resolutionChoice.value
            : this.resolutionChoice,
        resolutionOutcome: resolutionOutcome.present
            ? resolutionOutcome.value
            : this.resolutionOutcome,
      );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      monthOccurred: data.monthOccurred.present
          ? data.monthOccurred.value
          : this.monthOccurred,
      impactValue:
          data.impactValue.present ? data.impactValue.value : this.impactValue,
      requiresDecision: data.requiresDecision.present
          ? data.requiresDecision.value
          : this.requiresDecision,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
      resolutionChoice: data.resolutionChoice.present
          ? data.resolutionChoice.value
          : this.resolutionChoice,
      resolutionOutcome: data.resolutionOutcome.present
          ? data.resolutionOutcome.value
          : this.resolutionOutcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('groupId: $groupId, ')
          ..write('eventType: $eventType, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('monthOccurred: $monthOccurred, ')
          ..write('impactValue: $impactValue, ')
          ..write('requiresDecision: $requiresDecision, ')
          ..write('resolved: $resolved, ')
          ..write('resolutionChoice: $resolutionChoice, ')
          ..write('resolutionOutcome: $resolutionOutcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      careerId,
      groupId,
      eventType,
      category,
      title,
      description,
      monthOccurred,
      impactValue,
      requiresDecision,
      resolved,
      resolutionChoice,
      resolutionOutcome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.groupId == this.groupId &&
          other.eventType == this.eventType &&
          other.category == this.category &&
          other.title == this.title &&
          other.description == this.description &&
          other.monthOccurred == this.monthOccurred &&
          other.impactValue == this.impactValue &&
          other.requiresDecision == this.requiresDecision &&
          other.resolved == this.resolved &&
          other.resolutionChoice == this.resolutionChoice &&
          other.resolutionOutcome == this.resolutionOutcome);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int?> groupId;
  final Value<String> eventType;
  final Value<String> category;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> monthOccurred;
  final Value<int> impactValue;
  final Value<bool> requiresDecision;
  final Value<bool> resolved;
  final Value<String?> resolutionChoice;
  final Value<String?> resolutionOutcome;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.monthOccurred = const Value.absent(),
    this.impactValue = const Value.absent(),
    this.requiresDecision = const Value.absent(),
    this.resolved = const Value.absent(),
    this.resolutionChoice = const Value.absent(),
    this.resolutionOutcome = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    this.groupId = const Value.absent(),
    required String eventType,
    this.category = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required int monthOccurred,
    this.impactValue = const Value.absent(),
    this.requiresDecision = const Value.absent(),
    this.resolved = const Value.absent(),
    this.resolutionChoice = const Value.absent(),
    this.resolutionOutcome = const Value.absent(),
  })  : careerId = Value(careerId),
        eventType = Value(eventType),
        title = Value(title),
        monthOccurred = Value(monthOccurred);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? groupId,
    Expression<String>? eventType,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? monthOccurred,
    Expression<int>? impactValue,
    Expression<bool>? requiresDecision,
    Expression<bool>? resolved,
    Expression<String>? resolutionChoice,
    Expression<String>? resolutionOutcome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (groupId != null) 'group_id': groupId,
      if (eventType != null) 'event_type': eventType,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (monthOccurred != null) 'month_occurred': monthOccurred,
      if (impactValue != null) 'impact_value': impactValue,
      if (requiresDecision != null) 'requires_decision': requiresDecision,
      if (resolved != null) 'resolved': resolved,
      if (resolutionChoice != null) 'resolution_choice': resolutionChoice,
      if (resolutionOutcome != null) 'resolution_outcome': resolutionOutcome,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<int?>? groupId,
      Value<String>? eventType,
      Value<String>? category,
      Value<String>? title,
      Value<String?>? description,
      Value<int>? monthOccurred,
      Value<int>? impactValue,
      Value<bool>? requiresDecision,
      Value<bool>? resolved,
      Value<String?>? resolutionChoice,
      Value<String?>? resolutionOutcome}) {
    return EventsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      groupId: groupId ?? this.groupId,
      eventType: eventType ?? this.eventType,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      monthOccurred: monthOccurred ?? this.monthOccurred,
      impactValue: impactValue ?? this.impactValue,
      requiresDecision: requiresDecision ?? this.requiresDecision,
      resolved: resolved ?? this.resolved,
      resolutionChoice: resolutionChoice ?? this.resolutionChoice,
      resolutionOutcome: resolutionOutcome ?? this.resolutionOutcome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (monthOccurred.present) {
      map['month_occurred'] = Variable<int>(monthOccurred.value);
    }
    if (impactValue.present) {
      map['impact_value'] = Variable<int>(impactValue.value);
    }
    if (requiresDecision.present) {
      map['requires_decision'] = Variable<bool>(requiresDecision.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (resolutionChoice.present) {
      map['resolution_choice'] = Variable<String>(resolutionChoice.value);
    }
    if (resolutionOutcome.present) {
      map['resolution_outcome'] = Variable<String>(resolutionOutcome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('groupId: $groupId, ')
          ..write('eventType: $eventType, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('monthOccurred: $monthOccurred, ')
          ..write('impactValue: $impactValue, ')
          ..write('requiresDecision: $requiresDecision, ')
          ..write('resolved: $resolved, ')
          ..write('resolutionChoice: $resolutionChoice, ')
          ..write('resolutionOutcome: $resolutionOutcome')
          ..write(')'))
        .toString();
  }
}

class $EventAffectedIdolsTable extends EventAffectedIdols
    with TableInfo<$EventAffectedIdolsTable, EventAffectedIdol> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventAffectedIdolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
      'event_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES events (id)'));
  static const VerificationMeta _idolIdMeta = const VerificationMeta('idolId');
  @override
  late final GeneratedColumn<int> idolId = GeneratedColumn<int>(
      'idol_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_idols (id)'));
  static const VerificationMeta _effectDetailMeta =
      const VerificationMeta('effectDetail');
  @override
  late final GeneratedColumn<String> effectDetail = GeneratedColumn<String>(
      'effect_detail', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, eventId, idolId, effectDetail];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_affected_idols';
  @override
  VerificationContext validateIntegrity(Insertable<EventAffectedIdol> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('idol_id')) {
      context.handle(_idolIdMeta,
          idolId.isAcceptableOrUnknown(data['idol_id']!, _idolIdMeta));
    } else if (isInserting) {
      context.missing(_idolIdMeta);
    }
    if (data.containsKey('effect_detail')) {
      context.handle(
          _effectDetailMeta,
          effectDetail.isAcceptableOrUnknown(
              data['effect_detail']!, _effectDetailMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventAffectedIdol map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventAffectedIdol(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}event_id'])!,
      idolId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idol_id'])!,
      effectDetail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}effect_detail']),
    );
  }

  @override
  $EventAffectedIdolsTable createAlias(String alias) {
    return $EventAffectedIdolsTable(attachedDatabase, alias);
  }
}

class EventAffectedIdol extends DataClass
    implements Insertable<EventAffectedIdol> {
  final int id;
  final int eventId;
  final int idolId;
  final String? effectDetail;
  const EventAffectedIdol(
      {required this.id,
      required this.eventId,
      required this.idolId,
      this.effectDetail});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['idol_id'] = Variable<int>(idolId);
    if (!nullToAbsent || effectDetail != null) {
      map['effect_detail'] = Variable<String>(effectDetail);
    }
    return map;
  }

  EventAffectedIdolsCompanion toCompanion(bool nullToAbsent) {
    return EventAffectedIdolsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      idolId: Value(idolId),
      effectDetail: effectDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(effectDetail),
    );
  }

  factory EventAffectedIdol.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventAffectedIdol(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      idolId: serializer.fromJson<int>(json['idolId']),
      effectDetail: serializer.fromJson<String?>(json['effectDetail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'idolId': serializer.toJson<int>(idolId),
      'effectDetail': serializer.toJson<String?>(effectDetail),
    };
  }

  EventAffectedIdol copyWith(
          {int? id,
          int? eventId,
          int? idolId,
          Value<String?> effectDetail = const Value.absent()}) =>
      EventAffectedIdol(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        idolId: idolId ?? this.idolId,
        effectDetail:
            effectDetail.present ? effectDetail.value : this.effectDetail,
      );
  EventAffectedIdol copyWithCompanion(EventAffectedIdolsCompanion data) {
    return EventAffectedIdol(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      idolId: data.idolId.present ? data.idolId.value : this.idolId,
      effectDetail: data.effectDetail.present
          ? data.effectDetail.value
          : this.effectDetail,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventAffectedIdol(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('idolId: $idolId, ')
          ..write('effectDetail: $effectDetail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, idolId, effectDetail);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventAffectedIdol &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.idolId == this.idolId &&
          other.effectDetail == this.effectDetail);
}

class EventAffectedIdolsCompanion extends UpdateCompanion<EventAffectedIdol> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<int> idolId;
  final Value<String?> effectDetail;
  const EventAffectedIdolsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.idolId = const Value.absent(),
    this.effectDetail = const Value.absent(),
  });
  EventAffectedIdolsCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required int idolId,
    this.effectDetail = const Value.absent(),
  })  : eventId = Value(eventId),
        idolId = Value(idolId);
  static Insertable<EventAffectedIdol> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<int>? idolId,
    Expression<String>? effectDetail,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (idolId != null) 'idol_id': idolId,
      if (effectDetail != null) 'effect_detail': effectDetail,
    });
  }

  EventAffectedIdolsCompanion copyWith(
      {Value<int>? id,
      Value<int>? eventId,
      Value<int>? idolId,
      Value<String?>? effectDetail}) {
    return EventAffectedIdolsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      idolId: idolId ?? this.idolId,
      effectDetail: effectDetail ?? this.effectDetail,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (idolId.present) {
      map['idol_id'] = Variable<int>(idolId.value);
    }
    if (effectDetail.present) {
      map['effect_detail'] = Variable<String>(effectDetail.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventAffectedIdolsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('idolId: $idolId, ')
          ..write('effectDetail: $effectDetail')
          ..write(')'))
        .toString();
  }
}

class $RivalsTable extends Rivals with TableInfo<$RivalsTable, Rival> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RivalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rivalNameMeta =
      const VerificationMeta('rivalName');
  @override
  late final GeneratedColumn<String> rivalName = GeneratedColumn<String>(
      'rival_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _memberCountMeta =
      const VerificationMeta('memberCount');
  @override
  late final GeneratedColumn<int> memberCount = GeneratedColumn<int>(
      'member_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, rivalName, description, memberCount, logoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rivals';
  @override
  VerificationContext validateIntegrity(Insertable<Rival> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rival_name')) {
      context.handle(_rivalNameMeta,
          rivalName.isAcceptableOrUnknown(data['rival_name']!, _rivalNameMeta));
    } else if (isInserting) {
      context.missing(_rivalNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('member_count')) {
      context.handle(
          _memberCountMeta,
          memberCount.isAcceptableOrUnknown(
              data['member_count']!, _memberCountMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rival map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rival(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      rivalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rival_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      memberCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member_count'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
    );
  }

  @override
  $RivalsTable createAlias(String alias) {
    return $RivalsTable(attachedDatabase, alias);
  }
}

class Rival extends DataClass implements Insertable<Rival> {
  final int id;
  final String rivalName;
  final String? description;
  final int memberCount;
  final String? logoPath;
  const Rival(
      {required this.id,
      required this.rivalName,
      this.description,
      required this.memberCount,
      this.logoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rival_name'] = Variable<String>(rivalName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['member_count'] = Variable<int>(memberCount);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    return map;
  }

  RivalsCompanion toCompanion(bool nullToAbsent) {
    return RivalsCompanion(
      id: Value(id),
      rivalName: Value(rivalName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      memberCount: Value(memberCount),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
    );
  }

  factory Rival.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rival(
      id: serializer.fromJson<int>(json['id']),
      rivalName: serializer.fromJson<String>(json['rivalName']),
      description: serializer.fromJson<String?>(json['description']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rivalName': serializer.toJson<String>(rivalName),
      'description': serializer.toJson<String?>(description),
      'memberCount': serializer.toJson<int>(memberCount),
      'logoPath': serializer.toJson<String?>(logoPath),
    };
  }

  Rival copyWith(
          {int? id,
          String? rivalName,
          Value<String?> description = const Value.absent(),
          int? memberCount,
          Value<String?> logoPath = const Value.absent()}) =>
      Rival(
        id: id ?? this.id,
        rivalName: rivalName ?? this.rivalName,
        description: description.present ? description.value : this.description,
        memberCount: memberCount ?? this.memberCount,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
      );
  Rival copyWithCompanion(RivalsCompanion data) {
    return Rival(
      id: data.id.present ? data.id.value : this.id,
      rivalName: data.rivalName.present ? data.rivalName.value : this.rivalName,
      description:
          data.description.present ? data.description.value : this.description,
      memberCount:
          data.memberCount.present ? data.memberCount.value : this.memberCount,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rival(')
          ..write('id: $id, ')
          ..write('rivalName: $rivalName, ')
          ..write('description: $description, ')
          ..write('memberCount: $memberCount, ')
          ..write('logoPath: $logoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, rivalName, description, memberCount, logoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rival &&
          other.id == this.id &&
          other.rivalName == this.rivalName &&
          other.description == this.description &&
          other.memberCount == this.memberCount &&
          other.logoPath == this.logoPath);
}

class RivalsCompanion extends UpdateCompanion<Rival> {
  final Value<int> id;
  final Value<String> rivalName;
  final Value<String?> description;
  final Value<int> memberCount;
  final Value<String?> logoPath;
  const RivalsCompanion({
    this.id = const Value.absent(),
    this.rivalName = const Value.absent(),
    this.description = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.logoPath = const Value.absent(),
  });
  RivalsCompanion.insert({
    this.id = const Value.absent(),
    required String rivalName,
    this.description = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.logoPath = const Value.absent(),
  }) : rivalName = Value(rivalName);
  static Insertable<Rival> custom({
    Expression<int>? id,
    Expression<String>? rivalName,
    Expression<String>? description,
    Expression<int>? memberCount,
    Expression<String>? logoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rivalName != null) 'rival_name': rivalName,
      if (description != null) 'description': description,
      if (memberCount != null) 'member_count': memberCount,
      if (logoPath != null) 'logo_path': logoPath,
    });
  }

  RivalsCompanion copyWith(
      {Value<int>? id,
      Value<String>? rivalName,
      Value<String?>? description,
      Value<int>? memberCount,
      Value<String?>? logoPath}) {
    return RivalsCompanion(
      id: id ?? this.id,
      rivalName: rivalName ?? this.rivalName,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      logoPath: logoPath ?? this.logoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rivalName.present) {
      map['rival_name'] = Variable<String>(rivalName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RivalsCompanion(')
          ..write('id: $id, ')
          ..write('rivalName: $rivalName, ')
          ..write('description: $description, ')
          ..write('memberCount: $memberCount, ')
          ..write('logoPath: $logoPath')
          ..write(')'))
        .toString();
  }
}

class $RivalMilestonesTable extends RivalMilestones
    with TableInfo<$RivalMilestonesTable, RivalMilestone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RivalMilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rivalIdMeta =
      const VerificationMeta('rivalId');
  @override
  late final GeneratedColumn<int> rivalId = GeneratedColumn<int>(
      'rival_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES rivals (id)'));
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _popularityValueMeta =
      const VerificationMeta('popularityValue');
  @override
  late final GeneratedColumn<int> popularityValue = GeneratedColumn<int>(
      'popularity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _milestoneDescriptionMeta =
      const VerificationMeta('milestoneDescription');
  @override
  late final GeneratedColumn<String> milestoneDescription =
      GeneratedColumn<String>('milestone_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, rivalId, month, popularityValue, milestoneDescription];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rival_milestones';
  @override
  VerificationContext validateIntegrity(Insertable<RivalMilestone> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rival_id')) {
      context.handle(_rivalIdMeta,
          rivalId.isAcceptableOrUnknown(data['rival_id']!, _rivalIdMeta));
    } else if (isInserting) {
      context.missing(_rivalIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('popularity_value')) {
      context.handle(
          _popularityValueMeta,
          popularityValue.isAcceptableOrUnknown(
              data['popularity_value']!, _popularityValueMeta));
    } else if (isInserting) {
      context.missing(_popularityValueMeta);
    }
    if (data.containsKey('milestone_description')) {
      context.handle(
          _milestoneDescriptionMeta,
          milestoneDescription.isAcceptableOrUnknown(
              data['milestone_description']!, _milestoneDescriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RivalMilestone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RivalMilestone(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      rivalId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rival_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      popularityValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}popularity_value'])!,
      milestoneDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}milestone_description']),
    );
  }

  @override
  $RivalMilestonesTable createAlias(String alias) {
    return $RivalMilestonesTable(attachedDatabase, alias);
  }
}

class RivalMilestone extends DataClass implements Insertable<RivalMilestone> {
  final int id;
  final int rivalId;
  final int month;
  final int popularityValue;
  final String? milestoneDescription;
  const RivalMilestone(
      {required this.id,
      required this.rivalId,
      required this.month,
      required this.popularityValue,
      this.milestoneDescription});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rival_id'] = Variable<int>(rivalId);
    map['month'] = Variable<int>(month);
    map['popularity_value'] = Variable<int>(popularityValue);
    if (!nullToAbsent || milestoneDescription != null) {
      map['milestone_description'] = Variable<String>(milestoneDescription);
    }
    return map;
  }

  RivalMilestonesCompanion toCompanion(bool nullToAbsent) {
    return RivalMilestonesCompanion(
      id: Value(id),
      rivalId: Value(rivalId),
      month: Value(month),
      popularityValue: Value(popularityValue),
      milestoneDescription: milestoneDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(milestoneDescription),
    );
  }

  factory RivalMilestone.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RivalMilestone(
      id: serializer.fromJson<int>(json['id']),
      rivalId: serializer.fromJson<int>(json['rivalId']),
      month: serializer.fromJson<int>(json['month']),
      popularityValue: serializer.fromJson<int>(json['popularityValue']),
      milestoneDescription:
          serializer.fromJson<String?>(json['milestoneDescription']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rivalId': serializer.toJson<int>(rivalId),
      'month': serializer.toJson<int>(month),
      'popularityValue': serializer.toJson<int>(popularityValue),
      'milestoneDescription': serializer.toJson<String?>(milestoneDescription),
    };
  }

  RivalMilestone copyWith(
          {int? id,
          int? rivalId,
          int? month,
          int? popularityValue,
          Value<String?> milestoneDescription = const Value.absent()}) =>
      RivalMilestone(
        id: id ?? this.id,
        rivalId: rivalId ?? this.rivalId,
        month: month ?? this.month,
        popularityValue: popularityValue ?? this.popularityValue,
        milestoneDescription: milestoneDescription.present
            ? milestoneDescription.value
            : this.milestoneDescription,
      );
  RivalMilestone copyWithCompanion(RivalMilestonesCompanion data) {
    return RivalMilestone(
      id: data.id.present ? data.id.value : this.id,
      rivalId: data.rivalId.present ? data.rivalId.value : this.rivalId,
      month: data.month.present ? data.month.value : this.month,
      popularityValue: data.popularityValue.present
          ? data.popularityValue.value
          : this.popularityValue,
      milestoneDescription: data.milestoneDescription.present
          ? data.milestoneDescription.value
          : this.milestoneDescription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RivalMilestone(')
          ..write('id: $id, ')
          ..write('rivalId: $rivalId, ')
          ..write('month: $month, ')
          ..write('popularityValue: $popularityValue, ')
          ..write('milestoneDescription: $milestoneDescription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, rivalId, month, popularityValue, milestoneDescription);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RivalMilestone &&
          other.id == this.id &&
          other.rivalId == this.rivalId &&
          other.month == this.month &&
          other.popularityValue == this.popularityValue &&
          other.milestoneDescription == this.milestoneDescription);
}

class RivalMilestonesCompanion extends UpdateCompanion<RivalMilestone> {
  final Value<int> id;
  final Value<int> rivalId;
  final Value<int> month;
  final Value<int> popularityValue;
  final Value<String?> milestoneDescription;
  const RivalMilestonesCompanion({
    this.id = const Value.absent(),
    this.rivalId = const Value.absent(),
    this.month = const Value.absent(),
    this.popularityValue = const Value.absent(),
    this.milestoneDescription = const Value.absent(),
  });
  RivalMilestonesCompanion.insert({
    this.id = const Value.absent(),
    required int rivalId,
    required int month,
    required int popularityValue,
    this.milestoneDescription = const Value.absent(),
  })  : rivalId = Value(rivalId),
        month = Value(month),
        popularityValue = Value(popularityValue);
  static Insertable<RivalMilestone> custom({
    Expression<int>? id,
    Expression<int>? rivalId,
    Expression<int>? month,
    Expression<int>? popularityValue,
    Expression<String>? milestoneDescription,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rivalId != null) 'rival_id': rivalId,
      if (month != null) 'month': month,
      if (popularityValue != null) 'popularity_value': popularityValue,
      if (milestoneDescription != null)
        'milestone_description': milestoneDescription,
    });
  }

  RivalMilestonesCompanion copyWith(
      {Value<int>? id,
      Value<int>? rivalId,
      Value<int>? month,
      Value<int>? popularityValue,
      Value<String?>? milestoneDescription}) {
    return RivalMilestonesCompanion(
      id: id ?? this.id,
      rivalId: rivalId ?? this.rivalId,
      month: month ?? this.month,
      popularityValue: popularityValue ?? this.popularityValue,
      milestoneDescription: milestoneDescription ?? this.milestoneDescription,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rivalId.present) {
      map['rival_id'] = Variable<int>(rivalId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (popularityValue.present) {
      map['popularity_value'] = Variable<int>(popularityValue.value);
    }
    if (milestoneDescription.present) {
      map['milestone_description'] =
          Variable<String>(milestoneDescription.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RivalMilestonesCompanion(')
          ..write('id: $id, ')
          ..write('rivalId: $rivalId, ')
          ..write('month: $month, ')
          ..write('popularityValue: $popularityValue, ')
          ..write('milestoneDescription: $milestoneDescription')
          ..write(')'))
        .toString();
  }
}

class $MonthlyStatsTable extends MonthlyStats
    with TableInfo<$MonthlyStatsTable, MonthlyStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careerIdMeta =
      const VerificationMeta('careerId');
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
      'career_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_careers (id)'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _popularityScoreMeta =
      const VerificationMeta('popularityScore');
  @override
  late final GeneratedColumn<int> popularityScore = GeneratedColumn<int>(
      'popularity_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fanbaseSizeMeta =
      const VerificationMeta('fanbaseSize');
  @override
  late final GeneratedColumn<int> fanbaseSize = GeneratedColumn<int>(
      'fanbase_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avgChemistryMeta =
      const VerificationMeta('avgChemistry');
  @override
  late final GeneratedColumn<int> avgChemistry = GeneratedColumn<int>(
      'avg_chemistry', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _avgMoodMeta =
      const VerificationMeta('avgMood');
  @override
  late final GeneratedColumn<int> avgMood = GeneratedColumn<int>(
      'avg_mood', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        careerId,
        groupId,
        month,
        popularityScore,
        fanbaseSize,
        avgChemistry,
        avgMood
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_stats';
  @override
  VerificationContext validateIntegrity(Insertable<MonthlyStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(_careerIdMeta,
          careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta));
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('popularity_score')) {
      context.handle(
          _popularityScoreMeta,
          popularityScore.isAcceptableOrUnknown(
              data['popularity_score']!, _popularityScoreMeta));
    } else if (isInserting) {
      context.missing(_popularityScoreMeta);
    }
    if (data.containsKey('fanbase_size')) {
      context.handle(
          _fanbaseSizeMeta,
          fanbaseSize.isAcceptableOrUnknown(
              data['fanbase_size']!, _fanbaseSizeMeta));
    } else if (isInserting) {
      context.missing(_fanbaseSizeMeta);
    }
    if (data.containsKey('avg_chemistry')) {
      context.handle(
          _avgChemistryMeta,
          avgChemistry.isAcceptableOrUnknown(
              data['avg_chemistry']!, _avgChemistryMeta));
    }
    if (data.containsKey('avg_mood')) {
      context.handle(_avgMoodMeta,
          avgMood.isAcceptableOrUnknown(data['avg_mood']!, _avgMoodMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyStat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}career_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      popularityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}popularity_score'])!,
      fanbaseSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fanbase_size'])!,
      avgChemistry: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avg_chemistry']),
      avgMood: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avg_mood']),
    );
  }

  @override
  $MonthlyStatsTable createAlias(String alias) {
    return $MonthlyStatsTable(attachedDatabase, alias);
  }
}

class MonthlyStat extends DataClass implements Insertable<MonthlyStat> {
  final int id;
  final int careerId;
  final int groupId;
  final int month;
  final int popularityScore;
  final int fanbaseSize;
  final int? avgChemistry;
  final int? avgMood;
  const MonthlyStat(
      {required this.id,
      required this.careerId,
      required this.groupId,
      required this.month,
      required this.popularityScore,
      required this.fanbaseSize,
      this.avgChemistry,
      this.avgMood});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['group_id'] = Variable<int>(groupId);
    map['month'] = Variable<int>(month);
    map['popularity_score'] = Variable<int>(popularityScore);
    map['fanbase_size'] = Variable<int>(fanbaseSize);
    if (!nullToAbsent || avgChemistry != null) {
      map['avg_chemistry'] = Variable<int>(avgChemistry);
    }
    if (!nullToAbsent || avgMood != null) {
      map['avg_mood'] = Variable<int>(avgMood);
    }
    return map;
  }

  MonthlyStatsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyStatsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      groupId: Value(groupId),
      month: Value(month),
      popularityScore: Value(popularityScore),
      fanbaseSize: Value(fanbaseSize),
      avgChemistry: avgChemistry == null && nullToAbsent
          ? const Value.absent()
          : Value(avgChemistry),
      avgMood: avgMood == null && nullToAbsent
          ? const Value.absent()
          : Value(avgMood),
    );
  }

  factory MonthlyStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyStat(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      groupId: serializer.fromJson<int>(json['groupId']),
      month: serializer.fromJson<int>(json['month']),
      popularityScore: serializer.fromJson<int>(json['popularityScore']),
      fanbaseSize: serializer.fromJson<int>(json['fanbaseSize']),
      avgChemistry: serializer.fromJson<int?>(json['avgChemistry']),
      avgMood: serializer.fromJson<int?>(json['avgMood']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'groupId': serializer.toJson<int>(groupId),
      'month': serializer.toJson<int>(month),
      'popularityScore': serializer.toJson<int>(popularityScore),
      'fanbaseSize': serializer.toJson<int>(fanbaseSize),
      'avgChemistry': serializer.toJson<int?>(avgChemistry),
      'avgMood': serializer.toJson<int?>(avgMood),
    };
  }

  MonthlyStat copyWith(
          {int? id,
          int? careerId,
          int? groupId,
          int? month,
          int? popularityScore,
          int? fanbaseSize,
          Value<int?> avgChemistry = const Value.absent(),
          Value<int?> avgMood = const Value.absent()}) =>
      MonthlyStat(
        id: id ?? this.id,
        careerId: careerId ?? this.careerId,
        groupId: groupId ?? this.groupId,
        month: month ?? this.month,
        popularityScore: popularityScore ?? this.popularityScore,
        fanbaseSize: fanbaseSize ?? this.fanbaseSize,
        avgChemistry:
            avgChemistry.present ? avgChemistry.value : this.avgChemistry,
        avgMood: avgMood.present ? avgMood.value : this.avgMood,
      );
  MonthlyStat copyWithCompanion(MonthlyStatsCompanion data) {
    return MonthlyStat(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      month: data.month.present ? data.month.value : this.month,
      popularityScore: data.popularityScore.present
          ? data.popularityScore.value
          : this.popularityScore,
      fanbaseSize:
          data.fanbaseSize.present ? data.fanbaseSize.value : this.fanbaseSize,
      avgChemistry: data.avgChemistry.present
          ? data.avgChemistry.value
          : this.avgChemistry,
      avgMood: data.avgMood.present ? data.avgMood.value : this.avgMood,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyStat(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('groupId: $groupId, ')
          ..write('month: $month, ')
          ..write('popularityScore: $popularityScore, ')
          ..write('fanbaseSize: $fanbaseSize, ')
          ..write('avgChemistry: $avgChemistry, ')
          ..write('avgMood: $avgMood')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, careerId, groupId, month, popularityScore,
      fanbaseSize, avgChemistry, avgMood);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyStat &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.groupId == this.groupId &&
          other.month == this.month &&
          other.popularityScore == this.popularityScore &&
          other.fanbaseSize == this.fanbaseSize &&
          other.avgChemistry == this.avgChemistry &&
          other.avgMood == this.avgMood);
}

class MonthlyStatsCompanion extends UpdateCompanion<MonthlyStat> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> groupId;
  final Value<int> month;
  final Value<int> popularityScore;
  final Value<int> fanbaseSize;
  final Value<int?> avgChemistry;
  final Value<int?> avgMood;
  const MonthlyStatsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.month = const Value.absent(),
    this.popularityScore = const Value.absent(),
    this.fanbaseSize = const Value.absent(),
    this.avgChemistry = const Value.absent(),
    this.avgMood = const Value.absent(),
  });
  MonthlyStatsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int groupId,
    required int month,
    required int popularityScore,
    required int fanbaseSize,
    this.avgChemistry = const Value.absent(),
    this.avgMood = const Value.absent(),
  })  : careerId = Value(careerId),
        groupId = Value(groupId),
        month = Value(month),
        popularityScore = Value(popularityScore),
        fanbaseSize = Value(fanbaseSize);
  static Insertable<MonthlyStat> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? groupId,
    Expression<int>? month,
    Expression<int>? popularityScore,
    Expression<int>? fanbaseSize,
    Expression<int>? avgChemistry,
    Expression<int>? avgMood,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (groupId != null) 'group_id': groupId,
      if (month != null) 'month': month,
      if (popularityScore != null) 'popularity_score': popularityScore,
      if (fanbaseSize != null) 'fanbase_size': fanbaseSize,
      if (avgChemistry != null) 'avg_chemistry': avgChemistry,
      if (avgMood != null) 'avg_mood': avgMood,
    });
  }

  MonthlyStatsCompanion copyWith(
      {Value<int>? id,
      Value<int>? careerId,
      Value<int>? groupId,
      Value<int>? month,
      Value<int>? popularityScore,
      Value<int>? fanbaseSize,
      Value<int?>? avgChemistry,
      Value<int?>? avgMood}) {
    return MonthlyStatsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      groupId: groupId ?? this.groupId,
      month: month ?? this.month,
      popularityScore: popularityScore ?? this.popularityScore,
      fanbaseSize: fanbaseSize ?? this.fanbaseSize,
      avgChemistry: avgChemistry ?? this.avgChemistry,
      avgMood: avgMood ?? this.avgMood,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (popularityScore.present) {
      map['popularity_score'] = Variable<int>(popularityScore.value);
    }
    if (fanbaseSize.present) {
      map['fanbase_size'] = Variable<int>(fanbaseSize.value);
    }
    if (avgChemistry.present) {
      map['avg_chemistry'] = Variable<int>(avgChemistry.value);
    }
    if (avgMood.present) {
      map['avg_mood'] = Variable<int>(avgMood.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyStatsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('groupId: $groupId, ')
          ..write('month: $month, ')
          ..write('popularityScore: $popularityScore, ')
          ..write('fanbaseSize: $fanbaseSize, ')
          ..write('avgChemistry: $avgChemistry, ')
          ..write('avgMood: $avgMood')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonalityTraitsTable personalityTraits =
      $PersonalityTraitsTable(this);
  late final $NamePoolTable namePool = $NamePoolTable(this);
  late final $TagPoolTable tagPool = $TagPoolTable(this);
  late final $RarityTiersTable rarityTiers = $RarityTiersTable(this);
  late final $PlayerCareersTable playerCareers = $PlayerCareersTable(this);
  late final $GeneratedCharactersTable generatedCharacters =
      $GeneratedCharactersTable(this);
  late final $CurrencyWalletsTable currencyWallets =
      $CurrencyWalletsTable(this);
  late final $CareerHistoriesTable careerHistories =
      $CareerHistoriesTable(this);
  late final $PlayerIdolsTable playerIdols = $PlayerIdolsTable(this);
  late final $ChemistryRelationsTable chemistryRelations =
      $ChemistryRelationsTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $GlobalAchievementsTable globalAchievements =
      $GlobalAchievementsTable(this);
  late final $SocialPostsTable socialPosts = $SocialPostsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $CardPacksTable cardPacks = $CardPacksTable(this);
  late final $PackPoolItemsTable packPoolItems = $PackPoolItemsTable(this);
  late final $CoachesTable coaches = $CoachesTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $EventAffectedIdolsTable eventAffectedIdols =
      $EventAffectedIdolsTable(this);
  late final $RivalsTable rivals = $RivalsTable(this);
  late final $RivalMilestonesTable rivalMilestones =
      $RivalMilestonesTable(this);
  late final $MonthlyStatsTable monthlyStats = $MonthlyStatsTable(this);
  late final Index idxPlayerIdolsCareer = Index('idx_player_idols_career',
      'CREATE INDEX idx_player_idols_career ON player_idols (career_id)');
  late final Index idxChemistryIdols = Index('idx_chemistry_idols',
      'CREATE INDEX idx_chemistry_idols ON chemistry_relations (idol_a_id, idol_b_id)');
  late final Index idxGroupMembersGroup = Index('idx_group_members_group',
      'CREATE INDEX idx_group_members_group ON group_members (group_id)');
  late final Index idxCoachesCareer = Index('idx_coaches_career',
      'CREATE INDEX idx_coaches_career ON coaches (career_id)');
  late final Index idxEventsCareerMonth = Index('idx_events_career_month',
      'CREATE INDEX idx_events_career_month ON events (career_id, month_occurred)');
  late final Index idxRivalMilestonesRival = Index('idx_rival_milestones_rival',
      'CREATE INDEX idx_rival_milestones_rival ON rival_milestones (rival_id, month)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        personalityTraits,
        namePool,
        tagPool,
        rarityTiers,
        playerCareers,
        generatedCharacters,
        currencyWallets,
        careerHistories,
        playerIdols,
        chemistryRelations,
        groups,
        groupMembers,
        songs,
        albums,
        achievements,
        globalAchievements,
        socialPosts,
        transactions,
        cardPacks,
        packPoolItems,
        coaches,
        events,
        eventAffectedIdols,
        rivals,
        rivalMilestones,
        monthlyStats,
        idxPlayerIdolsCareer,
        idxChemistryIdols,
        idxGroupMembersGroup,
        idxCoachesCareer,
        idxEventsCareerMonth,
        idxRivalMilestonesRival
      ];
}

typedef $$PersonalityTraitsTableCreateCompanionBuilder
    = PersonalityTraitsCompanion Function({
  Value<int> id,
  required String traitName,
  Value<String?> description,
  Value<int> chemistryModifier,
  Value<double> moodDecayRate,
  Value<double> scandalChanceModifier,
});
typedef $$PersonalityTraitsTableUpdateCompanionBuilder
    = PersonalityTraitsCompanion Function({
  Value<int> id,
  Value<String> traitName,
  Value<String?> description,
  Value<int> chemistryModifier,
  Value<double> moodDecayRate,
  Value<double> scandalChanceModifier,
});

final class $$PersonalityTraitsTableReferences extends BaseReferences<
    _$AppDatabase, $PersonalityTraitsTable, PersonalityTrait> {
  $$PersonalityTraitsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GeneratedCharactersTable,
      List<GeneratedCharacter>> _generatedCharactersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.generatedCharacters,
          aliasName:
              'personality_traits__id__generated_characters__personality_id');

  $$GeneratedCharactersTableProcessedTableManager get generatedCharactersRefs {
    final manager = $$GeneratedCharactersTableTableManager(
            $_db, $_db.generatedCharacters)
        .filter((f) => f.personalityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_generatedCharactersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PersonalityTraitsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalityTraitsTable> {
  $$PersonalityTraitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get traitName => $composableBuilder(
      column: $table.traitName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chemistryModifier => $composableBuilder(
      column: $table.chemistryModifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get moodDecayRate => $composableBuilder(
      column: $table.moodDecayRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get scandalChanceModifier => $composableBuilder(
      column: $table.scandalChanceModifier,
      builder: (column) => ColumnFilters(column));

  Expression<bool> generatedCharactersRefs(
      Expression<bool> Function($$GeneratedCharactersTableFilterComposer f) f) {
    final $$GeneratedCharactersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.generatedCharacters,
        getReferencedColumn: (t) => t.personalityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GeneratedCharactersTableFilterComposer(
              $db: $db,
              $table: $db.generatedCharacters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PersonalityTraitsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalityTraitsTable> {
  $$PersonalityTraitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get traitName => $composableBuilder(
      column: $table.traitName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chemistryModifier => $composableBuilder(
      column: $table.chemistryModifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get moodDecayRate => $composableBuilder(
      column: $table.moodDecayRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get scandalChanceModifier => $composableBuilder(
      column: $table.scandalChanceModifier,
      builder: (column) => ColumnOrderings(column));
}

class $$PersonalityTraitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalityTraitsTable> {
  $$PersonalityTraitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get traitName =>
      $composableBuilder(column: $table.traitName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get chemistryModifier => $composableBuilder(
      column: $table.chemistryModifier, builder: (column) => column);

  GeneratedColumn<double> get moodDecayRate => $composableBuilder(
      column: $table.moodDecayRate, builder: (column) => column);

  GeneratedColumn<double> get scandalChanceModifier => $composableBuilder(
      column: $table.scandalChanceModifier, builder: (column) => column);

  Expression<T> generatedCharactersRefs<T extends Object>(
      Expression<T> Function($$GeneratedCharactersTableAnnotationComposer a)
          f) {
    final $$GeneratedCharactersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.generatedCharacters,
            getReferencedColumn: (t) => t.personalityId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GeneratedCharactersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.generatedCharacters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PersonalityTraitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonalityTraitsTable,
    PersonalityTrait,
    $$PersonalityTraitsTableFilterComposer,
    $$PersonalityTraitsTableOrderingComposer,
    $$PersonalityTraitsTableAnnotationComposer,
    $$PersonalityTraitsTableCreateCompanionBuilder,
    $$PersonalityTraitsTableUpdateCompanionBuilder,
    (PersonalityTrait, $$PersonalityTraitsTableReferences),
    PersonalityTrait,
    PrefetchHooks Function({bool generatedCharactersRefs})> {
  $$PersonalityTraitsTableTableManager(
      _$AppDatabase db, $PersonalityTraitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalityTraitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalityTraitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalityTraitsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> traitName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> chemistryModifier = const Value.absent(),
            Value<double> moodDecayRate = const Value.absent(),
            Value<double> scandalChanceModifier = const Value.absent(),
          }) =>
              PersonalityTraitsCompanion(
            id: id,
            traitName: traitName,
            description: description,
            chemistryModifier: chemistryModifier,
            moodDecayRate: moodDecayRate,
            scandalChanceModifier: scandalChanceModifier,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String traitName,
            Value<String?> description = const Value.absent(),
            Value<int> chemistryModifier = const Value.absent(),
            Value<double> moodDecayRate = const Value.absent(),
            Value<double> scandalChanceModifier = const Value.absent(),
          }) =>
              PersonalityTraitsCompanion.insert(
            id: id,
            traitName: traitName,
            description: description,
            chemistryModifier: chemistryModifier,
            moodDecayRate: moodDecayRate,
            scandalChanceModifier: scandalChanceModifier,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PersonalityTraitsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({generatedCharactersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (generatedCharactersRefs) db.generatedCharacters
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (generatedCharactersRefs)
                    await $_getPrefetchedData<PersonalityTrait,
                            $PersonalityTraitsTable, GeneratedCharacter>(
                        currentTable: table,
                        referencedTable: $$PersonalityTraitsTableReferences
                            ._generatedCharactersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonalityTraitsTableReferences(db, table, p0)
                                .generatedCharactersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personalityId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PersonalityTraitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonalityTraitsTable,
    PersonalityTrait,
    $$PersonalityTraitsTableFilterComposer,
    $$PersonalityTraitsTableOrderingComposer,
    $$PersonalityTraitsTableAnnotationComposer,
    $$PersonalityTraitsTableCreateCompanionBuilder,
    $$PersonalityTraitsTableUpdateCompanionBuilder,
    (PersonalityTrait, $$PersonalityTraitsTableReferences),
    PersonalityTrait,
    PrefetchHooks Function({bool generatedCharactersRefs})>;
typedef $$NamePoolTableCreateCompanionBuilder = NamePoolCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$NamePoolTableUpdateCompanionBuilder = NamePoolCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$NamePoolTableFilterComposer
    extends Composer<_$AppDatabase, $NamePoolTable> {
  $$NamePoolTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$NamePoolTableOrderingComposer
    extends Composer<_$AppDatabase, $NamePoolTable> {
  $$NamePoolTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$NamePoolTableAnnotationComposer
    extends Composer<_$AppDatabase, $NamePoolTable> {
  $$NamePoolTableAnnotationComposer({
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
}

class $$NamePoolTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NamePoolTable,
    NamePoolData,
    $$NamePoolTableFilterComposer,
    $$NamePoolTableOrderingComposer,
    $$NamePoolTableAnnotationComposer,
    $$NamePoolTableCreateCompanionBuilder,
    $$NamePoolTableUpdateCompanionBuilder,
    (NamePoolData, BaseReferences<_$AppDatabase, $NamePoolTable, NamePoolData>),
    NamePoolData,
    PrefetchHooks Function()> {
  $$NamePoolTableTableManager(_$AppDatabase db, $NamePoolTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NamePoolTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NamePoolTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NamePoolTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              NamePoolCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              NamePoolCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NamePoolTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NamePoolTable,
    NamePoolData,
    $$NamePoolTableFilterComposer,
    $$NamePoolTableOrderingComposer,
    $$NamePoolTableAnnotationComposer,
    $$NamePoolTableCreateCompanionBuilder,
    $$NamePoolTableUpdateCompanionBuilder,
    (NamePoolData, BaseReferences<_$AppDatabase, $NamePoolTable, NamePoolData>),
    NamePoolData,
    PrefetchHooks Function()>;
typedef $$TagPoolTableCreateCompanionBuilder = TagPoolCompanion Function({
  Value<int> id,
  required String category,
  required String value,
});
typedef $$TagPoolTableUpdateCompanionBuilder = TagPoolCompanion Function({
  Value<int> id,
  Value<String> category,
  Value<String> value,
});

class $$TagPoolTableFilterComposer
    extends Composer<_$AppDatabase, $TagPoolTable> {
  $$TagPoolTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$TagPoolTableOrderingComposer
    extends Composer<_$AppDatabase, $TagPoolTable> {
  $$TagPoolTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$TagPoolTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagPoolTable> {
  $$TagPoolTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$TagPoolTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagPoolTable,
    TagPoolData,
    $$TagPoolTableFilterComposer,
    $$TagPoolTableOrderingComposer,
    $$TagPoolTableAnnotationComposer,
    $$TagPoolTableCreateCompanionBuilder,
    $$TagPoolTableUpdateCompanionBuilder,
    (TagPoolData, BaseReferences<_$AppDatabase, $TagPoolTable, TagPoolData>),
    TagPoolData,
    PrefetchHooks Function()> {
  $$TagPoolTableTableManager(_$AppDatabase db, $TagPoolTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagPoolTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagPoolTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagPoolTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> value = const Value.absent(),
          }) =>
              TagPoolCompanion(
            id: id,
            category: category,
            value: value,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String category,
            required String value,
          }) =>
              TagPoolCompanion.insert(
            id: id,
            category: category,
            value: value,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagPoolTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagPoolTable,
    TagPoolData,
    $$TagPoolTableFilterComposer,
    $$TagPoolTableOrderingComposer,
    $$TagPoolTableAnnotationComposer,
    $$TagPoolTableCreateCompanionBuilder,
    $$TagPoolTableUpdateCompanionBuilder,
    (TagPoolData, BaseReferences<_$AppDatabase, $TagPoolTable, TagPoolData>),
    TagPoolData,
    PrefetchHooks Function()>;
typedef $$RarityTiersTableCreateCompanionBuilder = RarityTiersCompanion
    Function({
  Value<int> id,
  required String rarityName,
  required int statMin,
  required int statMax,
  required double poolWeight,
});
typedef $$RarityTiersTableUpdateCompanionBuilder = RarityTiersCompanion
    Function({
  Value<int> id,
  Value<String> rarityName,
  Value<int> statMin,
  Value<int> statMax,
  Value<double> poolWeight,
});

class $$RarityTiersTableFilterComposer
    extends Composer<_$AppDatabase, $RarityTiersTable> {
  $$RarityTiersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rarityName => $composableBuilder(
      column: $table.rarityName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get statMin => $composableBuilder(
      column: $table.statMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get statMax => $composableBuilder(
      column: $table.statMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get poolWeight => $composableBuilder(
      column: $table.poolWeight, builder: (column) => ColumnFilters(column));
}

class $$RarityTiersTableOrderingComposer
    extends Composer<_$AppDatabase, $RarityTiersTable> {
  $$RarityTiersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rarityName => $composableBuilder(
      column: $table.rarityName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get statMin => $composableBuilder(
      column: $table.statMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get statMax => $composableBuilder(
      column: $table.statMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get poolWeight => $composableBuilder(
      column: $table.poolWeight, builder: (column) => ColumnOrderings(column));
}

class $$RarityTiersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RarityTiersTable> {
  $$RarityTiersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rarityName => $composableBuilder(
      column: $table.rarityName, builder: (column) => column);

  GeneratedColumn<int> get statMin =>
      $composableBuilder(column: $table.statMin, builder: (column) => column);

  GeneratedColumn<int> get statMax =>
      $composableBuilder(column: $table.statMax, builder: (column) => column);

  GeneratedColumn<double> get poolWeight => $composableBuilder(
      column: $table.poolWeight, builder: (column) => column);
}

class $$RarityTiersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RarityTiersTable,
    RarityTier,
    $$RarityTiersTableFilterComposer,
    $$RarityTiersTableOrderingComposer,
    $$RarityTiersTableAnnotationComposer,
    $$RarityTiersTableCreateCompanionBuilder,
    $$RarityTiersTableUpdateCompanionBuilder,
    (RarityTier, BaseReferences<_$AppDatabase, $RarityTiersTable, RarityTier>),
    RarityTier,
    PrefetchHooks Function()> {
  $$RarityTiersTableTableManager(_$AppDatabase db, $RarityTiersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RarityTiersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RarityTiersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RarityTiersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> rarityName = const Value.absent(),
            Value<int> statMin = const Value.absent(),
            Value<int> statMax = const Value.absent(),
            Value<double> poolWeight = const Value.absent(),
          }) =>
              RarityTiersCompanion(
            id: id,
            rarityName: rarityName,
            statMin: statMin,
            statMax: statMax,
            poolWeight: poolWeight,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String rarityName,
            required int statMin,
            required int statMax,
            required double poolWeight,
          }) =>
              RarityTiersCompanion.insert(
            id: id,
            rarityName: rarityName,
            statMin: statMin,
            statMax: statMax,
            poolWeight: poolWeight,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RarityTiersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RarityTiersTable,
    RarityTier,
    $$RarityTiersTableFilterComposer,
    $$RarityTiersTableOrderingComposer,
    $$RarityTiersTableAnnotationComposer,
    $$RarityTiersTableCreateCompanionBuilder,
    $$RarityTiersTableUpdateCompanionBuilder,
    (RarityTier, BaseReferences<_$AppDatabase, $RarityTiersTable, RarityTier>),
    RarityTier,
    PrefetchHooks Function()>;
typedef $$PlayerCareersTableCreateCompanionBuilder = PlayerCareersCompanion
    Function({
  Value<int> id,
  required int careerNumber,
  Value<String> agencyName,
  Value<String> phase,
  required DateTime startedAt,
  Value<int> currentWeek,
  Value<int> currentMonth,
  Value<int> currentYear,
  Value<String> status,
  Value<int?> finalScore,
  Value<int> awardsWon,
  Value<String?> legacyBonusApplied,
  Value<String> difficulty,
});
typedef $$PlayerCareersTableUpdateCompanionBuilder = PlayerCareersCompanion
    Function({
  Value<int> id,
  Value<int> careerNumber,
  Value<String> agencyName,
  Value<String> phase,
  Value<DateTime> startedAt,
  Value<int> currentWeek,
  Value<int> currentMonth,
  Value<int> currentYear,
  Value<String> status,
  Value<int?> finalScore,
  Value<int> awardsWon,
  Value<String?> legacyBonusApplied,
  Value<String> difficulty,
});

final class $$PlayerCareersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayerCareersTable, PlayerCareer> {
  $$PlayerCareersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GeneratedCharactersTable,
      List<GeneratedCharacter>> _generatedCharactersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.generatedCharacters,
          aliasName: 'player_careers__id__generated_characters__career_id');

  $$GeneratedCharactersTableProcessedTableManager get generatedCharactersRefs {
    final manager =
        $$GeneratedCharactersTableTableManager($_db, $_db.generatedCharacters)
            .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_generatedCharactersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CurrencyWalletsTable, List<CurrencyWallet>>
      _currencyWalletsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.currencyWallets,
              aliasName: 'player_careers__id__currency_wallets__career_id');

  $$CurrencyWalletsTableProcessedTableManager get currencyWalletsRefs {
    final manager =
        $$CurrencyWalletsTableTableManager($_db, $_db.currencyWallets)
            .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_currencyWalletsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CareerHistoriesTable, List<CareerHistory>>
      _careerHistoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.careerHistories,
              aliasName: 'player_careers__id__career_histories__career_id');

  $$CareerHistoriesTableProcessedTableManager get careerHistoriesRefs {
    final manager =
        $$CareerHistoriesTableTableManager($_db, $_db.careerHistories)
            .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_careerHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlayerIdolsTable, List<PlayerIdol>>
      _playerIdolsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.playerIdols,
              aliasName: 'player_careers__id__player_idols__career_id');

  $$PlayerIdolsTableProcessedTableManager get playerIdolsRefs {
    final manager = $$PlayerIdolsTableTableManager($_db, $_db.playerIdols)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playerIdolsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GroupsTable, List<Group>> _groupsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.groups,
          aliasName: 'player_careers__id__groups__career_id');

  $$GroupsTableProcessedTableManager get groupsRefs {
    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AchievementsTable, List<Achievement>>
      _achievementsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.achievements,
              aliasName: 'player_careers__id__achievements__career_id');

  $$AchievementsTableProcessedTableManager get achievementsRefs {
    final manager = $$AchievementsTableTableManager($_db, $_db.achievements)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_achievementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SocialPostsTable, List<SocialPost>>
      _socialPostsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.socialPosts,
              aliasName: 'player_careers__id__social_posts__career_id');

  $$SocialPostsTableProcessedTableManager get socialPostsRefs {
    final manager = $$SocialPostsTableTableManager($_db, $_db.socialPosts)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_socialPostsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: 'player_careers__id__transactions__career_id');

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CoachesTable, List<Coach>> _coachesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.coaches,
          aliasName: 'player_careers__id__coaches__career_id');

  $$CoachesTableProcessedTableManager get coachesRefs {
    final manager = $$CoachesTableTableManager($_db, $_db.coaches)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_coachesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.events,
          aliasName: 'player_careers__id__events__career_id');

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MonthlyStatsTable, List<MonthlyStat>>
      _monthlyStatsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.monthlyStats,
              aliasName: 'player_careers__id__monthly_stats__career_id');

  $$MonthlyStatsTableProcessedTableManager get monthlyStatsRefs {
    final manager = $$MonthlyStatsTableTableManager($_db, $_db.monthlyStats)
        .filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_monthlyStatsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlayerCareersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerCareersTable> {
  $$PlayerCareersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get careerNumber => $composableBuilder(
      column: $table.careerNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agencyName => $composableBuilder(
      column: $table.agencyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentMonth => $composableBuilder(
      column: $table.currentMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentYear => $composableBuilder(
      column: $table.currentYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get awardsWon => $composableBuilder(
      column: $table.awardsWon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legacyBonusApplied => $composableBuilder(
      column: $table.legacyBonusApplied,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  Expression<bool> generatedCharactersRefs(
      Expression<bool> Function($$GeneratedCharactersTableFilterComposer f) f) {
    final $$GeneratedCharactersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.generatedCharacters,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GeneratedCharactersTableFilterComposer(
              $db: $db,
              $table: $db.generatedCharacters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> currencyWalletsRefs(
      Expression<bool> Function($$CurrencyWalletsTableFilterComposer f) f) {
    final $$CurrencyWalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.currencyWallets,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrencyWalletsTableFilterComposer(
              $db: $db,
              $table: $db.currencyWallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> careerHistoriesRefs(
      Expression<bool> Function($$CareerHistoriesTableFilterComposer f) f) {
    final $$CareerHistoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.careerHistories,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CareerHistoriesTableFilterComposer(
              $db: $db,
              $table: $db.careerHistories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> playerIdolsRefs(
      Expression<bool> Function($$PlayerIdolsTableFilterComposer f) f) {
    final $$PlayerIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableFilterComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> groupsRefs(
      Expression<bool> Function($$GroupsTableFilterComposer f) f) {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> achievementsRefs(
      Expression<bool> Function($$AchievementsTableFilterComposer f) f) {
    final $$AchievementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.achievements,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AchievementsTableFilterComposer(
              $db: $db,
              $table: $db.achievements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> socialPostsRefs(
      Expression<bool> Function($$SocialPostsTableFilterComposer f) f) {
    final $$SocialPostsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.socialPosts,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SocialPostsTableFilterComposer(
              $db: $db,
              $table: $db.socialPosts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> coachesRefs(
      Expression<bool> Function($$CoachesTableFilterComposer f) f) {
    final $$CoachesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.coaches,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CoachesTableFilterComposer(
              $db: $db,
              $table: $db.coaches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> eventsRefs(
      Expression<bool> Function($$EventsTableFilterComposer f) f) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monthlyStatsRefs(
      Expression<bool> Function($$MonthlyStatsTableFilterComposer f) f) {
    final $$MonthlyStatsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyStats,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonthlyStatsTableFilterComposer(
              $db: $db,
              $table: $db.monthlyStats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlayerCareersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerCareersTable> {
  $$PlayerCareersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get careerNumber => $composableBuilder(
      column: $table.careerNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agencyName => $composableBuilder(
      column: $table.agencyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentMonth => $composableBuilder(
      column: $table.currentMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentYear => $composableBuilder(
      column: $table.currentYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get awardsWon => $composableBuilder(
      column: $table.awardsWon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legacyBonusApplied => $composableBuilder(
      column: $table.legacyBonusApplied,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));
}

class $$PlayerCareersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerCareersTable> {
  $$PlayerCareersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get careerNumber => $composableBuilder(
      column: $table.careerNumber, builder: (column) => column);

  GeneratedColumn<String> get agencyName => $composableBuilder(
      column: $table.agencyName, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => column);

  GeneratedColumn<int> get currentMonth => $composableBuilder(
      column: $table.currentMonth, builder: (column) => column);

  GeneratedColumn<int> get currentYear => $composableBuilder(
      column: $table.currentYear, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => column);

  GeneratedColumn<int> get awardsWon =>
      $composableBuilder(column: $table.awardsWon, builder: (column) => column);

  GeneratedColumn<String> get legacyBonusApplied => $composableBuilder(
      column: $table.legacyBonusApplied, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  Expression<T> generatedCharactersRefs<T extends Object>(
      Expression<T> Function($$GeneratedCharactersTableAnnotationComposer a)
          f) {
    final $$GeneratedCharactersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.generatedCharacters,
            getReferencedColumn: (t) => t.careerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GeneratedCharactersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.generatedCharacters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> currencyWalletsRefs<T extends Object>(
      Expression<T> Function($$CurrencyWalletsTableAnnotationComposer a) f) {
    final $$CurrencyWalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.currencyWallets,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrencyWalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.currencyWallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> careerHistoriesRefs<T extends Object>(
      Expression<T> Function($$CareerHistoriesTableAnnotationComposer a) f) {
    final $$CareerHistoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.careerHistories,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CareerHistoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.careerHistories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> playerIdolsRefs<T extends Object>(
      Expression<T> Function($$PlayerIdolsTableAnnotationComposer a) f) {
    final $$PlayerIdolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableAnnotationComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> groupsRefs<T extends Object>(
      Expression<T> Function($$GroupsTableAnnotationComposer a) f) {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> achievementsRefs<T extends Object>(
      Expression<T> Function($$AchievementsTableAnnotationComposer a) f) {
    final $$AchievementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.achievements,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AchievementsTableAnnotationComposer(
              $db: $db,
              $table: $db.achievements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> socialPostsRefs<T extends Object>(
      Expression<T> Function($$SocialPostsTableAnnotationComposer a) f) {
    final $$SocialPostsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.socialPosts,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SocialPostsTableAnnotationComposer(
              $db: $db,
              $table: $db.socialPosts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> coachesRefs<T extends Object>(
      Expression<T> Function($$CoachesTableAnnotationComposer a) f) {
    final $$CoachesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.coaches,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CoachesTableAnnotationComposer(
              $db: $db,
              $table: $db.coaches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> eventsRefs<T extends Object>(
      Expression<T> Function($$EventsTableAnnotationComposer a) f) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monthlyStatsRefs<T extends Object>(
      Expression<T> Function($$MonthlyStatsTableAnnotationComposer a) f) {
    final $$MonthlyStatsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyStats,
        getReferencedColumn: (t) => t.careerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonthlyStatsTableAnnotationComposer(
              $db: $db,
              $table: $db.monthlyStats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlayerCareersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayerCareersTable,
    PlayerCareer,
    $$PlayerCareersTableFilterComposer,
    $$PlayerCareersTableOrderingComposer,
    $$PlayerCareersTableAnnotationComposer,
    $$PlayerCareersTableCreateCompanionBuilder,
    $$PlayerCareersTableUpdateCompanionBuilder,
    (PlayerCareer, $$PlayerCareersTableReferences),
    PlayerCareer,
    PrefetchHooks Function(
        {bool generatedCharactersRefs,
        bool currencyWalletsRefs,
        bool careerHistoriesRefs,
        bool playerIdolsRefs,
        bool groupsRefs,
        bool achievementsRefs,
        bool socialPostsRefs,
        bool transactionsRefs,
        bool coachesRefs,
        bool eventsRefs,
        bool monthlyStatsRefs})> {
  $$PlayerCareersTableTableManager(_$AppDatabase db, $PlayerCareersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerCareersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerCareersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerCareersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerNumber = const Value.absent(),
            Value<String> agencyName = const Value.absent(),
            Value<String> phase = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<int> currentWeek = const Value.absent(),
            Value<int> currentMonth = const Value.absent(),
            Value<int> currentYear = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> finalScore = const Value.absent(),
            Value<int> awardsWon = const Value.absent(),
            Value<String?> legacyBonusApplied = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
          }) =>
              PlayerCareersCompanion(
            id: id,
            careerNumber: careerNumber,
            agencyName: agencyName,
            phase: phase,
            startedAt: startedAt,
            currentWeek: currentWeek,
            currentMonth: currentMonth,
            currentYear: currentYear,
            status: status,
            finalScore: finalScore,
            awardsWon: awardsWon,
            legacyBonusApplied: legacyBonusApplied,
            difficulty: difficulty,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerNumber,
            Value<String> agencyName = const Value.absent(),
            Value<String> phase = const Value.absent(),
            required DateTime startedAt,
            Value<int> currentWeek = const Value.absent(),
            Value<int> currentMonth = const Value.absent(),
            Value<int> currentYear = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> finalScore = const Value.absent(),
            Value<int> awardsWon = const Value.absent(),
            Value<String?> legacyBonusApplied = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
          }) =>
              PlayerCareersCompanion.insert(
            id: id,
            careerNumber: careerNumber,
            agencyName: agencyName,
            phase: phase,
            startedAt: startedAt,
            currentWeek: currentWeek,
            currentMonth: currentMonth,
            currentYear: currentYear,
            status: status,
            finalScore: finalScore,
            awardsWon: awardsWon,
            legacyBonusApplied: legacyBonusApplied,
            difficulty: difficulty,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlayerCareersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {generatedCharactersRefs = false,
              currencyWalletsRefs = false,
              careerHistoriesRefs = false,
              playerIdolsRefs = false,
              groupsRefs = false,
              achievementsRefs = false,
              socialPostsRefs = false,
              transactionsRefs = false,
              coachesRefs = false,
              eventsRefs = false,
              monthlyStatsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (generatedCharactersRefs) db.generatedCharacters,
                if (currencyWalletsRefs) db.currencyWallets,
                if (careerHistoriesRefs) db.careerHistories,
                if (playerIdolsRefs) db.playerIdols,
                if (groupsRefs) db.groups,
                if (achievementsRefs) db.achievements,
                if (socialPostsRefs) db.socialPosts,
                if (transactionsRefs) db.transactions,
                if (coachesRefs) db.coaches,
                if (eventsRefs) db.events,
                if (monthlyStatsRefs) db.monthlyStats
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (generatedCharactersRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            GeneratedCharacter>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._generatedCharactersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .generatedCharactersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (currencyWalletsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable, CurrencyWallet>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._currencyWalletsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .currencyWalletsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (careerHistoriesRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            CareerHistory>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._careerHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .careerHistoriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (playerIdolsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            PlayerIdol>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._playerIdolsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .playerIdolsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (groupsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            Group>(
                        currentTable: table,
                        referencedTable:
                            $$PlayerCareersTableReferences._groupsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .groupsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (achievementsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            Achievement>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._achievementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .achievementsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (socialPostsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            SocialPost>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._socialPostsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .socialPostsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (transactionsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (coachesRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            Coach>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._coachesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .coachesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (eventsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            Event>(
                        currentTable: table,
                        referencedTable:
                            $$PlayerCareersTableReferences._eventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .eventsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items),
                  if (monthlyStatsRefs)
                    await $_getPrefetchedData<PlayerCareer, $PlayerCareersTable,
                            MonthlyStat>(
                        currentTable: table,
                        referencedTable: $$PlayerCareersTableReferences
                            ._monthlyStatsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerCareersTableReferences(db, table, p0)
                                .monthlyStatsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.careerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlayerCareersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayerCareersTable,
    PlayerCareer,
    $$PlayerCareersTableFilterComposer,
    $$PlayerCareersTableOrderingComposer,
    $$PlayerCareersTableAnnotationComposer,
    $$PlayerCareersTableCreateCompanionBuilder,
    $$PlayerCareersTableUpdateCompanionBuilder,
    (PlayerCareer, $$PlayerCareersTableReferences),
    PlayerCareer,
    PrefetchHooks Function(
        {bool generatedCharactersRefs,
        bool currencyWalletsRefs,
        bool careerHistoriesRefs,
        bool playerIdolsRefs,
        bool groupsRefs,
        bool achievementsRefs,
        bool socialPostsRefs,
        bool transactionsRefs,
        bool coachesRefs,
        bool eventsRefs,
        bool monthlyStatsRefs})>;
typedef $$GeneratedCharactersTableCreateCompanionBuilder
    = GeneratedCharactersCompanion Function({
  Value<int> id,
  required int careerId,
  required String name,
  Value<String?> imagePath,
  Value<int> cohortMonth,
  required int vocalSkill,
  required int danceSkill,
  required int rapSkill,
  Value<int> vocalPotential,
  Value<int> dancePotential,
  Value<int> rapPotential,
  Value<String> primaryDiscipline,
  Value<int> auditionScore,
  required int visualScore,
  required int charisma,
  required int staminaBase,
  required int personalityId,
  required String rarity,
  Value<String?> specialTrait,
  Value<String?> voiceType,
  Value<int> openness,
  Value<int> conscientiousness,
  Value<int> extraversion,
  Value<int> agreeableness,
  Value<int> neuroticism,
  Value<int> startingFame,
  Value<String> recruitStatus,
  Value<String> claimedRole,
  Value<String?> bioSnippet,
  Value<bool> isVocalRevealed,
  Value<bool> isDanceRevealed,
  Value<bool> isRapRevealed,
});
typedef $$GeneratedCharactersTableUpdateCompanionBuilder
    = GeneratedCharactersCompanion Function({
  Value<int> id,
  Value<int> careerId,
  Value<String> name,
  Value<String?> imagePath,
  Value<int> cohortMonth,
  Value<int> vocalSkill,
  Value<int> danceSkill,
  Value<int> rapSkill,
  Value<int> vocalPotential,
  Value<int> dancePotential,
  Value<int> rapPotential,
  Value<String> primaryDiscipline,
  Value<int> auditionScore,
  Value<int> visualScore,
  Value<int> charisma,
  Value<int> staminaBase,
  Value<int> personalityId,
  Value<String> rarity,
  Value<String?> specialTrait,
  Value<String?> voiceType,
  Value<int> openness,
  Value<int> conscientiousness,
  Value<int> extraversion,
  Value<int> agreeableness,
  Value<int> neuroticism,
  Value<int> startingFame,
  Value<String> recruitStatus,
  Value<String> claimedRole,
  Value<String?> bioSnippet,
  Value<bool> isVocalRevealed,
  Value<bool> isDanceRevealed,
  Value<bool> isRapRevealed,
});

final class $$GeneratedCharactersTableReferences extends BaseReferences<
    _$AppDatabase, $GeneratedCharactersTable, GeneratedCharacter> {
  $$GeneratedCharactersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('generated_characters__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PersonalityTraitsTable _personalityIdTable(_$AppDatabase db) =>
      db.personalityTraits.createAlias(
          'generated_characters__personality_id__personality_traits__id');

  $$PersonalityTraitsTableProcessedTableManager get personalityId {
    final $_column = $_itemColumn<int>('personality_id')!;

    final manager =
        $$PersonalityTraitsTableTableManager($_db, $_db.personalityTraits)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personalityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PlayerIdolsTable, List<PlayerIdol>>
      _playerIdolsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.playerIdols,
          aliasName: 'generated_characters__id__player_idols__character_id');

  $$PlayerIdolsTableProcessedTableManager get playerIdolsRefs {
    final manager = $$PlayerIdolsTableTableManager($_db, $_db.playerIdols)
        .filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playerIdolsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PackPoolItemsTable, List<PackPoolItem>>
      _packPoolItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.packPoolItems,
              aliasName:
                  'generated_characters__id__pack_pool_items__character_id');

  $$PackPoolItemsTableProcessedTableManager get packPoolItemsRefs {
    final manager = $$PackPoolItemsTableTableManager($_db, $_db.packPoolItems)
        .filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_packPoolItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GeneratedCharactersTableFilterComposer
    extends Composer<_$AppDatabase, $GeneratedCharactersTable> {
  $$GeneratedCharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cohortMonth => $composableBuilder(
      column: $table.cohortMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vocalSkill => $composableBuilder(
      column: $table.vocalSkill, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get danceSkill => $composableBuilder(
      column: $table.danceSkill, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rapSkill => $composableBuilder(
      column: $table.rapSkill, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vocalPotential => $composableBuilder(
      column: $table.vocalPotential,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dancePotential => $composableBuilder(
      column: $table.dancePotential,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rapPotential => $composableBuilder(
      column: $table.rapPotential, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryDiscipline => $composableBuilder(
      column: $table.primaryDiscipline,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get auditionScore => $composableBuilder(
      column: $table.auditionScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visualScore => $composableBuilder(
      column: $table.visualScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get charisma => $composableBuilder(
      column: $table.charisma, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get staminaBase => $composableBuilder(
      column: $table.staminaBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialTrait => $composableBuilder(
      column: $table.specialTrait, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voiceType => $composableBuilder(
      column: $table.voiceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openness => $composableBuilder(
      column: $table.openness, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conscientiousness => $composableBuilder(
      column: $table.conscientiousness,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get extraversion => $composableBuilder(
      column: $table.extraversion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get agreeableness => $composableBuilder(
      column: $table.agreeableness, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get neuroticism => $composableBuilder(
      column: $table.neuroticism, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startingFame => $composableBuilder(
      column: $table.startingFame, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recruitStatus => $composableBuilder(
      column: $table.recruitStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get claimedRole => $composableBuilder(
      column: $table.claimedRole, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bioSnippet => $composableBuilder(
      column: $table.bioSnippet, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVocalRevealed => $composableBuilder(
      column: $table.isVocalRevealed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDanceRevealed => $composableBuilder(
      column: $table.isDanceRevealed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRapRevealed => $composableBuilder(
      column: $table.isRapRevealed, builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PersonalityTraitsTableFilterComposer get personalityId {
    final $$PersonalityTraitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personalityId,
        referencedTable: $db.personalityTraits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonalityTraitsTableFilterComposer(
              $db: $db,
              $table: $db.personalityTraits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> playerIdolsRefs(
      Expression<bool> Function($$PlayerIdolsTableFilterComposer f) f) {
    final $$PlayerIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableFilterComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> packPoolItemsRefs(
      Expression<bool> Function($$PackPoolItemsTableFilterComposer f) f) {
    final $$PackPoolItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.packPoolItems,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PackPoolItemsTableFilterComposer(
              $db: $db,
              $table: $db.packPoolItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GeneratedCharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $GeneratedCharactersTable> {
  $$GeneratedCharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cohortMonth => $composableBuilder(
      column: $table.cohortMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vocalSkill => $composableBuilder(
      column: $table.vocalSkill, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get danceSkill => $composableBuilder(
      column: $table.danceSkill, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rapSkill => $composableBuilder(
      column: $table.rapSkill, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vocalPotential => $composableBuilder(
      column: $table.vocalPotential,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dancePotential => $composableBuilder(
      column: $table.dancePotential,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rapPotential => $composableBuilder(
      column: $table.rapPotential,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryDiscipline => $composableBuilder(
      column: $table.primaryDiscipline,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get auditionScore => $composableBuilder(
      column: $table.auditionScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visualScore => $composableBuilder(
      column: $table.visualScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get charisma => $composableBuilder(
      column: $table.charisma, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get staminaBase => $composableBuilder(
      column: $table.staminaBase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialTrait => $composableBuilder(
      column: $table.specialTrait,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voiceType => $composableBuilder(
      column: $table.voiceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openness => $composableBuilder(
      column: $table.openness, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conscientiousness => $composableBuilder(
      column: $table.conscientiousness,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraversion => $composableBuilder(
      column: $table.extraversion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get agreeableness => $composableBuilder(
      column: $table.agreeableness,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get neuroticism => $composableBuilder(
      column: $table.neuroticism, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startingFame => $composableBuilder(
      column: $table.startingFame,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recruitStatus => $composableBuilder(
      column: $table.recruitStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get claimedRole => $composableBuilder(
      column: $table.claimedRole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bioSnippet => $composableBuilder(
      column: $table.bioSnippet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVocalRevealed => $composableBuilder(
      column: $table.isVocalRevealed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDanceRevealed => $composableBuilder(
      column: $table.isDanceRevealed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRapRevealed => $composableBuilder(
      column: $table.isRapRevealed,
      builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PersonalityTraitsTableOrderingComposer get personalityId {
    final $$PersonalityTraitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personalityId,
        referencedTable: $db.personalityTraits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonalityTraitsTableOrderingComposer(
              $db: $db,
              $table: $db.personalityTraits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GeneratedCharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeneratedCharactersTable> {
  $$GeneratedCharactersTableAnnotationComposer({
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

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get cohortMonth => $composableBuilder(
      column: $table.cohortMonth, builder: (column) => column);

  GeneratedColumn<int> get vocalSkill => $composableBuilder(
      column: $table.vocalSkill, builder: (column) => column);

  GeneratedColumn<int> get danceSkill => $composableBuilder(
      column: $table.danceSkill, builder: (column) => column);

  GeneratedColumn<int> get rapSkill =>
      $composableBuilder(column: $table.rapSkill, builder: (column) => column);

  GeneratedColumn<int> get vocalPotential => $composableBuilder(
      column: $table.vocalPotential, builder: (column) => column);

  GeneratedColumn<int> get dancePotential => $composableBuilder(
      column: $table.dancePotential, builder: (column) => column);

  GeneratedColumn<int> get rapPotential => $composableBuilder(
      column: $table.rapPotential, builder: (column) => column);

  GeneratedColumn<String> get primaryDiscipline => $composableBuilder(
      column: $table.primaryDiscipline, builder: (column) => column);

  GeneratedColumn<int> get auditionScore => $composableBuilder(
      column: $table.auditionScore, builder: (column) => column);

  GeneratedColumn<int> get visualScore => $composableBuilder(
      column: $table.visualScore, builder: (column) => column);

  GeneratedColumn<int> get charisma =>
      $composableBuilder(column: $table.charisma, builder: (column) => column);

  GeneratedColumn<int> get staminaBase => $composableBuilder(
      column: $table.staminaBase, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get specialTrait => $composableBuilder(
      column: $table.specialTrait, builder: (column) => column);

  GeneratedColumn<String> get voiceType =>
      $composableBuilder(column: $table.voiceType, builder: (column) => column);

  GeneratedColumn<int> get openness =>
      $composableBuilder(column: $table.openness, builder: (column) => column);

  GeneratedColumn<int> get conscientiousness => $composableBuilder(
      column: $table.conscientiousness, builder: (column) => column);

  GeneratedColumn<int> get extraversion => $composableBuilder(
      column: $table.extraversion, builder: (column) => column);

  GeneratedColumn<int> get agreeableness => $composableBuilder(
      column: $table.agreeableness, builder: (column) => column);

  GeneratedColumn<int> get neuroticism => $composableBuilder(
      column: $table.neuroticism, builder: (column) => column);

  GeneratedColumn<int> get startingFame => $composableBuilder(
      column: $table.startingFame, builder: (column) => column);

  GeneratedColumn<String> get recruitStatus => $composableBuilder(
      column: $table.recruitStatus, builder: (column) => column);

  GeneratedColumn<String> get claimedRole => $composableBuilder(
      column: $table.claimedRole, builder: (column) => column);

  GeneratedColumn<String> get bioSnippet => $composableBuilder(
      column: $table.bioSnippet, builder: (column) => column);

  GeneratedColumn<bool> get isVocalRevealed => $composableBuilder(
      column: $table.isVocalRevealed, builder: (column) => column);

  GeneratedColumn<bool> get isDanceRevealed => $composableBuilder(
      column: $table.isDanceRevealed, builder: (column) => column);

  GeneratedColumn<bool> get isRapRevealed => $composableBuilder(
      column: $table.isRapRevealed, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PersonalityTraitsTableAnnotationComposer get personalityId {
    final $$PersonalityTraitsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.personalityId,
            referencedTable: $db.personalityTraits,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PersonalityTraitsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.personalityTraits,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> playerIdolsRefs<T extends Object>(
      Expression<T> Function($$PlayerIdolsTableAnnotationComposer a) f) {
    final $$PlayerIdolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableAnnotationComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> packPoolItemsRefs<T extends Object>(
      Expression<T> Function($$PackPoolItemsTableAnnotationComposer a) f) {
    final $$PackPoolItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.packPoolItems,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PackPoolItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.packPoolItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GeneratedCharactersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GeneratedCharactersTable,
    GeneratedCharacter,
    $$GeneratedCharactersTableFilterComposer,
    $$GeneratedCharactersTableOrderingComposer,
    $$GeneratedCharactersTableAnnotationComposer,
    $$GeneratedCharactersTableCreateCompanionBuilder,
    $$GeneratedCharactersTableUpdateCompanionBuilder,
    (GeneratedCharacter, $$GeneratedCharactersTableReferences),
    GeneratedCharacter,
    PrefetchHooks Function(
        {bool careerId,
        bool personalityId,
        bool playerIdolsRefs,
        bool packPoolItemsRefs})> {
  $$GeneratedCharactersTableTableManager(
      _$AppDatabase db, $GeneratedCharactersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneratedCharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneratedCharactersTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeneratedCharactersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<int> cohortMonth = const Value.absent(),
            Value<int> vocalSkill = const Value.absent(),
            Value<int> danceSkill = const Value.absent(),
            Value<int> rapSkill = const Value.absent(),
            Value<int> vocalPotential = const Value.absent(),
            Value<int> dancePotential = const Value.absent(),
            Value<int> rapPotential = const Value.absent(),
            Value<String> primaryDiscipline = const Value.absent(),
            Value<int> auditionScore = const Value.absent(),
            Value<int> visualScore = const Value.absent(),
            Value<int> charisma = const Value.absent(),
            Value<int> staminaBase = const Value.absent(),
            Value<int> personalityId = const Value.absent(),
            Value<String> rarity = const Value.absent(),
            Value<String?> specialTrait = const Value.absent(),
            Value<String?> voiceType = const Value.absent(),
            Value<int> openness = const Value.absent(),
            Value<int> conscientiousness = const Value.absent(),
            Value<int> extraversion = const Value.absent(),
            Value<int> agreeableness = const Value.absent(),
            Value<int> neuroticism = const Value.absent(),
            Value<int> startingFame = const Value.absent(),
            Value<String> recruitStatus = const Value.absent(),
            Value<String> claimedRole = const Value.absent(),
            Value<String?> bioSnippet = const Value.absent(),
            Value<bool> isVocalRevealed = const Value.absent(),
            Value<bool> isDanceRevealed = const Value.absent(),
            Value<bool> isRapRevealed = const Value.absent(),
          }) =>
              GeneratedCharactersCompanion(
            id: id,
            careerId: careerId,
            name: name,
            imagePath: imagePath,
            cohortMonth: cohortMonth,
            vocalSkill: vocalSkill,
            danceSkill: danceSkill,
            rapSkill: rapSkill,
            vocalPotential: vocalPotential,
            dancePotential: dancePotential,
            rapPotential: rapPotential,
            primaryDiscipline: primaryDiscipline,
            auditionScore: auditionScore,
            visualScore: visualScore,
            charisma: charisma,
            staminaBase: staminaBase,
            personalityId: personalityId,
            rarity: rarity,
            specialTrait: specialTrait,
            voiceType: voiceType,
            openness: openness,
            conscientiousness: conscientiousness,
            extraversion: extraversion,
            agreeableness: agreeableness,
            neuroticism: neuroticism,
            startingFame: startingFame,
            recruitStatus: recruitStatus,
            claimedRole: claimedRole,
            bioSnippet: bioSnippet,
            isVocalRevealed: isVocalRevealed,
            isDanceRevealed: isDanceRevealed,
            isRapRevealed: isRapRevealed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required String name,
            Value<String?> imagePath = const Value.absent(),
            Value<int> cohortMonth = const Value.absent(),
            required int vocalSkill,
            required int danceSkill,
            required int rapSkill,
            Value<int> vocalPotential = const Value.absent(),
            Value<int> dancePotential = const Value.absent(),
            Value<int> rapPotential = const Value.absent(),
            Value<String> primaryDiscipline = const Value.absent(),
            Value<int> auditionScore = const Value.absent(),
            required int visualScore,
            required int charisma,
            required int staminaBase,
            required int personalityId,
            required String rarity,
            Value<String?> specialTrait = const Value.absent(),
            Value<String?> voiceType = const Value.absent(),
            Value<int> openness = const Value.absent(),
            Value<int> conscientiousness = const Value.absent(),
            Value<int> extraversion = const Value.absent(),
            Value<int> agreeableness = const Value.absent(),
            Value<int> neuroticism = const Value.absent(),
            Value<int> startingFame = const Value.absent(),
            Value<String> recruitStatus = const Value.absent(),
            Value<String> claimedRole = const Value.absent(),
            Value<String?> bioSnippet = const Value.absent(),
            Value<bool> isVocalRevealed = const Value.absent(),
            Value<bool> isDanceRevealed = const Value.absent(),
            Value<bool> isRapRevealed = const Value.absent(),
          }) =>
              GeneratedCharactersCompanion.insert(
            id: id,
            careerId: careerId,
            name: name,
            imagePath: imagePath,
            cohortMonth: cohortMonth,
            vocalSkill: vocalSkill,
            danceSkill: danceSkill,
            rapSkill: rapSkill,
            vocalPotential: vocalPotential,
            dancePotential: dancePotential,
            rapPotential: rapPotential,
            primaryDiscipline: primaryDiscipline,
            auditionScore: auditionScore,
            visualScore: visualScore,
            charisma: charisma,
            staminaBase: staminaBase,
            personalityId: personalityId,
            rarity: rarity,
            specialTrait: specialTrait,
            voiceType: voiceType,
            openness: openness,
            conscientiousness: conscientiousness,
            extraversion: extraversion,
            agreeableness: agreeableness,
            neuroticism: neuroticism,
            startingFame: startingFame,
            recruitStatus: recruitStatus,
            claimedRole: claimedRole,
            bioSnippet: bioSnippet,
            isVocalRevealed: isVocalRevealed,
            isDanceRevealed: isDanceRevealed,
            isRapRevealed: isRapRevealed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GeneratedCharactersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {careerId = false,
              personalityId = false,
              playerIdolsRefs = false,
              packPoolItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playerIdolsRefs) db.playerIdols,
                if (packPoolItemsRefs) db.packPoolItems
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$GeneratedCharactersTableReferences._careerIdTable(db),
                    referencedColumn: $$GeneratedCharactersTableReferences
                        ._careerIdTable(db)
                        .id,
                  ) as T;
                }
                if (personalityId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personalityId,
                    referencedTable: $$GeneratedCharactersTableReferences
                        ._personalityIdTable(db),
                    referencedColumn: $$GeneratedCharactersTableReferences
                        ._personalityIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playerIdolsRefs)
                    await $_getPrefetchedData<GeneratedCharacter,
                            $GeneratedCharactersTable, PlayerIdol>(
                        currentTable: table,
                        referencedTable: $$GeneratedCharactersTableReferences
                            ._playerIdolsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GeneratedCharactersTableReferences(db, table, p0)
                                .playerIdolsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.characterId == item.id),
                        typedResults: items),
                  if (packPoolItemsRefs)
                    await $_getPrefetchedData<GeneratedCharacter,
                            $GeneratedCharactersTable, PackPoolItem>(
                        currentTable: table,
                        referencedTable: $$GeneratedCharactersTableReferences
                            ._packPoolItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GeneratedCharactersTableReferences(db, table, p0)
                                .packPoolItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.characterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GeneratedCharactersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GeneratedCharactersTable,
    GeneratedCharacter,
    $$GeneratedCharactersTableFilterComposer,
    $$GeneratedCharactersTableOrderingComposer,
    $$GeneratedCharactersTableAnnotationComposer,
    $$GeneratedCharactersTableCreateCompanionBuilder,
    $$GeneratedCharactersTableUpdateCompanionBuilder,
    (GeneratedCharacter, $$GeneratedCharactersTableReferences),
    GeneratedCharacter,
    PrefetchHooks Function(
        {bool careerId,
        bool personalityId,
        bool playerIdolsRefs,
        bool packPoolItemsRefs})>;
typedef $$CurrencyWalletsTableCreateCompanionBuilder = CurrencyWalletsCompanion
    Function({
  Value<int> id,
  required int careerId,
  Value<int> fanPoints,
  Value<int> premiumGems,
});
typedef $$CurrencyWalletsTableUpdateCompanionBuilder = CurrencyWalletsCompanion
    Function({
  Value<int> id,
  Value<int> careerId,
  Value<int> fanPoints,
  Value<int> premiumGems,
});

final class $$CurrencyWalletsTableReferences extends BaseReferences<
    _$AppDatabase, $CurrencyWalletsTable, CurrencyWallet> {
  $$CurrencyWalletsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('currency_wallets__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CurrencyWalletsTableFilterComposer
    extends Composer<_$AppDatabase, $CurrencyWalletsTable> {
  $$CurrencyWalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fanPoints => $composableBuilder(
      column: $table.fanPoints, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get premiumGems => $composableBuilder(
      column: $table.premiumGems, builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CurrencyWalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrencyWalletsTable> {
  $$CurrencyWalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fanPoints => $composableBuilder(
      column: $table.fanPoints, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get premiumGems => $composableBuilder(
      column: $table.premiumGems, builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CurrencyWalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrencyWalletsTable> {
  $$CurrencyWalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fanPoints =>
      $composableBuilder(column: $table.fanPoints, builder: (column) => column);

  GeneratedColumn<int> get premiumGems => $composableBuilder(
      column: $table.premiumGems, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CurrencyWalletsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrencyWalletsTable,
    CurrencyWallet,
    $$CurrencyWalletsTableFilterComposer,
    $$CurrencyWalletsTableOrderingComposer,
    $$CurrencyWalletsTableAnnotationComposer,
    $$CurrencyWalletsTableCreateCompanionBuilder,
    $$CurrencyWalletsTableUpdateCompanionBuilder,
    (CurrencyWallet, $$CurrencyWalletsTableReferences),
    CurrencyWallet,
    PrefetchHooks Function({bool careerId})> {
  $$CurrencyWalletsTableTableManager(
      _$AppDatabase db, $CurrencyWalletsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrencyWalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrencyWalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrencyWalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<int> fanPoints = const Value.absent(),
            Value<int> premiumGems = const Value.absent(),
          }) =>
              CurrencyWalletsCompanion(
            id: id,
            careerId: careerId,
            fanPoints: fanPoints,
            premiumGems: premiumGems,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            Value<int> fanPoints = const Value.absent(),
            Value<int> premiumGems = const Value.absent(),
          }) =>
              CurrencyWalletsCompanion.insert(
            id: id,
            careerId: careerId,
            fanPoints: fanPoints,
            premiumGems: premiumGems,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CurrencyWalletsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$CurrencyWalletsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$CurrencyWalletsTableReferences._careerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CurrencyWalletsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrencyWalletsTable,
    CurrencyWallet,
    $$CurrencyWalletsTableFilterComposer,
    $$CurrencyWalletsTableOrderingComposer,
    $$CurrencyWalletsTableAnnotationComposer,
    $$CurrencyWalletsTableCreateCompanionBuilder,
    $$CurrencyWalletsTableUpdateCompanionBuilder,
    (CurrencyWallet, $$CurrencyWalletsTableReferences),
    CurrencyWallet,
    PrefetchHooks Function({bool careerId})>;
typedef $$CareerHistoriesTableCreateCompanionBuilder = CareerHistoriesCompanion
    Function({
  Value<int> id,
  required int careerId,
  required int careerNumber,
  Value<String?> groupName,
  Value<int?> finalPopularity,
  Value<int?> monthsPlayed,
  Value<int?> peakChartPosition,
  Value<int?> finalScore,
  Value<int> awardsWon,
  Value<String?> agencyName,
  Value<String?> unlockedLegacyBonus,
});
typedef $$CareerHistoriesTableUpdateCompanionBuilder = CareerHistoriesCompanion
    Function({
  Value<int> id,
  Value<int> careerId,
  Value<int> careerNumber,
  Value<String?> groupName,
  Value<int?> finalPopularity,
  Value<int?> monthsPlayed,
  Value<int?> peakChartPosition,
  Value<int?> finalScore,
  Value<int> awardsWon,
  Value<String?> agencyName,
  Value<String?> unlockedLegacyBonus,
});

final class $$CareerHistoriesTableReferences extends BaseReferences<
    _$AppDatabase, $CareerHistoriesTable, CareerHistory> {
  $$CareerHistoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('career_histories__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CareerHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CareerHistoriesTable> {
  $$CareerHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get careerNumber => $composableBuilder(
      column: $table.careerNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get finalPopularity => $composableBuilder(
      column: $table.finalPopularity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthsPlayed => $composableBuilder(
      column: $table.monthsPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get peakChartPosition => $composableBuilder(
      column: $table.peakChartPosition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get awardsWon => $composableBuilder(
      column: $table.awardsWon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agencyName => $composableBuilder(
      column: $table.agencyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unlockedLegacyBonus => $composableBuilder(
      column: $table.unlockedLegacyBonus,
      builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CareerHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CareerHistoriesTable> {
  $$CareerHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get careerNumber => $composableBuilder(
      column: $table.careerNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get finalPopularity => $composableBuilder(
      column: $table.finalPopularity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthsPlayed => $composableBuilder(
      column: $table.monthsPlayed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get peakChartPosition => $composableBuilder(
      column: $table.peakChartPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get awardsWon => $composableBuilder(
      column: $table.awardsWon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agencyName => $composableBuilder(
      column: $table.agencyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unlockedLegacyBonus => $composableBuilder(
      column: $table.unlockedLegacyBonus,
      builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CareerHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareerHistoriesTable> {
  $$CareerHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get careerNumber => $composableBuilder(
      column: $table.careerNumber, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<int> get finalPopularity => $composableBuilder(
      column: $table.finalPopularity, builder: (column) => column);

  GeneratedColumn<int> get monthsPlayed => $composableBuilder(
      column: $table.monthsPlayed, builder: (column) => column);

  GeneratedColumn<int> get peakChartPosition => $composableBuilder(
      column: $table.peakChartPosition, builder: (column) => column);

  GeneratedColumn<int> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => column);

  GeneratedColumn<int> get awardsWon =>
      $composableBuilder(column: $table.awardsWon, builder: (column) => column);

  GeneratedColumn<String> get agencyName => $composableBuilder(
      column: $table.agencyName, builder: (column) => column);

  GeneratedColumn<String> get unlockedLegacyBonus => $composableBuilder(
      column: $table.unlockedLegacyBonus, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CareerHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CareerHistoriesTable,
    CareerHistory,
    $$CareerHistoriesTableFilterComposer,
    $$CareerHistoriesTableOrderingComposer,
    $$CareerHistoriesTableAnnotationComposer,
    $$CareerHistoriesTableCreateCompanionBuilder,
    $$CareerHistoriesTableUpdateCompanionBuilder,
    (CareerHistory, $$CareerHistoriesTableReferences),
    CareerHistory,
    PrefetchHooks Function({bool careerId})> {
  $$CareerHistoriesTableTableManager(
      _$AppDatabase db, $CareerHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareerHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareerHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareerHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<int> careerNumber = const Value.absent(),
            Value<String?> groupName = const Value.absent(),
            Value<int?> finalPopularity = const Value.absent(),
            Value<int?> monthsPlayed = const Value.absent(),
            Value<int?> peakChartPosition = const Value.absent(),
            Value<int?> finalScore = const Value.absent(),
            Value<int> awardsWon = const Value.absent(),
            Value<String?> agencyName = const Value.absent(),
            Value<String?> unlockedLegacyBonus = const Value.absent(),
          }) =>
              CareerHistoriesCompanion(
            id: id,
            careerId: careerId,
            careerNumber: careerNumber,
            groupName: groupName,
            finalPopularity: finalPopularity,
            monthsPlayed: monthsPlayed,
            peakChartPosition: peakChartPosition,
            finalScore: finalScore,
            awardsWon: awardsWon,
            agencyName: agencyName,
            unlockedLegacyBonus: unlockedLegacyBonus,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required int careerNumber,
            Value<String?> groupName = const Value.absent(),
            Value<int?> finalPopularity = const Value.absent(),
            Value<int?> monthsPlayed = const Value.absent(),
            Value<int?> peakChartPosition = const Value.absent(),
            Value<int?> finalScore = const Value.absent(),
            Value<int> awardsWon = const Value.absent(),
            Value<String?> agencyName = const Value.absent(),
            Value<String?> unlockedLegacyBonus = const Value.absent(),
          }) =>
              CareerHistoriesCompanion.insert(
            id: id,
            careerId: careerId,
            careerNumber: careerNumber,
            groupName: groupName,
            finalPopularity: finalPopularity,
            monthsPlayed: monthsPlayed,
            peakChartPosition: peakChartPosition,
            finalScore: finalScore,
            awardsWon: awardsWon,
            agencyName: agencyName,
            unlockedLegacyBonus: unlockedLegacyBonus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CareerHistoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$CareerHistoriesTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$CareerHistoriesTableReferences._careerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CareerHistoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CareerHistoriesTable,
    CareerHistory,
    $$CareerHistoriesTableFilterComposer,
    $$CareerHistoriesTableOrderingComposer,
    $$CareerHistoriesTableAnnotationComposer,
    $$CareerHistoriesTableCreateCompanionBuilder,
    $$CareerHistoriesTableUpdateCompanionBuilder,
    (CareerHistory, $$CareerHistoriesTableReferences),
    CareerHistory,
    PrefetchHooks Function({bool careerId})>;
typedef $$PlayerIdolsTableCreateCompanionBuilder = PlayerIdolsCompanion
    Function({
  Value<int> id,
  required int careerId,
  required int characterId,
  required int recruitedMonth,
  Value<int> currentLevel,
  Value<int> vocalBonus,
  Value<int> danceBonus,
  Value<int> rapBonus,
  Value<int> visualBonus,
  Value<int> charismaBonus,
  Value<int> fatigue,
  Value<int> mood,
  Value<int> loyalty,
  Value<int> popularityBonus,
  Value<int> salaryBonus,
  Value<String> status,
});
typedef $$PlayerIdolsTableUpdateCompanionBuilder = PlayerIdolsCompanion
    Function({
  Value<int> id,
  Value<int> careerId,
  Value<int> characterId,
  Value<int> recruitedMonth,
  Value<int> currentLevel,
  Value<int> vocalBonus,
  Value<int> danceBonus,
  Value<int> rapBonus,
  Value<int> visualBonus,
  Value<int> charismaBonus,
  Value<int> fatigue,
  Value<int> mood,
  Value<int> loyalty,
  Value<int> popularityBonus,
  Value<int> salaryBonus,
  Value<String> status,
});

final class $$PlayerIdolsTableReferences
    extends BaseReferences<_$AppDatabase, $PlayerIdolsTable, PlayerIdol> {
  $$PlayerIdolsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('player_idols__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GeneratedCharactersTable _characterIdTable(_$AppDatabase db) =>
      db.generatedCharacters
          .createAlias('player_idols__character_id__generated_characters__id');

  $$GeneratedCharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager =
        $$GeneratedCharactersTableTableManager($_db, $_db.generatedCharacters)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ChemistryRelationsTable, List<ChemistryRelation>>
      _chemistryAsIdolATable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chemistryRelations,
              aliasName: 'player_idols__id__chemistry_relations__idol_a_id');

  $$ChemistryRelationsTableProcessedTableManager get chemistryAsIdolA {
    final manager =
        $$ChemistryRelationsTableTableManager($_db, $_db.chemistryRelations)
            .filter((f) => f.idolAId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chemistryAsIdolATable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ChemistryRelationsTable, List<ChemistryRelation>>
      _chemistryAsIdolBTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chemistryRelations,
              aliasName: 'player_idols__id__chemistry_relations__idol_b_id');

  $$ChemistryRelationsTableProcessedTableManager get chemistryAsIdolB {
    final manager =
        $$ChemistryRelationsTableTableManager($_db, $_db.chemistryRelations)
            .filter((f) => f.idolBId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chemistryAsIdolBTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMember>>
      _groupMembersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.groupMembers,
              aliasName: 'player_idols__id__group_members__idol_id');

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager($_db, $_db.groupMembers)
        .filter((f) => f.idolId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EventAffectedIdolsTable, List<EventAffectedIdol>>
      _eventAffectedIdolsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.eventAffectedIdols,
              aliasName: 'player_idols__id__event_affected_idols__idol_id');

  $$EventAffectedIdolsTableProcessedTableManager get eventAffectedIdolsRefs {
    final manager =
        $$EventAffectedIdolsTableTableManager($_db, $_db.eventAffectedIdols)
            .filter((f) => f.idolId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_eventAffectedIdolsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlayerIdolsTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerIdolsTable> {
  $$PlayerIdolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recruitedMonth => $composableBuilder(
      column: $table.recruitedMonth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentLevel => $composableBuilder(
      column: $table.currentLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vocalBonus => $composableBuilder(
      column: $table.vocalBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get danceBonus => $composableBuilder(
      column: $table.danceBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rapBonus => $composableBuilder(
      column: $table.rapBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visualBonus => $composableBuilder(
      column: $table.visualBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get charismaBonus => $composableBuilder(
      column: $table.charismaBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fatigue => $composableBuilder(
      column: $table.fatigue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get loyalty => $composableBuilder(
      column: $table.loyalty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get popularityBonus => $composableBuilder(
      column: $table.popularityBonus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get salaryBonus => $composableBuilder(
      column: $table.salaryBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GeneratedCharactersTableFilterComposer get characterId {
    final $$GeneratedCharactersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.generatedCharacters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GeneratedCharactersTableFilterComposer(
              $db: $db,
              $table: $db.generatedCharacters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> chemistryAsIdolA(
      Expression<bool> Function($$ChemistryRelationsTableFilterComposer f) f) {
    final $$ChemistryRelationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chemistryRelations,
        getReferencedColumn: (t) => t.idolAId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChemistryRelationsTableFilterComposer(
              $db: $db,
              $table: $db.chemistryRelations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> chemistryAsIdolB(
      Expression<bool> Function($$ChemistryRelationsTableFilterComposer f) f) {
    final $$ChemistryRelationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chemistryRelations,
        getReferencedColumn: (t) => t.idolBId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChemistryRelationsTableFilterComposer(
              $db: $db,
              $table: $db.chemistryRelations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> groupMembersRefs(
      Expression<bool> Function($$GroupMembersTableFilterComposer f) f) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.idolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableFilterComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> eventAffectedIdolsRefs(
      Expression<bool> Function($$EventAffectedIdolsTableFilterComposer f) f) {
    final $$EventAffectedIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.eventAffectedIdols,
        getReferencedColumn: (t) => t.idolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventAffectedIdolsTableFilterComposer(
              $db: $db,
              $table: $db.eventAffectedIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlayerIdolsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerIdolsTable> {
  $$PlayerIdolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recruitedMonth => $composableBuilder(
      column: $table.recruitedMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentLevel => $composableBuilder(
      column: $table.currentLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vocalBonus => $composableBuilder(
      column: $table.vocalBonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get danceBonus => $composableBuilder(
      column: $table.danceBonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rapBonus => $composableBuilder(
      column: $table.rapBonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visualBonus => $composableBuilder(
      column: $table.visualBonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get charismaBonus => $composableBuilder(
      column: $table.charismaBonus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fatigue => $composableBuilder(
      column: $table.fatigue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get loyalty => $composableBuilder(
      column: $table.loyalty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get popularityBonus => $composableBuilder(
      column: $table.popularityBonus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get salaryBonus => $composableBuilder(
      column: $table.salaryBonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GeneratedCharactersTableOrderingComposer get characterId {
    final $$GeneratedCharactersTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.characterId,
            referencedTable: $db.generatedCharacters,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GeneratedCharactersTableOrderingComposer(
                  $db: $db,
                  $table: $db.generatedCharacters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PlayerIdolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerIdolsTable> {
  $$PlayerIdolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recruitedMonth => $composableBuilder(
      column: $table.recruitedMonth, builder: (column) => column);

  GeneratedColumn<int> get currentLevel => $composableBuilder(
      column: $table.currentLevel, builder: (column) => column);

  GeneratedColumn<int> get vocalBonus => $composableBuilder(
      column: $table.vocalBonus, builder: (column) => column);

  GeneratedColumn<int> get danceBonus => $composableBuilder(
      column: $table.danceBonus, builder: (column) => column);

  GeneratedColumn<int> get rapBonus =>
      $composableBuilder(column: $table.rapBonus, builder: (column) => column);

  GeneratedColumn<int> get visualBonus => $composableBuilder(
      column: $table.visualBonus, builder: (column) => column);

  GeneratedColumn<int> get charismaBonus => $composableBuilder(
      column: $table.charismaBonus, builder: (column) => column);

  GeneratedColumn<int> get fatigue =>
      $composableBuilder(column: $table.fatigue, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get loyalty =>
      $composableBuilder(column: $table.loyalty, builder: (column) => column);

  GeneratedColumn<int> get popularityBonus => $composableBuilder(
      column: $table.popularityBonus, builder: (column) => column);

  GeneratedColumn<int> get salaryBonus => $composableBuilder(
      column: $table.salaryBonus, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GeneratedCharactersTableAnnotationComposer get characterId {
    final $$GeneratedCharactersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.characterId,
            referencedTable: $db.generatedCharacters,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GeneratedCharactersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.generatedCharacters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> chemistryAsIdolA<T extends Object>(
      Expression<T> Function($$ChemistryRelationsTableAnnotationComposer a) f) {
    final $$ChemistryRelationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.chemistryRelations,
            getReferencedColumn: (t) => t.idolAId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ChemistryRelationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.chemistryRelations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> chemistryAsIdolB<T extends Object>(
      Expression<T> Function($$ChemistryRelationsTableAnnotationComposer a) f) {
    final $$ChemistryRelationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.chemistryRelations,
            getReferencedColumn: (t) => t.idolBId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ChemistryRelationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.chemistryRelations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> groupMembersRefs<T extends Object>(
      Expression<T> Function($$GroupMembersTableAnnotationComposer a) f) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.idolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> eventAffectedIdolsRefs<T extends Object>(
      Expression<T> Function($$EventAffectedIdolsTableAnnotationComposer a) f) {
    final $$EventAffectedIdolsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.eventAffectedIdols,
            getReferencedColumn: (t) => t.idolId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EventAffectedIdolsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.eventAffectedIdols,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PlayerIdolsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayerIdolsTable,
    PlayerIdol,
    $$PlayerIdolsTableFilterComposer,
    $$PlayerIdolsTableOrderingComposer,
    $$PlayerIdolsTableAnnotationComposer,
    $$PlayerIdolsTableCreateCompanionBuilder,
    $$PlayerIdolsTableUpdateCompanionBuilder,
    (PlayerIdol, $$PlayerIdolsTableReferences),
    PlayerIdol,
    PrefetchHooks Function(
        {bool careerId,
        bool characterId,
        bool chemistryAsIdolA,
        bool chemistryAsIdolB,
        bool groupMembersRefs,
        bool eventAffectedIdolsRefs})> {
  $$PlayerIdolsTableTableManager(_$AppDatabase db, $PlayerIdolsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerIdolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerIdolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerIdolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<int> characterId = const Value.absent(),
            Value<int> recruitedMonth = const Value.absent(),
            Value<int> currentLevel = const Value.absent(),
            Value<int> vocalBonus = const Value.absent(),
            Value<int> danceBonus = const Value.absent(),
            Value<int> rapBonus = const Value.absent(),
            Value<int> visualBonus = const Value.absent(),
            Value<int> charismaBonus = const Value.absent(),
            Value<int> fatigue = const Value.absent(),
            Value<int> mood = const Value.absent(),
            Value<int> loyalty = const Value.absent(),
            Value<int> popularityBonus = const Value.absent(),
            Value<int> salaryBonus = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              PlayerIdolsCompanion(
            id: id,
            careerId: careerId,
            characterId: characterId,
            recruitedMonth: recruitedMonth,
            currentLevel: currentLevel,
            vocalBonus: vocalBonus,
            danceBonus: danceBonus,
            rapBonus: rapBonus,
            visualBonus: visualBonus,
            charismaBonus: charismaBonus,
            fatigue: fatigue,
            mood: mood,
            loyalty: loyalty,
            popularityBonus: popularityBonus,
            salaryBonus: salaryBonus,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required int characterId,
            required int recruitedMonth,
            Value<int> currentLevel = const Value.absent(),
            Value<int> vocalBonus = const Value.absent(),
            Value<int> danceBonus = const Value.absent(),
            Value<int> rapBonus = const Value.absent(),
            Value<int> visualBonus = const Value.absent(),
            Value<int> charismaBonus = const Value.absent(),
            Value<int> fatigue = const Value.absent(),
            Value<int> mood = const Value.absent(),
            Value<int> loyalty = const Value.absent(),
            Value<int> popularityBonus = const Value.absent(),
            Value<int> salaryBonus = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              PlayerIdolsCompanion.insert(
            id: id,
            careerId: careerId,
            characterId: characterId,
            recruitedMonth: recruitedMonth,
            currentLevel: currentLevel,
            vocalBonus: vocalBonus,
            danceBonus: danceBonus,
            rapBonus: rapBonus,
            visualBonus: visualBonus,
            charismaBonus: charismaBonus,
            fatigue: fatigue,
            mood: mood,
            loyalty: loyalty,
            popularityBonus: popularityBonus,
            salaryBonus: salaryBonus,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlayerIdolsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {careerId = false,
              characterId = false,
              chemistryAsIdolA = false,
              chemistryAsIdolB = false,
              groupMembersRefs = false,
              eventAffectedIdolsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chemistryAsIdolA) db.chemistryRelations,
                if (chemistryAsIdolB) db.chemistryRelations,
                if (groupMembersRefs) db.groupMembers,
                if (eventAffectedIdolsRefs) db.eventAffectedIdols
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$PlayerIdolsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$PlayerIdolsTableReferences._careerIdTable(db).id,
                  ) as T;
                }
                if (characterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.characterId,
                    referencedTable:
                        $$PlayerIdolsTableReferences._characterIdTable(db),
                    referencedColumn:
                        $$PlayerIdolsTableReferences._characterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chemistryAsIdolA)
                    await $_getPrefetchedData<PlayerIdol, $PlayerIdolsTable,
                            ChemistryRelation>(
                        currentTable: table,
                        referencedTable: $$PlayerIdolsTableReferences
                            ._chemistryAsIdolATable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerIdolsTableReferences(db, table, p0)
                                .chemistryAsIdolA,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.idolAId == item.id),
                        typedResults: items),
                  if (chemistryAsIdolB)
                    await $_getPrefetchedData<PlayerIdol, $PlayerIdolsTable,
                            ChemistryRelation>(
                        currentTable: table,
                        referencedTable: $$PlayerIdolsTableReferences
                            ._chemistryAsIdolBTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerIdolsTableReferences(db, table, p0)
                                .chemistryAsIdolB,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.idolBId == item.id),
                        typedResults: items),
                  if (groupMembersRefs)
                    await $_getPrefetchedData<PlayerIdol, $PlayerIdolsTable,
                            GroupMember>(
                        currentTable: table,
                        referencedTable: $$PlayerIdolsTableReferences
                            ._groupMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerIdolsTableReferences(db, table, p0)
                                .groupMembersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.idolId == item.id),
                        typedResults: items),
                  if (eventAffectedIdolsRefs)
                    await $_getPrefetchedData<PlayerIdol, $PlayerIdolsTable,
                            EventAffectedIdol>(
                        currentTable: table,
                        referencedTable: $$PlayerIdolsTableReferences
                            ._eventAffectedIdolsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlayerIdolsTableReferences(db, table, p0)
                                .eventAffectedIdolsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.idolId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlayerIdolsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayerIdolsTable,
    PlayerIdol,
    $$PlayerIdolsTableFilterComposer,
    $$PlayerIdolsTableOrderingComposer,
    $$PlayerIdolsTableAnnotationComposer,
    $$PlayerIdolsTableCreateCompanionBuilder,
    $$PlayerIdolsTableUpdateCompanionBuilder,
    (PlayerIdol, $$PlayerIdolsTableReferences),
    PlayerIdol,
    PrefetchHooks Function(
        {bool careerId,
        bool characterId,
        bool chemistryAsIdolA,
        bool chemistryAsIdolB,
        bool groupMembersRefs,
        bool eventAffectedIdolsRefs})>;
typedef $$ChemistryRelationsTableCreateCompanionBuilder
    = ChemistryRelationsCompanion Function({
  Value<int> id,
  required int idolAId,
  required int idolBId,
  Value<int> chemistryScore,
  Value<String> relationshipType,
  required int lastUpdatedMonth,
});
typedef $$ChemistryRelationsTableUpdateCompanionBuilder
    = ChemistryRelationsCompanion Function({
  Value<int> id,
  Value<int> idolAId,
  Value<int> idolBId,
  Value<int> chemistryScore,
  Value<String> relationshipType,
  Value<int> lastUpdatedMonth,
});

final class $$ChemistryRelationsTableReferences extends BaseReferences<
    _$AppDatabase, $ChemistryRelationsTable, ChemistryRelation> {
  $$ChemistryRelationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PlayerIdolsTable _idolAIdTable(_$AppDatabase db) => db.playerIdols
      .createAlias('chemistry_relations__idol_a_id__player_idols__id');

  $$PlayerIdolsTableProcessedTableManager get idolAId {
    final $_column = $_itemColumn<int>('idol_a_id')!;

    final manager = $$PlayerIdolsTableTableManager($_db, $_db.playerIdols)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idolAIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PlayerIdolsTable _idolBIdTable(_$AppDatabase db) => db.playerIdols
      .createAlias('chemistry_relations__idol_b_id__player_idols__id');

  $$PlayerIdolsTableProcessedTableManager get idolBId {
    final $_column = $_itemColumn<int>('idol_b_id')!;

    final manager = $$PlayerIdolsTableTableManager($_db, $_db.playerIdols)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idolBIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChemistryRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $ChemistryRelationsTable> {
  $$ChemistryRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chemistryScore => $composableBuilder(
      column: $table.chemistryScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationshipType => $composableBuilder(
      column: $table.relationshipType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedMonth => $composableBuilder(
      column: $table.lastUpdatedMonth,
      builder: (column) => ColumnFilters(column));

  $$PlayerIdolsTableFilterComposer get idolAId {
    final $$PlayerIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolAId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableFilterComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableFilterComposer get idolBId {
    final $$PlayerIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolBId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableFilterComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChemistryRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChemistryRelationsTable> {
  $$ChemistryRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chemistryScore => $composableBuilder(
      column: $table.chemistryScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationshipType => $composableBuilder(
      column: $table.relationshipType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedMonth => $composableBuilder(
      column: $table.lastUpdatedMonth,
      builder: (column) => ColumnOrderings(column));

  $$PlayerIdolsTableOrderingComposer get idolAId {
    final $$PlayerIdolsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolAId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableOrderingComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableOrderingComposer get idolBId {
    final $$PlayerIdolsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolBId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableOrderingComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChemistryRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChemistryRelationsTable> {
  $$ChemistryRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chemistryScore => $composableBuilder(
      column: $table.chemistryScore, builder: (column) => column);

  GeneratedColumn<String> get relationshipType => $composableBuilder(
      column: $table.relationshipType, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedMonth => $composableBuilder(
      column: $table.lastUpdatedMonth, builder: (column) => column);

  $$PlayerIdolsTableAnnotationComposer get idolAId {
    final $$PlayerIdolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolAId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableAnnotationComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableAnnotationComposer get idolBId {
    final $$PlayerIdolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolBId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableAnnotationComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChemistryRelationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChemistryRelationsTable,
    ChemistryRelation,
    $$ChemistryRelationsTableFilterComposer,
    $$ChemistryRelationsTableOrderingComposer,
    $$ChemistryRelationsTableAnnotationComposer,
    $$ChemistryRelationsTableCreateCompanionBuilder,
    $$ChemistryRelationsTableUpdateCompanionBuilder,
    (ChemistryRelation, $$ChemistryRelationsTableReferences),
    ChemistryRelation,
    PrefetchHooks Function({bool idolAId, bool idolBId})> {
  $$ChemistryRelationsTableTableManager(
      _$AppDatabase db, $ChemistryRelationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChemistryRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChemistryRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChemistryRelationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> idolAId = const Value.absent(),
            Value<int> idolBId = const Value.absent(),
            Value<int> chemistryScore = const Value.absent(),
            Value<String> relationshipType = const Value.absent(),
            Value<int> lastUpdatedMonth = const Value.absent(),
          }) =>
              ChemistryRelationsCompanion(
            id: id,
            idolAId: idolAId,
            idolBId: idolBId,
            chemistryScore: chemistryScore,
            relationshipType: relationshipType,
            lastUpdatedMonth: lastUpdatedMonth,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int idolAId,
            required int idolBId,
            Value<int> chemistryScore = const Value.absent(),
            Value<String> relationshipType = const Value.absent(),
            required int lastUpdatedMonth,
          }) =>
              ChemistryRelationsCompanion.insert(
            id: id,
            idolAId: idolAId,
            idolBId: idolBId,
            chemistryScore: chemistryScore,
            relationshipType: relationshipType,
            lastUpdatedMonth: lastUpdatedMonth,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChemistryRelationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({idolAId = false, idolBId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (idolAId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.idolAId,
                    referencedTable:
                        $$ChemistryRelationsTableReferences._idolAIdTable(db),
                    referencedColumn: $$ChemistryRelationsTableReferences
                        ._idolAIdTable(db)
                        .id,
                  ) as T;
                }
                if (idolBId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.idolBId,
                    referencedTable:
                        $$ChemistryRelationsTableReferences._idolBIdTable(db),
                    referencedColumn: $$ChemistryRelationsTableReferences
                        ._idolBIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChemistryRelationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChemistryRelationsTable,
    ChemistryRelation,
    $$ChemistryRelationsTableFilterComposer,
    $$ChemistryRelationsTableOrderingComposer,
    $$ChemistryRelationsTableAnnotationComposer,
    $$ChemistryRelationsTableCreateCompanionBuilder,
    $$ChemistryRelationsTableUpdateCompanionBuilder,
    (ChemistryRelation, $$ChemistryRelationsTableReferences),
    ChemistryRelation,
    PrefetchHooks Function({bool idolAId, bool idolBId})>;
typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  Value<int> id,
  required int careerId,
  required String groupName,
  required int formationMonth,
  Value<int> totalPopularity,
  Value<int> fanbaseSize,
  Value<String?> logoPath,
  Value<String> status,
  Value<int> reputation,
  Value<int> socialFollowers,
  Value<int> scandalHeat,
  Value<int?> lastConcertMonth,
  Value<int?> lastTourMonth,
  Value<int?> lastReleaseMonth,
  Value<String?> sponsorName,
  Value<int> sponsorIncome,
  Value<int> sponsorMonthsLeft,
  Value<String?> fandomName,
  Value<int> fandomLoyalty,
  Value<int> lastFollowerDelta,
  Value<int> rodezFeud,
  Value<int?> lastRodezMonth,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<int> id,
  Value<int> careerId,
  Value<String> groupName,
  Value<int> formationMonth,
  Value<int> totalPopularity,
  Value<int> fanbaseSize,
  Value<String?> logoPath,
  Value<String> status,
  Value<int> reputation,
  Value<int> socialFollowers,
  Value<int> scandalHeat,
  Value<int?> lastConcertMonth,
  Value<int?> lastTourMonth,
  Value<int?> lastReleaseMonth,
  Value<String?> sponsorName,
  Value<int> sponsorIncome,
  Value<int> sponsorMonthsLeft,
  Value<String?> fandomName,
  Value<int> fandomLoyalty,
  Value<int> lastFollowerDelta,
  Value<int> rodezFeud,
  Value<int?> lastRodezMonth,
});

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers.createAlias('groups__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMember>>
      _groupMembersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.groupMembers,
              aliasName: 'groups__id__group_members__group_id');

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager($_db, $_db.groupMembers)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SongsTable, List<Song>> _songsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.songs,
          aliasName: 'groups__id__songs__group_id');

  $$SongsTableProcessedTableManager get songsRefs {
    final manager = $$SongsTableTableManager($_db, $_db.songs)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_songsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AlbumsTable, List<Album>> _albumsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.albums,
          aliasName: 'groups__id__albums__group_id');

  $$AlbumsTableProcessedTableManager get albumsRefs {
    final manager = $$AlbumsTableTableManager($_db, $_db.albums)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_albumsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.events,
          aliasName: 'groups__id__events__group_id');

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MonthlyStatsTable, List<MonthlyStat>>
      _monthlyStatsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.monthlyStats,
              aliasName: 'groups__id__monthly_stats__group_id');

  $$MonthlyStatsTableProcessedTableManager get monthlyStatsRefs {
    final manager = $$MonthlyStatsTableTableManager($_db, $_db.monthlyStats)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_monthlyStatsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get formationMonth => $composableBuilder(
      column: $table.formationMonth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPopularity => $composableBuilder(
      column: $table.totalPopularity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fanbaseSize => $composableBuilder(
      column: $table.fanbaseSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reputation => $composableBuilder(
      column: $table.reputation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get socialFollowers => $composableBuilder(
      column: $table.socialFollowers,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scandalHeat => $composableBuilder(
      column: $table.scandalHeat, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastConcertMonth => $composableBuilder(
      column: $table.lastConcertMonth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastTourMonth => $composableBuilder(
      column: $table.lastTourMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastReleaseMonth => $composableBuilder(
      column: $table.lastReleaseMonth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sponsorName => $composableBuilder(
      column: $table.sponsorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sponsorIncome => $composableBuilder(
      column: $table.sponsorIncome, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sponsorMonthsLeft => $composableBuilder(
      column: $table.sponsorMonthsLeft,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fandomName => $composableBuilder(
      column: $table.fandomName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fandomLoyalty => $composableBuilder(
      column: $table.fandomLoyalty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastFollowerDelta => $composableBuilder(
      column: $table.lastFollowerDelta,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rodezFeud => $composableBuilder(
      column: $table.rodezFeud, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastRodezMonth => $composableBuilder(
      column: $table.lastRodezMonth,
      builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> groupMembersRefs(
      Expression<bool> Function($$GroupMembersTableFilterComposer f) f) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableFilterComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> songsRefs(
      Expression<bool> Function($$SongsTableFilterComposer f) f) {
    final $$SongsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableFilterComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> albumsRefs(
      Expression<bool> Function($$AlbumsTableFilterComposer f) f) {
    final $$AlbumsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.albums,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlbumsTableFilterComposer(
              $db: $db,
              $table: $db.albums,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> eventsRefs(
      Expression<bool> Function($$EventsTableFilterComposer f) f) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monthlyStatsRefs(
      Expression<bool> Function($$MonthlyStatsTableFilterComposer f) f) {
    final $$MonthlyStatsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyStats,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonthlyStatsTableFilterComposer(
              $db: $db,
              $table: $db.monthlyStats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get formationMonth => $composableBuilder(
      column: $table.formationMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPopularity => $composableBuilder(
      column: $table.totalPopularity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fanbaseSize => $composableBuilder(
      column: $table.fanbaseSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reputation => $composableBuilder(
      column: $table.reputation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get socialFollowers => $composableBuilder(
      column: $table.socialFollowers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scandalHeat => $composableBuilder(
      column: $table.scandalHeat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastConcertMonth => $composableBuilder(
      column: $table.lastConcertMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastTourMonth => $composableBuilder(
      column: $table.lastTourMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastReleaseMonth => $composableBuilder(
      column: $table.lastReleaseMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sponsorName => $composableBuilder(
      column: $table.sponsorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sponsorIncome => $composableBuilder(
      column: $table.sponsorIncome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sponsorMonthsLeft => $composableBuilder(
      column: $table.sponsorMonthsLeft,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fandomName => $composableBuilder(
      column: $table.fandomName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fandomLoyalty => $composableBuilder(
      column: $table.fandomLoyalty,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastFollowerDelta => $composableBuilder(
      column: $table.lastFollowerDelta,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rodezFeud => $composableBuilder(
      column: $table.rodezFeud, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastRodezMonth => $composableBuilder(
      column: $table.lastRodezMonth,
      builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<int> get formationMonth => $composableBuilder(
      column: $table.formationMonth, builder: (column) => column);

  GeneratedColumn<int> get totalPopularity => $composableBuilder(
      column: $table.totalPopularity, builder: (column) => column);

  GeneratedColumn<int> get fanbaseSize => $composableBuilder(
      column: $table.fanbaseSize, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get reputation => $composableBuilder(
      column: $table.reputation, builder: (column) => column);

  GeneratedColumn<int> get socialFollowers => $composableBuilder(
      column: $table.socialFollowers, builder: (column) => column);

  GeneratedColumn<int> get scandalHeat => $composableBuilder(
      column: $table.scandalHeat, builder: (column) => column);

  GeneratedColumn<int> get lastConcertMonth => $composableBuilder(
      column: $table.lastConcertMonth, builder: (column) => column);

  GeneratedColumn<int> get lastTourMonth => $composableBuilder(
      column: $table.lastTourMonth, builder: (column) => column);

  GeneratedColumn<int> get lastReleaseMonth => $composableBuilder(
      column: $table.lastReleaseMonth, builder: (column) => column);

  GeneratedColumn<String> get sponsorName => $composableBuilder(
      column: $table.sponsorName, builder: (column) => column);

  GeneratedColumn<int> get sponsorIncome => $composableBuilder(
      column: $table.sponsorIncome, builder: (column) => column);

  GeneratedColumn<int> get sponsorMonthsLeft => $composableBuilder(
      column: $table.sponsorMonthsLeft, builder: (column) => column);

  GeneratedColumn<String> get fandomName => $composableBuilder(
      column: $table.fandomName, builder: (column) => column);

  GeneratedColumn<int> get fandomLoyalty => $composableBuilder(
      column: $table.fandomLoyalty, builder: (column) => column);

  GeneratedColumn<int> get lastFollowerDelta => $composableBuilder(
      column: $table.lastFollowerDelta, builder: (column) => column);

  GeneratedColumn<int> get rodezFeud =>
      $composableBuilder(column: $table.rodezFeud, builder: (column) => column);

  GeneratedColumn<int> get lastRodezMonth => $composableBuilder(
      column: $table.lastRodezMonth, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> groupMembersRefs<T extends Object>(
      Expression<T> Function($$GroupMembersTableAnnotationComposer a) f) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> songsRefs<T extends Object>(
      Expression<T> Function($$SongsTableAnnotationComposer a) f) {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableAnnotationComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> albumsRefs<T extends Object>(
      Expression<T> Function($$AlbumsTableAnnotationComposer a) f) {
    final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.albums,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlbumsTableAnnotationComposer(
              $db: $db,
              $table: $db.albums,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> eventsRefs<T extends Object>(
      Expression<T> Function($$EventsTableAnnotationComposer a) f) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monthlyStatsRefs<T extends Object>(
      Expression<T> Function($$MonthlyStatsTableAnnotationComposer a) f) {
    final $$MonthlyStatsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyStats,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonthlyStatsTableAnnotationComposer(
              $db: $db,
              $table: $db.monthlyStats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function(
        {bool careerId,
        bool groupMembersRefs,
        bool songsRefs,
        bool albumsRefs,
        bool eventsRefs,
        bool monthlyStatsRefs})> {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<String> groupName = const Value.absent(),
            Value<int> formationMonth = const Value.absent(),
            Value<int> totalPopularity = const Value.absent(),
            Value<int> fanbaseSize = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> reputation = const Value.absent(),
            Value<int> socialFollowers = const Value.absent(),
            Value<int> scandalHeat = const Value.absent(),
            Value<int?> lastConcertMonth = const Value.absent(),
            Value<int?> lastTourMonth = const Value.absent(),
            Value<int?> lastReleaseMonth = const Value.absent(),
            Value<String?> sponsorName = const Value.absent(),
            Value<int> sponsorIncome = const Value.absent(),
            Value<int> sponsorMonthsLeft = const Value.absent(),
            Value<String?> fandomName = const Value.absent(),
            Value<int> fandomLoyalty = const Value.absent(),
            Value<int> lastFollowerDelta = const Value.absent(),
            Value<int> rodezFeud = const Value.absent(),
            Value<int?> lastRodezMonth = const Value.absent(),
          }) =>
              GroupsCompanion(
            id: id,
            careerId: careerId,
            groupName: groupName,
            formationMonth: formationMonth,
            totalPopularity: totalPopularity,
            fanbaseSize: fanbaseSize,
            logoPath: logoPath,
            status: status,
            reputation: reputation,
            socialFollowers: socialFollowers,
            scandalHeat: scandalHeat,
            lastConcertMonth: lastConcertMonth,
            lastTourMonth: lastTourMonth,
            lastReleaseMonth: lastReleaseMonth,
            sponsorName: sponsorName,
            sponsorIncome: sponsorIncome,
            sponsorMonthsLeft: sponsorMonthsLeft,
            fandomName: fandomName,
            fandomLoyalty: fandomLoyalty,
            lastFollowerDelta: lastFollowerDelta,
            rodezFeud: rodezFeud,
            lastRodezMonth: lastRodezMonth,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required String groupName,
            required int formationMonth,
            Value<int> totalPopularity = const Value.absent(),
            Value<int> fanbaseSize = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> reputation = const Value.absent(),
            Value<int> socialFollowers = const Value.absent(),
            Value<int> scandalHeat = const Value.absent(),
            Value<int?> lastConcertMonth = const Value.absent(),
            Value<int?> lastTourMonth = const Value.absent(),
            Value<int?> lastReleaseMonth = const Value.absent(),
            Value<String?> sponsorName = const Value.absent(),
            Value<int> sponsorIncome = const Value.absent(),
            Value<int> sponsorMonthsLeft = const Value.absent(),
            Value<String?> fandomName = const Value.absent(),
            Value<int> fandomLoyalty = const Value.absent(),
            Value<int> lastFollowerDelta = const Value.absent(),
            Value<int> rodezFeud = const Value.absent(),
            Value<int?> lastRodezMonth = const Value.absent(),
          }) =>
              GroupsCompanion.insert(
            id: id,
            careerId: careerId,
            groupName: groupName,
            formationMonth: formationMonth,
            totalPopularity: totalPopularity,
            fanbaseSize: fanbaseSize,
            logoPath: logoPath,
            status: status,
            reputation: reputation,
            socialFollowers: socialFollowers,
            scandalHeat: scandalHeat,
            lastConcertMonth: lastConcertMonth,
            lastTourMonth: lastTourMonth,
            lastReleaseMonth: lastReleaseMonth,
            sponsorName: sponsorName,
            sponsorIncome: sponsorIncome,
            sponsorMonthsLeft: sponsorMonthsLeft,
            fandomName: fandomName,
            fandomLoyalty: fandomLoyalty,
            lastFollowerDelta: lastFollowerDelta,
            rodezFeud: rodezFeud,
            lastRodezMonth: lastRodezMonth,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GroupsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {careerId = false,
              groupMembersRefs = false,
              songsRefs = false,
              albumsRefs = false,
              eventsRefs = false,
              monthlyStatsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (groupMembersRefs) db.groupMembers,
                if (songsRefs) db.songs,
                if (albumsRefs) db.albums,
                if (eventsRefs) db.events,
                if (monthlyStatsRefs) db.monthlyStats
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable: $$GroupsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$GroupsTableReferences._careerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupMembersRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, GroupMember>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._groupMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0)
                                .groupMembersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (songsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, Song>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._songsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0).songsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (albumsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, Album>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._albumsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0).albumsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (eventsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, Event>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._eventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0).eventsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (monthlyStatsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, MonthlyStat>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._monthlyStatsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0)
                                .monthlyStatsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function(
        {bool careerId,
        bool groupMembersRefs,
        bool songsRefs,
        bool albumsRefs,
        bool eventsRefs,
        bool monthlyStatsRefs})>;
typedef $$GroupMembersTableCreateCompanionBuilder = GroupMembersCompanion
    Function({
  Value<int> id,
  required int groupId,
  required int idolId,
  required String position,
  required int joinMonth,
  Value<int?> leaveMonth,
});
typedef $$GroupMembersTableUpdateCompanionBuilder = GroupMembersCompanion
    Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> idolId,
  Value<String> position,
  Value<int> joinMonth,
  Value<int?> leaveMonth,
});

final class $$GroupMembersTableReferences
    extends BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMember> {
  $$GroupMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_members__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PlayerIdolsTable _idolIdTable(_$AppDatabase db) =>
      db.playerIdols.createAlias('group_members__idol_id__player_idols__id');

  $$PlayerIdolsTableProcessedTableManager get idolId {
    final $_column = $_itemColumn<int>('idol_id')!;

    final manager = $$PlayerIdolsTableTableManager($_db, $_db.playerIdols)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get joinMonth => $composableBuilder(
      column: $table.joinMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get leaveMonth => $composableBuilder(
      column: $table.leaveMonth, builder: (column) => ColumnFilters(column));

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableFilterComposer get idolId {
    final $$PlayerIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableFilterComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get joinMonth => $composableBuilder(
      column: $table.joinMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get leaveMonth => $composableBuilder(
      column: $table.leaveMonth, builder: (column) => ColumnOrderings(column));

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableOrderingComposer get idolId {
    final $$PlayerIdolsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableOrderingComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get joinMonth =>
      $composableBuilder(column: $table.joinMonth, builder: (column) => column);

  GeneratedColumn<int> get leaveMonth => $composableBuilder(
      column: $table.leaveMonth, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableAnnotationComposer get idolId {
    final $$PlayerIdolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableAnnotationComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupMembersTable,
    GroupMember,
    $$GroupMembersTableFilterComposer,
    $$GroupMembersTableOrderingComposer,
    $$GroupMembersTableAnnotationComposer,
    $$GroupMembersTableCreateCompanionBuilder,
    $$GroupMembersTableUpdateCompanionBuilder,
    (GroupMember, $$GroupMembersTableReferences),
    GroupMember,
    PrefetchHooks Function({bool groupId, bool idolId})> {
  $$GroupMembersTableTableManager(_$AppDatabase db, $GroupMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> idolId = const Value.absent(),
            Value<String> position = const Value.absent(),
            Value<int> joinMonth = const Value.absent(),
            Value<int?> leaveMonth = const Value.absent(),
          }) =>
              GroupMembersCompanion(
            id: id,
            groupId: groupId,
            idolId: idolId,
            position: position,
            joinMonth: joinMonth,
            leaveMonth: leaveMonth,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int idolId,
            required String position,
            required int joinMonth,
            Value<int?> leaveMonth = const Value.absent(),
          }) =>
              GroupMembersCompanion.insert(
            id: id,
            groupId: groupId,
            idolId: idolId,
            position: position,
            joinMonth: joinMonth,
            leaveMonth: leaveMonth,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GroupMembersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({groupId = false, idolId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$GroupMembersTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$GroupMembersTableReferences._groupIdTable(db).id,
                  ) as T;
                }
                if (idolId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.idolId,
                    referencedTable:
                        $$GroupMembersTableReferences._idolIdTable(db),
                    referencedColumn:
                        $$GroupMembersTableReferences._idolIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GroupMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupMembersTable,
    GroupMember,
    $$GroupMembersTableFilterComposer,
    $$GroupMembersTableOrderingComposer,
    $$GroupMembersTableAnnotationComposer,
    $$GroupMembersTableCreateCompanionBuilder,
    $$GroupMembersTableUpdateCompanionBuilder,
    (GroupMember, $$GroupMembersTableReferences),
    GroupMember,
    PrefetchHooks Function({bool groupId, bool idolId})>;
typedef $$SongsTableCreateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  required int groupId,
  required String title,
  Value<String?> genre,
  required int releaseMonth,
  Value<int?> qualityScore,
  Value<int?> peakChartPosition,
  Value<int?> currentChartPosition,
  Value<int> totalStreams,
  Value<String?> lyricProfile,
  Value<int?> albumId,
});
typedef $$SongsTableUpdateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<String> title,
  Value<String?> genre,
  Value<int> releaseMonth,
  Value<int?> qualityScore,
  Value<int?> peakChartPosition,
  Value<int?> currentChartPosition,
  Value<int> totalStreams,
  Value<String?> lyricProfile,
  Value<int?> albumId,
});

final class $$SongsTableReferences
    extends BaseReferences<_$AppDatabase, $SongsTable, Song> {
  $$SongsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('songs__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get releaseMonth => $composableBuilder(
      column: $table.releaseMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qualityScore => $composableBuilder(
      column: $table.qualityScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get peakChartPosition => $composableBuilder(
      column: $table.peakChartPosition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentChartPosition => $composableBuilder(
      column: $table.currentChartPosition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalStreams => $composableBuilder(
      column: $table.totalStreams, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lyricProfile => $composableBuilder(
      column: $table.lyricProfile, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get albumId => $composableBuilder(
      column: $table.albumId, builder: (column) => ColumnFilters(column));

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get releaseMonth => $composableBuilder(
      column: $table.releaseMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qualityScore => $composableBuilder(
      column: $table.qualityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get peakChartPosition => $composableBuilder(
      column: $table.peakChartPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentChartPosition => $composableBuilder(
      column: $table.currentChartPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalStreams => $composableBuilder(
      column: $table.totalStreams,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lyricProfile => $composableBuilder(
      column: $table.lyricProfile,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get albumId => $composableBuilder(
      column: $table.albumId, builder: (column) => ColumnOrderings(column));

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get releaseMonth => $composableBuilder(
      column: $table.releaseMonth, builder: (column) => column);

  GeneratedColumn<int> get qualityScore => $composableBuilder(
      column: $table.qualityScore, builder: (column) => column);

  GeneratedColumn<int> get peakChartPosition => $composableBuilder(
      column: $table.peakChartPosition, builder: (column) => column);

  GeneratedColumn<int> get currentChartPosition => $composableBuilder(
      column: $table.currentChartPosition, builder: (column) => column);

  GeneratedColumn<int> get totalStreams => $composableBuilder(
      column: $table.totalStreams, builder: (column) => column);

  GeneratedColumn<String> get lyricProfile => $composableBuilder(
      column: $table.lyricProfile, builder: (column) => column);

  GeneratedColumn<int> get albumId =>
      $composableBuilder(column: $table.albumId, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SongsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, $$SongsTableReferences),
    Song,
    PrefetchHooks Function({bool groupId})> {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> genre = const Value.absent(),
            Value<int> releaseMonth = const Value.absent(),
            Value<int?> qualityScore = const Value.absent(),
            Value<int?> peakChartPosition = const Value.absent(),
            Value<int?> currentChartPosition = const Value.absent(),
            Value<int> totalStreams = const Value.absent(),
            Value<String?> lyricProfile = const Value.absent(),
            Value<int?> albumId = const Value.absent(),
          }) =>
              SongsCompanion(
            id: id,
            groupId: groupId,
            title: title,
            genre: genre,
            releaseMonth: releaseMonth,
            qualityScore: qualityScore,
            peakChartPosition: peakChartPosition,
            currentChartPosition: currentChartPosition,
            totalStreams: totalStreams,
            lyricProfile: lyricProfile,
            albumId: albumId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required String title,
            Value<String?> genre = const Value.absent(),
            required int releaseMonth,
            Value<int?> qualityScore = const Value.absent(),
            Value<int?> peakChartPosition = const Value.absent(),
            Value<int?> currentChartPosition = const Value.absent(),
            Value<int> totalStreams = const Value.absent(),
            Value<String?> lyricProfile = const Value.absent(),
            Value<int?> albumId = const Value.absent(),
          }) =>
              SongsCompanion.insert(
            id: id,
            groupId: groupId,
            title: title,
            genre: genre,
            releaseMonth: releaseMonth,
            qualityScore: qualityScore,
            peakChartPosition: peakChartPosition,
            currentChartPosition: currentChartPosition,
            totalStreams: totalStreams,
            lyricProfile: lyricProfile,
            albumId: albumId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SongsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable: $$SongsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$SongsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SongsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, $$SongsTableReferences),
    Song,
    PrefetchHooks Function({bool groupId})>;
typedef $$AlbumsTableCreateCompanionBuilder = AlbumsCompanion Function({
  Value<int> id,
  required int groupId,
  required String title,
  required int releaseMonth,
  required int trackCount,
  required int avgQuality,
  Value<int> popBoost,
  Value<String?> concept,
});
typedef $$AlbumsTableUpdateCompanionBuilder = AlbumsCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<String> title,
  Value<int> releaseMonth,
  Value<int> trackCount,
  Value<int> avgQuality,
  Value<int> popBoost,
  Value<String?> concept,
});

final class $$AlbumsTableReferences
    extends BaseReferences<_$AppDatabase, $AlbumsTable, Album> {
  $$AlbumsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('albums__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AlbumsTableFilterComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get releaseMonth => $composableBuilder(
      column: $table.releaseMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get trackCount => $composableBuilder(
      column: $table.trackCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avgQuality => $composableBuilder(
      column: $table.avgQuality, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get popBoost => $composableBuilder(
      column: $table.popBoost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get concept => $composableBuilder(
      column: $table.concept, builder: (column) => ColumnFilters(column));

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlbumsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get releaseMonth => $composableBuilder(
      column: $table.releaseMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get trackCount => $composableBuilder(
      column: $table.trackCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avgQuality => $composableBuilder(
      column: $table.avgQuality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get popBoost => $composableBuilder(
      column: $table.popBoost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get concept => $composableBuilder(
      column: $table.concept, builder: (column) => ColumnOrderings(column));

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlbumsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get releaseMonth => $composableBuilder(
      column: $table.releaseMonth, builder: (column) => column);

  GeneratedColumn<int> get trackCount => $composableBuilder(
      column: $table.trackCount, builder: (column) => column);

  GeneratedColumn<int> get avgQuality => $composableBuilder(
      column: $table.avgQuality, builder: (column) => column);

  GeneratedColumn<int> get popBoost =>
      $composableBuilder(column: $table.popBoost, builder: (column) => column);

  GeneratedColumn<String> get concept =>
      $composableBuilder(column: $table.concept, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlbumsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, $$AlbumsTableReferences),
    Album,
    PrefetchHooks Function({bool groupId})> {
  $$AlbumsTableTableManager(_$AppDatabase db, $AlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> releaseMonth = const Value.absent(),
            Value<int> trackCount = const Value.absent(),
            Value<int> avgQuality = const Value.absent(),
            Value<int> popBoost = const Value.absent(),
            Value<String?> concept = const Value.absent(),
          }) =>
              AlbumsCompanion(
            id: id,
            groupId: groupId,
            title: title,
            releaseMonth: releaseMonth,
            trackCount: trackCount,
            avgQuality: avgQuality,
            popBoost: popBoost,
            concept: concept,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required String title,
            required int releaseMonth,
            required int trackCount,
            required int avgQuality,
            Value<int> popBoost = const Value.absent(),
            Value<String?> concept = const Value.absent(),
          }) =>
              AlbumsCompanion.insert(
            id: id,
            groupId: groupId,
            title: title,
            releaseMonth: releaseMonth,
            trackCount: trackCount,
            avgQuality: avgQuality,
            popBoost: popBoost,
            concept: concept,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AlbumsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable: $$AlbumsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$AlbumsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AlbumsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, $$AlbumsTableReferences),
    Album,
    PrefetchHooks Function({bool groupId})>;
typedef $$AchievementsTableCreateCompanionBuilder = AchievementsCompanion
    Function({
  Value<int> id,
  required int careerId,
  required String achKey,
  required String title,
  required int unlockedAbsMonth,
});
typedef $$AchievementsTableUpdateCompanionBuilder = AchievementsCompanion
    Function({
  Value<int> id,
  Value<int> careerId,
  Value<String> achKey,
  Value<String> title,
  Value<int> unlockedAbsMonth,
});

final class $$AchievementsTableReferences
    extends BaseReferences<_$AppDatabase, $AchievementsTable, Achievement> {
  $$AchievementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('achievements__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get achKey => $composableBuilder(
      column: $table.achKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unlockedAbsMonth => $composableBuilder(
      column: $table.unlockedAbsMonth,
      builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get achKey => $composableBuilder(
      column: $table.achKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unlockedAbsMonth => $composableBuilder(
      column: $table.unlockedAbsMonth,
      builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get achKey =>
      $composableBuilder(column: $table.achKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get unlockedAbsMonth => $composableBuilder(
      column: $table.unlockedAbsMonth, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (Achievement, $$AchievementsTableReferences),
    Achievement,
    PrefetchHooks Function({bool careerId})> {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<String> achKey = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> unlockedAbsMonth = const Value.absent(),
          }) =>
              AchievementsCompanion(
            id: id,
            careerId: careerId,
            achKey: achKey,
            title: title,
            unlockedAbsMonth: unlockedAbsMonth,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required String achKey,
            required String title,
            required int unlockedAbsMonth,
          }) =>
              AchievementsCompanion.insert(
            id: id,
            careerId: careerId,
            achKey: achKey,
            title: title,
            unlockedAbsMonth: unlockedAbsMonth,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AchievementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$AchievementsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$AchievementsTableReferences._careerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AchievementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (Achievement, $$AchievementsTableReferences),
    Achievement,
    PrefetchHooks Function({bool careerId})>;
typedef $$GlobalAchievementsTableCreateCompanionBuilder
    = GlobalAchievementsCompanion Function({
  Value<int> id,
  required String achKey,
  required String title,
  Value<int> unlockedCareerNumber,
});
typedef $$GlobalAchievementsTableUpdateCompanionBuilder
    = GlobalAchievementsCompanion Function({
  Value<int> id,
  Value<String> achKey,
  Value<String> title,
  Value<int> unlockedCareerNumber,
});

class $$GlobalAchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $GlobalAchievementsTable> {
  $$GlobalAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get achKey => $composableBuilder(
      column: $table.achKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unlockedCareerNumber => $composableBuilder(
      column: $table.unlockedCareerNumber,
      builder: (column) => ColumnFilters(column));
}

class $$GlobalAchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $GlobalAchievementsTable> {
  $$GlobalAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get achKey => $composableBuilder(
      column: $table.achKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unlockedCareerNumber => $composableBuilder(
      column: $table.unlockedCareerNumber,
      builder: (column) => ColumnOrderings(column));
}

class $$GlobalAchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GlobalAchievementsTable> {
  $$GlobalAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get achKey =>
      $composableBuilder(column: $table.achKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get unlockedCareerNumber => $composableBuilder(
      column: $table.unlockedCareerNumber, builder: (column) => column);
}

class $$GlobalAchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GlobalAchievementsTable,
    GlobalAchievement,
    $$GlobalAchievementsTableFilterComposer,
    $$GlobalAchievementsTableOrderingComposer,
    $$GlobalAchievementsTableAnnotationComposer,
    $$GlobalAchievementsTableCreateCompanionBuilder,
    $$GlobalAchievementsTableUpdateCompanionBuilder,
    (
      GlobalAchievement,
      BaseReferences<_$AppDatabase, $GlobalAchievementsTable, GlobalAchievement>
    ),
    GlobalAchievement,
    PrefetchHooks Function()> {
  $$GlobalAchievementsTableTableManager(
      _$AppDatabase db, $GlobalAchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GlobalAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GlobalAchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GlobalAchievementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> achKey = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> unlockedCareerNumber = const Value.absent(),
          }) =>
              GlobalAchievementsCompanion(
            id: id,
            achKey: achKey,
            title: title,
            unlockedCareerNumber: unlockedCareerNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String achKey,
            required String title,
            Value<int> unlockedCareerNumber = const Value.absent(),
          }) =>
              GlobalAchievementsCompanion.insert(
            id: id,
            achKey: achKey,
            title: title,
            unlockedCareerNumber: unlockedCareerNumber,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GlobalAchievementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GlobalAchievementsTable,
    GlobalAchievement,
    $$GlobalAchievementsTableFilterComposer,
    $$GlobalAchievementsTableOrderingComposer,
    $$GlobalAchievementsTableAnnotationComposer,
    $$GlobalAchievementsTableCreateCompanionBuilder,
    $$GlobalAchievementsTableUpdateCompanionBuilder,
    (
      GlobalAchievement,
      BaseReferences<_$AppDatabase, $GlobalAchievementsTable, GlobalAchievement>
    ),
    GlobalAchievement,
    PrefetchHooks Function()>;
typedef $$SocialPostsTableCreateCompanionBuilder = SocialPostsCompanion
    Function({
  Value<int> id,
  required int careerId,
  required int absWeek,
  required String postType,
  required String displayName,
  required String handle,
  required String content,
  required String avatarEmoji,
});
typedef $$SocialPostsTableUpdateCompanionBuilder = SocialPostsCompanion
    Function({
  Value<int> id,
  Value<int> careerId,
  Value<int> absWeek,
  Value<String> postType,
  Value<String> displayName,
  Value<String> handle,
  Value<String> content,
  Value<String> avatarEmoji,
});

final class $$SocialPostsTableReferences
    extends BaseReferences<_$AppDatabase, $SocialPostsTable, SocialPost> {
  $$SocialPostsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('social_posts__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SocialPostsTableFilterComposer
    extends Composer<_$AppDatabase, $SocialPostsTable> {
  $$SocialPostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get absWeek => $composableBuilder(
      column: $table.absWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postType => $composableBuilder(
      column: $table.postType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get handle => $composableBuilder(
      column: $table.handle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarEmoji => $composableBuilder(
      column: $table.avatarEmoji, builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SocialPostsTableOrderingComposer
    extends Composer<_$AppDatabase, $SocialPostsTable> {
  $$SocialPostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get absWeek => $composableBuilder(
      column: $table.absWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postType => $composableBuilder(
      column: $table.postType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get handle => $composableBuilder(
      column: $table.handle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarEmoji => $composableBuilder(
      column: $table.avatarEmoji, builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SocialPostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SocialPostsTable> {
  $$SocialPostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get absWeek =>
      $composableBuilder(column: $table.absWeek, builder: (column) => column);

  GeneratedColumn<String> get postType =>
      $composableBuilder(column: $table.postType, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get handle =>
      $composableBuilder(column: $table.handle, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get avatarEmoji => $composableBuilder(
      column: $table.avatarEmoji, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SocialPostsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SocialPostsTable,
    SocialPost,
    $$SocialPostsTableFilterComposer,
    $$SocialPostsTableOrderingComposer,
    $$SocialPostsTableAnnotationComposer,
    $$SocialPostsTableCreateCompanionBuilder,
    $$SocialPostsTableUpdateCompanionBuilder,
    (SocialPost, $$SocialPostsTableReferences),
    SocialPost,
    PrefetchHooks Function({bool careerId})> {
  $$SocialPostsTableTableManager(_$AppDatabase db, $SocialPostsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SocialPostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SocialPostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SocialPostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<int> absWeek = const Value.absent(),
            Value<String> postType = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> handle = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> avatarEmoji = const Value.absent(),
          }) =>
              SocialPostsCompanion(
            id: id,
            careerId: careerId,
            absWeek: absWeek,
            postType: postType,
            displayName: displayName,
            handle: handle,
            content: content,
            avatarEmoji: avatarEmoji,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required int absWeek,
            required String postType,
            required String displayName,
            required String handle,
            required String content,
            required String avatarEmoji,
          }) =>
              SocialPostsCompanion.insert(
            id: id,
            careerId: careerId,
            absWeek: absWeek,
            postType: postType,
            displayName: displayName,
            handle: handle,
            content: content,
            avatarEmoji: avatarEmoji,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SocialPostsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$SocialPostsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$SocialPostsTableReferences._careerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SocialPostsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SocialPostsTable,
    SocialPost,
    $$SocialPostsTableFilterComposer,
    $$SocialPostsTableOrderingComposer,
    $$SocialPostsTableAnnotationComposer,
    $$SocialPostsTableCreateCompanionBuilder,
    $$SocialPostsTableUpdateCompanionBuilder,
    (SocialPost, $$SocialPostsTableReferences),
    SocialPost,
    PrefetchHooks Function({bool careerId})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required int careerId,
  required int absMonth,
  required int displayMonth,
  required int year,
  required String category,
  required String label,
  required int amount,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<int> careerId,
  Value<int> absMonth,
  Value<int> displayMonth,
  Value<int> year,
  Value<String> category,
  Value<String> label,
  Value<int> amount,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('transactions__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get absMonth => $composableBuilder(
      column: $table.absMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get displayMonth => $composableBuilder(
      column: $table.displayMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get absMonth => $composableBuilder(
      column: $table.absMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayMonth => $composableBuilder(
      column: $table.displayMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get absMonth =>
      $composableBuilder(column: $table.absMonth, builder: (column) => column);

  GeneratedColumn<int> get displayMonth => $composableBuilder(
      column: $table.displayMonth, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({bool careerId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<int> absMonth = const Value.absent(),
            Value<int> displayMonth = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int> amount = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            careerId: careerId,
            absMonth: absMonth,
            displayMonth: displayMonth,
            year: year,
            category: category,
            label: label,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required int absMonth,
            required int displayMonth,
            required int year,
            required String category,
            required String label,
            required int amount,
          }) =>
              TransactionsCompanion.insert(
            id: id,
            careerId: careerId,
            absMonth: absMonth,
            displayMonth: displayMonth,
            year: year,
            category: category,
            label: label,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$TransactionsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._careerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({bool careerId})>;
typedef $$CardPacksTableCreateCompanionBuilder = CardPacksCompanion Function({
  Value<int> id,
  required String packName,
  Value<String> packType,
  Value<int> unlockMonth,
  Value<int> cost,
  Value<String?> guaranteedRarity,
});
typedef $$CardPacksTableUpdateCompanionBuilder = CardPacksCompanion Function({
  Value<int> id,
  Value<String> packName,
  Value<String> packType,
  Value<int> unlockMonth,
  Value<int> cost,
  Value<String?> guaranteedRarity,
});

final class $$CardPacksTableReferences
    extends BaseReferences<_$AppDatabase, $CardPacksTable, CardPack> {
  $$CardPacksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PackPoolItemsTable, List<PackPoolItem>>
      _packPoolItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.packPoolItems,
              aliasName: 'card_packs__id__pack_pool_items__pack_id');

  $$PackPoolItemsTableProcessedTableManager get packPoolItemsRefs {
    final manager = $$PackPoolItemsTableTableManager($_db, $_db.packPoolItems)
        .filter((f) => f.packId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_packPoolItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CardPacksTableFilterComposer
    extends Composer<_$AppDatabase, $CardPacksTable> {
  $$CardPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packName => $composableBuilder(
      column: $table.packName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packType => $composableBuilder(
      column: $table.packType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unlockMonth => $composableBuilder(
      column: $table.unlockMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guaranteedRarity => $composableBuilder(
      column: $table.guaranteedRarity,
      builder: (column) => ColumnFilters(column));

  Expression<bool> packPoolItemsRefs(
      Expression<bool> Function($$PackPoolItemsTableFilterComposer f) f) {
    final $$PackPoolItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.packPoolItems,
        getReferencedColumn: (t) => t.packId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PackPoolItemsTableFilterComposer(
              $db: $db,
              $table: $db.packPoolItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardPacksTableOrderingComposer
    extends Composer<_$AppDatabase, $CardPacksTable> {
  $$CardPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packName => $composableBuilder(
      column: $table.packName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packType => $composableBuilder(
      column: $table.packType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unlockMonth => $composableBuilder(
      column: $table.unlockMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guaranteedRarity => $composableBuilder(
      column: $table.guaranteedRarity,
      builder: (column) => ColumnOrderings(column));
}

class $$CardPacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardPacksTable> {
  $$CardPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packName =>
      $composableBuilder(column: $table.packName, builder: (column) => column);

  GeneratedColumn<String> get packType =>
      $composableBuilder(column: $table.packType, builder: (column) => column);

  GeneratedColumn<int> get unlockMonth => $composableBuilder(
      column: $table.unlockMonth, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get guaranteedRarity => $composableBuilder(
      column: $table.guaranteedRarity, builder: (column) => column);

  Expression<T> packPoolItemsRefs<T extends Object>(
      Expression<T> Function($$PackPoolItemsTableAnnotationComposer a) f) {
    final $$PackPoolItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.packPoolItems,
        getReferencedColumn: (t) => t.packId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PackPoolItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.packPoolItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardPacksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardPacksTable,
    CardPack,
    $$CardPacksTableFilterComposer,
    $$CardPacksTableOrderingComposer,
    $$CardPacksTableAnnotationComposer,
    $$CardPacksTableCreateCompanionBuilder,
    $$CardPacksTableUpdateCompanionBuilder,
    (CardPack, $$CardPacksTableReferences),
    CardPack,
    PrefetchHooks Function({bool packPoolItemsRefs})> {
  $$CardPacksTableTableManager(_$AppDatabase db, $CardPacksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardPacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardPacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> packName = const Value.absent(),
            Value<String> packType = const Value.absent(),
            Value<int> unlockMonth = const Value.absent(),
            Value<int> cost = const Value.absent(),
            Value<String?> guaranteedRarity = const Value.absent(),
          }) =>
              CardPacksCompanion(
            id: id,
            packName: packName,
            packType: packType,
            unlockMonth: unlockMonth,
            cost: cost,
            guaranteedRarity: guaranteedRarity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String packName,
            Value<String> packType = const Value.absent(),
            Value<int> unlockMonth = const Value.absent(),
            Value<int> cost = const Value.absent(),
            Value<String?> guaranteedRarity = const Value.absent(),
          }) =>
              CardPacksCompanion.insert(
            id: id,
            packName: packName,
            packType: packType,
            unlockMonth: unlockMonth,
            cost: cost,
            guaranteedRarity: guaranteedRarity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CardPacksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({packPoolItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (packPoolItemsRefs) db.packPoolItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (packPoolItemsRefs)
                    await $_getPrefetchedData<CardPack, $CardPacksTable,
                            PackPoolItem>(
                        currentTable: table,
                        referencedTable: $$CardPacksTableReferences
                            ._packPoolItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CardPacksTableReferences(db, table, p0)
                                .packPoolItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.packId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CardPacksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardPacksTable,
    CardPack,
    $$CardPacksTableFilterComposer,
    $$CardPacksTableOrderingComposer,
    $$CardPacksTableAnnotationComposer,
    $$CardPacksTableCreateCompanionBuilder,
    $$CardPacksTableUpdateCompanionBuilder,
    (CardPack, $$CardPacksTableReferences),
    CardPack,
    PrefetchHooks Function({bool packPoolItemsRefs})>;
typedef $$PackPoolItemsTableCreateCompanionBuilder = PackPoolItemsCompanion
    Function({
  Value<int> id,
  required int packId,
  required int characterId,
  required double dropRate,
});
typedef $$PackPoolItemsTableUpdateCompanionBuilder = PackPoolItemsCompanion
    Function({
  Value<int> id,
  Value<int> packId,
  Value<int> characterId,
  Value<double> dropRate,
});

final class $$PackPoolItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PackPoolItemsTable, PackPoolItem> {
  $$PackPoolItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CardPacksTable _packIdTable(_$AppDatabase db) =>
      db.cardPacks.createAlias('pack_pool_items__pack_id__card_packs__id');

  $$CardPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<int>('pack_id')!;

    final manager = $$CardPacksTableTableManager($_db, $_db.cardPacks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GeneratedCharactersTable _characterIdTable(_$AppDatabase db) => db
      .generatedCharacters
      .createAlias('pack_pool_items__character_id__generated_characters__id');

  $$GeneratedCharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager =
        $$GeneratedCharactersTableTableManager($_db, $_db.generatedCharacters)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PackPoolItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PackPoolItemsTable> {
  $$PackPoolItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dropRate => $composableBuilder(
      column: $table.dropRate, builder: (column) => ColumnFilters(column));

  $$CardPacksTableFilterComposer get packId {
    final $$CardPacksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.packId,
        referencedTable: $db.cardPacks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardPacksTableFilterComposer(
              $db: $db,
              $table: $db.cardPacks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GeneratedCharactersTableFilterComposer get characterId {
    final $$GeneratedCharactersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.generatedCharacters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GeneratedCharactersTableFilterComposer(
              $db: $db,
              $table: $db.generatedCharacters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PackPoolItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PackPoolItemsTable> {
  $$PackPoolItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dropRate => $composableBuilder(
      column: $table.dropRate, builder: (column) => ColumnOrderings(column));

  $$CardPacksTableOrderingComposer get packId {
    final $$CardPacksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.packId,
        referencedTable: $db.cardPacks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardPacksTableOrderingComposer(
              $db: $db,
              $table: $db.cardPacks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GeneratedCharactersTableOrderingComposer get characterId {
    final $$GeneratedCharactersTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.characterId,
            referencedTable: $db.generatedCharacters,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GeneratedCharactersTableOrderingComposer(
                  $db: $db,
                  $table: $db.generatedCharacters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PackPoolItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackPoolItemsTable> {
  $$PackPoolItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get dropRate =>
      $composableBuilder(column: $table.dropRate, builder: (column) => column);

  $$CardPacksTableAnnotationComposer get packId {
    final $$CardPacksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.packId,
        referencedTable: $db.cardPacks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardPacksTableAnnotationComposer(
              $db: $db,
              $table: $db.cardPacks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GeneratedCharactersTableAnnotationComposer get characterId {
    final $$GeneratedCharactersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.characterId,
            referencedTable: $db.generatedCharacters,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GeneratedCharactersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.generatedCharacters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PackPoolItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PackPoolItemsTable,
    PackPoolItem,
    $$PackPoolItemsTableFilterComposer,
    $$PackPoolItemsTableOrderingComposer,
    $$PackPoolItemsTableAnnotationComposer,
    $$PackPoolItemsTableCreateCompanionBuilder,
    $$PackPoolItemsTableUpdateCompanionBuilder,
    (PackPoolItem, $$PackPoolItemsTableReferences),
    PackPoolItem,
    PrefetchHooks Function({bool packId, bool characterId})> {
  $$PackPoolItemsTableTableManager(_$AppDatabase db, $PackPoolItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackPoolItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackPoolItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackPoolItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> packId = const Value.absent(),
            Value<int> characterId = const Value.absent(),
            Value<double> dropRate = const Value.absent(),
          }) =>
              PackPoolItemsCompanion(
            id: id,
            packId: packId,
            characterId: characterId,
            dropRate: dropRate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int packId,
            required int characterId,
            required double dropRate,
          }) =>
              PackPoolItemsCompanion.insert(
            id: id,
            packId: packId,
            characterId: characterId,
            dropRate: dropRate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PackPoolItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({packId = false, characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (packId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.packId,
                    referencedTable:
                        $$PackPoolItemsTableReferences._packIdTable(db),
                    referencedColumn:
                        $$PackPoolItemsTableReferences._packIdTable(db).id,
                  ) as T;
                }
                if (characterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.characterId,
                    referencedTable:
                        $$PackPoolItemsTableReferences._characterIdTable(db),
                    referencedColumn:
                        $$PackPoolItemsTableReferences._characterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PackPoolItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PackPoolItemsTable,
    PackPoolItem,
    $$PackPoolItemsTableFilterComposer,
    $$PackPoolItemsTableOrderingComposer,
    $$PackPoolItemsTableAnnotationComposer,
    $$PackPoolItemsTableCreateCompanionBuilder,
    $$PackPoolItemsTableUpdateCompanionBuilder,
    (PackPoolItem, $$PackPoolItemsTableReferences),
    PackPoolItem,
    PrefetchHooks Function({bool packId, bool characterId})>;
typedef $$CoachesTableCreateCompanionBuilder = CoachesCompanion Function({
  Value<int> id,
  required int careerId,
  required String name,
  required String discipline,
  required int quality,
  required int monthlySalary,
  Value<bool> isHired,
});
typedef $$CoachesTableUpdateCompanionBuilder = CoachesCompanion Function({
  Value<int> id,
  Value<int> careerId,
  Value<String> name,
  Value<String> discipline,
  Value<int> quality,
  Value<int> monthlySalary,
  Value<bool> isHired,
});

final class $$CoachesTableReferences
    extends BaseReferences<_$AppDatabase, $CoachesTable, Coach> {
  $$CoachesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers.createAlias('coaches__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CoachesTableFilterComposer
    extends Composer<_$AppDatabase, $CoachesTable> {
  $$CoachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get discipline => $composableBuilder(
      column: $table.discipline, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quality => $composableBuilder(
      column: $table.quality, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHired => $composableBuilder(
      column: $table.isHired, builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CoachesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoachesTable> {
  $$CoachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get discipline => $composableBuilder(
      column: $table.discipline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quality => $composableBuilder(
      column: $table.quality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHired => $composableBuilder(
      column: $table.isHired, builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CoachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoachesTable> {
  $$CoachesTableAnnotationComposer({
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

  GeneratedColumn<String> get discipline => $composableBuilder(
      column: $table.discipline, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<int> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary, builder: (column) => column);

  GeneratedColumn<bool> get isHired =>
      $composableBuilder(column: $table.isHired, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CoachesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CoachesTable,
    Coach,
    $$CoachesTableFilterComposer,
    $$CoachesTableOrderingComposer,
    $$CoachesTableAnnotationComposer,
    $$CoachesTableCreateCompanionBuilder,
    $$CoachesTableUpdateCompanionBuilder,
    (Coach, $$CoachesTableReferences),
    Coach,
    PrefetchHooks Function({bool careerId})> {
  $$CoachesTableTableManager(_$AppDatabase db, $CoachesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> discipline = const Value.absent(),
            Value<int> quality = const Value.absent(),
            Value<int> monthlySalary = const Value.absent(),
            Value<bool> isHired = const Value.absent(),
          }) =>
              CoachesCompanion(
            id: id,
            careerId: careerId,
            name: name,
            discipline: discipline,
            quality: quality,
            monthlySalary: monthlySalary,
            isHired: isHired,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required String name,
            required String discipline,
            required int quality,
            required int monthlySalary,
            Value<bool> isHired = const Value.absent(),
          }) =>
              CoachesCompanion.insert(
            id: id,
            careerId: careerId,
            name: name,
            discipline: discipline,
            quality: quality,
            monthlySalary: monthlySalary,
            isHired: isHired,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CoachesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$CoachesTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$CoachesTableReferences._careerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CoachesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CoachesTable,
    Coach,
    $$CoachesTableFilterComposer,
    $$CoachesTableOrderingComposer,
    $$CoachesTableAnnotationComposer,
    $$CoachesTableCreateCompanionBuilder,
    $$CoachesTableUpdateCompanionBuilder,
    (Coach, $$CoachesTableReferences),
    Coach,
    PrefetchHooks Function({bool careerId})>;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required int careerId,
  Value<int?> groupId,
  required String eventType,
  Value<String> category,
  required String title,
  Value<String?> description,
  required int monthOccurred,
  Value<int> impactValue,
  Value<bool> requiresDecision,
  Value<bool> resolved,
  Value<String?> resolutionChoice,
  Value<String?> resolutionOutcome,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<int> careerId,
  Value<int?> groupId,
  Value<String> eventType,
  Value<String> category,
  Value<String> title,
  Value<String?> description,
  Value<int> monthOccurred,
  Value<int> impactValue,
  Value<bool> requiresDecision,
  Value<bool> resolved,
  Value<String?> resolutionChoice,
  Value<String?> resolutionOutcome,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers.createAlias('events__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('events__group_id__groups__id');

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EventAffectedIdolsTable, List<EventAffectedIdol>>
      _eventAffectedIdolsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.eventAffectedIdols,
              aliasName: 'events__id__event_affected_idols__event_id');

  $$EventAffectedIdolsTableProcessedTableManager get eventAffectedIdolsRefs {
    final manager =
        $$EventAffectedIdolsTableTableManager($_db, $_db.eventAffectedIdols)
            .filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_eventAffectedIdolsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthOccurred => $composableBuilder(
      column: $table.monthOccurred, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get impactValue => $composableBuilder(
      column: $table.impactValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get requiresDecision => $composableBuilder(
      column: $table.requiresDecision,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get resolved => $composableBuilder(
      column: $table.resolved, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolutionChoice => $composableBuilder(
      column: $table.resolutionChoice,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolutionOutcome => $composableBuilder(
      column: $table.resolutionOutcome,
      builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> eventAffectedIdolsRefs(
      Expression<bool> Function($$EventAffectedIdolsTableFilterComposer f) f) {
    final $$EventAffectedIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.eventAffectedIdols,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventAffectedIdolsTableFilterComposer(
              $db: $db,
              $table: $db.eventAffectedIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthOccurred => $composableBuilder(
      column: $table.monthOccurred,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get impactValue => $composableBuilder(
      column: $table.impactValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get requiresDecision => $composableBuilder(
      column: $table.requiresDecision,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get resolved => $composableBuilder(
      column: $table.resolved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolutionChoice => $composableBuilder(
      column: $table.resolutionChoice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolutionOutcome => $composableBuilder(
      column: $table.resolutionOutcome,
      builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get monthOccurred => $composableBuilder(
      column: $table.monthOccurred, builder: (column) => column);

  GeneratedColumn<int> get impactValue => $composableBuilder(
      column: $table.impactValue, builder: (column) => column);

  GeneratedColumn<bool> get requiresDecision => $composableBuilder(
      column: $table.requiresDecision, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);

  GeneratedColumn<String> get resolutionChoice => $composableBuilder(
      column: $table.resolutionChoice, builder: (column) => column);

  GeneratedColumn<String> get resolutionOutcome => $composableBuilder(
      column: $table.resolutionOutcome, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> eventAffectedIdolsRefs<T extends Object>(
      Expression<T> Function($$EventAffectedIdolsTableAnnotationComposer a) f) {
    final $$EventAffectedIdolsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.eventAffectedIdols,
            getReferencedColumn: (t) => t.eventId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EventAffectedIdolsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.eventAffectedIdols,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function(
        {bool careerId, bool groupId, bool eventAffectedIdolsRefs})> {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> monthOccurred = const Value.absent(),
            Value<int> impactValue = const Value.absent(),
            Value<bool> requiresDecision = const Value.absent(),
            Value<bool> resolved = const Value.absent(),
            Value<String?> resolutionChoice = const Value.absent(),
            Value<String?> resolutionOutcome = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            careerId: careerId,
            groupId: groupId,
            eventType: eventType,
            category: category,
            title: title,
            description: description,
            monthOccurred: monthOccurred,
            impactValue: impactValue,
            requiresDecision: requiresDecision,
            resolved: resolved,
            resolutionChoice: resolutionChoice,
            resolutionOutcome: resolutionOutcome,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            Value<int?> groupId = const Value.absent(),
            required String eventType,
            Value<String> category = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required int monthOccurred,
            Value<int> impactValue = const Value.absent(),
            Value<bool> requiresDecision = const Value.absent(),
            Value<bool> resolved = const Value.absent(),
            Value<String?> resolutionChoice = const Value.absent(),
            Value<String?> resolutionOutcome = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            id: id,
            careerId: careerId,
            groupId: groupId,
            eventType: eventType,
            category: category,
            title: title,
            description: description,
            monthOccurred: monthOccurred,
            impactValue: impactValue,
            requiresDecision: requiresDecision,
            resolved: resolved,
            resolutionChoice: resolutionChoice,
            resolutionOutcome: resolutionOutcome,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EventsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {careerId = false,
              groupId = false,
              eventAffectedIdolsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eventAffectedIdolsRefs) db.eventAffectedIdols
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable: $$EventsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$EventsTableReferences._careerIdTable(db).id,
                  ) as T;
                }
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable: $$EventsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$EventsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventAffectedIdolsRefs)
                    await $_getPrefetchedData<Event, $EventsTable,
                            EventAffectedIdol>(
                        currentTable: table,
                        referencedTable: $$EventsTableReferences
                            ._eventAffectedIdolsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0)
                                .eventAffectedIdolsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.eventId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function(
        {bool careerId, bool groupId, bool eventAffectedIdolsRefs})>;
typedef $$EventAffectedIdolsTableCreateCompanionBuilder
    = EventAffectedIdolsCompanion Function({
  Value<int> id,
  required int eventId,
  required int idolId,
  Value<String?> effectDetail,
});
typedef $$EventAffectedIdolsTableUpdateCompanionBuilder
    = EventAffectedIdolsCompanion Function({
  Value<int> id,
  Value<int> eventId,
  Value<int> idolId,
  Value<String?> effectDetail,
});

final class $$EventAffectedIdolsTableReferences extends BaseReferences<
    _$AppDatabase, $EventAffectedIdolsTable, EventAffectedIdol> {
  $$EventAffectedIdolsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('event_affected_idols__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PlayerIdolsTable _idolIdTable(_$AppDatabase db) => db.playerIdols
      .createAlias('event_affected_idols__idol_id__player_idols__id');

  $$PlayerIdolsTableProcessedTableManager get idolId {
    final $_column = $_itemColumn<int>('idol_id')!;

    final manager = $$PlayerIdolsTableTableManager($_db, $_db.playerIdols)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EventAffectedIdolsTableFilterComposer
    extends Composer<_$AppDatabase, $EventAffectedIdolsTable> {
  $$EventAffectedIdolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get effectDetail => $composableBuilder(
      column: $table.effectDetail, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableFilterComposer get idolId {
    final $$PlayerIdolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableFilterComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventAffectedIdolsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventAffectedIdolsTable> {
  $$EventAffectedIdolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get effectDetail => $composableBuilder(
      column: $table.effectDetail,
      builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableOrderingComposer get idolId {
    final $$PlayerIdolsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableOrderingComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventAffectedIdolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventAffectedIdolsTable> {
  $$EventAffectedIdolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get effectDetail => $composableBuilder(
      column: $table.effectDetail, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlayerIdolsTableAnnotationComposer get idolId {
    final $$PlayerIdolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idolId,
        referencedTable: $db.playerIdols,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerIdolsTableAnnotationComposer(
              $db: $db,
              $table: $db.playerIdols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventAffectedIdolsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventAffectedIdolsTable,
    EventAffectedIdol,
    $$EventAffectedIdolsTableFilterComposer,
    $$EventAffectedIdolsTableOrderingComposer,
    $$EventAffectedIdolsTableAnnotationComposer,
    $$EventAffectedIdolsTableCreateCompanionBuilder,
    $$EventAffectedIdolsTableUpdateCompanionBuilder,
    (EventAffectedIdol, $$EventAffectedIdolsTableReferences),
    EventAffectedIdol,
    PrefetchHooks Function({bool eventId, bool idolId})> {
  $$EventAffectedIdolsTableTableManager(
      _$AppDatabase db, $EventAffectedIdolsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventAffectedIdolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventAffectedIdolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventAffectedIdolsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eventId = const Value.absent(),
            Value<int> idolId = const Value.absent(),
            Value<String?> effectDetail = const Value.absent(),
          }) =>
              EventAffectedIdolsCompanion(
            id: id,
            eventId: eventId,
            idolId: idolId,
            effectDetail: effectDetail,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eventId,
            required int idolId,
            Value<String?> effectDetail = const Value.absent(),
          }) =>
              EventAffectedIdolsCompanion.insert(
            id: id,
            eventId: eventId,
            idolId: idolId,
            effectDetail: effectDetail,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EventAffectedIdolsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({eventId = false, idolId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (eventId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventId,
                    referencedTable:
                        $$EventAffectedIdolsTableReferences._eventIdTable(db),
                    referencedColumn: $$EventAffectedIdolsTableReferences
                        ._eventIdTable(db)
                        .id,
                  ) as T;
                }
                if (idolId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.idolId,
                    referencedTable:
                        $$EventAffectedIdolsTableReferences._idolIdTable(db),
                    referencedColumn:
                        $$EventAffectedIdolsTableReferences._idolIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EventAffectedIdolsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventAffectedIdolsTable,
    EventAffectedIdol,
    $$EventAffectedIdolsTableFilterComposer,
    $$EventAffectedIdolsTableOrderingComposer,
    $$EventAffectedIdolsTableAnnotationComposer,
    $$EventAffectedIdolsTableCreateCompanionBuilder,
    $$EventAffectedIdolsTableUpdateCompanionBuilder,
    (EventAffectedIdol, $$EventAffectedIdolsTableReferences),
    EventAffectedIdol,
    PrefetchHooks Function({bool eventId, bool idolId})>;
typedef $$RivalsTableCreateCompanionBuilder = RivalsCompanion Function({
  Value<int> id,
  required String rivalName,
  Value<String?> description,
  Value<int> memberCount,
  Value<String?> logoPath,
});
typedef $$RivalsTableUpdateCompanionBuilder = RivalsCompanion Function({
  Value<int> id,
  Value<String> rivalName,
  Value<String?> description,
  Value<int> memberCount,
  Value<String?> logoPath,
});

final class $$RivalsTableReferences
    extends BaseReferences<_$AppDatabase, $RivalsTable, Rival> {
  $$RivalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RivalMilestonesTable, List<RivalMilestone>>
      _rivalMilestonesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.rivalMilestones,
              aliasName: 'rivals__id__rival_milestones__rival_id');

  $$RivalMilestonesTableProcessedTableManager get rivalMilestonesRefs {
    final manager =
        $$RivalMilestonesTableTableManager($_db, $_db.rivalMilestones)
            .filter((f) => f.rivalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_rivalMilestonesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RivalsTableFilterComposer
    extends Composer<_$AppDatabase, $RivalsTable> {
  $$RivalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rivalName => $composableBuilder(
      column: $table.rivalName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));

  Expression<bool> rivalMilestonesRefs(
      Expression<bool> Function($$RivalMilestonesTableFilterComposer f) f) {
    final $$RivalMilestonesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rivalMilestones,
        getReferencedColumn: (t) => t.rivalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RivalMilestonesTableFilterComposer(
              $db: $db,
              $table: $db.rivalMilestones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RivalsTableOrderingComposer
    extends Composer<_$AppDatabase, $RivalsTable> {
  $$RivalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rivalName => $composableBuilder(
      column: $table.rivalName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));
}

class $$RivalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RivalsTable> {
  $$RivalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rivalName =>
      $composableBuilder(column: $table.rivalName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  Expression<T> rivalMilestonesRefs<T extends Object>(
      Expression<T> Function($$RivalMilestonesTableAnnotationComposer a) f) {
    final $$RivalMilestonesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rivalMilestones,
        getReferencedColumn: (t) => t.rivalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RivalMilestonesTableAnnotationComposer(
              $db: $db,
              $table: $db.rivalMilestones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RivalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RivalsTable,
    Rival,
    $$RivalsTableFilterComposer,
    $$RivalsTableOrderingComposer,
    $$RivalsTableAnnotationComposer,
    $$RivalsTableCreateCompanionBuilder,
    $$RivalsTableUpdateCompanionBuilder,
    (Rival, $$RivalsTableReferences),
    Rival,
    PrefetchHooks Function({bool rivalMilestonesRefs})> {
  $$RivalsTableTableManager(_$AppDatabase db, $RivalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RivalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RivalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RivalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> rivalName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> memberCount = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
          }) =>
              RivalsCompanion(
            id: id,
            rivalName: rivalName,
            description: description,
            memberCount: memberCount,
            logoPath: logoPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String rivalName,
            Value<String?> description = const Value.absent(),
            Value<int> memberCount = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
          }) =>
              RivalsCompanion.insert(
            id: id,
            rivalName: rivalName,
            description: description,
            memberCount: memberCount,
            logoPath: logoPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RivalsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({rivalMilestonesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (rivalMilestonesRefs) db.rivalMilestones
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (rivalMilestonesRefs)
                    await $_getPrefetchedData<Rival, $RivalsTable,
                            RivalMilestone>(
                        currentTable: table,
                        referencedTable: $$RivalsTableReferences
                            ._rivalMilestonesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RivalsTableReferences(db, table, p0)
                                .rivalMilestonesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.rivalId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RivalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RivalsTable,
    Rival,
    $$RivalsTableFilterComposer,
    $$RivalsTableOrderingComposer,
    $$RivalsTableAnnotationComposer,
    $$RivalsTableCreateCompanionBuilder,
    $$RivalsTableUpdateCompanionBuilder,
    (Rival, $$RivalsTableReferences),
    Rival,
    PrefetchHooks Function({bool rivalMilestonesRefs})>;
typedef $$RivalMilestonesTableCreateCompanionBuilder = RivalMilestonesCompanion
    Function({
  Value<int> id,
  required int rivalId,
  required int month,
  required int popularityValue,
  Value<String?> milestoneDescription,
});
typedef $$RivalMilestonesTableUpdateCompanionBuilder = RivalMilestonesCompanion
    Function({
  Value<int> id,
  Value<int> rivalId,
  Value<int> month,
  Value<int> popularityValue,
  Value<String?> milestoneDescription,
});

final class $$RivalMilestonesTableReferences extends BaseReferences<
    _$AppDatabase, $RivalMilestonesTable, RivalMilestone> {
  $$RivalMilestonesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RivalsTable _rivalIdTable(_$AppDatabase db) =>
      db.rivals.createAlias('rival_milestones__rival_id__rivals__id');

  $$RivalsTableProcessedTableManager get rivalId {
    final $_column = $_itemColumn<int>('rival_id')!;

    final manager = $$RivalsTableTableManager($_db, $_db.rivals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rivalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RivalMilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $RivalMilestonesTable> {
  $$RivalMilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get popularityValue => $composableBuilder(
      column: $table.popularityValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get milestoneDescription => $composableBuilder(
      column: $table.milestoneDescription,
      builder: (column) => ColumnFilters(column));

  $$RivalsTableFilterComposer get rivalId {
    final $$RivalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rivalId,
        referencedTable: $db.rivals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RivalsTableFilterComposer(
              $db: $db,
              $table: $db.rivals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RivalMilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $RivalMilestonesTable> {
  $$RivalMilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get popularityValue => $composableBuilder(
      column: $table.popularityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get milestoneDescription => $composableBuilder(
      column: $table.milestoneDescription,
      builder: (column) => ColumnOrderings(column));

  $$RivalsTableOrderingComposer get rivalId {
    final $$RivalsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rivalId,
        referencedTable: $db.rivals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RivalsTableOrderingComposer(
              $db: $db,
              $table: $db.rivals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RivalMilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RivalMilestonesTable> {
  $$RivalMilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get popularityValue => $composableBuilder(
      column: $table.popularityValue, builder: (column) => column);

  GeneratedColumn<String> get milestoneDescription => $composableBuilder(
      column: $table.milestoneDescription, builder: (column) => column);

  $$RivalsTableAnnotationComposer get rivalId {
    final $$RivalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rivalId,
        referencedTable: $db.rivals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RivalsTableAnnotationComposer(
              $db: $db,
              $table: $db.rivals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RivalMilestonesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RivalMilestonesTable,
    RivalMilestone,
    $$RivalMilestonesTableFilterComposer,
    $$RivalMilestonesTableOrderingComposer,
    $$RivalMilestonesTableAnnotationComposer,
    $$RivalMilestonesTableCreateCompanionBuilder,
    $$RivalMilestonesTableUpdateCompanionBuilder,
    (RivalMilestone, $$RivalMilestonesTableReferences),
    RivalMilestone,
    PrefetchHooks Function({bool rivalId})> {
  $$RivalMilestonesTableTableManager(
      _$AppDatabase db, $RivalMilestonesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RivalMilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RivalMilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RivalMilestonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> rivalId = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> popularityValue = const Value.absent(),
            Value<String?> milestoneDescription = const Value.absent(),
          }) =>
              RivalMilestonesCompanion(
            id: id,
            rivalId: rivalId,
            month: month,
            popularityValue: popularityValue,
            milestoneDescription: milestoneDescription,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int rivalId,
            required int month,
            required int popularityValue,
            Value<String?> milestoneDescription = const Value.absent(),
          }) =>
              RivalMilestonesCompanion.insert(
            id: id,
            rivalId: rivalId,
            month: month,
            popularityValue: popularityValue,
            milestoneDescription: milestoneDescription,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RivalMilestonesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({rivalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (rivalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.rivalId,
                    referencedTable:
                        $$RivalMilestonesTableReferences._rivalIdTable(db),
                    referencedColumn:
                        $$RivalMilestonesTableReferences._rivalIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RivalMilestonesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RivalMilestonesTable,
    RivalMilestone,
    $$RivalMilestonesTableFilterComposer,
    $$RivalMilestonesTableOrderingComposer,
    $$RivalMilestonesTableAnnotationComposer,
    $$RivalMilestonesTableCreateCompanionBuilder,
    $$RivalMilestonesTableUpdateCompanionBuilder,
    (RivalMilestone, $$RivalMilestonesTableReferences),
    RivalMilestone,
    PrefetchHooks Function({bool rivalId})>;
typedef $$MonthlyStatsTableCreateCompanionBuilder = MonthlyStatsCompanion
    Function({
  Value<int> id,
  required int careerId,
  required int groupId,
  required int month,
  required int popularityScore,
  required int fanbaseSize,
  Value<int?> avgChemistry,
  Value<int?> avgMood,
});
typedef $$MonthlyStatsTableUpdateCompanionBuilder = MonthlyStatsCompanion
    Function({
  Value<int> id,
  Value<int> careerId,
  Value<int> groupId,
  Value<int> month,
  Value<int> popularityScore,
  Value<int> fanbaseSize,
  Value<int?> avgChemistry,
  Value<int?> avgMood,
});

final class $$MonthlyStatsTableReferences
    extends BaseReferences<_$AppDatabase, $MonthlyStatsTable, MonthlyStat> {
  $$MonthlyStatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerCareersTable _careerIdTable(_$AppDatabase db) =>
      db.playerCareers
          .createAlias('monthly_stats__career_id__player_careers__id');

  $$PlayerCareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$PlayerCareersTableTableManager($_db, $_db.playerCareers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('monthly_stats__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MonthlyStatsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyStatsTable> {
  $$MonthlyStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get popularityScore => $composableBuilder(
      column: $table.popularityScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fanbaseSize => $composableBuilder(
      column: $table.fanbaseSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avgChemistry => $composableBuilder(
      column: $table.avgChemistry, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avgMood => $composableBuilder(
      column: $table.avgMood, builder: (column) => ColumnFilters(column));

  $$PlayerCareersTableFilterComposer get careerId {
    final $$PlayerCareersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableFilterComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonthlyStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyStatsTable> {
  $$MonthlyStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get popularityScore => $composableBuilder(
      column: $table.popularityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fanbaseSize => $composableBuilder(
      column: $table.fanbaseSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avgChemistry => $composableBuilder(
      column: $table.avgChemistry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avgMood => $composableBuilder(
      column: $table.avgMood, builder: (column) => ColumnOrderings(column));

  $$PlayerCareersTableOrderingComposer get careerId {
    final $$PlayerCareersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableOrderingComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonthlyStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyStatsTable> {
  $$MonthlyStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get popularityScore => $composableBuilder(
      column: $table.popularityScore, builder: (column) => column);

  GeneratedColumn<int> get fanbaseSize => $composableBuilder(
      column: $table.fanbaseSize, builder: (column) => column);

  GeneratedColumn<int> get avgChemistry => $composableBuilder(
      column: $table.avgChemistry, builder: (column) => column);

  GeneratedColumn<int> get avgMood =>
      $composableBuilder(column: $table.avgMood, builder: (column) => column);

  $$PlayerCareersTableAnnotationComposer get careerId {
    final $$PlayerCareersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careerId,
        referencedTable: $db.playerCareers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerCareersTableAnnotationComposer(
              $db: $db,
              $table: $db.playerCareers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonthlyStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonthlyStatsTable,
    MonthlyStat,
    $$MonthlyStatsTableFilterComposer,
    $$MonthlyStatsTableOrderingComposer,
    $$MonthlyStatsTableAnnotationComposer,
    $$MonthlyStatsTableCreateCompanionBuilder,
    $$MonthlyStatsTableUpdateCompanionBuilder,
    (MonthlyStat, $$MonthlyStatsTableReferences),
    MonthlyStat,
    PrefetchHooks Function({bool careerId, bool groupId})> {
  $$MonthlyStatsTableTableManager(_$AppDatabase db, $MonthlyStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careerId = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> popularityScore = const Value.absent(),
            Value<int> fanbaseSize = const Value.absent(),
            Value<int?> avgChemistry = const Value.absent(),
            Value<int?> avgMood = const Value.absent(),
          }) =>
              MonthlyStatsCompanion(
            id: id,
            careerId: careerId,
            groupId: groupId,
            month: month,
            popularityScore: popularityScore,
            fanbaseSize: fanbaseSize,
            avgChemistry: avgChemistry,
            avgMood: avgMood,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careerId,
            required int groupId,
            required int month,
            required int popularityScore,
            required int fanbaseSize,
            Value<int?> avgChemistry = const Value.absent(),
            Value<int?> avgMood = const Value.absent(),
          }) =>
              MonthlyStatsCompanion.insert(
            id: id,
            careerId: careerId,
            groupId: groupId,
            month: month,
            popularityScore: popularityScore,
            fanbaseSize: fanbaseSize,
            avgChemistry: avgChemistry,
            avgMood: avgMood,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MonthlyStatsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({careerId = false, groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (careerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careerId,
                    referencedTable:
                        $$MonthlyStatsTableReferences._careerIdTable(db),
                    referencedColumn:
                        $$MonthlyStatsTableReferences._careerIdTable(db).id,
                  ) as T;
                }
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$MonthlyStatsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$MonthlyStatsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MonthlyStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonthlyStatsTable,
    MonthlyStat,
    $$MonthlyStatsTableFilterComposer,
    $$MonthlyStatsTableOrderingComposer,
    $$MonthlyStatsTableAnnotationComposer,
    $$MonthlyStatsTableCreateCompanionBuilder,
    $$MonthlyStatsTableUpdateCompanionBuilder,
    (MonthlyStat, $$MonthlyStatsTableReferences),
    MonthlyStat,
    PrefetchHooks Function({bool careerId, bool groupId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonalityTraitsTableTableManager get personalityTraits =>
      $$PersonalityTraitsTableTableManager(_db, _db.personalityTraits);
  $$NamePoolTableTableManager get namePool =>
      $$NamePoolTableTableManager(_db, _db.namePool);
  $$TagPoolTableTableManager get tagPool =>
      $$TagPoolTableTableManager(_db, _db.tagPool);
  $$RarityTiersTableTableManager get rarityTiers =>
      $$RarityTiersTableTableManager(_db, _db.rarityTiers);
  $$PlayerCareersTableTableManager get playerCareers =>
      $$PlayerCareersTableTableManager(_db, _db.playerCareers);
  $$GeneratedCharactersTableTableManager get generatedCharacters =>
      $$GeneratedCharactersTableTableManager(_db, _db.generatedCharacters);
  $$CurrencyWalletsTableTableManager get currencyWallets =>
      $$CurrencyWalletsTableTableManager(_db, _db.currencyWallets);
  $$CareerHistoriesTableTableManager get careerHistories =>
      $$CareerHistoriesTableTableManager(_db, _db.careerHistories);
  $$PlayerIdolsTableTableManager get playerIdols =>
      $$PlayerIdolsTableTableManager(_db, _db.playerIdols);
  $$ChemistryRelationsTableTableManager get chemistryRelations =>
      $$ChemistryRelationsTableTableManager(_db, _db.chemistryRelations);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$GroupMembersTableTableManager get groupMembers =>
      $$GroupMembersTableTableManager(_db, _db.groupMembers);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$GlobalAchievementsTableTableManager get globalAchievements =>
      $$GlobalAchievementsTableTableManager(_db, _db.globalAchievements);
  $$SocialPostsTableTableManager get socialPosts =>
      $$SocialPostsTableTableManager(_db, _db.socialPosts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$CardPacksTableTableManager get cardPacks =>
      $$CardPacksTableTableManager(_db, _db.cardPacks);
  $$PackPoolItemsTableTableManager get packPoolItems =>
      $$PackPoolItemsTableTableManager(_db, _db.packPoolItems);
  $$CoachesTableTableManager get coaches =>
      $$CoachesTableTableManager(_db, _db.coaches);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$EventAffectedIdolsTableTableManager get eventAffectedIdols =>
      $$EventAffectedIdolsTableTableManager(_db, _db.eventAffectedIdols);
  $$RivalsTableTableManager get rivals =>
      $$RivalsTableTableManager(_db, _db.rivals);
  $$RivalMilestonesTableTableManager get rivalMilestones =>
      $$RivalMilestonesTableTableManager(_db, _db.rivalMilestones);
  $$MonthlyStatsTableTableManager get monthlyStats =>
      $$MonthlyStatsTableTableManager(_db, _db.monthlyStats);
}
