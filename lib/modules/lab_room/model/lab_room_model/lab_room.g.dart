// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabRoom _$LabRoomFromJson(Map<String, dynamic> json) => LabRoom(
      id: json['id'] as String?,
      labName: json['lab_name'] as String?,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      labPhoto: json['lab_photo'] as String?,
      qrPhoto: json['qr_photo'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LabRoomToJson(LabRoom instance) => <String, dynamic>{
      'id': instance.id,
      'lab_name': instance.labName,
      'open_time': instance.openTime,
      'close_time': instance.closeTime,
      'lab_photo': instance.labPhoto,
      'qr_photo': instance.qrPhoto,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
