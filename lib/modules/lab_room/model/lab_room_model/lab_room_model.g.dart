// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabRoomModel _$LabRoomModelFromJson(Map<String, dynamic> json) => LabRoomModel(
      labRoom: (json['labRoom'] as List<dynamic>?)
          ?.map((e) => LabRoom.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LabRoomModelToJson(LabRoomModel instance) =>
    <String, dynamic>{
      'labRoom': instance.labRoom,
    };
