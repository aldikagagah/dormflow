// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String,
      taskName: json['taskName'] as String,
      category: json['category'] as String,
      assignedMemberId: json['assignedMemberId'] as String,
      assignedMemberName: json['assignedMemberName'] as String,
      date: DateTime.parse(json['date'] as String),
      dateString: json['dateString'] as String,
      weekNumber: (json['weekNumber'] as num).toInt(),
      status:
          $enumDecodeNullable(_$ScheduleStatusEnumMap, json['status']) ??
          ScheduleStatus.pending,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskName': instance.taskName,
      'category': instance.category,
      'assignedMemberId': instance.assignedMemberId,
      'assignedMemberName': instance.assignedMemberName,
      'date': instance.date.toIso8601String(),
      'dateString': instance.dateString,
      'weekNumber': instance.weekNumber,
      'status': _$ScheduleStatusEnumMap[instance.status]!,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ScheduleStatusEnumMap = {
  ScheduleStatus.pending: 'Pending',
  ScheduleStatus.selesai: 'Selesai',
};

_$MemberModelImpl _$$MemberModelImplFromJson(Map<String, dynamic> json) =>
    _$MemberModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$$MemberModelImplToJson(_$MemberModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
