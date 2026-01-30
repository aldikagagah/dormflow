// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) {
  return _ScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$ScheduleModel {
  /// Document ID dari Firestore
  String get id => throw _privateConstructorUsedError;

  /// Nama tugas/kegiatan
  String get taskName => throw _privateConstructorUsedError;

  /// Kategori jadwal
  String get category => throw _privateConstructorUsedError;

  /// ID member yang ditugaskan
  String get assignedMemberId => throw _privateConstructorUsedError;

  /// Nama member yang ditugaskan
  String get assignedMemberName => throw _privateConstructorUsedError;

  /// Tanggal jadwal
  DateTime get date => throw _privateConstructorUsedError;

  /// Tanggal dalam format string (yyyy-MM-dd)
  String get dateString => throw _privateConstructorUsedError;

  /// Nomor minggu dalam tahun
  int get weekNumber => throw _privateConstructorUsedError;

  /// Status jadwal
  ScheduleStatus get status => throw _privateConstructorUsedError;

  /// User ID pembuat jadwal
  String? get createdBy => throw _privateConstructorUsedError;

  /// Timestamp pembuatan
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Timestamp update terakhir
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleModelCopyWith<ScheduleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleModelCopyWith<$Res> {
  factory $ScheduleModelCopyWith(
    ScheduleModel value,
    $Res Function(ScheduleModel) then,
  ) = _$ScheduleModelCopyWithImpl<$Res, ScheduleModel>;
  @useResult
  $Res call({
    String id,
    String taskName,
    String category,
    String assignedMemberId,
    String assignedMemberName,
    DateTime date,
    String dateString,
    int weekNumber,
    ScheduleStatus status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ScheduleModelCopyWithImpl<$Res, $Val extends ScheduleModel>
    implements $ScheduleModelCopyWith<$Res> {
  _$ScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskName = null,
    Object? category = null,
    Object? assignedMemberId = null,
    Object? assignedMemberName = null,
    Object? date = null,
    Object? dateString = null,
    Object? weekNumber = null,
    Object? status = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            taskName: null == taskName
                ? _value.taskName
                : taskName // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedMemberId: null == assignedMemberId
                ? _value.assignedMemberId
                : assignedMemberId // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedMemberName: null == assignedMemberName
                ? _value.assignedMemberName
                : assignedMemberName // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dateString: null == dateString
                ? _value.dateString
                : dateString // ignore: cast_nullable_to_non_nullable
                      as String,
            weekNumber: null == weekNumber
                ? _value.weekNumber
                : weekNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ScheduleStatus,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduleModelImplCopyWith<$Res>
    implements $ScheduleModelCopyWith<$Res> {
  factory _$$ScheduleModelImplCopyWith(
    _$ScheduleModelImpl value,
    $Res Function(_$ScheduleModelImpl) then,
  ) = __$$ScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String taskName,
    String category,
    String assignedMemberId,
    String assignedMemberName,
    DateTime date,
    String dateString,
    int weekNumber,
    ScheduleStatus status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ScheduleModelImplCopyWithImpl<$Res>
    extends _$ScheduleModelCopyWithImpl<$Res, _$ScheduleModelImpl>
    implements _$$ScheduleModelImplCopyWith<$Res> {
  __$$ScheduleModelImplCopyWithImpl(
    _$ScheduleModelImpl _value,
    $Res Function(_$ScheduleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskName = null,
    Object? category = null,
    Object? assignedMemberId = null,
    Object? assignedMemberName = null,
    Object? date = null,
    Object? dateString = null,
    Object? weekNumber = null,
    Object? status = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ScheduleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        taskName: null == taskName
            ? _value.taskName
            : taskName // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedMemberId: null == assignedMemberId
            ? _value.assignedMemberId
            : assignedMemberId // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedMemberName: null == assignedMemberName
            ? _value.assignedMemberName
            : assignedMemberName // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dateString: null == dateString
            ? _value.dateString
            : dateString // ignore: cast_nullable_to_non_nullable
                  as String,
        weekNumber: null == weekNumber
            ? _value.weekNumber
            : weekNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ScheduleStatus,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleModelImpl extends _ScheduleModel {
  const _$ScheduleModelImpl({
    required this.id,
    required this.taskName,
    required this.category,
    required this.assignedMemberId,
    required this.assignedMemberName,
    required this.date,
    required this.dateString,
    required this.weekNumber,
    this.status = ScheduleStatus.pending,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$ScheduleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleModelImplFromJson(json);

  /// Document ID dari Firestore
  @override
  final String id;

  /// Nama tugas/kegiatan
  @override
  final String taskName;

  /// Kategori jadwal
  @override
  final String category;

  /// ID member yang ditugaskan
  @override
  final String assignedMemberId;

  /// Nama member yang ditugaskan
  @override
  final String assignedMemberName;

  /// Tanggal jadwal
  @override
  final DateTime date;

  /// Tanggal dalam format string (yyyy-MM-dd)
  @override
  final String dateString;

  /// Nomor minggu dalam tahun
  @override
  final int weekNumber;

  /// Status jadwal
  @override
  @JsonKey()
  final ScheduleStatus status;

  /// User ID pembuat jadwal
  @override
  final String? createdBy;

  /// Timestamp pembuatan
  @override
  final DateTime? createdAt;

  /// Timestamp update terakhir
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ScheduleModel(id: $id, taskName: $taskName, category: $category, assignedMemberId: $assignedMemberId, assignedMemberName: $assignedMemberName, date: $date, dateString: $dateString, weekNumber: $weekNumber, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskName, taskName) ||
                other.taskName == taskName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.assignedMemberId, assignedMemberId) ||
                other.assignedMemberId == assignedMemberId) &&
            (identical(other.assignedMemberName, assignedMemberName) ||
                other.assignedMemberName == assignedMemberName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dateString, dateString) ||
                other.dateString == dateString) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    taskName,
    category,
    assignedMemberId,
    assignedMemberName,
    date,
    dateString,
    weekNumber,
    status,
    createdBy,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleModelImplCopyWith<_$ScheduleModelImpl> get copyWith =>
      __$$ScheduleModelImplCopyWithImpl<_$ScheduleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleModelImplToJson(this);
  }
}

abstract class _ScheduleModel extends ScheduleModel {
  const factory _ScheduleModel({
    required final String id,
    required final String taskName,
    required final String category,
    required final String assignedMemberId,
    required final String assignedMemberName,
    required final DateTime date,
    required final String dateString,
    required final int weekNumber,
    final ScheduleStatus status,
    final String? createdBy,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ScheduleModelImpl;
  const _ScheduleModel._() : super._();

  factory _ScheduleModel.fromJson(Map<String, dynamic> json) =
      _$ScheduleModelImpl.fromJson;

  /// Document ID dari Firestore
  @override
  String get id;

  /// Nama tugas/kegiatan
  @override
  String get taskName;

  /// Kategori jadwal
  @override
  String get category;

  /// ID member yang ditugaskan
  @override
  String get assignedMemberId;

  /// Nama member yang ditugaskan
  @override
  String get assignedMemberName;

  /// Tanggal jadwal
  @override
  DateTime get date;

  /// Tanggal dalam format string (yyyy-MM-dd)
  @override
  String get dateString;

  /// Nomor minggu dalam tahun
  @override
  int get weekNumber;

  /// Status jadwal
  @override
  ScheduleStatus get status;

  /// User ID pembuat jadwal
  @override
  String? get createdBy;

  /// Timestamp pembuatan
  @override
  DateTime? get createdAt;

  /// Timestamp update terakhir
  @override
  DateTime? get updatedAt;

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleModelImplCopyWith<_$ScheduleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) {
  return _MemberModel.fromJson(json);
}

/// @nodoc
mixin _$MemberModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  /// Serializes this MemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberModelCopyWith<MemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberModelCopyWith<$Res> {
  factory $MemberModelCopyWith(
    MemberModel value,
    $Res Function(MemberModel) then,
  ) = _$MemberModelCopyWithImpl<$Res, MemberModel>;
  @useResult
  $Res call({String id, String name, String email});
}

/// @nodoc
class _$MemberModelCopyWithImpl<$Res, $Val extends MemberModel>
    implements $MemberModelCopyWith<$Res> {
  _$MemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? email = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberModelImplCopyWith<$Res>
    implements $MemberModelCopyWith<$Res> {
  factory _$$MemberModelImplCopyWith(
    _$MemberModelImpl value,
    $Res Function(_$MemberModelImpl) then,
  ) = __$$MemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String email});
}

/// @nodoc
class __$$MemberModelImplCopyWithImpl<$Res>
    extends _$MemberModelCopyWithImpl<$Res, _$MemberModelImpl>
    implements _$$MemberModelImplCopyWith<$Res> {
  __$$MemberModelImplCopyWithImpl(
    _$MemberModelImpl _value,
    $Res Function(_$MemberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? email = null}) {
    return _then(
      _$MemberModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberModelImpl implements _MemberModel {
  const _$MemberModelImpl({
    required this.id,
    required this.name,
    this.email = '',
  });

  factory _$MemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String email;

  @override
  String toString() {
    return 'MemberModel(id: $id, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email);

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberModelImplCopyWith<_$MemberModelImpl> get copyWith =>
      __$$MemberModelImplCopyWithImpl<_$MemberModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberModelImplToJson(this);
  }
}

abstract class _MemberModel implements MemberModel {
  const factory _MemberModel({
    required final String id,
    required final String name,
    final String email,
  }) = _$MemberModelImpl;

  factory _MemberModel.fromJson(Map<String, dynamic> json) =
      _$MemberModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberModelImplCopyWith<_$MemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
