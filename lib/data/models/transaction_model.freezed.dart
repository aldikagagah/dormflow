// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  /// Document ID dari Firestore
  String get id => throw _privateConstructorUsedError;

  /// User ID pemilik transaksi
  String get userId => throw _privateConstructorUsedError;

  /// Tipe transaksi: Pemasukan atau Pengeluaran
  TransactionType get type => throw _privateConstructorUsedError;

  /// Kategori transaksi
  String get category => throw _privateConstructorUsedError;

  /// Jumlah uang
  double get amount => throw _privateConstructorUsedError;

  /// Deskripsi/catatan transaksi
  String get description => throw _privateConstructorUsedError;

  /// Tanggal transaksi
  DateTime get date => throw _privateConstructorUsedError;

  /// Bulan-tahun untuk filtering (yyyy-MM)
  String get monthYear => throw _privateConstructorUsedError;

  /// Timestamp pembuatan
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
    TransactionModel value,
    $Res Function(TransactionModel) then,
  ) = _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    TransactionType type,
    String category,
    double amount,
    String description,
    DateTime date,
    String monthYear,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? description = null,
    Object? date = null,
    Object? monthYear = null,
    Object? createdAt = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            monthYear: null == monthYear
                ? _value.monthYear
                : monthYear // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(
    _$TransactionModelImpl value,
    $Res Function(_$TransactionModelImpl) then,
  ) = __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    TransactionType type,
    String category,
    double amount,
    String description,
    DateTime date,
    String monthYear,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(
    _$TransactionModelImpl _value,
    $Res Function(_$TransactionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? description = null,
    Object? date = null,
    Object? monthYear = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TransactionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        monthYear: null == monthYear
            ? _value.monthYear
            : monthYear // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl extends _TransactionModel {
  const _$TransactionModelImpl({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    this.description = '',
    required this.date,
    required this.monthYear,
    this.createdAt,
  }) : super._();

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  /// Document ID dari Firestore
  @override
  final String id;

  /// User ID pemilik transaksi
  @override
  final String userId;

  /// Tipe transaksi: Pemasukan atau Pengeluaran
  @override
  final TransactionType type;

  /// Kategori transaksi
  @override
  final String category;

  /// Jumlah uang
  @override
  final double amount;

  /// Deskripsi/catatan transaksi
  @override
  @JsonKey()
  final String description;

  /// Tanggal transaksi
  @override
  final DateTime date;

  /// Bulan-tahun untuk filtering (yyyy-MM)
  @override
  final String monthYear;

  /// Timestamp pembuatan
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TransactionModel(id: $id, userId: $userId, type: $type, category: $category, amount: $amount, description: $description, date: $date, monthYear: $monthYear, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.monthYear, monthYear) ||
                other.monthYear == monthYear) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    type,
    category,
    amount,
    description,
    date,
    monthYear,
    createdAt,
  );

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(this);
  }
}

abstract class _TransactionModel extends TransactionModel {
  const factory _TransactionModel({
    required final String id,
    required final String userId,
    required final TransactionType type,
    required final String category,
    required final double amount,
    final String description,
    required final DateTime date,
    required final String monthYear,
    final DateTime? createdAt,
  }) = _$TransactionModelImpl;
  const _TransactionModel._() : super._();

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  /// Document ID dari Firestore
  @override
  String get id;

  /// User ID pemilik transaksi
  @override
  String get userId;

  /// Tipe transaksi: Pemasukan atau Pengeluaran
  @override
  TransactionType get type;

  /// Kategori transaksi
  @override
  String get category;

  /// Jumlah uang
  @override
  double get amount;

  /// Deskripsi/catatan transaksi
  @override
  String get description;

  /// Tanggal transaksi
  @override
  DateTime get date;

  /// Bulan-tahun untuk filtering (yyyy-MM)
  @override
  String get monthYear;

