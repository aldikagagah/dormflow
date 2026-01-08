// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  category: json['category'] as String,
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String? ?? '',
  date: DateTime.parse(json['date'] as String),
  monthYear: json['monthYear'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'category': instance.category,
  'amount': instance.amount,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'monthYear': instance.monthYear,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$TransactionTypeEnumMap = {
  TransactionType.pemasukan: 'Pemasukan',
  TransactionType.pengeluaran: 'Pengeluaran',
};

_$MonthlySummaryImpl _$$MonthlySummaryImplFromJson(Map<String, dynamic> json) =>
    _$MonthlySummaryImpl(
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
      expense: (json['expense'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MonthlySummaryImplToJson(
  _$MonthlySummaryImpl instance,
) => <String, dynamic>{
  'income': instance.income,
  'expense': instance.expense,
  'balance': instance.balance,
  'transactionCount': instance.transactionCount,
};
