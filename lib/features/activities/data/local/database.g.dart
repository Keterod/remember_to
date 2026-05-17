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

class $RepeticionesTable extends Repeticiones
    with TableInfo<$RepeticionesTable, RepeticionLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepeticionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actividadIdMeta = const VerificationMeta(
    'actividadId',
  );
  @override
  late final GeneratedColumn<String> actividadId = GeneratedColumn<String>(
    'actividad_id',
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
  static const VerificationMeta _intervaloMeta = const VerificationMeta(
    'intervalo',
  );
  @override
  late final GeneratedColumn<int> intervalo = GeneratedColumn<int>(
    'intervalo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _diasSemanaMeta = const VerificationMeta(
    'diasSemana',
  );
  @override
  late final GeneratedColumn<String> diasSemana = GeneratedColumn<String>(
    'dias_semana',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diaMesMeta = const VerificationMeta('diaMes');
  @override
  late final GeneratedColumn<int> diaMes = GeneratedColumn<int>(
    'dia_mes',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  static const VerificationMeta _reglaTextoMeta = const VerificationMeta(
    'reglaTexto',
  );
  @override
  late final GeneratedColumn<String> reglaTexto = GeneratedColumn<String>(
    'regla_texto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actividadId,
    tipo,
    intervalo,
    diasSemana,
    diaMes,
    fechaInicio,
    fechaFin,
    reglaTexto,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repeticiones';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepeticionLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('actividad_id')) {
      context.handle(
        _actividadIdMeta,
        actividadId.isAcceptableOrUnknown(
          data['actividad_id']!,
          _actividadIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actividadIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('intervalo')) {
      context.handle(
        _intervaloMeta,
        intervalo.isAcceptableOrUnknown(data['intervalo']!, _intervaloMeta),
      );
    }
    if (data.containsKey('dias_semana')) {
      context.handle(
        _diasSemanaMeta,
        diasSemana.isAcceptableOrUnknown(data['dias_semana']!, _diasSemanaMeta),
      );
    }
    if (data.containsKey('dia_mes')) {
      context.handle(
        _diaMesMeta,
        diaMes.isAcceptableOrUnknown(data['dia_mes']!, _diaMesMeta),
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
    if (data.containsKey('regla_texto')) {
      context.handle(
        _reglaTextoMeta,
        reglaTexto.isAcceptableOrUnknown(data['regla_texto']!, _reglaTextoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepeticionLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepeticionLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      actividadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actividad_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      intervalo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intervalo'],
      )!,
      diasSemana: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dias_semana'],
      ),
      diaMes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_mes'],
      ),
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      ),
      fechaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fin'],
      ),
      reglaTexto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regla_texto'],
      ),
    );
  }

  @override
  $RepeticionesTable createAlias(String alias) {
    return $RepeticionesTable(attachedDatabase, alias);
  }
}

class RepeticionLocal extends DataClass implements Insertable<RepeticionLocal> {
  final String id;
  final String actividadId;
  final String tipo;
  final int intervalo;
  final String? diasSemana;
  final int? diaMes;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? reglaTexto;
  const RepeticionLocal({
    required this.id,
    required this.actividadId,
    required this.tipo,
    required this.intervalo,
    this.diasSemana,
    this.diaMes,
    this.fechaInicio,
    this.fechaFin,
    this.reglaTexto,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['actividad_id'] = Variable<String>(actividadId);
    map['tipo'] = Variable<String>(tipo);
    map['intervalo'] = Variable<int>(intervalo);
    if (!nullToAbsent || diasSemana != null) {
      map['dias_semana'] = Variable<String>(diasSemana);
    }
    if (!nullToAbsent || diaMes != null) {
      map['dia_mes'] = Variable<int>(diaMes);
    }
    if (!nullToAbsent || fechaInicio != null) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    }
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    if (!nullToAbsent || reglaTexto != null) {
      map['regla_texto'] = Variable<String>(reglaTexto);
    }
    return map;
  }

  RepeticionesCompanion toCompanion(bool nullToAbsent) {
    return RepeticionesCompanion(
      id: Value(id),
      actividadId: Value(actividadId),
      tipo: Value(tipo),
      intervalo: Value(intervalo),
      diasSemana: diasSemana == null && nullToAbsent
          ? const Value.absent()
          : Value(diasSemana),
      diaMes: diaMes == null && nullToAbsent
          ? const Value.absent()
          : Value(diaMes),
      fechaInicio: fechaInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaInicio),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
      reglaTexto: reglaTexto == null && nullToAbsent
          ? const Value.absent()
          : Value(reglaTexto),
    );
  }

  factory RepeticionLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepeticionLocal(
      id: serializer.fromJson<String>(json['id']),
      actividadId: serializer.fromJson<String>(json['actividadId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      intervalo: serializer.fromJson<int>(json['intervalo']),
      diasSemana: serializer.fromJson<String?>(json['diasSemana']),
      diaMes: serializer.fromJson<int?>(json['diaMes']),
      fechaInicio: serializer.fromJson<DateTime?>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
      reglaTexto: serializer.fromJson<String?>(json['reglaTexto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'actividadId': serializer.toJson<String>(actividadId),
      'tipo': serializer.toJson<String>(tipo),
      'intervalo': serializer.toJson<int>(intervalo),
      'diasSemana': serializer.toJson<String?>(diasSemana),
      'diaMes': serializer.toJson<int?>(diaMes),
      'fechaInicio': serializer.toJson<DateTime?>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
      'reglaTexto': serializer.toJson<String?>(reglaTexto),
    };
  }

  RepeticionLocal copyWith({
    String? id,
    String? actividadId,
    String? tipo,
    int? intervalo,
    Value<String?> diasSemana = const Value.absent(),
    Value<int?> diaMes = const Value.absent(),
    Value<DateTime?> fechaInicio = const Value.absent(),
    Value<DateTime?> fechaFin = const Value.absent(),
    Value<String?> reglaTexto = const Value.absent(),
  }) => RepeticionLocal(
    id: id ?? this.id,
    actividadId: actividadId ?? this.actividadId,
    tipo: tipo ?? this.tipo,
    intervalo: intervalo ?? this.intervalo,
    diasSemana: diasSemana.present ? diasSemana.value : this.diasSemana,
    diaMes: diaMes.present ? diaMes.value : this.diaMes,
    fechaInicio: fechaInicio.present ? fechaInicio.value : this.fechaInicio,
    fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
    reglaTexto: reglaTexto.present ? reglaTexto.value : this.reglaTexto,
  );
  RepeticionLocal copyWithCompanion(RepeticionesCompanion data) {
    return RepeticionLocal(
      id: data.id.present ? data.id.value : this.id,
      actividadId: data.actividadId.present
          ? data.actividadId.value
          : this.actividadId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      intervalo: data.intervalo.present ? data.intervalo.value : this.intervalo,
      diasSemana: data.diasSemana.present
          ? data.diasSemana.value
          : this.diasSemana,
      diaMes: data.diaMes.present ? data.diaMes.value : this.diaMes,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      reglaTexto: data.reglaTexto.present
          ? data.reglaTexto.value
          : this.reglaTexto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepeticionLocal(')
          ..write('id: $id, ')
          ..write('actividadId: $actividadId, ')
          ..write('tipo: $tipo, ')
          ..write('intervalo: $intervalo, ')
          ..write('diasSemana: $diasSemana, ')
          ..write('diaMes: $diaMes, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('reglaTexto: $reglaTexto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actividadId,
    tipo,
    intervalo,
    diasSemana,
    diaMes,
    fechaInicio,
    fechaFin,
    reglaTexto,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepeticionLocal &&
          other.id == this.id &&
          other.actividadId == this.actividadId &&
          other.tipo == this.tipo &&
          other.intervalo == this.intervalo &&
          other.diasSemana == this.diasSemana &&
          other.diaMes == this.diaMes &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.reglaTexto == this.reglaTexto);
}

class RepeticionesCompanion extends UpdateCompanion<RepeticionLocal> {
  final Value<String> id;
  final Value<String> actividadId;
  final Value<String> tipo;
  final Value<int> intervalo;
  final Value<String?> diasSemana;
  final Value<int?> diaMes;
  final Value<DateTime?> fechaInicio;
  final Value<DateTime?> fechaFin;
  final Value<String?> reglaTexto;
  final Value<int> rowid;
  const RepeticionesCompanion({
    this.id = const Value.absent(),
    this.actividadId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.intervalo = const Value.absent(),
    this.diasSemana = const Value.absent(),
    this.diaMes = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.reglaTexto = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepeticionesCompanion.insert({
    required String id,
    required String actividadId,
    required String tipo,
    this.intervalo = const Value.absent(),
    this.diasSemana = const Value.absent(),
    this.diaMes = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.reglaTexto = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       actividadId = Value(actividadId),
       tipo = Value(tipo);
  static Insertable<RepeticionLocal> custom({
    Expression<String>? id,
    Expression<String>? actividadId,
    Expression<String>? tipo,
    Expression<int>? intervalo,
    Expression<String>? diasSemana,
    Expression<int>? diaMes,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<String>? reglaTexto,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actividadId != null) 'actividad_id': actividadId,
      if (tipo != null) 'tipo': tipo,
      if (intervalo != null) 'intervalo': intervalo,
      if (diasSemana != null) 'dias_semana': diasSemana,
      if (diaMes != null) 'dia_mes': diaMes,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (reglaTexto != null) 'regla_texto': reglaTexto,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepeticionesCompanion copyWith({
    Value<String>? id,
    Value<String>? actividadId,
    Value<String>? tipo,
    Value<int>? intervalo,
    Value<String?>? diasSemana,
    Value<int?>? diaMes,
    Value<DateTime?>? fechaInicio,
    Value<DateTime?>? fechaFin,
    Value<String?>? reglaTexto,
    Value<int>? rowid,
  }) {
    return RepeticionesCompanion(
      id: id ?? this.id,
      actividadId: actividadId ?? this.actividadId,
      tipo: tipo ?? this.tipo,
      intervalo: intervalo ?? this.intervalo,
      diasSemana: diasSemana ?? this.diasSemana,
      diaMes: diaMes ?? this.diaMes,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      reglaTexto: reglaTexto ?? this.reglaTexto,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (actividadId.present) {
      map['actividad_id'] = Variable<String>(actividadId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (intervalo.present) {
      map['intervalo'] = Variable<int>(intervalo.value);
    }
    if (diasSemana.present) {
      map['dias_semana'] = Variable<String>(diasSemana.value);
    }
    if (diaMes.present) {
      map['dia_mes'] = Variable<int>(diaMes.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (reglaTexto.present) {
      map['regla_texto'] = Variable<String>(reglaTexto.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepeticionesCompanion(')
          ..write('id: $id, ')
          ..write('actividadId: $actividadId, ')
          ..write('tipo: $tipo, ')
          ..write('intervalo: $intervalo, ')
          ..write('diasSemana: $diasSemana, ')
          ..write('diaMes: $diaMes, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('reglaTexto: $reglaTexto, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OcurrenciasActividadesTable extends OcurrenciasActividades
    with TableInfo<$OcurrenciasActividadesTable, OcurrenciaActividadLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OcurrenciasActividadesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actividadIdMeta = const VerificationMeta(
    'actividadId',
  );
  @override
  late final GeneratedColumn<String> actividadId = GeneratedColumn<String>(
    'actividad_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaProgramadaMeta = const VerificationMeta(
    'fechaProgramada',
  );
  @override
  late final GeneratedColumn<DateTime> fechaProgramada =
      GeneratedColumn<DateTime>(
        'fecha_programada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _estadoOcurrenciaMeta = const VerificationMeta(
    'estadoOcurrencia',
  );
  @override
  late final GeneratedColumn<String> estadoOcurrencia = GeneratedColumn<String>(
    'estado_ocurrencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _skippedAtMeta = const VerificationMeta(
    'skippedAt',
  );
  @override
  late final GeneratedColumn<DateTime> skippedAt = GeneratedColumn<DateTime>(
    'skipped_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postponedToMeta = const VerificationMeta(
    'postponedTo',
  );
  @override
  late final GeneratedColumn<DateTime> postponedTo = GeneratedColumn<DateTime>(
    'postponed_to',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actividadId,
    fechaProgramada,
    estadoOcurrencia,
    completedAt,
    skippedAt,
    postponedTo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ocurrencias_actividades';
  @override
  VerificationContext validateIntegrity(
    Insertable<OcurrenciaActividadLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('actividad_id')) {
      context.handle(
        _actividadIdMeta,
        actividadId.isAcceptableOrUnknown(
          data['actividad_id']!,
          _actividadIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actividadIdMeta);
    }
    if (data.containsKey('fecha_programada')) {
      context.handle(
        _fechaProgramadaMeta,
        fechaProgramada.isAcceptableOrUnknown(
          data['fecha_programada']!,
          _fechaProgramadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaProgramadaMeta);
    }
    if (data.containsKey('estado_ocurrencia')) {
      context.handle(
        _estadoOcurrenciaMeta,
        estadoOcurrencia.isAcceptableOrUnknown(
          data['estado_ocurrencia']!,
          _estadoOcurrenciaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estadoOcurrenciaMeta);
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
    if (data.containsKey('skipped_at')) {
      context.handle(
        _skippedAtMeta,
        skippedAt.isAcceptableOrUnknown(data['skipped_at']!, _skippedAtMeta),
      );
    }
    if (data.containsKey('postponed_to')) {
      context.handle(
        _postponedToMeta,
        postponedTo.isAcceptableOrUnknown(
          data['postponed_to']!,
          _postponedToMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OcurrenciaActividadLocal map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OcurrenciaActividadLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      actividadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actividad_id'],
      )!,
      fechaProgramada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_programada'],
      )!,
      estadoOcurrencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_ocurrencia'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      skippedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}skipped_at'],
      ),
      postponedTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}postponed_to'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OcurrenciasActividadesTable createAlias(String alias) {
    return $OcurrenciasActividadesTable(attachedDatabase, alias);
  }
}

class OcurrenciaActividadLocal extends DataClass
    implements Insertable<OcurrenciaActividadLocal> {
  final String id;
  final String actividadId;
  final DateTime fechaProgramada;
  final String estadoOcurrencia;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final DateTime? postponedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OcurrenciaActividadLocal({
    required this.id,
    required this.actividadId,
    required this.fechaProgramada,
    required this.estadoOcurrencia,
    this.completedAt,
    this.skippedAt,
    this.postponedTo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['actividad_id'] = Variable<String>(actividadId);
    map['fecha_programada'] = Variable<DateTime>(fechaProgramada);
    map['estado_ocurrencia'] = Variable<String>(estadoOcurrencia);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || skippedAt != null) {
      map['skipped_at'] = Variable<DateTime>(skippedAt);
    }
    if (!nullToAbsent || postponedTo != null) {
      map['postponed_to'] = Variable<DateTime>(postponedTo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OcurrenciasActividadesCompanion toCompanion(bool nullToAbsent) {
    return OcurrenciasActividadesCompanion(
      id: Value(id),
      actividadId: Value(actividadId),
      fechaProgramada: Value(fechaProgramada),
      estadoOcurrencia: Value(estadoOcurrencia),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      skippedAt: skippedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(skippedAt),
      postponedTo: postponedTo == null && nullToAbsent
          ? const Value.absent()
          : Value(postponedTo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OcurrenciaActividadLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OcurrenciaActividadLocal(
      id: serializer.fromJson<String>(json['id']),
      actividadId: serializer.fromJson<String>(json['actividadId']),
      fechaProgramada: serializer.fromJson<DateTime>(json['fechaProgramada']),
      estadoOcurrencia: serializer.fromJson<String>(json['estadoOcurrencia']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      skippedAt: serializer.fromJson<DateTime?>(json['skippedAt']),
      postponedTo: serializer.fromJson<DateTime?>(json['postponedTo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'actividadId': serializer.toJson<String>(actividadId),
      'fechaProgramada': serializer.toJson<DateTime>(fechaProgramada),
      'estadoOcurrencia': serializer.toJson<String>(estadoOcurrencia),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'skippedAt': serializer.toJson<DateTime?>(skippedAt),
      'postponedTo': serializer.toJson<DateTime?>(postponedTo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OcurrenciaActividadLocal copyWith({
    String? id,
    String? actividadId,
    DateTime? fechaProgramada,
    String? estadoOcurrencia,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> skippedAt = const Value.absent(),
    Value<DateTime?> postponedTo = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OcurrenciaActividadLocal(
    id: id ?? this.id,
    actividadId: actividadId ?? this.actividadId,
    fechaProgramada: fechaProgramada ?? this.fechaProgramada,
    estadoOcurrencia: estadoOcurrencia ?? this.estadoOcurrencia,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    skippedAt: skippedAt.present ? skippedAt.value : this.skippedAt,
    postponedTo: postponedTo.present ? postponedTo.value : this.postponedTo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OcurrenciaActividadLocal copyWithCompanion(
    OcurrenciasActividadesCompanion data,
  ) {
    return OcurrenciaActividadLocal(
      id: data.id.present ? data.id.value : this.id,
      actividadId: data.actividadId.present
          ? data.actividadId.value
          : this.actividadId,
      fechaProgramada: data.fechaProgramada.present
          ? data.fechaProgramada.value
          : this.fechaProgramada,
      estadoOcurrencia: data.estadoOcurrencia.present
          ? data.estadoOcurrencia.value
          : this.estadoOcurrencia,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      skippedAt: data.skippedAt.present ? data.skippedAt.value : this.skippedAt,
      postponedTo: data.postponedTo.present
          ? data.postponedTo.value
          : this.postponedTo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OcurrenciaActividadLocal(')
          ..write('id: $id, ')
          ..write('actividadId: $actividadId, ')
          ..write('fechaProgramada: $fechaProgramada, ')
          ..write('estadoOcurrencia: $estadoOcurrencia, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('postponedTo: $postponedTo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actividadId,
    fechaProgramada,
    estadoOcurrencia,
    completedAt,
    skippedAt,
    postponedTo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OcurrenciaActividadLocal &&
          other.id == this.id &&
          other.actividadId == this.actividadId &&
          other.fechaProgramada == this.fechaProgramada &&
          other.estadoOcurrencia == this.estadoOcurrencia &&
          other.completedAt == this.completedAt &&
          other.skippedAt == this.skippedAt &&
          other.postponedTo == this.postponedTo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OcurrenciasActividadesCompanion
    extends UpdateCompanion<OcurrenciaActividadLocal> {
  final Value<String> id;
  final Value<String> actividadId;
  final Value<DateTime> fechaProgramada;
  final Value<String> estadoOcurrencia;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> skippedAt;
  final Value<DateTime?> postponedTo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OcurrenciasActividadesCompanion({
    this.id = const Value.absent(),
    this.actividadId = const Value.absent(),
    this.fechaProgramada = const Value.absent(),
    this.estadoOcurrencia = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.postponedTo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OcurrenciasActividadesCompanion.insert({
    required String id,
    required String actividadId,
    required DateTime fechaProgramada,
    required String estadoOcurrencia,
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.postponedTo = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       actividadId = Value(actividadId),
       fechaProgramada = Value(fechaProgramada),
       estadoOcurrencia = Value(estadoOcurrencia),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<OcurrenciaActividadLocal> custom({
    Expression<String>? id,
    Expression<String>? actividadId,
    Expression<DateTime>? fechaProgramada,
    Expression<String>? estadoOcurrencia,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? skippedAt,
    Expression<DateTime>? postponedTo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actividadId != null) 'actividad_id': actividadId,
      if (fechaProgramada != null) 'fecha_programada': fechaProgramada,
      if (estadoOcurrencia != null) 'estado_ocurrencia': estadoOcurrencia,
      if (completedAt != null) 'completed_at': completedAt,
      if (skippedAt != null) 'skipped_at': skippedAt,
      if (postponedTo != null) 'postponed_to': postponedTo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OcurrenciasActividadesCompanion copyWith({
    Value<String>? id,
    Value<String>? actividadId,
    Value<DateTime>? fechaProgramada,
    Value<String>? estadoOcurrencia,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? skippedAt,
    Value<DateTime?>? postponedTo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OcurrenciasActividadesCompanion(
      id: id ?? this.id,
      actividadId: actividadId ?? this.actividadId,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      estadoOcurrencia: estadoOcurrencia ?? this.estadoOcurrencia,
      completedAt: completedAt ?? this.completedAt,
      skippedAt: skippedAt ?? this.skippedAt,
      postponedTo: postponedTo ?? this.postponedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (actividadId.present) {
      map['actividad_id'] = Variable<String>(actividadId.value);
    }
    if (fechaProgramada.present) {
      map['fecha_programada'] = Variable<DateTime>(fechaProgramada.value);
    }
    if (estadoOcurrencia.present) {
      map['estado_ocurrencia'] = Variable<String>(estadoOcurrencia.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (skippedAt.present) {
      map['skipped_at'] = Variable<DateTime>(skippedAt.value);
    }
    if (postponedTo.present) {
      map['postponed_to'] = Variable<DateTime>(postponedTo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OcurrenciasActividadesCompanion(')
          ..write('id: $id, ')
          ..write('actividadId: $actividadId, ')
          ..write('fechaProgramada: $fechaProgramada, ')
          ..write('estadoOcurrencia: $estadoOcurrencia, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('postponedTo: $postponedTo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActividadesTable actividades = $ActividadesTable(this);
  late final $RepeticionesTable repeticiones = $RepeticionesTable(this);
  late final $OcurrenciasActividadesTable ocurrenciasActividades =
      $OcurrenciasActividadesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    actividades,
    repeticiones,
    ocurrenciasActividades,
  ];
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
typedef $$RepeticionesTableCreateCompanionBuilder =
    RepeticionesCompanion Function({
      required String id,
      required String actividadId,
      required String tipo,
      Value<int> intervalo,
      Value<String?> diasSemana,
      Value<int?> diaMes,
      Value<DateTime?> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<String?> reglaTexto,
      Value<int> rowid,
    });
typedef $$RepeticionesTableUpdateCompanionBuilder =
    RepeticionesCompanion Function({
      Value<String> id,
      Value<String> actividadId,
      Value<String> tipo,
      Value<int> intervalo,
      Value<String?> diasSemana,
      Value<int?> diaMes,
      Value<DateTime?> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<String?> reglaTexto,
      Value<int> rowid,
    });

class $$RepeticionesTableFilterComposer
    extends Composer<_$AppDatabase, $RepeticionesTable> {
  $$RepeticionesTableFilterComposer({
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

  ColumnFilters<String> get actividadId => $composableBuilder(
    column: $table.actividadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalo => $composableBuilder(
    column: $table.intervalo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diasSemana => $composableBuilder(
    column: $table.diasSemana,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaMes => $composableBuilder(
    column: $table.diaMes,
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

  ColumnFilters<String> get reglaTexto => $composableBuilder(
    column: $table.reglaTexto,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RepeticionesTableOrderingComposer
    extends Composer<_$AppDatabase, $RepeticionesTable> {
  $$RepeticionesTableOrderingComposer({
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

  ColumnOrderings<String> get actividadId => $composableBuilder(
    column: $table.actividadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalo => $composableBuilder(
    column: $table.intervalo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diasSemana => $composableBuilder(
    column: $table.diasSemana,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaMes => $composableBuilder(
    column: $table.diaMes,
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

  ColumnOrderings<String> get reglaTexto => $composableBuilder(
    column: $table.reglaTexto,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RepeticionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepeticionesTable> {
  $$RepeticionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actividadId => $composableBuilder(
    column: $table.actividadId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get intervalo =>
      $composableBuilder(column: $table.intervalo, builder: (column) => column);

  GeneratedColumn<String> get diasSemana => $composableBuilder(
    column: $table.diasSemana,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diaMes =>
      $composableBuilder(column: $table.diaMes, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<String> get reglaTexto => $composableBuilder(
    column: $table.reglaTexto,
    builder: (column) => column,
  );
}

class $$RepeticionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepeticionesTable,
          RepeticionLocal,
          $$RepeticionesTableFilterComposer,
          $$RepeticionesTableOrderingComposer,
          $$RepeticionesTableAnnotationComposer,
          $$RepeticionesTableCreateCompanionBuilder,
          $$RepeticionesTableUpdateCompanionBuilder,
          (
            RepeticionLocal,
            BaseReferences<_$AppDatabase, $RepeticionesTable, RepeticionLocal>,
          ),
          RepeticionLocal,
          PrefetchHooks Function()
        > {
  $$RepeticionesTableTableManager(_$AppDatabase db, $RepeticionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepeticionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepeticionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepeticionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> actividadId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> intervalo = const Value.absent(),
                Value<String?> diasSemana = const Value.absent(),
                Value<int?> diaMes = const Value.absent(),
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<String?> reglaTexto = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepeticionesCompanion(
                id: id,
                actividadId: actividadId,
                tipo: tipo,
                intervalo: intervalo,
                diasSemana: diasSemana,
                diaMes: diaMes,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                reglaTexto: reglaTexto,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String actividadId,
                required String tipo,
                Value<int> intervalo = const Value.absent(),
                Value<String?> diasSemana = const Value.absent(),
                Value<int?> diaMes = const Value.absent(),
                Value<DateTime?> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<String?> reglaTexto = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepeticionesCompanion.insert(
                id: id,
                actividadId: actividadId,
                tipo: tipo,
                intervalo: intervalo,
                diasSemana: diasSemana,
                diaMes: diaMes,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                reglaTexto: reglaTexto,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RepeticionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepeticionesTable,
      RepeticionLocal,
      $$RepeticionesTableFilterComposer,
      $$RepeticionesTableOrderingComposer,
      $$RepeticionesTableAnnotationComposer,
      $$RepeticionesTableCreateCompanionBuilder,
      $$RepeticionesTableUpdateCompanionBuilder,
      (
        RepeticionLocal,
        BaseReferences<_$AppDatabase, $RepeticionesTable, RepeticionLocal>,
      ),
      RepeticionLocal,
      PrefetchHooks Function()
    >;
typedef $$OcurrenciasActividadesTableCreateCompanionBuilder =
    OcurrenciasActividadesCompanion Function({
      required String id,
      required String actividadId,
      required DateTime fechaProgramada,
      required String estadoOcurrencia,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      Value<DateTime?> postponedTo,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$OcurrenciasActividadesTableUpdateCompanionBuilder =
    OcurrenciasActividadesCompanion Function({
      Value<String> id,
      Value<String> actividadId,
      Value<DateTime> fechaProgramada,
      Value<String> estadoOcurrencia,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      Value<DateTime?> postponedTo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OcurrenciasActividadesTableFilterComposer
    extends Composer<_$AppDatabase, $OcurrenciasActividadesTable> {
  $$OcurrenciasActividadesTableFilterComposer({
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

  ColumnFilters<String> get actividadId => $composableBuilder(
    column: $table.actividadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoOcurrencia => $composableBuilder(
    column: $table.estadoOcurrencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postponedTo => $composableBuilder(
    column: $table.postponedTo,
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
}

class $$OcurrenciasActividadesTableOrderingComposer
    extends Composer<_$AppDatabase, $OcurrenciasActividadesTable> {
  $$OcurrenciasActividadesTableOrderingComposer({
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

  ColumnOrderings<String> get actividadId => $composableBuilder(
    column: $table.actividadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoOcurrencia => $composableBuilder(
    column: $table.estadoOcurrencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postponedTo => $composableBuilder(
    column: $table.postponedTo,
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
}

class $$OcurrenciasActividadesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OcurrenciasActividadesTable> {
  $$OcurrenciasActividadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actividadId => $composableBuilder(
    column: $table.actividadId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoOcurrencia => $composableBuilder(
    column: $table.estadoOcurrencia,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get skippedAt =>
      $composableBuilder(column: $table.skippedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get postponedTo => $composableBuilder(
    column: $table.postponedTo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OcurrenciasActividadesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OcurrenciasActividadesTable,
          OcurrenciaActividadLocal,
          $$OcurrenciasActividadesTableFilterComposer,
          $$OcurrenciasActividadesTableOrderingComposer,
          $$OcurrenciasActividadesTableAnnotationComposer,
          $$OcurrenciasActividadesTableCreateCompanionBuilder,
          $$OcurrenciasActividadesTableUpdateCompanionBuilder,
          (
            OcurrenciaActividadLocal,
            BaseReferences<
              _$AppDatabase,
              $OcurrenciasActividadesTable,
              OcurrenciaActividadLocal
            >,
          ),
          OcurrenciaActividadLocal,
          PrefetchHooks Function()
        > {
  $$OcurrenciasActividadesTableTableManager(
    _$AppDatabase db,
    $OcurrenciasActividadesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OcurrenciasActividadesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OcurrenciasActividadesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OcurrenciasActividadesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> actividadId = const Value.absent(),
                Value<DateTime> fechaProgramada = const Value.absent(),
                Value<String> estadoOcurrencia = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                Value<DateTime?> postponedTo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OcurrenciasActividadesCompanion(
                id: id,
                actividadId: actividadId,
                fechaProgramada: fechaProgramada,
                estadoOcurrencia: estadoOcurrencia,
                completedAt: completedAt,
                skippedAt: skippedAt,
                postponedTo: postponedTo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String actividadId,
                required DateTime fechaProgramada,
                required String estadoOcurrencia,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                Value<DateTime?> postponedTo = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => OcurrenciasActividadesCompanion.insert(
                id: id,
                actividadId: actividadId,
                fechaProgramada: fechaProgramada,
                estadoOcurrencia: estadoOcurrencia,
                completedAt: completedAt,
                skippedAt: skippedAt,
                postponedTo: postponedTo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OcurrenciasActividadesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OcurrenciasActividadesTable,
      OcurrenciaActividadLocal,
      $$OcurrenciasActividadesTableFilterComposer,
      $$OcurrenciasActividadesTableOrderingComposer,
      $$OcurrenciasActividadesTableAnnotationComposer,
      $$OcurrenciasActividadesTableCreateCompanionBuilder,
      $$OcurrenciasActividadesTableUpdateCompanionBuilder,
      (
        OcurrenciaActividadLocal,
        BaseReferences<
          _$AppDatabase,
          $OcurrenciasActividadesTable,
          OcurrenciaActividadLocal
        >,
      ),
      OcurrenciaActividadLocal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActividadesTableTableManager get actividades =>
      $$ActividadesTableTableManager(_db, _db.actividades);
  $$RepeticionesTableTableManager get repeticiones =>
      $$RepeticionesTableTableManager(_db, _db.repeticiones);
  $$OcurrenciasActividadesTableTableManager get ocurrenciasActividades =>
      $$OcurrenciasActividadesTableTableManager(
        _db,
        _db.ocurrenciasActividades,
      );
}
