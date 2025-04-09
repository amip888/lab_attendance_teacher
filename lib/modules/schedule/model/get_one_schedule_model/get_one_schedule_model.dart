import 'package:json_annotation/json_annotation.dart';

import 'schedule.dart';

part 'get_one_schedule_model.g.dart';

@JsonSerializable()
class GetOneScheduleModel {
  @JsonKey(name: 'schedule')
  Schedule? schedule;

  GetOneScheduleModel({this.schedule});

  @override
  String toString() => 'GetOneScheduleModel(schedule: $schedule)';

  factory GetOneScheduleModel.fromJson(Map<String, dynamic> json) {
    return _$GetOneScheduleModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetOneScheduleModelToJson(this);

  GetOneScheduleModel copyWith({
    Schedule? schedule,
  }) {
    return GetOneScheduleModel(
      schedule: schedule ?? this.schedule,
    );
  }
}
