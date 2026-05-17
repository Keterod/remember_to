// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ActividadesTable extends Actividades
    with TableInfo<$ActividadesTable, ActividadLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActividadesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urgenteMeta = const VerificationMeta(
    'urgente',
  );
  @override
  late final GeneratedColumn<bool> urgente = GeneratedColumn<bool>(
    'urgente',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("urgente" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaLimiteMeta = const VerificationMeta(
    'fechaLimite',
  );
  @override
  late final GeneratedColumn<DateTime> fechaLimite = GeneratedColumn<DateTime>(
    'fecha_limite',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaFinMeta = const VerificationMeta(
    'fechaFin',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
    'fecha_fin',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaAvisoMeta = const VerificationMeta(
    'fechaAviso',
  );
  @override
  late final GeneratedColumn<DateTime> fechaAviso = GeneratedColumn<DateTime>(
    'fecha_aviso',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    titulo,
    descripcion,
    estado,
    urgente,
    fechaLimite,
    fechaInicio,
    fechaFin,
    fechaAviso,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'actividades';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActividadLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('urgente')) {
      context.handle(
        _urgenteMeta,
        urgente.isAcceptableOrUnknown(data['urgente']!, _urgenteMeta),
      );
    }
    if (data.containsKey('fecha_limite')) {
      context.handle(
        _fechaLimiteMeta,
        fechaLimite.isAcceptableOrUnknown(
          data['fecha_limite']!,
          _fechaLimiteMeta,
        ),
      );
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(
        _fechaFinMeta,
        fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta),
      );
    }
    if (data.containsKey('fecha_aviso')) {
      context.handle(
        _fechaAvisoMeta,
        fechaAviso.isAcceptableOrUnknown(data['fecha_aviso']!, _fechaAvisoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActividadLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActividadLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      urgente: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}urgente'],
      )!,
      fechaLimite: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_limite'],
      ),
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      ),
      fechaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fin'],
      ),
      fechaAviso: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_aviso'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ActividadesTable createAlias(String alias) {
    return $ActividadesTable(attachedDatabase, alias);
  }
}

