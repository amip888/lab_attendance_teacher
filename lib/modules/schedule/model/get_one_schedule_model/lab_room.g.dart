// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabRoom _$LabRoomFromJson(Map<String, dynamic> json) => LabRoom(
      labName: json['lab_name'] as String?,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LabRoomToJson(LabRoom instance) => <String, dynamic>{
      'lab_name': instance.labName,
      'open_time': instance.openTime,
      'close_time': instance.closeTime,
      'lat': instance.lat,
      'lng': instance.lng,
    };