  /// Timestamp pembuatan
  @override
  DateTime? get createdAt;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlySummary _$MonthlySummaryFromJson(Map<String, dynamic> json) {
  return _MonthlySummary.fromJson(json);
}

/// @nodoc
mixin _$MonthlySummary {
  /// Total pemasukan
  double get income => throw _privateConstructorUsedError;

  /// Total pengeluaran
  double get expense => throw _privateConstructorUsedError;

  /// Saldo (income - expense)
  double get balance => throw _privateConstructorUsedError;

  /// Jumlah transaksi
  int get transactionCount => throw _privateConstructorUsedError;

  /// Serializes this MonthlySummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlySummaryCopyWith<MonthlySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlySummaryCopyWith<$Res> {
  factory $MonthlySummaryCopyWith(
    MonthlySummary value,
    $Res Function(MonthlySummary) then,
  ) = _$MonthlySummaryCopyWithImpl<$Res, MonthlySummary>;
  @useResult
  $Res call({
    double income,
    double expense,
    double balance,
    int transactionCount,
  });
}

/// @nodoc
class _$MonthlySummaryCopyWithImpl<$Res, $Val extends MonthlySummary>
    implements $MonthlySummaryCopyWith<$Res> {
  _$MonthlySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? balance = null,
    Object? transactionCount = null,
  }) {
    return _then(
      _value.copyWith(
            income: null == income
                ? _value.income
                : income // ignore: cast_nullable_to_non_nullable
                      as double,
            expense: null == expense
                ? _value.expense
                : expense // ignore: cast_nullable_to_non_nullable
                      as double,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            transactionCount: null == transactionCount
                ? _value.transactionCount
                : transactionCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonthlySummaryImplCopyWith<$Res>
    implements $MonthlySummaryCopyWith<$Res> {
  factory _$$MonthlySummaryImplCopyWith(
    _$MonthlySummaryImpl value,
    $Res Function(_$MonthlySummaryImpl) then,
  ) = __$$MonthlySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double income,
    double expense,
    double balance,
    int transactionCount,
  });
}

/// @nodoc
class __$$MonthlySummaryImplCopyWithImpl<$Res>
    extends _$MonthlySummaryCopyWithImpl<$Res, _$MonthlySummaryImpl>
    implements _$$MonthlySummaryImplCopyWith<$Res> {
  __$$MonthlySummaryImplCopyWithImpl(
    _$MonthlySummaryImpl _value,
    $Res Function(_$MonthlySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? balance = null,
    Object? transactionCount = null,
  }) {
    return _then(
      _$MonthlySummaryImpl(
        income: null == income
            ? _value.income
            : income // ignore: cast_nullable_to_non_nullable
                  as double,
        expense: null == expense
            ? _value.expense
            : expense // ignore: cast_nullable_to_non_nullable
                  as double,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        transactionCount: null == transactionCount
            ? _value.transactionCount
            : transactionCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlySummaryImpl extends _MonthlySummary {
  const _$MonthlySummaryImpl({
    this.income = 0.0,
    this.expense = 0.0,
    this.balance = 0.0,
    this.transactionCount = 0,
  }) : super._();

  factory _$MonthlySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlySummaryImplFromJson(json);

  /// Total pemasukan
  @override
  @JsonKey()
  final double income;

  /// Total pengeluaran
  @override
  @JsonKey()
  final double expense;

  /// Saldo (income - expense)
  @override
  @JsonKey()
  final double balance;

  /// Jumlah transaksi
  @override
  @JsonKey()
  final int transactionCount;

  @override
  String toString() {
    return 'MonthlySummary(income: $income, expense: $expense, balance: $balance, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlySummaryImpl &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, income, expense, balance, transactionCount);

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlySummaryImplCopyWith<_$MonthlySummaryImpl> get copyWith =>
      __$$MonthlySummaryImplCopyWithImpl<_$MonthlySummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlySummaryImplToJson(this);
  }
}

abstract class _MonthlySummary extends MonthlySummary {
  const factory _MonthlySummary({
    final double income,
    final double expense,
    final double balance,
    final int transactionCount,
  }) = _$MonthlySummaryImpl;
  const _MonthlySummary._() : super._();

  factory _MonthlySummary.fromJson(Map<String, dynamic> json) =
      _$MonthlySummaryImpl.fromJson;

  /// Total pemasukan
  @override
  double get income;

  /// Total pengeluaran
  @override
  double get expense;

  /// Saldo (income - expense)
  @override
  double get balance;

  /// Jumlah transaksi
  @override
  int get transactionCount;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlySummaryImplCopyWith<_$MonthlySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
