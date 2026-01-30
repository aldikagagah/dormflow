// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceModelImpl _$$AttendanceModelImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userEmail: json['userEmail'] as String?,
  type: $enumDecode(_$AttendanceTypeEnumMap, json['type']),
  timestamp: DateTime.parse(json['timestamp'] as String),
  date: json['date'] as String,
  status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
  localTime: json['localTime'] as String?,
);

Map<String, dynamic> _$$AttendanceModelImplToJson(
  _$AttendanceModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userEmail': instance.userEmail,
  'type': _$AttendanceTypeEnumMap[instance.type]!,
  'timestamp': instance.timestamp.toIso8601String(),
  'date': instance.date,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'localTime': instance.localTime,
};

const _$AttendanceTypeEnumMap = {
  AttendanceType.masuk: 'Masuk',
  AttendanceType.keluar: 'Keluar',
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.hadir: 'Hadir',
  AttendanceStatus.terlambat: 'Terlambat',
  AttendanceStatus.selesai: 'Selesai',
  AttendanceStatus.belumAbsen: 'Belum Absen',
};

_$TodayAttendanceStatusImpl _$$TodayAttendanceStatusImplFromJson(
  Map<String, dynamic> json,
) => _$TodayAttendanceStatusImpl(
  checkInTime: json['checkInTime'] as String?,
  checkOutTime: json['checkOutTime'] as String?,
  status:
      $enumDecodeNullable(_$AttendanceStatusEnumMap, json['status']) ??
      AttendanceStatus.belumAbsen,
  hasCheckedIn: json['hasCheckedIn'] as bool? ?? false,
  hasCheckedOut: json['hasCheckedOut'] as bool? ?? false,
);

Map<String, dynamic> _$$TodayAttendanceStatusImplToJson(
  _$TodayAttendanceStatusImpl instance,
) => <String, dynamic>{
  'checkInTime': instance.checkInTime,
  'checkOutTime': instance.checkOutTime,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'hasCheckedIn': instance.hasCheckedIn,
  'hasCheckedOut': instance.hasCheckedOut,
};