class ActividadLocal extends DataClass implements Insertable<ActividadLocal> {
  final String id;
  final String tipo;
  final String titulo;
  final String? descripcion;
  final String estado;
  final bool urgente;
  final DateTime? fechaLimite;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final DateTime? fechaAviso;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ActividadLocal({
    required this.id,
    required this.tipo,
    required this.titulo,
    this.descripcion,
    required this.estado,
    required this.urgente,
    this.fechaLimite,
    this.fechaInicio,
    this.fechaFin,
    this.fechaAviso,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tipo'] = Variable<String>(tipo);
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['estado'] = Variable<String>(estado);
    map['urgente'] = Variable<bool>(urgente);
    if (!nullToAbsent || fechaLimite != null) {
      map['fecha_limite'] = Variable<DateTime>(fechaLimite);
    }
    if (!nullToAbsent || fechaInicio != null) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    }
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    if (!nullToAbsent || fechaAviso != null) {
      map['fecha_aviso'] = Variable<DateTime>(fechaAviso);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ActividadesCompanion toCompanion(bool nullToAbsent) {
    return ActividadesCompanion(
      id: Value(id),
      tipo: Value(tipo),
      titulo: Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      estado: Value(estado),
      urgente: Value(urgente),
      fechaLimite: fechaLimite == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaLimite),
      fechaInicio: fechaInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaInicio),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
      fechaAviso: fechaAviso == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaAviso),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ActividadLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActividadLocal(
      id: serializer.fromJson<String>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      estado: serializer.fromJson<String>(json['estado']),
      urgente: serializer.fromJson<bool>(json['urgente']),
      fechaLimite: serializer.fromJson<DateTime?>(json['fechaLimite']),
      fechaInicio: serializer.fromJson<DateTime?>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
      fechaAviso: serializer.fromJson<DateTime?>(json['fechaAviso']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipo': serializer.toJson<String>(tipo),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String?>(descripcion),
      'estado': serializer.toJson<String>(estado),
      'urgente': serializer.toJson<bool>(urgente),
      'fechaLimite': serializer.toJson<DateTime?>(fechaLimite),
      'fechaInicio': serializer.toJson<DateTime?>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
      'fechaAviso': serializer.toJson<DateTime?>(fechaAviso),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ActividadLocal copyWith({
    String? id,
    String? tipo,
    String? titulo,
    Value<String?> descripcion = const Value.absent(),
    String? estado,
    bool? urgente,
    Value<DateTime?> fechaLimite = const Value.absent(),
    Value<DateTime?> fechaInicio = const Value.absent(),
    Value<DateTime?> fechaFin = const Value.absent(),
    Value<DateTime?> fechaAviso = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ActividadLocal(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    estado: estado ?? this.estado,
    urgente: urgente ?? this.urgente,
    fechaLimite: fechaLimite.present ? fechaLimite.value : this.fechaLimite,
    fechaInicio: fechaInicio.present ? fechaInicio.value : this.fechaInicio,
    fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
    fechaAviso: fechaAviso.present ? fechaAviso.value : this.fechaAviso,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ActividadLocal copyWithCompanion(ActividadesCompanion data) {
    return ActividadLocal(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      estado: data.estado.present ? data.estado.value : this.estado,
      urgente: data.urgente.present ? data.urgente.value : this.urgente,
      fechaLimite: data.fechaLimite.present
          ? data.fechaLimite.value
          : this.fechaLimite,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      fechaAviso: data.fechaAviso.present
          ? data.fechaAviso.value
          : this.fechaAviso,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActividadLocal(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('estado: $estado, ')
          ..write('urgente: $urgente, ')
          ..write('fechaLimite: $fechaLimite, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('fechaAviso: $fechaAviso, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    titulo,
    descripcion,
    estado,
    urgente,
    fechaLimite,
    fechaInicio,
    fechaFin,
    fechaAviso,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActividadLocal &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.estado == this.estado &&
          other.urgente == this.urgente &&
          other.fechaLimite == this.fechaLimite &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.fechaAviso == this.fechaAviso &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ActividadesCompanion extends UpdateCompanion<ActividadLocal> {
  final Value<String> id;
  final Value<String> tipo;
  final Value<String> titulo;
  final Value<String?> descripcion;
  final Value<String> estado;
  final Value<bool> urgente;
  final Value<DateTime?> fechaLimite;
  final Value<DateTime?> fechaInicio;
  final Value<DateTime?> fechaFin;
  final Value<DateTime?> fechaAviso;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ActividadesCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.estado = const Value.absent(),
    this.urgente = const Value.absent(),
    this.fechaLimite = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.fechaAviso = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActividadesCompanion.insert({
    required String id,
    required String tipo,
    required String titulo,
    this.descripcion = const Value.absent(),
    required String estado,
    this.urgente = const Value.absent(),
    this.fechaLimite = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.fechaAviso = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tipo = Value(tipo),
       titulo = Value(titulo),
       estado = Value(estado),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActividadLocal> custom({
    Expression<String>? id,
    Expression<String>? tipo,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<String>? estado,
    Expression<bool>? urgente,
    Expression<DateTime>? fechaLimite,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<DateTime>? fechaAviso,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (estado != null) 'estado': estado,
      if (urgente != null) 'urgente': urgente,
      if (fechaLimite != null) 'fecha_limite': fechaLimite,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (fechaAviso != null) 'fecha_aviso': fechaAviso,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActividadesCompanion copyWith({
    Value<String>? id,
    Value<String>? tipo,
    Value<String>? titulo,
    Value<String?>? descripcion,
    Value<String>? estado,
    Value<bool>? urgente,
    Value<DateTime?>? fechaLimite,
    Value<DateTime?>? fechaInicio,
    Value<DateTime?>? fechaFin,
    Value<DateTime?>? fechaAviso,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ActividadesCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      urgente: urgente ?? this.urgente,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      fechaAviso: fechaAviso ?? this.fechaAviso,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (urgente.present) {
      map['urgente'] = Variable<bool>(urgente.value);
    }
    if (fechaLimite.present) {
      map['fecha_limite'] = Variable<DateTime>(fechaLimite.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (fechaAviso.present) {
      map['fecha_aviso'] = Variable<DateTime>(fechaAviso.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActividadesCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('estado: $estado, ')
          ..write('urgente: $urgente, ')
          ..write('fechaLimite: $fechaLimite, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('fechaAviso: $fechaAviso, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActividadesTable actividades = $ActividadesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [actividades];
}

typedef $$ActividadesTableCreateCompanionBuilder =
    ActividadesCompanion Function({
      required String id,
      required String tipo,
      required String titulo,
      Value<String?> descripcion,
      required String estado,
      Value<bool> urgente,
      Value<DateTime?> fechaLimite,
      Value<DateTime?> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<DateTime?> fechaAviso,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ActividadesTableUpdateCompanionBuilder =
    ActividadesCompanion Function({
      Value<String> id,
      Value<String> tipo,
      Value<String> titulo,
      Value<String?> descripcion,
      Value<String> estado,
      Value<bool> urgente,
      Value<DateTime?> fechaLimite,
      Value<DateTime?> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<DateTime?> fechaAviso,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ActividadesTableFilterComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get urgente => $composableBuilder(
    column: $table.urgente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaLimite => $composableBuilder(
    column: $table.fechaLimite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaAviso => $composableBuilder(
    column: $table.fechaAviso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActividadesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get urgente => $composableBuilder(
    column: $table.urgente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaLimite => $composableBuilder(
    column: $table.fechaLimite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaAviso => $composableBuilder(
    column: $table.fechaAviso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActividadesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<bool> get urgente =>
      $composableBuilder(column: $table.urgente, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaLimite => $composableBuilder(
    column: $table.fechaLimite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaAviso => $composableBuilder(
    column: $table.fechaAviso,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ActividadesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActividadesTable,
          ActividadLocal,
          $$ActividadesTableFilterComposer,
          $$ActividadesTableOrderingComposer,
          $$ActividadesTableAnnotationComposer,
          $$ActividadesTableCreateCompanionBuilder,
          $$ActividadesTableUpdateCompanionBuilder,
          (
            ActividadLocal,
            BaseReferences<_$AppDatabase, $ActividadesTable, ActividadLocal>,
          ),
          ActividadLocal,
          PrefetchHooks Function()
        > {
  $$ActividadesTableTableManager(_$AppDatabase db, $ActividadesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActividadesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActividadesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActividadesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<bool> urgente = const Value.absent(),
                Value<DateTime?> fechaLimite = const Value.absent(),
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<DateTime?> fechaAviso = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActividadesCompanion(
                id: id,
                tipo: tipo,
                titulo: titulo,
                descripcion: descripcion,
                estado: estado,
                urgente: urgente,
                fechaLimite: fechaLimite,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                fechaAviso: fechaAviso,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tipo,
                required String titulo,
                Value<String?> descripcion = const Value.absent(),
                required String estado,
                Value<bool> urgente = const Value.absent(),
                Value<DateTime?> fechaLimite = const Value.absent(),
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<DateTime?> fechaAviso = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActividadesCompanion.insert(
                id: id,
                tipo: tipo,
                titulo: titulo,
                descripcion: descripcion,
                estado: estado,
                urgente: urgente,
                fechaLimite: fechaLimite,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                fechaAviso: fechaAviso,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActividadesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActividadesTable,
      ActividadLocal,
      $$ActividadesTableFilterComposer,
      $$ActividadesTableOrderingComposer,
      $$ActividadesTableAnnotationComposer,
      $$ActividadesTableCreateCompanionBuilder,
      $$ActividadesTableUpdateCompanionBuilder,
      (
        ActividadLocal,
        BaseReferences<_$AppDatabase, $ActividadesTable, ActividadLocal>,
      ),
      ActividadLocal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActividadesTableTableManager get actividades =>
      $$ActividadesTableTableManager(_db, _db.actividades);
}
