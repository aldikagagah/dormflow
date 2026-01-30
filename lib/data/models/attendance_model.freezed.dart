// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) {
  return _AttendanceModel.fromJson(json);
}

/// @nodoc
mixin _$AttendanceModel {
  /// Document ID dari Firestore
  String get id => throw _privateConstructorUsedError;

  /// User ID pemilik absensi
  String get userId => throw _privateConstructorUsedError;

  /// Email user (untuk display)
  String? get userEmail => throw _privateConstructorUsedError;

  /// Tipe absensi: Masuk atau Keluar
  AttendanceType get type => throw _privateConstructorUsedError;

  /// Timestamp dari server
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Tanggal dalam format yyyy-MM-dd
  String get date => throw _privateConstructorUsedError;

  /// Status absensi
  AttendanceStatus get status => throw _privateConstructorUsedError;

  /// Waktu lokal dalam ISO format
  String? get localTime => throw _privateConstructorUsedError;

  /// Serializes this AttendanceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceModelCopyWith<AttendanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceModelCopyWith<$Res> {
  factory $AttendanceModelCopyWith(
    AttendanceModel value,
    $Res Function(AttendanceModel) then,
  ) = _$AttendanceModelCopyWithImpl<$Res, AttendanceModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? userEmail,
    AttendanceType type,
    DateTime timestamp,
    String date,
    AttendanceStatus status,
    String? localTime,
  });
}

/// @nodoc
class _$AttendanceModelCopyWithImpl<$Res, $Val extends AttendanceModel>
    implements $AttendanceModelCopyWith<$Res> {
  _$AttendanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userEmail = freezed,
    Object? type = null,
    Object? timestamp = null,
    Object? date = null,
    Object? status = null,
    Object? localTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userEmail: freezed == userEmail
                ? _value.userEmail
                : userEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AttendanceType,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AttendanceStatus,
            localTime: freezed == localTime
                ? _value.localTime
                : localTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttendanceModelImplCopyWith<$Res>
    implements $AttendanceModelCopyWith<$Res> {
  factory _$$AttendanceModelImplCopyWith(
    _$AttendanceModelImpl value,
    $Res Function(_$AttendanceModelImpl) then,
  ) = __$$AttendanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? userEmail,
    AttendanceType type,
    DateTime timestamp,
    String date,
    AttendanceStatus status,
    String? localTime,
  });
}

