import 'package:json_annotation/json_annotation.dart';

import 'schedule.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  List<Schedule>? schedules;

  ScheduleModel({this.schedules});

  @override
  String toString() => 'ScheduleModel(schedules: $schedules)';

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return _$ScheduleModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  ScheduleModel copyWith({
    List<Schedule>? schedules,
  }) {
    return ScheduleModel(
      schedules: schedules ?? this.schedules,
    );
  }
}
