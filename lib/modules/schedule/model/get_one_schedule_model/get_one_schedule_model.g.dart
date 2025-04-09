// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_one_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOneScheduleModel _$GetOneScheduleModelFromJson(Map<String, dynamic> json) =>
    GetOneScheduleModel(
      schedule: json['schedule'] == null
          ? null
          : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetOneScheduleModelToJson(
        GetOneScheduleModel instance) =>
    <String, dynamic>{
      'schedule': instance.schedule,
    };