/// @nodoc
class __$$AttendanceModelImplCopyWithImpl<$Res>
    extends _$AttendanceModelCopyWithImpl<$Res, _$AttendanceModelImpl>
    implements _$$AttendanceModelImplCopyWith<$Res> {
  __$$AttendanceModelImplCopyWithImpl(
    _$AttendanceModelImpl _value,
    $Res Function(_$AttendanceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userEmail = freezed,
    Object? type = null,
    Object? timestamp = null,
    Object? date = null,
    Object? status = null,
    Object? localTime = freezed,
  }) {
    return _then(
      _$AttendanceModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userEmail: freezed == userEmail
            ? _value.userEmail
            : userEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AttendanceType,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AttendanceStatus,
        localTime: freezed == localTime
            ? _value.localTime
            : localTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceModelImpl extends _AttendanceModel {
  const _$AttendanceModelImpl({
    required this.id,
    required this.userId,
    this.userEmail,
    required this.type,
    required this.timestamp,
    required this.date,
    required this.status,
    this.localTime,
  }) : super._();

  factory _$AttendanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceModelImplFromJson(json);

  /// Document ID dari Firestore
  @override
  final String id;

  /// User ID pemilik absensi
  @override
  final String userId;

  /// Email user (untuk display)
  @override
  final String? userEmail;

  /// Tipe absensi: Masuk atau Keluar
  @override
  final AttendanceType type;

  /// Timestamp dari server
  @override
  final DateTime timestamp;

  /// Tanggal dalam format yyyy-MM-dd
  @override
  final String date;

  /// Status absensi
  @override
  final AttendanceStatus status;

  /// Waktu lokal dalam ISO format
  @override
  final String? localTime;

  @override
  String toString() {
    return 'AttendanceModel(id: $id, userId: $userId, userEmail: $userEmail, type: $type, timestamp: $timestamp, date: $date, status: $status, localTime: $localTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.localTime, localTime) ||
                other.localTime == localTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    userEmail,
    type,
    timestamp,
    date,
    status,
    localTime,
  );

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceModelImplCopyWith<_$AttendanceModelImpl> get copyWith =>
      __$$AttendanceModelImplCopyWithImpl<_$AttendanceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceModelImplToJson(this);
  }
}

abstract class _AttendanceModel extends AttendanceModel {
  const factory _AttendanceModel({
    required final String id,
    required final String userId,
    final String? userEmail,
    required final AttendanceType type,
    required final DateTime timestamp,
    required final String date,
    required final AttendanceStatus status,
    final String? localTime,
  }) = _$AttendanceModelImpl;
  const _AttendanceModel._() : super._();

  factory _AttendanceModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceModelImpl.fromJson;

  /// Document ID dari Firestore
  @override
  String get id;

  /// User ID pemilik absensi
  @override
  String get userId;

  /// Email user (untuk display)
  @override
  String? get userEmail;

  /// Tipe absensi: Masuk atau Keluar
  @override
  AttendanceType get type;

  /// Timestamp dari server
  @override
  DateTime get timestamp;

  /// Tanggal dalam format yyyy-MM-dd
  @override
  String get date;

  /// Status absensi
  @override
  AttendanceStatus get status;

  /// Waktu lokal dalam ISO format
  @override
  String? get localTime;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceModelImplCopyWith<_$AttendanceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TodayAttendanceStatus _$TodayAttendanceStatusFromJson(
  Map<String, dynamic> json,
) {
  return _TodayAttendanceStatus.fromJson(json);
}

/// @nodoc
mixin _$TodayAttendanceStatus {
  /// Waktu check-in (null jika belum)
  String? get checkInTime => throw _privateConstructorUsedError;

  /// Waktu check-out (null jika belum)
  String? get checkOutTime => throw _privateConstructorUsedError;

  /// Status absensi hari ini
  AttendanceStatus get status => throw _privateConstructorUsedError;

  /// Apakah sudah check-in
  bool get hasCheckedIn => throw _privateConstructorUsedError;

  /// Apakah sudah check-out
  bool get hasCheckedOut => throw _privateConstructorUsedError;

  /// Serializes this TodayAttendanceStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodayAttendanceStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodayAttendanceStatusCopyWith<TodayAttendanceStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodayAttendanceStatusCopyWith<$Res> {
  factory $TodayAttendanceStatusCopyWith(
    TodayAttendanceStatus value,
    $Res Function(TodayAttendanceStatus) then,
  ) = _$TodayAttendanceStatusCopyWithImpl<$Res, TodayAttendanceStatus>;
  @useResult
  $Res call({
    String? checkInTime,
    String? checkOutTime,
    AttendanceStatus status,
    bool hasCheckedIn,
    bool hasCheckedOut,
  });
}

/// @nodoc
class _$TodayAttendanceStatusCopyWithImpl<
  $Res,
  $Val extends TodayAttendanceStatus
>
    implements $TodayAttendanceStatusCopyWith<$Res> {
  _$TodayAttendanceStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodayAttendanceStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? status = null,
    Object? hasCheckedIn = null,
    Object? hasCheckedOut = null,
  }) {
    return _then(
      _value.copyWith(
            checkInTime: freezed == checkInTime
                ? _value.checkInTime
                : checkInTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkOutTime: freezed == checkOutTime
                ? _value.checkOutTime
                : checkOutTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AttendanceStatus,
            hasCheckedIn: null == hasCheckedIn
                ? _value.hasCheckedIn
                : hasCheckedIn // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasCheckedOut: null == hasCheckedOut
                ? _value.hasCheckedOut
                : hasCheckedOut // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TodayAttendanceStatusImplCopyWith<$Res>
    implements $TodayAttendanceStatusCopyWith<$Res> {
  factory _$$TodayAttendanceStatusImplCopyWith(
    _$TodayAttendanceStatusImpl value,
    $Res Function(_$TodayAttendanceStatusImpl) then,
  ) = __$$TodayAttendanceStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? checkInTime,
    String? checkOutTime,
    AttendanceStatus status,
    bool hasCheckedIn,
    bool hasCheckedOut,
  });
}

/// @nodoc
class __$$TodayAttendanceStatusImplCopyWithImpl<$Res>
    extends
        _$TodayAttendanceStatusCopyWithImpl<$Res, _$TodayAttendanceStatusImpl>
    implements _$$TodayAttendanceStatusImplCopyWith<$Res> {
  __$$TodayAttendanceStatusImplCopyWithImpl(
    _$TodayAttendanceStatusImpl _value,
    $Res Function(_$TodayAttendanceStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TodayAttendanceStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? status = null,
    Object? hasCheckedIn = null,
    Object? hasCheckedOut = null,
  }) {
    return _then(
      _$TodayAttendanceStatusImpl(
        checkInTime: freezed == checkInTime
            ? _value.checkInTime
            : checkInTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkOutTime: freezed == checkOutTime
            ? _value.checkOutTime
            : checkOutTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AttendanceStatus,
        hasCheckedIn: null == hasCheckedIn
            ? _value.hasCheckedIn
            : hasCheckedIn // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasCheckedOut: null == hasCheckedOut
            ? _value.hasCheckedOut
            : hasCheckedOut // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TodayAttendanceStatusImpl implements _TodayAttendanceStatus {
  const _$TodayAttendanceStatusImpl({
    this.checkInTime,
    this.checkOutTime,
    this.status = AttendanceStatus.belumAbsen,
    this.hasCheckedIn = false,
    this.hasCheckedOut = false,
  });

  factory _$TodayAttendanceStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodayAttendanceStatusImplFromJson(json);

  /// Waktu check-in (null jika belum)
  @override
  final String? checkInTime;

  /// Waktu check-out (null jika belum)
  @override
  final String? checkOutTime;

  /// Status absensi hari ini
  @override
  @JsonKey()
  final AttendanceStatus status;

  /// Apakah sudah check-in
  @override
  @JsonKey()
  final bool hasCheckedIn;

  /// Apakah sudah check-out
  @override
  @JsonKey()
  final bool hasCheckedOut;

  @override
  String toString() {
    return 'TodayAttendanceStatus(checkInTime: $checkInTime, checkOutTime: $checkOutTime, status: $status, hasCheckedIn: $hasCheckedIn, hasCheckedOut: $hasCheckedOut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodayAttendanceStatusImpl &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasCheckedIn, hasCheckedIn) ||
                other.hasCheckedIn == hasCheckedIn) &&
            (identical(other.hasCheckedOut, hasCheckedOut) ||
                other.hasCheckedOut == hasCheckedOut));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    checkInTime,
    checkOutTime,
    status,
    hasCheckedIn,
    hasCheckedOut,
  );

  /// Create a copy of TodayAttendanceStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodayAttendanceStatusImplCopyWith<_$TodayAttendanceStatusImpl>
  get copyWith =>
      __$$TodayAttendanceStatusImplCopyWithImpl<_$TodayAttendanceStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TodayAttendanceStatusImplToJson(this);
  }
}

abstract class _TodayAttendanceStatus implements TodayAttendanceStatus {
  const factory _TodayAttendanceStatus({
    final String? checkInTime,
    final String? checkOutTime,
    final AttendanceStatus status,
    final bool hasCheckedIn,
    final bool hasCheckedOut,
  }) = _$TodayAttendanceStatusImpl;

  factory _TodayAttendanceStatus.fromJson(Map<String, dynamic> json) =
      _$TodayAttendanceStatusImpl.fromJson;

  /// Waktu check-in (null jika belum)
  @override
  String? get checkInTime;

  /// Waktu check-out (null jika belum)
  @override
  String? get checkOutTime;

  /// Status absensi hari ini
  @override
  AttendanceStatus get status;

  /// Apakah sudah check-in
  @override
  bool get hasCheckedIn;

  /// Apakah sudah check-out
  @override
  bool get hasCheckedOut;

  /// Create a copy of TodayAttendanceStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodayAttendanceStatusImplCopyWith<_$TodayAttendanceStatusImpl>
  get copyWith => throw _privateConstructorUsedError;
}
